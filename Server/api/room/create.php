<?php
    // required headers
    header("Access-Control-Allow-Origin: *");
    header("Content-Type: application/json; charset=UTF-8");
    header("Access-Control-Allow-Methods: POST");
    header("Access-Control-Max-Age: 3600");
    header("Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With");
     
    // get database connection
    include_once '../config/database.php';
     
    
    include_once '../model/room.php';
    include_once '../model/client.php';
     
    $database = new Database();
    $db = $database->getConnection();
     
    $room = new Room($db);
    $client = new Client($db);
     
    // get posted data
    $data = json_decode(file_get_contents("php://input"));
    //echo ("username: ".$data->username."\r\n");
    //echo ("Password: ".$data->password."\r\n");
    // make sure data is not empty
    if(
        !empty($data->clientId) &&
        !empty($data->sessionToken) &&
        !empty($data->roomName) &&
        !empty($data->roomCategory) &&
        !empty($data->roomButtonImgPath)
    ){
        if($client->validateRequest($data->clientId, $data->sessionToken)) {
            // set room property values
            $room->name = $data->roomName;
            $room->category = $data->roomCategory; 
            $room->imgPath = $data->roomButtonImgPath;
         
            // create the room
            if($room->create()){
         
                // set response code - 200 created
                http_response_code(200);
         
                // tell the user
                echo json_encode(array("message" => "Room was created."));
            }
         
            // if unable to create the room, tell the user
            else{     
                // set response code - 503 service unavailable
                http_response_code(503);
         
                // tell the user
                echo json_encode(array("message" => "Unable to create room."));
            }
        }
        else {
            // set response code - 402 token not valid
            http_response_code(402);
            
            // tell the user
            echo json_encode(array("message" => "Unable to create room. Token not valid."));
        }
            
    }
     
    // tell the user data is incomplete
    else{
     
        // set response code - 400 bad request
        http_response_code(400);
     
        // tell the user
        echo json_encode(array("message" => "Unable to create room. Data is incomplete."));
    }
?>