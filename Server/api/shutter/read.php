<?php
    // required headers
    header("Access-Control-Allow-Origin: *");
    header("Content-Type: application/json; charset=UTF-8");
    
    // database connection will be here
    
    include_once '../config/database.php';
    include_once '../model/client.php';
    include_once '../model/device.php';
    include_once '../model/shutter.php';
    
    // instantiate database and product object
    $database = new Database();
    $db = $database->getConnection();
    
    // initialize object
    $client = new Client($db);
    $device = new Device($db);
    $shutter = new Shutter($db);
    
    // get posted data
    $data = json_decode(file_get_contents("php://input"));
    
    if(
        !empty($data->clientId) &&
        !empty($data->sessionToken)
        ){
            if ($client->validateRequest($data->clientId, $data->sessionToken)) {//validate user request
                // read devices
                $stmt = $device->readType("shutter");
                $num = $stmt->rowCount();
                
                // check if more than 0 record found
                if($num>0){
                    // devices array
                    $device_arr=array();
                    $device_arr["records"]=array();
                    while ($row = $stmt->fetch(PDO::FETCH_ASSOC)){
                        // extract row
                        // this will make $row['name'] to
                        // just $name only
                        extract($row);
                        $openingLevel = $shutter->getLevelStatus($id);
                        $device_item=array(
                            "id" => $id,
                            "name" => $name,
                            "description" => $description,
                            "type" => $type,
                            "roomId" => $roomId,
                            "status" => $status,
                            "enabled" => $enabled,
                            "ip" => $ip,
                            "openingLevel"=>$openingLevel
                        );
                        
                        array_push($device_arr["records"], $device_item);
                    }
                    
                    // set response code - 200 OK
                    http_response_code(200);
                    
                    // show data in json format
                    echo json_encode($device_arr);
                }
                else {
                    // set response code - 201 Not found
                    http_response_code(201);
                    
                    // tell the user no shutters found
                    echo json_encode(
                        array("message" => "No devices found.")
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