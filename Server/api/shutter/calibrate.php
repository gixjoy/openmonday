<?php
    // required headers
    header("Access-Control-Allow-Origin: *");
    header("Content-Type: application/json; charset=UTF-8");
    
    include_once '../config/database.php';
    include_once '../model/client.php';
    include_once '../model/shutter.php';
    include_once '../common/shelly.php';
    include_once '../model/device.php';
    
    // instantiate database and product object
    $database = new Database();
    $db = $database->getConnection();
    
    // initialize object
    $client = new Client($db);
    $shutter = new Shutter($db);
    $device = new Device($db);
    
    // get posted data
    $data = json_decode(file_get_contents("php://input"));
    
    if(
        !empty($data->clientId) &&
        !empty($data->sessionToken) &&
        !empty($data->id)
    ){
       if ($client->validateRequest($data->clientId, $data->sessionToken)) {//validate user request
           // send opening level to Shelly 
           $devStmt = $device->readDevice($data->id);
           $devRow = $devStmt->fetch(PDO::FETCH_ASSOC);
           extract($devRow);
           $shellyResponseCode = calibrateShutter($ip);
           if($shellyResponseCode == 1){//Shelly correctly executed command
               // set response code - 200 OK
               http_response_code(200);
               
               // tell the user
               echo json_encode(array("message" => "Shutter opening level correctly set."));
           }
           else {//error on Shelly side
               if ($device->updateDeviceStatus($data->id, 0)) {//update device status to "not working"
                   // set response code - 503 error on Shelly side
                   http_response_code(503);
                   
                   // tell the user
                   echo json_encode(array("message" => "Unable to perform the request. Shelly is not reachable"));
               }
               
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