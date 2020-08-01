<?php 
    
    /*
     * The script is used for deleting all detected measures from MeasureDailyAVG table on Monday.
     * It is scheduled inside Crontab
     */

    include_once '/var/www/html/monday/api/config/database.php';
    include_once '/var/www/html/monday/api/model/measure_daily_avg.php';
    
    // instantiate database
    $database = new Database();
    $db = $database->getConnection();
    
    $dailyMeasure = new MeasureDailyAVG($db);
    
    //Delete all measures of "consumption" type from Measure table on Monday
    $dailyMeasure->deleteAll("consumption");
    $dailyMeasure->deleteAll("temperature");
    $dailyMeasure->deleteAll("humidity");

?>