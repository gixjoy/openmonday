<?php
    
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
        $command = "/usr/bin/php /var/www/html/monday/process/connect_device_to_mosquitto.php ".$id." ".$description." ".$type." >> /var/log/monday/monday_mq_connections.log &";
        exec($command);
    }
    publishNotificationToFirebase("Connessioni Mosquitto stabilite");
    insertNotificationOnDB("Connessioni Mosquitto stabilite");
?>