<?php
    // required headers
    header("Access-Control-Allow-Origin: *");
    header("Content-Type: application/json; charset=UTF-8");
    header("Access-Control-Allow-Methods: POST");
    header("Access-Control-Max-Age: 3600");
    header("Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With");
     
    // get database connection
    include_once '../config/database.php';
     
    // instantiate product object
    include_once '../model/client.php';
     
    $database = new Database();
    $db = $database->getConnection();
     
    $user = new User($db);
     
    // get posted data
    $data = json_decode(file_get_contents("php://input"));
    //echo ("username: ".$data->username."\r\n");
    //echo ("Password: ".$data->password."\r\n");
    // make sure data is not empty
    if(
        !empty($data->username) &&
        !empty($data->password) &&
        !empty($data->sessionToken)
        ){
            if ($client->validateRequest($data->username, $data->sessionToken)) {//validate user request
                //update user data on database
                if ($user->updateUserPassword($data->username, $data->password)) {
                    // set response code - 200 update executed
                    http_response_code(200);
                    
                    // tell the user
                    echo json_encode(array("message" => "User was updated."));
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
     
    // tell the user data is incomplete
    else{
     
        // set response code - 400 bad request
        http_response_code(400);
     
        // tell the user
        echo json_encode(array("message" => "Unable to create user. Data is incomplete."));
    }
?>