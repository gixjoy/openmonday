<?php

    /*
     * This script is executed every minute by a crontab job. It checks all conditions of all
     * automated scenes and when a condition matches, it executes all corresponding actions, 
     * calling scene_run.php script.
     * It responsible for all Monday automation.
     */
    
    include_once '/var/www/html/monday/api/config/database.php';
    include_once '/var/www/html/monday/api/model/scene.php';
    include_once '/var/www/html/monday/api/model/time_condition.php';
    include_once '/var/www/html/monday/api/model/measure_condition.php';
    include_once '/var/www/html/monday/api/model/scene_has_measurecondition.php';
    include_once '/var/www/html/monday/api/model/client.php';
    include_once("/var/www/html/monday/api/model/measure.php");
    include_once("/var/www/html/monday/api/common/utils.php");
    
    $database = new Database();
    $db = $database->getConnection();
    
    $scene = new Scene($db);
    $timeCondition = new TimeCondition($db);
    $measureCondition = new MeasureCondition($db);
    $shmCondition = new SceneHasMeasureCondition($db);
    $client = new Client($db);
    $measure = new Measure($db);
    
    $date = date("Y-m-d H:i:s");
    $actualMonth = date('m');
    $actualDay = date('d');
    $actualHour = date('H');
    $actualMinute = date('i');

    $sceneStmt = $scene->readType("automated");//read all automated scenes
    while($row = $sceneStmt->fetch(PDO::FETCH_ASSOC)){
        extract($row);
        $sceneId = $id;//get scene ID
        $sceneName = $name;//get scene name
        if($enabled == 1){//if scene is enabled then move forward checking all conditions
            $timeFlag = false;//flag used for putting time condition in AND with measure conditions
            $timeConditionStmt = $timeCondition->readWithSceneId($sceneId);//get possible time condition (it must be the first condition to be considered because is in AND with the other conditions)
            $num = $timeConditionStmt->rowCount();
            if($num > 0){//time condition exists, so put it in AND with measure conditions if evaluated True
                $tcRow = $timeConditionStmt->fetch(PDO::FETCH_ASSOC);
                extract($tcRow);
                $convertedMonths = convertStringToNumericMonths($months);
                $convertedDays = convertStringToNumericDays($days);
                $timeFlag = evaluateTimeCondition($convertedMonths, $convertedDays, $hour, $minute);//evaluate time condition and get time condition flag
                if($timeFlag){//time condition matched
                    evaluateMeasureConditions($sceneId, $sceneName);
                }
                else{//time condition evaluated False, do nothing
                    
                }
                
            }
            else{//time condition does not exist, only evaluate measure conditions
                evaluateMeasureConditions($sceneId, $sceneName);
            }
        }
    }
    
    /*This function is used for evaluating time condition.
     * If time conditions on hour, minute, months and days match, it returns True;
     * it returns False otherwise.
     */
    function evaluateTimeCondition($months, $days, $hour, $minute){
        global $actualMonth, $actualDay, $actualHour, $actualMinute;
        $timeFlag = false;
        if(!empty($months)){//months have been selected for executing scene
            if(!empty($days)){//days have been selected for executing scene
                if(in_array($actualMonth, $months) &&
                    in_array($actualDay, $days) &&
                    $actualHour == $hour && $actualMinute == $minute){
                        echo("Evaluating months and days\n\r");
                        $timeFlag = true;//time condition verified, so take it into account for next conditions
                }
            }
            else{//days have not been selected, execute scene each day of the week
                if(in_array($actualMonth, $months) &&
                    $actualHour == $hour && $actualMinute == $minute){
                        echo("Evaluating months only\n\r");
                        $timeFlag = true;//time condition verified, so take it into account for next conditions
                }
            }
        }
        else{//months have not been selected, execute scene each month of the year
            if(!empty($days)){//days have been selected for executing scene
                if(in_array($actualDay, $days) &&
                    $actualHour == $hour && $actualMinute == $minute){
                        echo("Evaluating days only\n\r");
                        $timeFlag = true;//time condition verified, so take it into account for next conditions
                }
            }
            else{//days have not been selected, execute scene each day of the week
                if($actualHour == $hour && $actualMinute == $minute){
                    echo("Evaluating hour and minute only\n\r");
                    $timeFlag = true;//time condition verified, so take it into account for next conditions
                }
            }
        }
        return $timeFlag;
    }
    
    /*
     * Function used for evaluating all scene measure conditions.
     * If one of them matches, then the respective actions are executed.
     * Measure conditions are in OR among them and in AND with time condition.
     */
    function evaluateMeasureConditions($sceneId, $sceneName){
        global $scene, $shmCondition, $measureCondition, $measure;
        $shmConditionStmt = $shmCondition->readWithSceneId($sceneId);//get all scene measure conditions
        $num = $shmConditionStmt->rowCount();
        if($num > 0){
            while($shmcRow = $shmConditionStmt->fetch(PDO::FETCH_ASSOC)){
                extract($shmcRow);
                $measureId = $measureConditionId;
                $mcStmt = $measureCondition->readId($measureId);//get specific measure condition
                $mcRow = $mcStmt->fetch(PDO::FETCH_ASSOC);
                extract($mcRow);
                switch($type){//get the right type of measure and its last value
                    case "temperature":
                        $actualValue = $measure->readLastOfType("temperature");
                        break;
                    case "humidity":
                        $actualValue = $measure->readLastOfType("humidity");
                        break;
                    case "consumption":
                        $actualValue = $measure->readLastOfType("consumption");
                        break;
                }
                
                switch ($operator){//since measure conditions are in OR among them, the first time a condition macthes the respective actions are executed
                    case "<":
                        if($actualValue < $value){//measure condition matches
                            if($scene->readRunning($sceneId) == 0){//only executes actions the first time the condition matches
                                $command = "/usr/bin/php /var/www/html/monday/process/scene_run.php ".$sceneId." >> /var/log/monday/scene.log &";
                                exec($command);
                                $scene->updateSceneRunning($sceneId, 1);
                                //publishNotificationToFirebase("Scenario ".$sceneName." in esecuzione");
                            }
                        }
                        else{//condition does not match anymore
                            if($scene->readRunning($sceneId) == 1){//if scene is running then turn it off
                                $scene->updateSceneRunning($sceneId, 0);
                                //publishNotificationToFirebase("Scenario ".$sceneName." terminato");
                            }
                        }
                        break;
                    case ">":
                        if($actualValue > $value){//measure condition matches
                            if($scene->readRunning($sceneId) == 0){//only executes actions the first time the condition matches
                                $command = "/usr/bin/php /var/www/html/monday/process/scene_run.php ".$sceneId." >> /var/log/monday/scene.log &";
                                exec($command);
                                $scene->updateSceneRunning($sceneId, 1);
                                //publishNotificationToFirebase("Scenario ".$sceneName." in esecuzione");
                            }
                        }
                        else{//condition does not match anymore
                            if($scene->readRunning($sceneId) == 1){//condition does not match anymore, if scene is running then turn it off
                                $scene->updateSceneRunning($sceneId, 0);
                                //publishNotificationToFirebase("Scenario ".$sceneName." terminato");
                            }
                        }
                        break;
                    case "=":
                        if($actualValue == $value){//measure condition matches
                            if($scene->readRunning($sceneId) == 0){//only executes actions the first time the condition matches
                                $command = "/usr/bin/php /var/www/html/monday/process/scene_run.php ".$sceneId." >> /var/log/monday/scene.log &";
                                exec($command);
                                $scene->updateSceneRunning($sceneId, 1);
                                //publishNotificationToFirebase("Scenario ".$sceneName." in esecuzione");
                            }
                        }
                        else{//condition does not match anymore
                            if($scene->readRunning($sceneId) == 1){//condition does not match anymore, if scene is running then turn it off
                                $scene->updateSceneRunning($sceneId, 0);
                                //publishNotificationToFirebase("Scenario ".$sceneName." terminato");
                            }
                        }
                        break;
                }
                
            }
        }
        else{/*there are no measure condition set; for time condition only there is no need to 
            set "running" attribute of the scene because the running time would be the time
            needed to execute scene_run.php script, even if the scene has some Timer actions
            inside. For this reason in this chunk of code there is only the call to the script.                        
            */
            $command = "/usr/bin/php /var/www/html/monday/process/scene_run.php ".$sceneId." >> /var/log/monday/scene.log &";
            exec($command);
            publishNotificationToFirebase("Scenario ".$sceneName." in esecuzione");
        }
        
    }

    function convertStringToNumericMonths($months){
        $numMonths = array();
        foreach($months as $key=>$value){
            switch($value){
                case "Gen":
                    array_push($numMonths, 1);
                    break;
                case "Feb":
                    array_push($numMonths, 2);
                    break;
                case "Mar":
                    array_push($numMonths, 3);
                    break;
                case "Apr":
                    array_push($numMonths, 4);
                    break;
                case "Mag":
                    array_push($numMonths, 5);
                    break;
                case "Giu":
                    array_push($numMonths, 6);
                    break;
                case "Lug":
                    array_push($numMonths, 7);
                    break;
                case "Ago":
                    array_push($numMonths, 8);
                    break;
                case "Set":
                    array_push($numMonths, 9);
                    break;
                case "Ott":
                    array_push($numMonths, 10);
                    break;
                case "Nov":
                    array_push($numMonths, 11);
                    break;
                case "Dic":
                    array_push($numMonths, 12);
                    break;
            }
        }
        return $numMonths;
    }
    
    function convertStringToNumericDays($days){
        $numDays = array();
        foreach($days as $key=>$value){
            switch($value){
                case "L":
                    array_push($numDays, 1);
                    break;
                case "Ma":
                    array_push($numDays, 2);
                    break;
                case "Me":
                    array_push($numDays, 3);
                    break;
                case "G":
                    array_push($numDays, 4);
                    break;
                case "V":
                    array_push($numDays, 5);
                    break;
                case "S":
                    array_push($numDays, 6);
                    break;
                case "D":
                    array_push($numDays, 7);
                    break;
            }
        }
        return $numDays;
    }

?>