<?php
    // required headers
    header("Access-Control-Allow-Origin: *");
    header("Content-Type: application/json; charset=UTF-8");
    header("Access-Control-Allow-Methods: POST");
    header("Access-Control-Max-Age: 3600");
    header("Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With");
     
     
    $data = json_decode(file_get_contents("php://input"));
    //echo ("username: ".$data->username."\r\n");
    //echo ("Password: ".$data->password."\r\n");
    // make sure data is not empty
    if(
        !empty($data->command) &&
        $data->command == "ping"
        ){
        // set response code - 200 OK
        http_response_code(200);
        
        // tell the user
        echo json_encode(array("message" => "Monday is available"));
    }
    else {
        // set response code - 400 bad request
        http_response_code(400);
        
        // tell the user
        echo json_encode(array("message" => "Unable to perform the request. Data is incomplete."));
    }
?>