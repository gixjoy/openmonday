<?php 

    include_once("/var/www/html/monday/api/config/database.php");
    include_once("/var/www/html/monday/api/model/notification.php");
    include_once("/var/www/html/monday/api/model/measure.php");
    include_once("/var/www/html/monday/api/common/utils.php");
    
    
    $notif_message = "Sensore clima non disponibile.\nControllare il livello di carica della batteria e procedere con il riavvio del dispositivo.";
    
    // instantiate database 
    $db = $database->getConnection();
    
    /*
     * Logic section
     */
    $actualDate = date("Y-m-d H:i:s"); 
    $dateInSeconds = strtotime($actualDate);//convert string to time in seconds since Epoch
    //echo "Date in seconds: ".$dateInSeconds."\n\r";
    
    //Get date of the last measure from climate sensor
    $measure = new Measure($db);
    $date = $measure->readLastDate("temperature");
    if (!$date)
        echo $actualDate." --- No temperature detected yet\n\r";
    else {
        $lastDateInSeconds = strtotime($date);
        
        //echo "Last date in seconds: ".$lastDateInSeconds."\n\r";
        
        
        if (($dateInSeconds - $lastDateInSeconds) > 3600){//let's assume that Shelly climate sensor is sending data every hour (if it is set differently, modify this condition)
            $notification = new Notification($db);
            $stmt = $notification->readLastWithMessage($notif_message);
            if ($stmt->rowCount() > 0) {
                $row = $stmt->fetch(PDO::FETCH_ASSOC);
                extract($row);
                $notificationTime = strtotime($date);
                //echo $notificationTime;
    
                if (($dateInSeconds - $notificationTime) > 3600) {//send a notification only one time per hour in case of error
                    //publishNotificationToMosquitto("Sensore clima non disponibile");
                    publishNotificationToFirebase("Sensore clima non disponibile");
                    insertNotificationOnDB($notif_message);
                }
            }
            else {
                //publishNotificationToMosquitto("Sensore clima non disponibile");
                publishNotificationToFirebase("Sensore clima non disponibile");
                insertNotificationOnDB($notif_message);
            }
        }
    }
    
?>