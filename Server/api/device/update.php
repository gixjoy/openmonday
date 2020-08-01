<?php
    // required headers
    header("Access-Control-Allow-Origin: *");
    header("Content-Type: application/json; charset=UTF-8");
     
    // database connection will be here
    
    include_once '../config/database.php';
    include_once '../model/device.php';
    include_once '../model/room.php';
    include_once '../model/client.php';
    include_once '../common/utils.php';
    
    // instantiate database object
    $database = new Database();
    $db = $database->getConnection();
    
    // initialize object
    $room = new Room($db);
    $device = new Device($db);
    $client = new Client($db);
    
    
    // get posted data
    $data = json_decode(file_get_contents("php://input"));
    /*echo $data->id;
    echo $data->name;
    echo $data->type;
    echo $data->roomId;*/
        
    if(//roomId can be empty
        !empty($data->clientId) &&
        !empty($data->sessionToken) &&
        !empty($data->id) &&
        !empty($data->name) &&
        !empty($data->type)
    ){
       if ($client->validateRequest($data->clientId, $data->sessionToken)) {//validate user request
           // update device
           $stmt = $device->readDevice($data->id);
           $row = $stmt->fetch(PDO::FETCH_ASSOC);
           extract($row);
           $enabledField = $enabled;//useful to know if we have to start the listening process on Mosquitto or not
           $deviceDescription = $description;
           
           if($device->updateDevice($data->id, $data->name, $data->type, $data->roomId)) {
               if($enabledField == 0){//device is being configured for the first time
                   $command = "/usr/bin/php /var/www/html/monday/process/connect_device_to_mosquitto.php ".$data->id." ".$deviceDescription." ".$data->type." >> /var/log/monday/monday_mq_connections.log &";
                   exec($command);
               }
               // set response code - 200 OK
               http_response_code(200);
                
               // show room data in json format
               echo json_encode(array("message" => "Device updated successfully."));
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