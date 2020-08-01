<?php
    // required headers
    header("Access-Control-Allow-Origin: *");
    header("Content-Type: application/json; charset=UTF-8");
    
    include_once '../config/database.php';
    include_once '../model/client.php';
    include_once '../model/measure.php';
    include_once '../model/measure_hourly_avg.php';
    include_once '../model/measure_daily_avg.php';
    
    // instantiate database and product object
    $database = new Database();
    $db = $database->getConnection();
    
    // initialize object
    $client = new Client($db);
    $measure = new Measure($db);
    $measureHourly = new MeasureHourlyAVG($db);
    $measureDaily = new MeasureDailyAVG($db);
    
    // get posted data
    $data = json_decode(file_get_contents("php://input"));
    //echo $data->time;
    //error_log($data->time);
    
    if(
        !empty($data->clientId) &&
        !empty($data->sessionToken)&&
        !empty($data->time)
        ){
            if ($client->validateRequest($data->clientId, $data->sessionToken)) {//validate user request
                if ($data->time == "now"){//actual consumptions
                    getActualValue();
                }
                if ($data->time == "daily"){//daily consumptions
                    getDailyValues();
                    
                }
                if ($data->time == "monthly"){//monthly consumptions
                    getMonthlyValues();
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
    
    
    function getHourFromDate($date){
        $explodeDate = explode(" ", $date);
        $explodeHour = explode(":", $explodeDate[1]);
        $hour = $explodeHour[0];
        return $hour;
    }
    
    function getDayFromDate($date){
        $explodeDate = explode(" ", $date);
        $explodeDay = explode("-", $explodeDate[0]);
        $day = $explodeDay[2];
        return $day;
    }
    
    /*
     * Function made for getting actual consumptions value
     */
    function getActualValue(){
        global $measure, $db, $database;
        $value = $measure->sumLastOfType("consumption");
        $measure_item=array(
            "value" => $value
        );

        // set response code - 200 OK
        http_response_code(200);
        
        // show data in json format
        echo json_encode($measure_item);
    }
    
    /*
     * Function used for getting daily values from MeasureHourlyAVG and
     * sending results to mobile application
     */
    function getDailyValues(){
        global $measureHourly, $db, $database;
        $measure_arr=array();
        $measure_arr["records"]=array();
        $stmt = $measureHourly->sumOfType("consumption");
        while ($row = $stmt->fetch(PDO::FETCH_ASSOC)) {
            extract($row);
            $hour = intVal(getHourFromDate($date));
            //echo "HOUR: ".$hour;
            $measure_item=array(
                "hour" => $hour,
                "value" => $hourlyConsumptionTotal,
            );
            array_push($measure_arr["records"], $measure_item);
        }
        // set response code - 200 OK
        http_response_code(200);
        
        // show data in json format
        echo json_encode($measure_arr);
    }
    
    /*
     * Function used for getting monthly values from MeasureDailyAVG and
     * sending results to mobile application
     */
    function getMonthlyValues(){
        global $measureDaily, $db, $database;
        $measure_arr=array();
        $measure_arr["records"]=array();
        $stmt = $measureDaily->sumOfType("consumption");
        while ($row = $stmt->fetch(PDO::FETCH_ASSOC)) {
            extract($row);
            $day = intVal(getDayFromDate($date));
            //echo "HOUR: ".$hour;
            $measure_item=array(
                "day" => $day,
                "value" => $dailyConsumptionTotal,
            );
            array_push($measure_arr["records"], $measure_item);
        }
        // set response code - 200 OK
        http_response_code(200);
        
        // show data in json format
        echo json_encode($measure_arr);
    }
?>