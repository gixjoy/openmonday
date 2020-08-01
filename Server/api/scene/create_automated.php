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
    
    // get posted data
    $data = json_decode(file_get_contents("php://input"));
    //var_dump($data);
    
    if(
        !empty($data->clientId) &&
        !empty($data->sessionToken) &&
        !empty($data->sceneName)
        ){
            if($client->validateRequest($data->clientId, $data->sessionToken)) {
                // set room property values
                $scene->name = $data->sceneName;
                $scene->type = "automated";
                $scene->enabled = 1;
                If($scene->create()) {//create new scene and get it's id
                    $sceneId = $scene->readLastId();
                    
                    $records = ($data->actions)->records;
                    foreach($records as $key=>$value){
                        $action->deviceId = $value->deviceId;
                        $action->command = $value->command;
                        if($action->create()){//create new action and get it's id
                            $actionId = $action->readLastId();
                            $sceneHasAction->sceneId = $sceneId;
                            $sceneHasAction->actionId = $actionId;
                            if (!$sceneHasAction->create()){
                                // set response code - 501 DB error
                                http_response_code(501);
                                
                                // tell the user
                                echo json_encode(array("message" => "Error creating SceneHasAction record."));
                            }
                            
                        }
                        else {
                            // set response code - 501 DB error
                            http_response_code(501);
                            
                            // tell the user
                            echo json_encode(array("message" => "Error creating Action record."));
                        }
                    }
                    if($data->timeCondition->enabled == 1){//check if time condition is enabled
                        $timeCondition->hour = $data->timeCondition->hour;
                        $timeCondition->minute = $data->timeCondition->minute;
                        $months = "'";
                        foreach($data->timeCondition->months as $key=>$value){
                            $months = $months.$value.",";
                        }
                        $months = rtrim($months, ",")."'";
                        $timeCondition->months = $months;
                        $days = "'";
                        foreach($data->timeCondition->days as $key=>$value){
                            $days = $days.$value.",";
                        }
                        $days = rtrim($days, ",")."'";
                        $timeCondition->days = $days;
                        $timeCondition->periodic = $data->timeCondition->periodic;
                        $timeCondition->sceneId = $sceneId;
                        if (!$timeCondition->create()){//create time condition record
                            // set response code - 501 DB error
                            http_response_code(501);
                            
                            // tell the user
                            echo json_encode(array("message" => "Error creating TimeCondition record."));
                        }
                    }
                    if($data->temperatureCondition->enabled == 1){//check if temperature condition is enabled
                        $measureCondition->type = "temperature";
                        $measureCondition->operator = $data->temperatureCondition->operator;
                        $measureCondition->value = $data->temperatureCondition->value;
                        if (!$measureCondition->create()){//create measure condition record
                            // set response code - 501 DB error
                            http_response_code(501);
                            
                            // tell the user
                            echo json_encode(array("message" => "Error creating TemperatureCondition record."));
                        }
                        else{
                            $shmCondition->sceneId = $sceneId;
                            $shmCondition->measureConditionId = $measureCondition->readLastId();
                            if(!$shmCondition->create()){//create SceneHasMeasureCondition record
                                // set response code - 501 DB error
                                http_response_code(501);
                                
                                // tell the user
                                echo json_encode(array("message" => "Error creating SceneHasMeasureCondition record."));
                            }
                        }
                    }
                    if($data->humidityCondition->enabled == 1){//check if humidity condition is enabled
                        $measureCondition->type = "humidity";
                        $measureCondition->operator = $data->humidityCondition->operator;
                        $measureCondition->value = $data->humidityCondition->value;
                        if (!$measureCondition->create()){//create measure condition record
                            // set response code - 501 DB error
                            http_response_code(501);
                            
                            // tell the user
                            echo json_encode(array("message" => "Error creating HumidityCondition record."));
                        }
                        else{
                            $shmCondition->sceneId = $sceneId;
                            $shmCondition->measureConditionId = $measureCondition->readLastId();
                            if(!$shmCondition->create()){//create SceneHasMeasureCondition record
                                // set response code - 501 DB error
                                http_response_code(501);
                                
                                // tell the user
                                echo json_encode(array("message" => "Error creating SceneHasMeasureCondition record."));
                            }
                        }
                    }
                    if($data->consumptionCondition->enabled == 1){//check if consumption condition is enabled
                        $measureCondition->type = "consumption";
                        $measureCondition->operator = $data->consumptionCondition->operator;
                        $measureCondition->value = $data->consumptionCondition->value;
                        if (!$measureCondition->create()){//create measure condition record
                            // set response code - 501 DB error
                            http_response_code(501);
                            
                            // tell the user
                            echo json_encode(array("message" => "Error creating ConsumptionCondition record."));
                        }
                        else{
                            $shmCondition->sceneId = $sceneId;
                            $shmCondition->measureConditionId = $measureCondition->readLastId();
                            if(!$shmCondition->create()){//create SceneHasMeasureCondition record
                                // set response code - 501 DB error
                                http_response_code(501);
                                
                                // tell the user
                                echo json_encode(array("message" => "Error creating SceneHasMeasureCondition record."));
                            }
                        }
                    }
                    // set response code - 200 created
                    http_response_code(200);
                    
                    // tell the user
                    echo json_encode(array("message" => "Scene successfully created."));
                }
                
                // if unable to create the room, tell the user
                else{
                    // set response code - 501 DB error
                    http_response_code(501);
                    
                    // tell the user
                    echo json_encode(array("message" => "Error creating Scene record."));
                }
            }
            else {
                // set response code - 402 token not valid
                http_response_code(402);
                
                // tell the user
                echo json_encode(array("message" => "Unable to create scene. Token not valid."));
            }
            
    }
    
    // tell the user data is incomplete
    else{
        
        // set response code - 400 bad request
        http_response_code(400);
        
        // tell the user
        echo json_encode(array("message" => "Unable to create scene. Data is incomplete."));
    }
?>