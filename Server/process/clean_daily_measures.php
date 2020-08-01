<?php 
    
    /*
     * The script is used for calculating the average values in the last day of consumptions, temperature and humidity
     * detected by the system and for storing them inside MeasureDailyAVG table on Monday. 
     * Eventually it deletes all detected measures from MeasureHourlyAVG table on Monday.
     * 
     * It is scheduled inside Crontab
     */

    include_once '/var/www/html/monday/api/config/database.php';
    include_once '/var/www/html/monday/api/model/measure.php';
    include_once '/var/www/html/monday/api/model/measure_hourly_avg.php';
    include_once '/var/www/html/monday/api/model/measure_daily_avg.php';
    
    // instantiate database
    $database = new Database();
    $db = $database->getConnection();
    
    $hourlyMeasure = new MeasureHourlyAVG($db);
    $dailyMeasure = new MeasureDailyAVG($db);
    
    $date = date("Y-m-d H:i:s");
    
    //Consumptions section
    $stmtConsumptions = $hourlyMeasure->getAVGofDeviceAndType("consumption");
    while ($row = $stmtConsumptions->fetch(PDO::FETCH_ASSOC)){
        extract($row);
        $dailyMeasure->deviceId = $deviceId;
        $dailyMeasure->date = $date;
        $dailyMeasure->type = "consumption";
        $dailyMeasure->value = $averageValue;
        
        $dailyMeasure->create();
    }
    
    //Temperature section
    $stmtTemperature = $hourlyMeasure->getAVGofDeviceAndType("temperature");
    while ($row = $stmtTemperature->fetch(PDO::FETCH_ASSOC)){
        extract($row);
        $dailyMeasure->deviceId = $deviceId;
        $dailyMeasure->date = $date;
        $dailyMeasure->type = "temperature";
        $dailyMeasure->value = $averageValue;
        
        $dailyMeasure->create();
    }
    
    //Humidity section
    $stmtHumidity = $hourlyMeasure->getAVGofDeviceAndType("humidity");
    while ($row = $stmtHumidity->fetch(PDO::FETCH_ASSOC)){
        extract($row);
        $dailyMeasure->deviceId = $deviceId;
        $dailyMeasure->date = $date;
        $dailyMeasure->type = "humidity";
        $dailyMeasure->value = $averageValue;
        
        $dailyMeasure->create();
    }
    
    //Delete all measures of "consumption" type from Measure table on Monday
    $hourlyMeasure->deleteAll("consumption");
    $hourlyMeasure->deleteAll("temperature");
    $hourlyMeasure->deleteAll("humidity");

?>