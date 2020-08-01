<?php
    // required headers
    header("Access-Control-Allow-Origin: *");
    header("Content-Type: application/json; charset=UTF-8");
    header("Access-Control-Allow-Methods: POST");
    header("Access-Control-Max-Age: 3600");
    header("Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With");
    
    include_once '../config/database.php';
    include_once '../model/user.php';
    include_once '../model/client.php';
     
    // get database connection
    $database = new Database();
    $db = $database->getConnection();
     
    $user = new User($db);
    $client = new Client($db);
     
    // get posted data
    $data = json_decode(file_get_contents("php://input"));
    
    if(isClientOnServerLAN($_SERVER['REMOTE_ADDR'], $_SERVER['SERVER_ADDR'])){//only allow user creation from within the same LAN as the server's
    //echo ("username: ".$data->username."\r\n");
    //echo ("Password: ".$data->password."\r\n");
    // make sure data is not empty
        if(
            !empty($data->username) &&
            !empty($data->password) &&
            !empty($data->clientId) &&
            !empty($data->firebaseToken)
        ){
         
            // set user property values
            $user->username = $data->username;
            $user->password = $data->password;
         
            // create the user
            if($user->create()){
                $stmt = $user->readUser($user->username);
                $row = $stmt->fetch(PDO::FETCH_ASSOC);
                extract($row);
                $client->clientId = $data->clientId;
                $client->userId = $id;
                $client->firebaseToken = $data->firebaseToken;
                if ($client->create()) {//create new record in Client table, with userid and firebase token for notification system
         
                    // set response code - 200 created
                    http_response_code(200);
             
                    // tell the user
                    echo json_encode(array("message" => "User was created."));
                }
                else {
                    // set response code - 503 service unavailable
                    http_response_code(503);
                    
                    // tell the user
                    echo json_encode(array("message" => "Unable to create user. Error while creating client record on Client table."));
                }
            }
         
            // if unable to create the user, tell the user
            else{     
                // set response code - 503 service unavailable
                http_response_code(503);
         
                // tell the user
                echo json_encode(array("message" => "Unable to create user."));
            }
        }
         
        // tell the user data is incomplete
        else{
         
            // set response code - 400 bad request
            http_response_code(400);
         
            // tell the user
            echo json_encode(array("message" => "Unable to create user. Data is incomplete."));
        }
    }
    else{
        // set response code - 405 Client IP on different LAN
        http_response_code(405);
        
        // tell the user
        echo json_encode(array("message" => "Unable to perform the request. Client is not on the same server's LAN."));
    }
    
    function isClientOnServerLAN($clientIp, $serverIp){
        $splitClientIp = explode(".", $clientIp);
        $clientNetwork = "";
        for($i=0; $i<sizeof($splitClientIp)-1; $i++ ){//get only the first 3 numbers of client IP address
            $clientNetwork .=$splitClientIp[$i];
        }
        
        $splitServerIp = explode(".", $serverIp);
        $serverNetwork = "";
        for($i=0; $i<sizeof($splitServerIp)-1; $i++ ){//get only the first 3 numbers of server IP address
            $serverNetwork .=$splitServerIp[$i];
        }
        
        if(strcmp($serverNetwork, $clientNetwork) == 0)
            return true;
        else
            return false;
    }
?>