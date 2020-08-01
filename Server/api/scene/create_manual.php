<?php
    // required headers
    header("Access-Control-Allow-Origin: *");
    header("Content-Type: application/json; charset=UTF-8");
    header("Access-Control-Allow-Methods: POST");
    header("Access-Control-Max-Age: 3600");
    header("Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With");
    
    // get database connection
    include_once '../config/database.php';
    include_once '../model/action.php';
    include_once '../model/scene.php';
    include_once '../model/scene_has_action.php';
    include_once '../model/client.php';
    
    $database = new Database();
    $db = $database->getConnection();
    
    $scene = new Scene($db);
    $action = new Action($db);
    $sceneHasAction = new SceneHasAction($db);
    $client = new Client($db);
    
    // get posted data
    $data = json_decode(file_get_contents("php://input"));
    
    if(
        !empty($data->clientId) &&
        !empty($data->sessionToken) &&
        !empty($data->sceneName) &&
        !empty($data->actions)
        ){
            if($client->validateRequest($data->clientId, $data->sessionToken)) {
                // set scene property values
                $scene->name = $data->sceneName;
                $scene->type = "manual";
                $scene->enabled = 0;
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
                                // set response code - DB error
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