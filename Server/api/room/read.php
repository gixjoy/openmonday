<?php
    // required headers
    header("Access-Control-Allow-Origin: *");
    header("Content-Type: application/json; charset=UTF-8");
     
    // database connection will be here
    
    include_once '../config/database.php';
    include_once '../model/client.php';
    include_once '../model/room.php';
    
    // instantiate database and product object
    $database = new Database();
    $db = $database->getConnection();
    
    // initialize object
    $client = new Client($db);
    $room = new Room($db);
    
    // get posted data
    $data = json_decode(file_get_contents("php://input"));
    
    if(
        !empty($data->clientId) &&
        !empty($data->sessionToken)
    ){
       if ($client->validateRequest($data->clientId, $data->sessionToken)) {//validate user request
           // read rooms
           $stmt = $room->read();
           $num = $stmt->rowCount();
            
           // check if more than 0 record found
           if($num>0){
               // rooms array
               $room_arr=array();
               $room_arr["records"]=array();
               
               // retrieve our table contents
               // fetch() is faster than fetchAll()
               // http://stackoverflow.com/questions/2770630/pdofetchall-vs-pdofetch-in-a-loop
               while ($row = $stmt->fetch(PDO::FETCH_ASSOC)){
                   // extract row
                   // this will make $row['name'] to
                   // just $name only
                   extract($row);
                   
                   $room_item=array(
                       "id" => $id,
                       "name" => $name,
                       "category" => $category,
                       "imgPath" => $imgPath
                   );
                   
                   array_push($room_arr["records"], $room_item);
               }
                
               // set response code - 200 OK
               http_response_code(200);
                
               // show room data in json format
               echo json_encode($room_arr);
           }
           else {
               // set response code - 201 Not found
               http_response_code(201);
               
               // tell the user no rooms found
               echo json_encode(
                   array("message" => "No rooms found.")
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