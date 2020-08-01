<?php
    // required headers
    header("Access-Control-Allow-Origin: *");
    header("Content-Type: application/json; charset=UTF-8");
     
    // database connection will be here
    
    include_once '../config/database.php';
    include_once '../model/client.php';
    include_once '../model/access_history.php';
    include_once '../model/measure.php';
    
    //Set Rome timezone
    date_default_timezone_set("Europe/Rome");
    
    // instantiate database and product object
    $database = new Database();
    $db = $database->getConnection();
    
    // initialize object
    $client = new Client($db);
    $measure = new Measure($db);
    $accessHistory = new AccessHistory($db);
    //$consumptionsMeasure = new ConsumptionsMeasure($db);
    
    // get posted data
    $data = json_decode(file_get_contents("php://input"));
    
    /*echo $data->username;
    echo $data->sessionToken;*/
    
    if(!empty($data->clientId) && 
       !empty($data->sessionToken)) {
        
           if ($client->validateRequest($data->clientId, $data->sessionToken)) {//read user fields
                $stmt = $client->readOne($data->clientId);
                $row = $stmt->fetch(PDO::FETCH_ASSOC);
                extract($row);
                
                //check sessionTimeout
                if($sessionTimeout > time() && $sessionToken == $data->sessionToken) {//login not required
                    //$lastAccess = $accessHistory->getLastAccess($id); //$id is the user id got from extract($row)
                    $lastUpdate = date('d/m/Y-H:i:s');
                    if ($lastUpdate == null) 
                        $lastUpdate = "---";
                    $lastTemperature = $measure->readLastOfType("temperature");
                    if ($lastTemperature == null)
                        $lastTemperature = "--";
                    $lastHumidity = $measure->readLastOfType("humidity");
                    if ($lastHumidity == null)
                        $lastHumidity = "--";
                    $lastConsumptions = $measure->sumLastOfType("consumption");
                    if ($lastConsumptions == null)
                        $lastConsumptions = "--";
                    $lastBattery = $measure->readLastOfType("battery"); //$id is the user id got from extract($row)
                    if ($lastBattery == null)
                        $lastBattery = "--";
                    $lastDate = $measure->readLastDate("temperature");//let's consider as last date the one of temperature reading
                    if ($lastDate == null)
                        $lastDate = "--";
                    $response = array("lastUpdate" => $lastUpdate, 
                                        "temperature" => $lastTemperature,
                                        "humidity" => $lastHumidity,
                                        "consumptions" => $lastConsumptions,
                                        "battery" => $lastBattery,
                                        "lastMeasureDate" => $lastDate 
                    );
                    // set response code - 200 request fulfilled
                    http_response_code(200);
                    echo json_encode($response);
                }
                else { //login required
                    // set response code - 401 login requested
                    http_response_code(401);
                    
                    // tell the user
                    echo json_encode(array("message" => "Unable to perform the request. Login requested."));
                }
           }
           else {
               // set response code - 402 token not valid
               http_response_code(402);
               
               // tell the user
               echo json_encode(array("message" => "Unable to get home data. Token not valid."));
           }
        
    }
    else {
        // set response code - 400 bad request
        http_response_code(400);
        
        // tell the user
        echo json_encode(array("message" => "Unable to perform the request. Data is incomplete."));
    }
?>