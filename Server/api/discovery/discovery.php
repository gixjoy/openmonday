<?php

    // required headers
    header("Access-Control-Allow-Origin: *");
    header("Content-Type: application/json; charset=UTF-8");
    
    include_once("../model/discovery_record.php");
    include_once '../config/database.php';
    include_once("../model/device.php");
    include_once("../common/shelly.php");
    include_once '../model/client.php';
    
    $filename = "/tmp/discovered_devices.txt"; //filename for discovered devices
    //$command = "sudo nmap -sP 192.168.1.0/24 > ".$filename;//command for discoverying new devices on the network
    
    // instantiate database and product object
    $database = new Database();
    $db = $database->getConnection();
    
    // initialize object
    $device = new Device($db);
    $client = new Client($db);
    
    // get posted data
    $data = json_decode(file_get_contents("php://input"));
    
    if(
        !empty($data->clientId) &&
        !empty($data->sessionToken)
        ){
            if ($client->validateRequest($data->clientId, $data->sessionToken)) {//validate user request
                //read all new devices from database
                $newDevices = $device->readNotEnabled();
                $num = $newDevices->rowCount();
                $dev_arr=array();
                $dev_arr["records"]=array();
                if($num>0){//there are devices on database
                    while ($row = $newDevices->fetch(PDO::FETCH_ASSOC)){//build array of already discovered devices from db
                        extract($row);
                        $dev_item=array(
                            "id" => $id,
                            "description" => $description,
                            "ip" => $ip
                        );
                        
                        array_push($dev_arr["records"], $dev_item);
                    }
                }
                // set response code - 200 OK
                http_response_code(200);
                echo json_encode($dev_arr);
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
