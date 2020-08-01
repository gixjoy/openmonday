<?php
    // required headers
    header("Access-Control-Allow-Origin: *");
    header("Content-Type: application/json; charset=UTF-8");
    header("Access-Control-Allow-Methods: POST");
    header("Access-Control-Max-Age: 3600");
    header("Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With");
     
    include_once '../config/database.php';
    include_once '../model/action.php';
    include_once '../model/scene.php';
    include_once '../model/scene_has_action.php';
    include_once '../model/time_condition.php';
    include_once '../model/measure_condition.php';
    include_once '../model/scene_has_measurecondition.php';
    include_once '../model/client.php';
     
    $database = new Database();
    $db = $database->getConnection();
     
    $scene = new Scene($db);
    $action = new Action($db);
    $sceneHasAction = new SceneHasAction($db);
    $timeCondition = new TimeCondition($db);
    $measureCondition = new MeasureCondition($db);
    $shmCondition = new SceneHasMeasureCondition($db);
    $client = new Client($db);
    
    $data = json_decode(file_get_contents("php://input"));
    
    if (!empty($data->clientId) &&
        !empty($data->sessionToken) &&
        !empty($data->sceneId) &&
        !empty($data->actions)){
        
        if($client->validateRequest($data->clientId, $data->sessionToken)) {
            if(!empty($data->sceneName)) {
                if(!$scene->update($data->sceneId, $data->sceneName)){
                    // set response code - 503 service unavailable
                    http_response_code(501);
                    
                    // tell the user
                    echo json_encode(array("message" => "Error updating automated Scene record."));
                }
                else
                    updateAutomatedScene($data->sceneId);
            }
            else {
                updateAutomatedScene($data->sceneId);
            }
            // set response code - 200 OK
            http_response_code(200);
            echo json_encode(array("message" => "Automated Scene successfully updated."));
        }
        else {
            // set response code - 402 token not valid
            http_response_code(402);
            
            // tell the user
            echo json_encode(array("message" => "Unable to update automated Scene. Token not valid."));
        }
    }
    else{
        // set response code - 400 bad request
        http_response_code(400);
        
        // tell the user
        echo json_encode(array("message" => "Unable to process the request. Data is incomplete."));
    }
    
    function updateAutomatedScene($sceneId){
        global $action, $sceneHasAction, $data, $timeCondition, $measureCondition;
        $sceneActions = $sceneHasAction->readActionsWithSceneId($sceneId);
        while($row = $sceneActions->fetch(PDO::FETCH_ASSOC)){
            extract($row);
            $sceneHasAction->delete($data->sceneId);//delete all SceneHasRecords records
            $action->delete($actionId);//delete all actions of actual scene
        }
        //Let's create new actions with updated commands and indexes
        $records = ($data->actions)->records;
        foreach($records as $key=>$value){
            $action->deviceId = $value->deviceId;
            $action->command = $value->command;
            if($action->create()){//create new action and get it's id
                $actionId = $action->readLastId();
                $sceneHasAction->sceneId = $data->sceneId;
                $sceneHasAction->actionId = $actionId;
                if (!$sceneHasAction->create()){
                    // set response code - 503 service unavailable
                    http_response_code(501);
                    
                    // tell the user
                    echo json_encode(array("message" => "Error creating SceneHasAction record."));
                }
                
            }
            else {
                // set response code - 503 service unavailable
                http_response_code(501);
                
                // tell the user
                echo json_encode(array("message" => "Error creating Action record."));
            }
        }
        cleanSceneConditions($data->sceneId);//delete all scene's old records
        
        //Let's create new conditions updated
        createTimeConditionRecord($data->timeCondition, $data->sceneId);//updated time condition
        createTemperatureConditionRecord($data->temperatureCondition, $data->sceneId);
        createHumidityConditionRecord($data->humidityCondition, $data->sceneId);
        createConsumptionConditionRecord($data->consumptionCondition, $data->sceneId);
    }
    
    //Function used for deleting old scene records in MeasureCondition and TimeCondition tables
    function cleanSceneConditions($sceneId){
        global $shmCondition, $timeCondition, $measureCondition;
        $stmt = $shmCondition->readWithSceneId($sceneId);
        while($row = $stmt->fetch(PDO::FETCH_ASSOC)){//delete single MeasureCondition, SceneHasMeasureCondition records are deleted on cascade
            extract($row);
            if(!$measureCondition->delete($measureConditionId)) {
                http_response_code(501);
                echo json_encode(array("message" => "Error while updating scene, deleting MeasureCondition records."));
            }
        }
        if(!$timeCondition->delete($sceneId)) {
            http_response_code(501);
            echo json_encode(array("message" => "Error while updating scene, deleting TimeCondition record."));
        }
    }
    
    //Function used for creating new time condition record 
    function createTimeConditionRecord($timeCond, $sceneId){
        global $timeCondition;
        //var_dump($timeCond);
        if($timeCond->enabled == 1){//check if time condition is enabled
            $timeCondition->hour = $timeCond->hour;
            $timeCondition->minute = $timeCond->minute;
            $months = "'";
            foreach($timeCond->months as $key=>$value){
                $months = $months.$value.",";
            }
            $months = rtrim($months, ",")."'";
            $timeCondition->months = $months;
            $days = "'";
            foreach($timeCond->days as $key=>$value){
                $days = $days.$value.",";
            }
            $days = rtrim($days, ",")."'";
            $timeCondition->days = $days;
            $timeCondition->periodic = $timeCond->periodic;
            $timeCondition->sceneId = $sceneId;
            if (!$timeCondition->create()){//create time condition record
                // set response code - 501 DB error
                http_response_code(501);
                
                // tell the user
                echo json_encode(array("message" => "Error while updating automated scene, creating TimeCondition record."));
            }
        }
    }
    
    //Function used for creating new temperature condition record 
    function createTemperatureConditionRecord($tempCond, $sceneId){
        global $shmCondition, $measureCondition;
        if($tempCond->enabled == 1){//check if temperature condition is enabled
            $measureCondition->type = "temperature";
            $measureCondition->operator = $tempCond->operator;
            $measureCondition->value = $tempCond->value;
            if (!$measureCondition->create()){//create measure condition record
                // set response code - 501 DB error
                http_response_code(501);
                
                // tell the user
                echo json_encode(array("message" => "Error while updating automated scene, creating MeasureCondition(temperature) record."));
            }
            else{
                $shmCondition->sceneId = $sceneId;
                $shmCondition->measureConditionId = $measureCondition->readLastId();
                if(!$shmCondition->create()){//create SceneHasMeasureCondition record
                    // set response code - 501 DB error
                    http_response_code(501);
                    
                    // tell the user
                    echo json_encode(array("message" => "Error while updating automated scene, creating SceneHasMeasureCondition(temperature) record."));
                }
            }
        }
    }
    
    //Function used for creating new humidity condition record
    function createHumidityConditionRecord($humCond, $sceneId){
        global $shmCondition, $measureCondition;
        if($humCond->enabled == 1){//check if humidity condition is enabled
            $measureCondition->type = "humidity";
            $measureCondition->operator = $humCond->operator;
            $measureCondition->value = $humCond->value;
            if (!$measureCondition->create()){//create measure condition record
                // set response code - 501 DB error
                http_response_code(501);
                
                // tell the user
                echo json_encode(array("message" => "Error while updating automated scene, creating MeasureCondition(humidity) record."));
            }
            else{
                $shmCondition->sceneId = $sceneId;
                $shmCondition->measureConditionId = $measureCondition->readLastId();
                if(!$shmCondition->create()){//create SceneHasMeasureCondition record
                    // set response code - 501 DB error
                    http_response_code(501);
                    
                    // tell the user
                    echo json_encode(array("message" => "Error while updating automated scene, creating SceneHasMeasureCondition(humidity) record."));
                }
            }
        }
    }
    
    //Function used for creating new consumption condition record
    function createConsumptionConditionRecord($consCond, $sceneId){
        global $shmCondition, $measureCondition;
        if($consCond->enabled == 1){//check if consumption condition is enabled
            $measureCondition->type = "consumption";
            $measureCondition->operator = $consCond->operator;
            $measureCondition->value = $consCond->value;
            if (!$measureCondition->create()){//create measure condition record
                // set response code - 501 DB error
                http_response_code(501);
                
                // tell the user
                echo json_encode(array("message" => "Error while updating automated scene, creating MeasureCondition(consumption) record."));
            }
            else{
                $shmCondition->sceneId = $sceneId;
                $shmCondition->measureConditionId = $measureCondition->readLastId();
                if(!$shmCondition->create()){//create SceneHasMeasureCondition record
                    // set response code - 501 DB error
                    http_response_code(501);
                    
                    // tell the user
                    echo json_encode(array("message" => "Error while updating automated scene, creating SceneHasMeasureCondition(consumption) record."));
                }
            }
        }
    }
    
?>