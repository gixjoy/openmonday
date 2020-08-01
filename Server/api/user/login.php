<?php
    // required headers
    header("Access-Control-Allow-Origin: *");
    header("Content-Type: application/json; charset=UTF-8");
     
    // database connection will be here
    
    include_once '../config/database.php';
    include_once '../model/user.php';
    include_once '../model/client.php';
    include_once '../common/utils.php';
    
    $timeout = 43200; //session timeout = 12 hour (in seconds)
    //Set Rome timezone
    date_default_timezone_set("Europe/Rome");
    
    // instantiate database and product object
    $database = new Database();
    $db = $database->getConnection();
    
    // initialize object
    $user = new User($db);
    $client = new Client($db);
    
    // get posted data
    $data = json_decode(file_get_contents("php://input"));
    /*echo "Username: ".$data->username."\n\r";
    echo "Password: ".$data->password."\n\r"; 
    echo "Client ID: ".$data->clientId."\n\r";
    echo "Firebase token: ".$data->firebaseToken."\n\r";*/
    
    
    if(
        !empty($data->username) &&
        !empty($data->password) &&
        !empty($data->clientId) &&
        !empty($data->firebaseToken)
        ){
            
            // set user property values
            $username = $data->username;
            $password = $data->password;
    
            // login user
            $res = $user->login($username, $password);
            if( $res == 0) {
                // set response code - 200 user found but not enabled
                http_response_code(401);
                // tell the user
                echo json_encode(array("message" => "User exists but not enabled."));
            }
            if($res == 1) {//User exists and enabled                
                //set current access on User table
                $currentAccess = date("Y-m-d H:i:s");
                $user->updateCurrentAccess($username, $currentAccess);
                
                //set sessionTimeout on User table
                $now = time();//get current time in seconds
                $sessionTimeout = $now + $timeout; //compute now + timeout
                $sessionToken = generateRandomString();//generate session token
                //echo ("\r\nSession timeout successfully set on database\r\n");//after successful login, set sessionTimeout on database
                
                $stmt = $client->readOne($data->clientId);
                if($stmt->rowCount() > 0) {//clientId already exists
                    $client->updateFirebaseToken($data->clientId, $data->firebaseToken);
                    $client->updateSessionToken($data->clientId, $sessionToken);
                    $client->updateSessionTimeout($data->clientId, $sessionTimeout);
                }
                else {//otherwise
                    $stmt = $user->readUser($username);
                    $row = $stmt->fetch(PDO::FETCH_ASSOC);
                    extract($row);
                    $client->clientId = $data->clientId;
                    $client->userId = $id;
                    $client->firebaseToken = $data->firebaseToken;
                    $client->clientId = $data->clientId;
                    $client->sessionTimeout = $sessionTimeout;
                    $client->sessionToken = $sessionToken;
                    $client->create();
                }
                 
                //$user->updateFirebaseToken($data->username, $firebaseToken);
               // echo ("\r\nSession token successfully set on database\r\n");
                http_response_code(200);
                echo json_encode(array("message" => "User exists and enabled.",
                                    "sessionToken" => $sessionToken
                ));
                
            }
            if($res == 2) {
                http_response_code(403);//User does not exist
                echo json_encode(array("message" => "Unable to perform the request. Wrong credentials."));
            }
    }
    else {
        // set response code - 400 bad request
        http_response_code(400);
        
        // tell the user
        echo json_encode(array("message" => "Unable to login. Data is incomplete."));
        
    }
?>
