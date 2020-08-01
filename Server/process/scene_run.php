<?php
    
    /*
     * This script is used for running scene commands, either manual and automated. 
     * It is fired by switch_scene_status.php API or check_automated_scenes.php script
     */

    include_once '/var/www/html/monday/api/config/database.php';
    include_once '/var/www/html/monday/api/model/action.php';
    include_once '/var/www/html/monday/api/model/scene_has_action.php';
    include_once '/var/www/html/monday/api/model/scene.php';
    include_once '/var/www/html/monday/api/model/device.php';
    include_once '/var/www/html/monday/api/common/shelly.php';
    
    include_once '/var/www/html/monday/api/model/light.php';
    include_once '/var/www/html/monday/api/model/outlet.php';
    include_once '/var/www/html/monday/api/model/heater.php';
    
    $database = new Database();
    $db = $database->getConnection();
    
    $scene = new Scene($db);
    $sceneHasAction = new SceneHasAction($db);
    $action = new Action($db);
    $device = new Device($db);
    
    $light = new Light($db);
    $outlet = new Outlet($db);
    $heater = new Heater($db);
    
    /*
     * Command format:
     *      scene_run.php "sceneId"
     */
    
    $sceneId = $argv[1];
    
    executeActionCommands($sceneId);
    
    //Function used to execute commands of either automated or manual scene's actions
    function executeActionCommands($sceneId){
        global $sceneHasAction, $action, $device;
        global $light, $outlet, $heater;
        $shaStmt = $sceneHasAction->readActionsWithSceneId($sceneId);
        $actionArray = array();//temporary array of actions inside the scene
        $arrayIndex = 0;
        while($row = $shaStmt->fetch(PDO::FETCH_ASSOC)){//get all actions ids inside the scene
            extract($row);
            $actionStmt = $action->readId($actionId);//get action id
            $actionRow = $actionStmt->fetch(PDO::FETCH_ASSOC);
            extract($actionRow);//get action informations
            $arrayItem = array(//create array action item
                "deviceId"=>$deviceId,
                "command"=>$command
            );
            array_push($actionArray, $arrayItem);
            
        }
        //$orderedActions = orderActionsById($actionArray);//reorder actions based on indexInScene attribute
        foreach ($actionArray as $key=>$value){
            $devId = $value["deviceId"];//get action device id
            $cmd = $value["command"];
            $command = "";//the final command to send to the physical device
            if($cmd == "on")
                $command = 1;
            elseif ($cmd == "off")
                $command = 0;
            else
                $command = $cmd;//in case action is a sleep
            $devStmt = $device->readDevice($devId);//get device information
            $dev = $devStmt->fetch(PDO::FETCH_ASSOC);
            extract($dev);
            switch ($type){
                case "light":
                    echo "Executing command on light..."."\n\r";
                    $switchStatus = $light->getSwitchStatus($devId);
                    if($switchStatus != $command){
                        $switchStatus = $light->updateSwitch($devId);//$switchStatus becomes $command
                        if($switchStatus != -2) {//there is a light device on the database
                            if ($switchStatus != -1) {//no error while updating switch status on database
                                //get ip of light device
                                $stmt = $device->readDevice($devId);
                                $row = $stmt->fetch(PDO::FETCH_ASSOC);
                                extract($row);
                                //send command to light device
                                if (sendSwitchCommandToDevice($ip, $switchStatus) != -1){ //command successfully executed by Shelly
                                    $device->updateDeviceStatus($devId, 1);
                                    echo "Command successfully executed!"."\n\r";
                                }
                            }
                        }
                    }
                    break;
                case "outlet":
                    echo "Executing command on outlet..."."\n\r";
                    $switchStatus = $outlet->getSwitchStatus($devId);
                    echo "Switch status: ".$switchStatus."\n\r";
                    echo "Command value: ".$command."\n\r";
                    if($switchStatus != $command){
                        $switchStatus = $outlet->updateSwitch($devId);//$switchStatus becomes $command
                        if($switchStatus != -2) {//there is a light device on the database
                            if ($switchStatus != -1) {//no error while updating switch status on database
                                //get ip of light device
                                $stmt = $device->readDevice($devId);
                                $row = $stmt->fetch(PDO::FETCH_ASSOC);
                                extract($row);
                                //send command to light device
                                if (sendSwitchCommandToDevice($ip, $switchStatus) != -1){ //command successfully executed by Shelly
                                    $device->updateDeviceStatus($devId, 1);
                                    echo "Command successfully executed!"."\n\r";
                                }
                            }
                        }
                    }
                    break;
                case "clock":
                    echo "Executing clock command ..."."\n\r";
                    sleep($command);
                    break;
                case "climate":
                    echo "Executing command on climate..."."\n\r";
                    $switchStatus = $heater->getSwitchStatus($devId);
                    if($switchStatus != $command){
                        $switchStatus = $heater->updateSwitch($devId);//$switchStatus becomes $command
                        if($switchStatus != -2) {//there is a light device on the database
                            if ($switchStatus != -1) {//no error while updating switch status on database
                                //get ip of light device
                                $stmt = $device->readDevice($devId);
                                $row = $stmt->fetch(PDO::FETCH_ASSOC);
                                extract($row);
                                //send command to light device
                                if (sendSwitchCommandToDevice($ip, $switchStatus) != -1){ //command successfully executed by Shelly
                                    $device->updateDeviceStatus($devId, 1);
                                    echo "Command successfully executed!"."\n\r";
                                }
                            }
                        }
                    }
                    break;
            }
            
        }
    }
?>
    