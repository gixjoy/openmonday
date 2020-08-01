<?php
    /*
     * Executed every 10 seconds by systemd task monday_discovery.service
     * It runs an Nmap command looking for new devices on LAN network where Monday and Shelly 
     * controllers are. 
     * The script also updates devices' IPs on database in case they change in time.
     * The discovery of new devices within the app is instead started by the user when he goes
     * to Devices--->New from Home Route.
     */
    include_once("/var/www/html/monday/api/model/discovery_record.php");
    include_once '/var/www/html/monday/api/config/database.php';
    include_once("/var/www/html/monday/api/model/user.php");
    include_once("/var/www/html/monday/api/model/device.php");
    include_once("/var/www/html/monday/api/common/shelly.php");
    include_once("/var/www/html/monday/api/common/utils.php");
    
    $filename = "/tmp/tmp_buffer.txt"; //filename for discovered devices
    $command = "sudo nmap -n -sn -oG - 192.168.1.* | grep Up | cut -d ' ' -f 2 > ".$filename." && cp /tmp/tmp_buffer.txt /tmp/discovered_devices.txt";//command for discoverying new devices on the network
    
    // instantiate database object
    $database = new Database();
    $db = $database->getConnection();
    
    // initialize object
    $user = new User($db);
    $device = new Device($db);
    
    exec($command, $output, $return_var);//execute discovery of devices
    $devices = getDevicesFromFile($filename);//parse discovery file and extract devices found
    $newDiscoveredDevices = getOnlyNewDiscoveredDevices($devices, $device);//get only new devices
    if (sizeof($newDiscoveredDevices) > 0){
        foreach($newDiscoveredDevices as $newDev){
            $device->id = $newDev->mac;
            $device->ip = $newDev->ip;
            $device->description = $newDev->hostname;
            if(!updateDeviceIP($device, $device->id, $device->ip)) {//update existing device record on database
                //Device not found on database ---> create it
                echo date("h:i:sa")." --- Device ".$device->id." not found on database. Not yet discovered\n\r";
                $device->create();
            }
        }
    }
    echo "Discovery completed. All devices IPs up to date\n\r";   
    
    
    //Gets DiscoveryRecord objects from the file created with Nmap command
    function getDevicesFromFile($filename) {
        $file = fopen($filename,'r');
        $result = array();//the final result with all new devices discovered
        $index = 0;//index of the result array
        $ip = "";
        $hostname = "";
        $mac = "";
        while ($line = fgets($file)) {
            $cleanLine = rtrim($line,"\n");
            $ip = $cleanLine;
            $params = getShellyHostnameAndMAC($ip);
            $hostname = $params[0];
            $mac = $params[1];
            if($hostname != "" && $mac != ""){//shelly device has been found
                echo $hostname."; ".$mac."\n\r";
                $result[$index] = new DiscoveryRecord($ip, $hostname, $mac);
                //echo "IP: ".$result[$index]->ip.";Hostname: ".$result[$index]->hostname;
                $index++;
            }
        }
        fclose($file);
        echo ("Discovery records created.\n\r");
        return $result;
    }
    
    
    //Updates field ip of device $id if the device's ip on database is different from the actual one
    function updateDeviceIP($device, $deviceID, $deviceIP){
        $stmt = $device->readDevice($deviceID);
        $num = $stmt->rowCount();
        if($num>0){//device found on database
            while ($row = $stmt->fetch(PDO::FETCH_ASSOC)){//build array of already discovered devices from db
                extract($row);
                if($ip != $deviceIP) {//if old IP is differente from the actual one, then update it
                    $device->updateDeviceIP($deviceID, $deviceIP);
                    echo date("d/m/Y")." - ".date("h:i:sa")." --- Device ".$deviceID.": IP correctly updated\n\r";
                }
                else 
                    echo date("d/m/Y")." - ".date("h:i:sa")." --- Device ".$deviceID.": no need for updates\n\r";
            }
            return true;
        }
        return false;
    }
    
    //Checks if a device discovered by Nmap is already on the database; if it is, then it is removed from new discovered devices
    function getOnlyNewDiscoveredDevices($discoveredDevices, $deviceConnToDB){
        $newDevices = array();
        $stmt = $deviceConnToDB->read();//read all devices on database
        $num = $stmt->rowCount();
        $devicesOnDB = array();
        $i = 0;//used for scanning $devicesOnDB
        $index = 0;//used for scanning $discoveredDevices
        if($num>0){//some device is already on database
            while ($num > 0){ //build array of already discovered devices from db
                $row = $stmt->fetch(PDO::FETCH_ASSOC);
                extract($row);
                $dbDev = array(
                    "id"=>$id,
                    "ip"=>$ip
                );
                /*echo "IP on DB: ".$dbDev["ip"]."\n\r";
                 echo "ID on DB: ".$dbDev["id"]."\n\r\n\r";*/
                $devicesOnDB[$i] = $dbDev;//save device inside the array
                $i++;
                $num--;
            }
            foreach($discoveredDevices as $discDev) {//scan new discovered devices
                $discMac = $discDev->mac;
                /*echo "Discovered ID: ".$discMac."\n\r";
                 echo "Discovered IP: ".$discIp."\n\r\n\r";*/
                if(!isDeviceOnDB($discDev, $devicesOnDB)) {
                    $newDevices[$index] = $discDev;//save new discovered device
                    $index++;
                }
                else
                    $index++;
            }
            return $newDevices;
        }
        else //all discovered device are new and not present on database
            return $discoveredDevices;
    }
    
    /*
     * Checks if $device is already among $devicesOnDB
     */
    function isDeviceOnDB($device, $devicesOnDB) {
        foreach($devicesOnDB as $devOnDB) {//get all devices from database
            $macOnDB = $devOnDB["id"];
            if ($device->mac == $macOnDB) {
                return true;
            }
        }
        return false;
    }
?>
