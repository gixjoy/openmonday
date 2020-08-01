<?php 

    include_once("/var/www/html/monday/api/config/database.php");
    include_once("/var/www/html/monday/api/common/utils.php");
    include_once("/var/www/html/monday/api/model/heater.php");
    include_once("/var/www/html/monday/api/model/notification.php");
    include_once("/var/www/html/monday/api/model/device.php");
    include_once("/var/www/html/monday/api/common/shelly.php");
    include_once("/var/www/html/monday/api/model/measure.php");
    
    
    // instantiate database and product object
    $database = new Database();    
    $db = $database->getConnection();
    
    /*
     * Logic section
     */
    $heater = new Heater($db);
    $device = new Device($db);
    $measure = new Measure($db);
    
    $setTemperature = getSetTemperature($heater);
    $lastTemperature = $measure->readLastOfType("temperature");
    $date = date("Y-m-d H:i:s");
    $isEnabled = getHeaterEnabled($heater);
    
    if ($isEnabled == 1){
        echo $date." --- Heating system enabled\n\r";
        if ($lastTemperature >= $setTemperature){//set temperature has been reached
            $switchStatus = getHeaterSwitchStatus($heater);
            turnOffHeatingSystem($switchStatus);
        }
        else {//set temperature is > lastTemperature; turn on heating system
            $switchStatus = getHeaterSwitchStatus($heater);
            turnOnHeatingSystem($switchStatus);
        }
    }
    else {
        echo $date." --- Heating system disabled\n\r";
        $switchStatus = getHeaterSwitchStatus($heater);
        turnOffHeatingSystem($switchStatus);
    }
        
    
    
    //Functions
    
    function turnOnHeatingSystem($switchStatus){
        global $heater;
        global $device;
        global $date;
        if ($switchStatus == 0) {
            echo $date." --- Turning on heating system...\n\r";
            $heaterId = getHeaterSwitchId($heater);
            $heaterIP = getHeaterIP($heaterId, $device);
            //turn on heaters
            if(sendSwitchCommandToDevice($heaterIP, 1) != -1){//turn on the switch
                $heater->updateSwitch();
                $device->updateDeviceStatus($heaterId, 1);
                echo $date." --- Heating system successfully turned on\n\r";
                //publishNotificationToMosquitto("Sistema di riscaldamento acceso");
                publishNotificationToFirebase("Sistema di riscaldamento acceso");
                insertNotificationOnDB("Sistema di riscaldamento acceso.");
            }
            else{
                //update status column on database
                if ($device->updateDeviceStatus($heaterId, 0)) {
                    echo $date." --- Error turning ON heating system. Communication error with Shelly heater device\n\r";
                    
                    //publishNotificationToMosquitto("Errore durante l'accensione del sistema di riscaldamento");
                    publishNotificationToFirebase("Errore durante l'accensione del sistema di riscaldamento");
                    insertNotificationOnDB("Errore durante l'accensione del sistema di riscaldamento. 
                        Impossibile comunicare con Shelly. Verificare lo stato del dispositivo e riprovare.");
                }
                else {
                    echo $date." --- Error turning ON heating system. Communication error with Shelly heater device\n\r";
                    echo $date." --- Error when updating device status on database\n\r";
                    
                    //publishNotificationToMosquitto("Errore durante l'accensione del sistema di riscaldamento");
                    publishNotificationToFirebase("Errore durante l'accensione del sistema di riscaldamento");
                    insertNotificationOnDB("Errore durante l'accensione del sistema di riscaldamento 
                        Non è stato possibile aggiornare lo stato del dispositivo sul database.");
                }
            }
        }//else do nothing because heating system is already ON
    }
    
    function turnOffHeatingSystem($switchStatus){
        global $heater;
        global $device;
        global $date;
        if ($switchStatus == 1) {//turn off heating system
            echo $date." --- Turning off heating system...\n\r";
            $heaterId = getHeaterSwitchId($heater);
            $heaterIP = getHeaterIP($heaterId, $device);
            //turn off heaters
            if(sendSwitchCommandToDevice($heaterIP, 0) != -1){
                $heater->updateSwitch();
                $device->updateDeviceStatus($heaterId, 1);
                echo $date." --- Heating system successfully turned off\n\r";
               
                //publishNotificationToMosquitto("Sistema di riscaldamento spento");
                publishNotificationToFirebase("Sistema di riscaldamento spento");
                insertNotificationOnDB("Sistema di riscaldamento spento.");
            }
            else{
                //update status column on database
                if ($device->updateDeviceStatus($heaterId, 0)) {
                    echo $date." --- Error turning OFF heating system. Communication error with Shelly heater device\n\r";
                    
                    //publishNotificationToMosquitto("Errore durante lo spegnimento del sistema di riscaldamento");
                    publishNotificationToFirebase("Errore durante lo spegnimento del sistema di riscaldamento");
                    insertNotificationOnDB("Errore durante lo spegnimento del sistema di riscaldamento. 
                        Impossibile comunicare con Shelly. Verificare lo stato del dispositivo e riprovare.");
                }
                else {
                    echo $date." --- Error turning OFF heating system. Communication error with Shelly heater device\n\r";
                    echo $date." --- Error when updating device status on database\n\r";
                    
                    //publishNotificationToMosquitto("Errore durante lo spegnimento del sistema di riscaldamento");
                    publishNotificationToFirebase("Errore durante lo spegnimento del sistema di riscaldamento");
                    insertNotificationOnDB("Errore durante lo spegnimento del sistema di riscaldamento. 
                        Non è stato possibile aggiornare lo stato del dispositivo sul database.");
                }
            }
        }//else do nothing because heating system is already OFF
    }
    
    //Gets set temperature from Heater table
    function getsetTemperature($heater){
        $heaterStmt = $heater->readLast();
        $heaterRow = $heaterStmt->fetch(PDO::FETCH_ASSOC);
        extract($heaterRow);
        return $setTemperature;
    }
    
    //Gets heater switch status from Heater table
    function getHeaterSwitchStatus($heater){
        $heaterStmt = $heater->readLast();
        $heaterRow = $heaterStmt->fetch(PDO::FETCH_ASSOC);
        extract($heaterRow);
        return $switch;
    }
    
    //Gets heater switch status from Heater table
    function getHeaterSwitchId($heater){
        $heaterStmt = $heater->readLast();
        $heaterRow = $heaterStmt->fetch(PDO::FETCH_ASSOC);
        extract($heaterRow);
        return $id;
    }
    
    //Gets "enabled" field from Heater table
    function getHeaterEnabled($heater){
        $heaterStmt = $heater->readLast();
        $heaterRow = $heaterStmt->fetch(PDO::FETCH_ASSOC);
        extract($heaterRow);
        return $enabled;
    }
    
    //Gets heater IP address from heater ID
    function getHeaterIP($heaterId, $device){
        $deviceStmt = $device->readDevice($heaterId);
        $deviceRow = $deviceStmt->fetch(PDO::FETCH_ASSOC);
        extract($deviceRow);
        return $ip;
    }
?>