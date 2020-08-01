<?php
    // required headers
    header("Access-Control-Allow-Origin: *");
    header("Content-Type: application/json; charset=UTF-8");
    header("Access-Control-Allow-Methods: POST");
    header("Access-Control-Max-Age: 3600");
    header("Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With");
     
    // get database connection
    include_once '../config/database.php';
    include_once '../model/client.php';
    include_once '../model/scene.php';
     
    $database = new Database();
    $db = $database->getConnection();
     
    $scene = new Scene($db);
    $client = new Client($db);
    
    $data = json_decode(file_get_contents("php://input"));
    
    if (!empty($data->clientId) &&
        !empty($data->sessionToken)){
        
        if($client->validateRequest($data->clientId, $data->sessionToken)) {
            $records_arr=array();
            $records_arr["records"]=array();
            
            $stmt = $scene->readType("manual");
            while($row = $stmt->fetch(PDO::FETCH_ASSOC)){
                extract($row);
                $records_item=array(
                    "id" => $id,
                    "name" => $name,
                    "enabled" => $enabled
                );
                array_push($records_arr["records"], $records_item);
            }
            // set response code - 200 OK
            http_response_code(200);
            echo json_encode($records_arr);
        }
        else {
            // set response code - 402 token not valid
            http_response_code(402);
            
            // tell the user
            echo json_encode(array("message" => "Unable to read manual scenes. Token not valid."));
        }
    }
    else{
        // set response code - 400 bad request
        http_response_code(400);
        
        // tell the user
        echo json_encode(array("message" => "Unable to process the request. Data is incomplete."));
    }
    
?>