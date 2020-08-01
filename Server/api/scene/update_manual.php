<?php
    // required headers
    header("Access-Control-Allow-Origin: *");
    header("Content-Type: application/json; charset=UTF-8");
    header("Access-Control-Allow-Methods: POST");
    header("Access-Control-Max-Age: 3600");
    header("Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With");
     
    // get database connection
    include_once '../config/database.php';
    include_once '../model/client.php';
    include_once '../model/action.php';
    include_once '../model/scene_has_action.php';
    include_once '../model/scene.php';
     
    $database = new Database();
    $db = $database->getConnection();
     
    $client = new Client($db);
    $sceneHasAction = new SceneHasAction($db);
    $action = new Action($db);
    $scene = new Scene($db);
    
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
                    echo json_encode(array("message" => "Error updating manual Scene record."));
                }
                else
                    updateManualScene($data->sceneId);
            }
            else {
                updateManualScene($data->sceneId);
            }
            // set response code - 200 OK
            http_response_code(200);
            echo json_encode(array("message" => "Manual Scene successfully updated."));
        }
        else {
            // set response code - 402 token not valid
            http_response_code(402);
            
            // tell the user
            echo json_encode(array("message" => "Unable to update manual scene. Token not valid."));
        }
    }
    else{
        // set response code - 400 bad request
        http_response_code(400);
        
        // tell the user
        echo json_encode(array("message" => "Unable to process the request. Data is incomplete."));
    }
    
    function updateManualScene($sceneId){
        global $action, $sceneHasAction, $data;
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
        
    }
    
?>