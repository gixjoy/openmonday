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
    include_once '../model/room.php';
    include_once '../model/device.php';
     
    $database = new Database();
    $db = $database->getConnection();
     
    $client = new Client($db);
    $room = new Room($db);
    $device = new Device($db);
    
    $data = json_decode(file_get_contents("php://input"));
    
    if (!empty($data->clientId) &&
        !empty($data->sessionToken) &&
        !empty($data->roomId)) {
        
        if($client->validateRequest($data->clientId, $data->sessionToken)) {
            $deviceStmt = $device->readRoom($data->roomId);//get all devices with specified room id
            while($row = $deviceStmt->fetch(PDO::FETCH_ASSOC)){//remove room id from all devices
                extract($row);
                $deviceId = $id;//get device id
                if(!$device->removeRoom($deviceId)) {//remove room from single device
                    http_response_code(501);
                    echo json_encode(array("message" => "Error setting roomId to NULL for device record."));
                }
            }
            if($room->delete($data->roomId)) {//delete room
                // set response code - 200 OK
                http_response_code(200);
                echo json_encode(array("message" => "Room successfully deleted."));
            }
            else{
                http_response_code(501);
                echo json_encode(array("message" => "Error deleting Room record."));
            }
        }
        else {
            // set response code - 402 token not valid
            http_response_code(402);
            
            // tell the user
            echo json_encode(array("message" => "Unable to delete room. Token not valid."));
        }
    }
    else{
        // set response code - 400 bad request
        http_response_code(400);
        
        // tell the user
        echo json_encode(array("message" => "Unable to process the request. Data is incomplete."));
    }
    
?>