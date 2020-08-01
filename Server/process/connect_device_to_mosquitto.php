<?php
    
    /*
     * This script is used for connecting Monday to Mosquitto topics when a connection is dropped
     * for some reason. It is fired by check_mosquitto_connections.php or connecto_to_mosquitto_on_reboot.php
     */

    include_once '/var/www/html/monday/api/config/database.php';
    include_once '/var/www/html/monday/api/config/mosquitto.php';
    include_once '/var/www/html/monday/api/model/measure.php';
    include_once '/var/www/html/monday/api/model/device.php';
    include_once '/var/www/html/monday/api/common/utils.php';
    
    // instantiate database
    $database = new Database();
    $db = $database->getConnection();
    
    /*
     * Command format:
     *      connect_to_mosquitto_topic.php "deviceId" "deviceDescription" "deviceType"
     */
    
    $deviceId = $argv[1];
    $deviceDescription = $argv[2];
    $type = $argv[3];
    
    
    if($type == "outlet" || $type == "light" || $type == "climate") {
        $consumptionTopic = "shellies/".$deviceDescription."/relay/0/power";
        
        //Mosquitto connection
        $mosquitto = new Mosquitto();
        $client = $mosquitto->getClient("Monday_subscribe_to_".$deviceId);
        $client->setWill('monday/consumption_sub', 'Consumption_sub offline', 1, true);
        $client->onMessage('message');//execute callback function "message"
        $client->onDisconnect('disconnectFromConsumptions');
        $client->subscribe($consumptionTopic, 1);
        
        //publishNotificationToFirebase("Connessione MQ ".$deviceDescription." stabilita");
        //insertNotificationOnDB("Connessione MQ ".$deviceDescription." stabilita");
        
        $client->loopForever();
    }
    elseif($type == "shutter") {
        $consumptionTopic = "shellies/".$deviceDescription."/roller/0/power";
        
        //Mosquitto connection
        $mosquitto = new Mosquitto();
        $client = $mosquitto->getClient("Monday_subscribe_to_".$deviceId);
        $client->setWill('monday/consumption_sub', 'Consumption_sub offline', 1, true);
        $client->onMessage('message');//execute callback function "message"
        $client->onDisconnect('disconnectFromConsumptions');
        $client->subscribe($consumptionTopic, 1);
        
        //publishNotificationToFirebase("Connessione MQ ".$deviceDescription." stabilita");
        //insertNotificationOnDB("Connessione MQ ".$deviceDescription." stabilita");
        
        $client->loopForever();
    }
    elseif($type == "climate_sensor"){
        //MQTT topics
        $temperatureTopic = "shellies/".$deviceDescription."/sensor/temperature";
        $humidityTopic = "shellies/".$deviceDescription."/sensor/humidity";
        $batteryTopic = "shellies/".$deviceDescription."/sensor/battery";
        
        //Mosquitto connection
        $mosquitto = new Mosquitto();
        $client = $mosquitto->getClient("Monday_subscribe_to_".$deviceId);
        $client->setWill('monday/climate_sub', 'Climate_sub offline', 1, true);
        $client->onDisconnect('disconnectFromClimate');
        $client->onMessage('message');//execute callback function "message"
        $client->subscribe($temperatureTopic, 1);
        $client->subscribe($humidityTopic, 1);
        $client->subscribe($batteryTopic, 1);
        
        $client->loopForever();
    }
    
    
    function message($message) {
        global $database, $db, $deviceId;
        // initialize object
        $measure = new Measure($db);
        
        //printf("Got a message on topic %s with payload:\n%s\n", $message->topic, $message->payload);
        $date = date("Y-m-d H:i:s");
        $value = $message->payload;
        $topic = $message->topic;
        if(strpos($topic, "temperature") !== false) {
            $type = "temperature";
        }
        if (strpos($topic, "humidity") !== false){
            $type = "humidity";
        }
        if (strpos($topic, "battery") !== false){
            $type = "battery";
        }
        if (strpos($topic, "power") !== false){
            $type = "consumption";
        }
        
        //Initialize new LastMEasure record
        $measure->deviceId = $deviceId;
        $measure->date = $date;
        $measure->type = $type;
        $measure->value = $value;
        
        if($measure->create()) //create new LastMeasure row
            echo "New measure created on database: ".$deviceId." , ".$date." , ".$type." , ".$value."\n\r";
            else
                echo "Error: ".$deviceId." , ".$date." , ".$type." , ".$value.". Measure was not created on database\n\r";
    }
    
    function disconnectFromConsumptions(){
        echo "Disconnecting from consumption topic...\n\r";
        $message = "Dispositivo disconnesso dalla coda dei consumi";
        publishNotificationToFirebase($message);
    }
    
    function disconnectFromClimate(){
        echo "Disconnecting from climate topic...\n\r";
        $message = "Dispositivo disconnesso dalla coda del clima";
        publishNotificationToFirebase($message);
    }
?>