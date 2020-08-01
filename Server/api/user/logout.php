<?php
    // required headers
    header("Access-Control-Allow-Origin: *");
    header("Content-Type: application/json; charset=UTF-8");
    
    include_once '../config/database.php';
    include_once '../model/client.php';
    include_once '../common/utils.php';
    
    // instantiate database and product object
    $database = new Database();
    $db = $database->getConnection();
    
    // initialize object
    $client = new Client($db);
    
    // get posted data
    $data = json_decode(file_get_contents("php://input"));
    /*echo "Username: ".$data->username."\n\r";
    echo "Password: ".$data->password."\n\r"; 
    echo "Client ID: ".$data->clientId."\n\r";
    echo "Firebase token: ".$data->firebaseToken."\n\r";*/
    
    
    if(!empty($data->clientId)){
        // logout user
        if($client->updateSessionToken($data->clientId, "") &&
            $client->updateSessionTimeout($data->clientId, 0)){
        
            http_response_code(200);
            echo json_encode(array("message" => "Logout successfully executed."));
        }
        else{
            // set response code - 501 database error
            http_response_code(501);
            
            // tell the user
            echo json_encode(array("message" => "Error on database while updating client record"));
        }
    }
    else {
        // set response code - 400 bad request
        http_response_code(400);
        
        // tell the user
        echo json_encode(array("message" => "Unable to logout. Data is incomplete."));
        
    }
?>
