<?php
    // required headers
    header("Access-Control-Allow-Origin: *");
    header("Content-Type: application/json; charset=UTF-8");
    
    // database connection will be here
    
    include_once '../config/database.php';
    include_once '../model/device.php';
    include_once '../model/client.php';
    
    // instantiate database and product object
    $database = new Database();
    $db = $database->getConnection();
    
    // initialize object
    $device = new Device($db);
    $client = new Client($db);
    
    // get posted data
    $data = json_decode(file_get_contents("php://input"));
    
    if(
        !empty($data->clientId) &&
        !empty($data->sessionToken) &&
        !empty($data->deviceId)
        ){
            if ($client->validateRequest($data->clientId, $data->sessionToken)) {//validate user request
                // read device status of specified device
                $devStatus = $device->getDeviceStatus($data->deviceId);
                if ($devStatus != -1) {
                    // set response code - 200 OK
                    http_response_code(200);
                    
                    echo json_encode(array("message" => "Device found.", "status" => $devStatus));
                }
                else {
                    // set response code - 201 Not found
                    http_response_code(201);
                    
                    // tell the user no light found
                    echo json_encode(array("message" => "No device found."));
                }
            }
            else {
                // set response code - 402 token not valid
                http_response_code(402);
                
                // tell the user
                echo json_encode(array("message" => "Unable to perform the request. Token not valid."));
            }
    }
    else {
        // set response code - 400 bad request
        http_response_code(400);
        
        // tell the user
        echo json_encode(array("message" => "Unable to perform the request. Data is incomplete."));
    }
?>