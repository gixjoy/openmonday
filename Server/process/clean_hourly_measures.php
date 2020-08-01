<?php 
    
    /*
     * The script is used for calculating the average values in the last hour of consumptions, temperature and humidity
     * detected by the system and for storing them inside MeasureHourlyAVG table on Monday. 
     * Eventually it deletes all detected measures from Measure table on Monday.
     * 
     * It is scheduled inside Crontab
     */

    include_once '/var/www/html/monday/api/config/database.php';
    include_once '/var/www/html/monday/api/model/measure.php';
    include_once '/var/www/html/monday/api/model/measure_hourly_avg.php';
    
    // instantiate database
    $database = new Database();
    $db = $database->getConnection();
    
    $measure = new Measure($db);
    $hourlyMeasure = new MeasureHourlyAVG($db);
    
    $date = date("Y-m-d H:i:s");
    
    //Consumptions section
    $stmtConsumptions = $measure->getAVGofDeviceAndType("consumption");
    while ($row = $stmtConsumptions->fetch(PDO::FETCH_ASSOC)){
        extract($row);
        $hourlyMeasure->deviceId = $deviceId;
        $hourlyMeasure->date = $date;
        $hourlyMeasure->type = "consumption";
        $hourlyMeasure->value = $averageValue;
        
        $hourlyMeasure->create();
    }
    
    //Temperature section
    $stmtTemperature = $measure->getAVGofDeviceAndType("temperature");
    while ($row = $stmtTemperature->fetch(PDO::FETCH_ASSOC)){
        extract($row);
        $hourlyMeasure->deviceId = $deviceId;
        $hourlyMeasure->date = $date;
        $hourlyMeasure->type = "temperature";
        $hourlyMeasure->value = $averageValue;
        
        $hourlyMeasure->create();
    }
    
    //Humidity section
    $stmtHumidity = $measure->getAVGofDeviceAndType("humidity");
    while ($row = $stmtHumidity->fetch(PDO::FETCH_ASSOC)){
        extract($row);
        $hourlyMeasure->deviceId = $deviceId;
        $hourlyMeasure->date = $date;
        $hourlyMeasure->type = "humidity";
        $hourlyMeasure->value = $averageValue;
        
        $hourlyMeasure->create();
    }
    
    //Delete all measures of "consumption" type from Measure table on Monday
    $measure->deleteAll("consumption");
    $measure->deleteAllButTheLast("temperature");

?>