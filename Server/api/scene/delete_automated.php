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
    include_once '../model/scene_has_measurecondition.php';
    include_once '../model/time_condition.php';
    include_once '../model/measure_condition.php';
    include_once '../model/scene.php';
     
    $database = new Database();
    $db = $database->getConnection();
     
    $client = new Client($db);
    $sceneHasAction = new SceneHasAction($db);
    $action = new Action($db);
    $scene = new Scene($db);
    $shmCondition = new SceneHasMeasureCondition($db);
    $timeCondition = new TimeCondition($db);
    $measureCondition = new MeasureCondition($db);
    
    $data = json_decode(file_get_contents("php://input"));
    
    if (!empty($data->clientId) &&
        !empty($data->sessionToken) &&
        !empty($data->sceneId)) {
        
        if($client->validateRequest($data->clientId, $data->sessionToken)) {
            $stmt = $sceneHasAction->readActionsWithSceneId($data->sceneId);
            while($row = $stmt->fetch(PDO::FETCH_ASSOC)){//delete all actions associated
                extract($row);
                if(!$action->delete($actionId)) {//delete single action, SceneHasAction records are deleted on cascade
                    http_response_code(501);
                    echo json_encode(array("message" => "Error deleting Action records."));
                }
            }
            $stmt = $shmCondition->readWithSceneId($data->sceneId);
            while($row = $stmt->fetch(PDO::FETCH_ASSOC)){//delete single MeasureCondition, SceneHasMeasureCondition records are deleted on cascade
                extract($row);
                if(!$measureCondition->delete($measureConditionId)) {
                    http_response_code(501);
                    echo json_encode(array("message" => "Error deleting MeasureCondition records."));
                }
            }
            if(!$timeCondition->delete($data->sceneId)) {
                http_response_code(501);
                echo json_encode(array("message" => "Error deleting TimeCondition record."));
            }
            if($scene->delete($data->sceneId)) {//delete scene
                // set response code - 200 OK
                http_response_code(200);
                echo json_encode(array("message" => "Scene successfully deleted."));
            }
            else{
                http_response_code(501);
                echo json_encode(array("message" => "Error deleting Scene record."));
            }
        }
        else {
            // set response code - 402 token not valid
            http_response_code(402);
            
            // tell the user
            echo json_encode(array("message" => "Unable to delete scene. Token not valid."));
        }
    }
    else{
        // set response code - 400 bad request
        http_response_code(400);
        
        // tell the user
        echo json_encode(array("message" => "Unable to process the request. Data is incomplete."));
    }
    
?>