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
    include_once '../model/device.php';
     
    $database = new Database();
    $db = $database->getConnection();
     
    $client = new Client($db);
    $sceneHasAction = new SceneHasAction($db);
    $action = new Action($db);
    $device = new Device($db);
    
    $data = json_decode(file_get_contents("php://input"));
    
    if (!empty($data->clientId) &&
        !empty($data->sessionToken) &&
        !empty($data->sceneId)){
        
        if($client->validateRequest($data->clientId, $data->sessionToken)) {
            $records_arr=array();
            $records_arr["records"]=array();
            
            $stmt = $sceneHasAction->readActionsWithSceneId($data->sceneId);//read actions
            while($row = $stmt->fetch(PDO::FETCH_ASSOC)){
                extract($row);
                $aId = $actionId;
                
                $actionstmt = $action->readId($aId);//read single action
                $actionRow = $actionstmt->fetch(PDO::FETCH_ASSOC);
                extract($actionRow);
                $devId = $deviceId;
                
                $devicestmt = $device->readDevice($devId);//read action device
                $deviceRow = $devicestmt->fetch(PDO::FETCH_ASSOC);
                extract($deviceRow);
                $deviceName = $name;//read action device name
                $deviceType = $type;
                
                $records_item=array(//create records item with all action infos
                    "actionId" => $id,
                    "deviceId" => $deviceId,
                    "deviceType" => $deviceType,
                    "deviceName" => $deviceName,
                    "command" => $command
                );
                array_push($records_arr["records"], $records_item);
            }
            // set response code - 200 OK
            http_response_code(200);
            echo json_encode($records_arr);
        }
        else {
            // set response code - 402 token not valid
            http_response_code(402);
            
            // tell the user
            echo json_encode(array("message" => "Unable to read scenes. Token not valid."));
        }
    }
    else{
        // set response code - 400 bad request
        http_response_code(400);
        
        // tell the user
        echo json_encode(array("message" => "Unable to process the request. Data is incomplete."));
    }
    
?>