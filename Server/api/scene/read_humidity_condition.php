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
    include_once '../model/measure_condition.php';
    include_once '../model/scene_has_measurecondition.php';
    
    $database = new Database();
    $db = $database->getConnection();
    
    $client = new Client($db);
    $humCondition = new MeasureCondition($db);
    $shmCondition = new SceneHasMeasureCondition($db);
    
    $data = json_decode(file_get_contents("php://input"));
    
    if (!empty($data->clientId) &&
        !empty($data->sessionToken) &&
        !empty($data->sceneId)){
            
            if($client->validateRequest($data->clientId, $data->sessionToken)) {
                
                $stmt = $shmCondition->readWithSceneId($data->sceneId);//get all scene conditions
                while($row = $stmt->fetch(PDO::FETCH_ASSOC)){
                    extract($row);
                    $measureStmt = $humCondition->readId($measureConditionId);//get measure record
                    $measureRow = $measureStmt->fetch(PDO::FETCH_ASSOC);
                    extract($measureRow);
                    if($type == "humidity"){//prepare TemperatureCondition to send back to client
                        $humCondition->operator = $operator;
                        $humCondition->value = $value;
                    }
                }
                // set response code - 200 OK
                http_response_code(200);
                echo json_encode($humCondition);
            }
            else {
                // set response code - 402 token not valid
                http_response_code(402);
                
                // tell the user
                echo json_encode(array("message" => "Unable to read HumidityCondition record. Token not valid."));
            }
    }
    else{
        // set response code - 400 bad request
        http_response_code(400);
        
        // tell the user
        echo json_encode(array("message" => "Unable to process the request. Data is incomplete."));
    }

?>