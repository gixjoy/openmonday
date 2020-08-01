<?php
    // required headers
    header("Access-Control-Allow-Origin: *");
    header("Content-Type: application/json; charset=UTF-8");
    
    // database connection will be here
    
    include_once '../config/database.php';
    include_once '../model/client.php';
    include_once '../model/notification.php';
    include_once '../common/utils.php';
    
    // instantiate database and product object
    $database = new Database();
    $db = $database->getConnection();
    
    // initialize object
    $client = new Client($db);
    $notification = new Notification($db);
    
    // get posted data
    $data = json_decode(file_get_contents("php://input"));
    
    if(
        !empty($data->clientId) &&
        !empty($data->sessionToken)
        ){
            if ($client->validateRequest($data->clientId, $data->sessionToken)) {//validate user request
                // read notifications
                $stmt = $notification->readAll();
                $num = $stmt->rowCount();
                
                // check if more than 0 record found
                if($num>0){
                    // notifications array
                    $notification_arr=array();
                    $notification_arr["records"]=array();
                    
                    while ($row = $stmt->fetch(PDO::FETCH_ASSOC)){
                        extract($row);
                        $newDate = convertDateToEUFormat($date);
                        $notification_item=array(
                            "id" => $id,
                            "message" => $message,
                            "date" => $newDate,
                        );
                        
                        array_push($notification_arr["records"], $notification_item);
                    }
                    
                    // set response code - 200 OK
                    http_response_code(200);
                    
                    // show notification data in json format
                    echo json_encode($notification_arr);
                }
                else {
                    // set response code - 201 Not found
                    http_response_code(201);
                    
                    // tell the user no notifications found
                    echo json_encode(
                        array("message" => "No notification found.")
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
    
    
    
    
    
    
    
    
    
    