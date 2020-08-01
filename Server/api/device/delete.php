<?php
    // required headers
    header("Access-Control-Allow-Origin: *");
    header("Content-Type: application/json; charset=UTF-8");
     
    // database connection will be here
    
    include_once '../config/database.php';
    include_once '../model/device.php';
    include_once '../model/client.php';
    include_once '../model/measure.php';
    
    // instantiate database and product object
    $database = new Database();
    $db = $database->getConnection();
    
    // initialize object
    $device = new Device($db);
    $client = new Client($db);
    $measure = new Measure($db);
    
    // get posted data
    $data = json_decode(file_get_contents("php://input"));
    /*echo $data->id;
    echo $data->name;
    echo $data->type;
    echo $data->roomId;*/
        
    if(//roomId can be empty
        !empty($data->clientId) &&
        !empty($data->sessionToken) &&
        !empty($data->id)
    ){
       if ($client->validateRequest($data->clientId, $data->sessionToken)) {//validate user request
           // delete measures from device
           $measure->deleteWithDeviceId($data->id);
           // delete device
           if($device->delete($data->id)) {
               $command = "sudo pkill -f '".$data->id."'";
               exec($command);
               // set response code - 200 OK
               http_response_code(200);
                
               // show data in json format
               echo json_encode(array("message" => "Device successfully deleted."));
           }
           else {
               // set response code - 501 error on database
               http_response_code(501);
               
               // tell the user
               echo json_encode(array("message" => "Unable to perform the request. Error on database side"));
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