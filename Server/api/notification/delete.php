<?php
    // required headers
    header("Access-Control-Allow-Origin: *");
    header("Content-Type: application/json; charset=UTF-8");
     
    // database connection will be here
    
    include_once '../config/database.php';
    include_once '../model/notification.php';
    include_once '../model/client.php';
    
    // instantiate database 
    $database = new Database();
    $db = $database->getConnection();
    
    // initialize object
    $client = new Client($db);
    $notification = new Notification($db);
    
    // get posted data
    $data = json_decode(file_get_contents("php://input"));
    //echo $data->id;
    //echo $data->username;
    //echo $data->sessionToken;
        
    if(
        !empty($data->clientId) &&
        !empty($data->sessionToken) &&
        (!empty($data->id || $data->id == 0))
    ){
       if ($client->validateRequest($data->clientId, $data->sessionToken)) {//validate user request
           // delete notification
           if($notification->delete($data->id)) {
               // set response code - 200 OK
               http_response_code(200);
                
               // show data in json format
               echo json_encode(array("message" => "Notification successfully deleted."));
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