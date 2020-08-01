<?php

    include_once("/var/www/html/monday/api/config/mosquitto.php");
    include_once("/var/www/html/monday/api/config/database.php");
    include_once("/var/www/html/monday/api/config/firebase.php");
    include_once("/var/www/html/monday/api/model/notification.php");
    include_once("/var/www/html/monday/api/model/client.php");
    include_once("/var/www/html/monday/api/model/device.php");
    include_once("/var/www/html/monday/api/model/measure.php");
    
    $shellyDeviceId="";
    
    // instantiate database object
    $database = new Database();
    $db = $database->getConnection();
    
    /*
     * Mosquitto section
     */
    $notificationTopic = "monday/notification";
    $qos = 1;
    $retain = false;
    $mosquitto = new Mosquitto();

    //generates random string for session token creation
    function generateRandomString() {
        $characters = '0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ';
        $charactersLength = strlen($characters);
        $String = '';
        for ($i = 0; $i < 20; ++$i) {
            $String .= $characters[rand(0, $charactersLength - 1)];
        }
        return $String;
    }
    
    function convertDateToEUFormat($date){
        $newDateFormat = DateTime::createFromFormat('Y-m-d H:i:s', $date)->format('d/m/Y H:i:s');//needed to convert initial format to Y-m-d d/m/Y
        return $newDateFormat;
    }
    
    function publishNotificationToMosquitto($message){
        global $mosquitto;
        global $qos, $retain;
        global $notificationTopic;
        $client = $mosquitto->getClient("Monday_notification_sub");
        $client->setWill('monday/notification', 'Notification_sub offline', 1, true);
        $client->publish($notificationTopic, $message, $qos, $retain);
    }
    
    function publishNotificationToFirebase($message){
        global $db, $database;
        $client = new Client($db);
        $stmt = $client->readAll();
        $num = $stmt->rowCount();
        while($num>0){
            $row = $stmt->fetch(PDO::FETCH_ASSOC);
            extract($row);
            $firebase = new FireBaseNotification();
            $firebase->sendNotificationToFirebase($message, $firebaseToken);
            $num--;
        }
        
    }
    
    function insertNotificationOnDB($message){
        global $database, $db;
        $date = date("Y-m-d H:i:s");
        $notification = new Notification($db);
        $notification->message = $message;
        $notification->date = $date;
        if(!$notification->create()) {
            echo $date." - Error creating notification on database\n\r";
        }
    }
?>