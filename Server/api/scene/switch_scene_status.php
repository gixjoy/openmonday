<?php
    // required headers
    header("Access-Control-Allow-Origin: *");
    header("Content-Type: application/json; charset=UTF-8");
    header("Access-Control-Allow-Methods: POST");
    header("Access-Control-Max-Age: 3600");
    header("Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With");
     
    // get database connection
    include_once '../config/database.php';
    include_once '../model/client.php';
    include_once '../model/scene.php';
     
    $database = new Database();
    $db = $database->getConnection();
     
    $client = new Client($db);
    $scene = new Scene($db);
    
    $data = json_decode(file_get_contents("php://input"));
    
    if (!empty($data->clientId) &&
        !empty($data->sessionToken) &&
        !empty($data->sceneId)){
        
        if($client->validateRequest($data->clientId, $data->sessionToken)) {
            $stmt = $scene->readOne($data->sceneId);
            $row = $stmt->fetch(PDO::FETCH_ASSOC);
            extract($row);
            $newStatus = 0;
            if($enabled == 0){
                $newStatus = 1;
                if($scene->updateSceneStatus($data->sceneId, $newStatus)){
                    if($type == "manual") {//execute script only if command is about manual scene
                        $command = "/usr/bin/php /var/www/html/monday/process/scene_run.php ".$data->sceneId." >> /var/log/monday/scene.log &";
                        exec($command);
                        $sceneResult = array(
                            "id" => $data->sceneId,
                            "enabled" => $newStatus
                        );
                        // set response code - 200 OK
                        http_response_code(200);
                        echo json_encode($sceneResult);
                    }
                    else{//automated scene is managed by crontab task "check_automated_scene.php"
                        $sceneResult = array(
                            "id" => $data->sceneId,
                            "enabled" => $newStatus
                        );
                        // set response code - 200 OK
                        http_response_code(200);
                        echo json_encode($sceneResult);
                    }
                }
                else{
                    http_response_code(503);
                    echo json_encode(array("message" => "Unable to update scene status."));
                }
            }
            else {
                $newStatus = 0;
                if($scene->updateSceneStatus($data->sceneId, $newStatus)){
                    $scene->updateSceneRunning($data->sceneId, 0);//reset "running" status of the scene
                    $sceneResult = array(
                        "id" => $data->sceneId,
                        "enabled" => $newStatus
                    );
                    // set response code - 200 OK
                    http_response_code(200);
                    echo json_encode($sceneResult);
                }
            }
                
        }
        else {
            // set response code - 402 token not valid
            http_response_code(402);
            
            // tell the user
            echo json_encode(array("message" => "Unable to read scenes. Token not valid."));
        }
    }
    else{
        // set response code - 400 bad request
        http_response_code(400);
        
        // tell the user
        echo json_encode(array("message" => "Unable to process the request. Data is incomplete."));
    }
    
?>