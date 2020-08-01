<?php
    // required headers
    header("Access-Control-Allow-Origin: *");
    header("Content-Type: application/json; charset=UTF-8");
    
    include_once '../config/database.php';
    include_once '../model/client.php';
    include_once '../model/outlet.php';
    include_once '../common/shelly.php';
    include_once '../model/device.php';
    
    // instantiate database and product object
    $database = new Database();
    $db = $database->getConnection();
    
    // initialize object
    $client = new Client($db);
    $outlet = new Outlet($db);
    $device = new Device($db);
    
    // get posted data
    $data = json_decode(file_get_contents("php://input"));
    
    if(
        !empty($data->clientId) &&
        !empty($data->sessionToken) &&
        !empty($data->id)
    ){
       if ($client->validateRequest($data->clientId, $data->sessionToken)) {//validate user request
           // update outlet
           $switchStatus = $outlet->updateSwitch($data->id);
           if($switchStatus != -2) {//there is an outlet device on the database
               if ($switchStatus != -1) {//no error while updating switch status on database
                   //get ip of outlet device
                   $stmt = $device->readDevice($data->id);
                   $row = $stmt->fetch(PDO::FETCH_ASSOC);
                   extract($row);
                   //send command to outlet device
                   if (sendSwitchCommandToDevice($ip, $switchStatus) != -1){ //command successfully executed by Shelly
                       $device->updateDeviceStatus($data->id, 1);
                       // set response code - 200 OK
                       http_response_code(200);
                       
                       // show outlet data in json format
                       echo json_encode(array("message" => "Device successfully switched.", "switchStatus" => $switchStatus));
                   }
                   else {//error on Shelly side
                       if ($device->updateDeviceStatus($data->id, 0)) {
                           $outlet->updateSwitch($data->id);//update again switch status
                           // set response code - 503 error on Shelly side
                           http_response_code(503);
                           
                           // tell the user
                           echo json_encode(array("message" => "Unable to perform the request. Shelly is not reachable"));
                       }
                       else {
                           // set response code - 501 error on database
                           http_response_code(501);
                           
                           // tell the user
                           echo json_encode(array("message" => "Unable to update device status. Error on database side"));
                       }
                   }
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
                
                // tell the user no outlet device found
                echo json_encode(array("message" => "No outlet device found."));
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