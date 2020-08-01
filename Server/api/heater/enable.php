<?php
    // required headers
    header("Access-Control-Allow-Origin: *");
    header("Content-Type: application/json; charset=UTF-8");
     
    // database connection will be here
    
    include_once '../config/database.php';
    include_once '../model/heater.php';
    include_once '../common/shelly.php';
    include_once '../model/device.php';
    include_once '../model/client.php';
    
    // instantiate database and product object
    $database = new Database();
    $db = $database->getConnection();
    
    // initialize object
    $heater = new Heater($db);
    $device = new Device($db);
    $client = new Client($db);
    
    // get posted data
    $data = json_decode(file_get_contents("php://input"));
    
    if(
        !empty($data->clientId) &&
        !empty($data->sessionToken) &&
        !empty($data->id)
    ){
       if ($client->validateRequest($data->clientId, $data->sessionToken)) {//validate user request
           // update heater
           $enabledStatus = $heater->updateEnabled();//$result is the status of "enabled" field
           if($enabledStatus != -2) {//there is a climate controller on the database
               if ($enabledStatus != -1) {//no error while updating "enabled" status on database
                   http_response_code(200);
                   
                   // show heater data in json format
                   echo json_encode(array("message" => "System successfully triggered.", "enabled" => $enabledStatus));
               }
               else {
                   // set response code - 501 error on database
                   http_response_code(501);
                   
                   // tell the user
                   echo json_encode(array("message" => "Unable to perform the request. Error on database side"));
               }
            }
            else {
                // set response code - 201 Not found
                http_response_code(201);
                
                // tell the user no climate controller found
                echo json_encode(array("message" => "No climate controller found."));
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