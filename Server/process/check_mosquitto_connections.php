<?php
    
    /*
     * This script is used for checking Monday connections to Mosquitto topics for 
     * devices of type "climate_sensor", "light" and "outlet".
     * If Shelly devices have no power meter, no measure will be sent to Monday DB - Measure table.
     * It is fired by a system process running every 10 seconds - Actually it is disabled by default
     */

    include_once '/var/www/html/monday/api/config/database.php';
    include_once '/var/www/html/monday/api/model/device.php';
    include_once '/var/www/html/monday/api/common/utils.php';
    
    // instantiate database
    $database = new Database();
    $db = $database->getConnection();
    
    $device = new Device($db);
    
    $stmt = $device->read();
    while($row = $stmt->fetch(PDO::FETCH_ASSOC)){
        extract($row);
        //echo($type."\n\r");
        if ($type == "climate_sensor" || 
            $type == "light" || 
            $type == "outlet") {
            $command = "ps aux | grep -v grep | grep ".$id;
            //echo $command."\n\r";
            exec($command, $output);
            //var_dump($output);
            if(sizeof($output) < 1) {
                echo "Processo MQ ".$description." terminato\n\r";
                publishNotificationToFirebase("Processo MQ ".$description." terminato");
                insertNotificationOnDB("Processo MQ ".$description." terminato");
                //establish new connection to Mosquitto topic when connection is dead for some reason
                $command = "/usr/bin/php /var/www/html/monday/process/connect_device_to_mosquitto.php ".$id." ".$description." ".$type." >> /var/log/monday/monday_mq_connections.log &";
                exec($command);
            }
            $output = "";
        }
    }
    //notification section
?>