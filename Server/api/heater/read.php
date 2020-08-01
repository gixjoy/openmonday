<?php
    // required headers
    header("Access-Control-Allow-Origin: *");
    header("Content-Type: application/json; charset=UTF-8");
     
    // database connection will be here
    
    include_once '../config/database.php';
    include_once '../model/client.php';
    include_once '../model/heater.php';
    
    // instantiate database and product object
    $database = new Database();
    $db = $database->getConnection();
    
    // initialize object
    $heater = new Heater($db);
    $client = new Client($db);
    
    // get posted data
    $data = json_decode(file_get_contents("php://input"));
    
    if(
        !empty($data->clientId) &&
        !empty($data->sessionToken)
    ){
       if ($client->validateRequest($data->clientId, $data->sessionToken)) {//validate user request
           
           $stmt = $heater->readLast();
           $row = $stmt->fetch(PDO::FETCH_ASSOC);
           extract($row);
           
           if ($id != null) {
               $response = array("id" => $id,
                   "switch" => $switch,
                   "setTemperature" => $setTemperature,
                   "enabled" => $enabled
               );
                    
               // set response code - 200 OK
               http_response_code(200);
                
               // show heater data in json format
               echo json_encode($response);
           }
           else {
               // set response code - 201 Not found
               http_response_code(201);
               
               // tell the user no heater records found
               echo json_encode(
                   array("message" => "No heater records found.")
               );
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