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
    include_once '../model/time_condition.php';
    
    $database = new Database();
    $db = $database->getConnection();
    
    $client = new Client($db);
    $timeCondition = new TimeCondition($db);
    
    $data = json_decode(file_get_contents("php://input"));
    
    if (!empty($data->clientId) &&
        !empty($data->sessionToken) &&
        !empty($data->sceneId)){
            
            if($client->validateRequest($data->clientId, $data->sessionToken)) {
                
                $stmt = $timeCondition->readWithSceneId($data->sceneId);
                while($row = $stmt->fetch(PDO::FETCH_ASSOC)){
                    extract($row);
                    $timeCondition->hour = $hour;
                    $timeCondition->minute = $minute;
                    $timeCondition->periodic = $periodic;
                    $condMonths = array();
                    $condDays = array();
                    if($periodic == 1){
                        $condMonths = explode (",", $months);
                        $timeCondition->months = $condMonths;
                        $condDays = explode(",", $days);
                        $timeCondition->days = $condDays;
                    }
                }
                // set response code - 200 OK
                http_response_code(200);
                echo json_encode($timeCondition);
            }
            else {
                // set response code - 402 token not valid
                http_response_code(402);
                
                // tell the user
                echo json_encode(array("message" => "Unable to read TimeCondition record. Token not valid."));
            }
    }
    else{
        // set response code - 400 bad request
        http_response_code(400);
        
        // tell the user
        echo json_encode(array("message" => "Unable to process the request. Data is incomplete."));
    }

?>