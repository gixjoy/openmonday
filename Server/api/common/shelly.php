<?php 
    //Used for sending command to Shelly device
    /* Returns json body for response coming from Shelly:
     *  {
            "ison": false,
            "has_timer": false
        }
     * Or "Bad turn!" in case of error
     */
    function sendSwitchCommandToDevice($ip, $switchStatus) {
        if($switchStatus == 0)
            $command = "off";
        else
            $command = "on";
        $data = "turn=".$command;
        
        //Initialize POST parameters
        $url = "http://".$ip."/relay/0";
        $ch = curl_init();
        
        curl_setopt($ch, CURLOPT_URL, $url);
        curl_setopt($ch, CURLOPT_CONNECTTIMEOUT, 5);
        curl_setopt($ch, CURLOPT_POST, 1);
        curl_setopt($ch, CURLOPT_POSTFIELDS,$data);
        curl_setopt($ch, CURLOPT_HTTPHEADER,
            array('Content-Type: application/x-www-form-urlencoded'));
        // receive server response ...
        curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
        
        $response = curl_exec ($ch);
        
        //$header_size = curl_getinfo($ch, CURLINFO_HEADER_SIZE);
        //$header = substr($response, 0, $header_size);
        //$body = substr($response, $header_size);
        
        curl_close ($ch);
        //var_dump($response);
        $result = json_decode($response);
        //var_dump($result);
        if ($result != null){
            $shellyResult = 1; 
        }
        else {
            $shellyResult = -1; 
        }
        //var_dump($shellyResult);
        return $shellyResult;
        //return " ";
    }

    //used for getting Shelly's hostname and mac, for sending to Monday as device description
    function getShellyHostnameAndMAC($ip) {
        $result = array();//the array that will contain hostname and MAC address of found device
        //Initialize POST parameters
        $url = "http://".$ip."/settings";
        $ch = curl_init();
        
        curl_setopt($ch, CURLOPT_URL, $url);
        curl_setopt($ch, CURLOPT_CONNECTTIMEOUT, 2);//if device takes more than 2 seconds, it is not Shelly 
        //curl_setopt($ch, CURLOPT_GET, 1);
        curl_setopt($ch, CURLOPT_HTTPHEADER,
            array('Content-Type: application/x-www-form-urlencoded'));
        // receive server response ...
        curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
        
        $response = curl_exec ($ch);
        
        $header_size = curl_getinfo($ch, CURLINFO_HEADER_SIZE);
        $header = substr($response, 0, $header_size);
        $body = substr($response, $header_size);
        $resCode = curl_getinfo($ch, CURLINFO_HTTP_CODE);
        
        curl_close ($ch);
        
        $hostname = "";
        $mac = "";
        $values = json_decode($response, true);
        //$deviceInfos = json_decode($values["device"]);
        
        if($resCode == 200){//then inquired device is a Shelly device
            foreach( $values["device"] as $key=>$value) {
                if($key == "hostname")
                    $hostname = $value;
                if($key == "mac")
                    $mac = $value;
            }
        }
        array_push($result, $hostname);
        array_push($result, $mac);
        return $result;
    }
    
    /*
     * Used for sending opening level to Shelly 2.5 for shutter control
     */
    function sendOpeningLevelToShutter($ip, $openingLevel) {
        
        $data = "go=to_pos&roller_pos=".$openingLevel;
        //$data = "go=close";
        
        //Initialize POST parameters
        $url = "http://".$ip."/roller/0";
        $ch = curl_init();
        
        curl_setopt($ch, CURLOPT_URL, $url);
        curl_setopt($ch, CURLOPT_CONNECTTIMEOUT, 5);//if device takes more than 5 seconds, it is not available
        curl_setopt($ch, CURLOPT_POSTFIELDS,$data);
        curl_setopt($ch, CURLOPT_HTTPHEADER,
            array('Content-Type: application/x-www-form-urlencoded'));
        // receive server response ...
        curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
        
        $response = curl_exec ($ch);
        
        $header_size = curl_getinfo($ch, CURLINFO_HEADER_SIZE);
        $header = substr($response, 0, $header_size);
        $body = substr($response, $header_size);
        $resCode = curl_getinfo($ch, CURLINFO_HTTP_CODE);
        
        curl_close ($ch);
        
        var_dump($response);
        var_dump($resCode);
        //$result = json_decode($response);
        if($resCode == 400)//Shelly needs to be calibrated
            return 1;
        elseif($resCode == 200)
            return 2;
        else 
            return 3;
        //return " ";
    }
    
    /*
     * Used for sending calibrate command to Shelly 2.5 for shutter calibration.
     * Clibration allows to automatically calculate the times shutter needs for opening 
     * and closing.
     */
    function calibrateShutter($ip) {
        
        //Initialize POST parameters
        $url = "http://".$ip."/roller/0/calibrate";
        $ch = curl_init();
        
        curl_setopt($ch, CURLOPT_URL, $url);
        curl_setopt($ch, CURLOPT_CONNECTTIMEOUT, 5);//if device takes more than 5 seconds, it is not available
        curl_setopt($ch, CURLOPT_HTTPHEADER,
            array('Content-Type: application/x-www-form-urlencoded'));
        // receive server response ...
        curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
        
        $response = curl_exec ($ch);
        
        $header_size = curl_getinfo($ch, CURLINFO_HEADER_SIZE);
        $header = substr($response, 0, $header_size);
        $body = substr($response, $header_size);
        $resCode = curl_getinfo($ch, CURLINFO_HTTP_CODE);
        
        curl_close ($ch);
        
        var_dump($response);
        var_dump($resCode);
        //$result = json_decode($response);
        if($resCode == 200)
            return 1;
        else
            return 2;
            //return " ";
    }
?>