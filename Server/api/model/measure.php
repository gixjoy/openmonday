<?php
    class Measure{
        
        // database connection and table name
        private $conn;
        private $table_name = "Measure";
        
        // object properties
        public $id;
        public $deviceId;
        public $type;
        public $value;
        public $date;
        
        // constructor with $db as database connection
        public function __construct($db){
            $this->conn = $db;
        }
        
        // read all measures
        function read(){
            
            // select all query
            $query = "SELECT *
                FROM
                    " . $this->table_name;
            
            // prepare query statement
            $stmt = $this->conn->prepare($query);
            
            // execute query
            $stmt->execute();
            
            return $stmt;
        }
        
        // read only last measure from device $deviceId
        function readOne($deviceId){
            
            // select all query
            $query = "SELECT *
                FROM
                    " . $this->table_name."
                WHERE deviceId = '".$deviceId."' 
                ORDER BY date DESC LIMIT 1";
            
            // prepare query statement
            $stmt = $this->conn->prepare($query);
            
            // execute query
            $stmt->execute();
            
            return $stmt;
        }
        
        // read last measure of type $type
        function readLastOfType($type){
            
            // select all query
            $query = "SELECT *
                FROM
                    " . $this->table_name."
                WHERE type = '".$type."'
                ORDER BY date DESC LIMIT 1";
            
            // prepare query statement
            $stmt = $this->conn->prepare($query);
            
            // execute query
            $stmt->execute();
            $row = $stmt->fetch(PDO::FETCH_ASSOC);
            extract($row);
            
            return $value;
        }
        
        function readLastRowOfType($type){
            
            // select all query
            $query = "SELECT *
                FROM
                    " . $this->table_name."
                WHERE type = '".$type."'
                ORDER BY date DESC LIMIT 1";
            
            // prepare query statement
            $stmt = $this->conn->prepare($query);
            
            // execute query
            $stmt->execute();
            return $stmt;
        }
        
        // sum last measures of type $type from all devices
        function sumLastOfType($type){
            
            // select all query
            $query = "SELECT SUM(value) as totalConsumptions
            FROM (SELECT m1.*
            FROM ".$this->table_name." m1
            WHERE type = '".$type."' AND m1.id = (SELECT id
                FROM ".$this->table_name." m2
                WHERE m2.deviceId = m1.deviceId
                ORDER BY date DESC LIMIT 1)) m3";
            
            // prepare query statement
            $stmt = $this->conn->prepare($query);
            
            // execute query
            $stmt->execute();
            $row = $stmt->fetch(PDO::FETCH_ASSOC);
            extract($row);
            
            return $totalConsumptions;
        }
        
        // read last measure of type $type and device $deviceId
        function readLastOfTypeAndDevice($type, $deviceId){
            
            $query = "SELECT *
                FROM
                    " . $this->table_name."
                WHERE type = '".$type."' AND deviceId = '".$deviceId."'
                ORDER BY date DESC LIMIT 1";
            
            // prepare query statement
            $stmt = $this->conn->prepare($query);
            
            // execute query
            $stmt->execute();
            
            return $stmt;
        }
        
        // read last date of measure of type $type
        function readLastDate($type){
            
            // select all query
            $query = "SELECT *
                FROM
                    " . $this->table_name."
                WHERE type = '".$type."' 
                ORDER BY date DESC LIMIT 1";
            
            // prepare query statement
            $stmt = $this->conn->prepare($query);
            
            // execute query
            $stmt->execute();
            if($row = $stmt->fetch(PDO::FETCH_ASSOC)) {
                extract($row);
                return $date;
            }
            else
                return false;
        }
        
        // read devices and types
        function readDevices(){
            
            // select all query
            $query = "SELECT deviceId, type 
                FROM " . $this->table_name."
                DISTINCT deviceId";
            
            // prepare query statement
            $stmt = $this->conn->prepare($query);
            
            // execute query
            $stmt->execute();
            return $stmt;
        }
        
        function create(){
            /*$stmt = $this->read();
            $num = $stmt->rowCount();
            if ($num == 0)
                $this->id = 0;
            else
                $this->id = $num+1;*/
            
            // query to insert record
            $query = "INSERT INTO
                    " . $this->table_name . "
                SET
                    deviceId=:deviceId, date=:date, type=:type, value=:value";
            // prepare query
            $stmt = $this->conn->prepare($query);
            
            // sanitize
            $this->deviceId=htmlspecialchars(strip_tags($this->deviceId));
            $this->date=htmlspecialchars(strip_tags($this->date));
            $this->type=htmlspecialchars(strip_tags($this->type));
            $this->value=htmlspecialchars(strip_tags($this->value));
            
            // bind values
            //$stmt->bindParam(":id", $this->id);
            $stmt->bindParam(":deviceId", $this->deviceId);
            $stmt->bindParam(":date", $this->date);
            $stmt->bindParam(":type", $this->type);
            $stmt->bindParam(":value", $this->value);
            
            // execute query
            if($stmt->execute()){
                return true;
            }
            else {
                //var_dump($stmt->errorInfo());
                return false;
            }
        }
        
        //it gets the average value of measures of specified type for every device
        function getAVGofDeviceAndType($type){
            $query = "SELECT deviceId, FORMAT(AVG(value), 2) averageValue
                        FROM ".$this->table_name."
                        WHERE type = '".$type."' 
                        GROUP BY deviceId";
            $stmt = $this->conn->prepare($query);
            $stmt->execute();
            return $stmt;
        }
        
        function deleteAll($type){
            $query = "DELETE FROM ".$this->table_name." WHERE type = '".$type."'";
            $stmt = $this->conn->prepare($query);
            $stmt->execute();
        }
        
        /* This function is used for deleting all records of the specified type, except for the last one
        *  Useful for deleting all measures of type "temperature" but the last, for not triggering check_ht_sensor_isalive.php script notifications
        */
        function deleteAllButTheLast($type){
            $query = "DELETE FROM ".$this->table_name." 
                    WHERE id < (SELECT max(id)
                    FROM ".$this->table_name." 
                    WHERE type = '".$type."')";
            $stmt = $this->conn->prepare($query);
            $stmt->execute();
        }
        
        function deleteWithDeviceId($devId){
            $query = "DELETE FROM ".$this->table_name." WHERE deviceId = '".$devId."'";
            $stmt = $this->conn->prepare($query);
            $stmt->execute();
        }
    }
?>