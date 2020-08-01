<?php
    class MeasureDailyAVG{
        
        // database connection and table name
        private $conn;
        private $table_name = "MeasureDailyAVG";
        
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
        
        // read measures of type $type and device $deviceId
        function readOfTypeAndDevice($type, $deviceId){
            
            $query = "SELECT *
                FROM
                    " . $this->table_name."
                WHERE type = '".$type."' AND deviceId = '".$deviceId."'
                ORDER BY date ASC";
            
            // prepare query statement
            $stmt = $this->conn->prepare($query);
            
            // execute query
            $stmt->execute();
            
            return $stmt;
        }
        
        // read measures of type $type
        function readOfType($type){
            
            $query = "SELECT *
                FROM
                    " . $this->table_name."
                WHERE type = '".$type."'
                ORDER BY date ASC";
            
            // prepare query statement
            $stmt = $this->conn->prepare($query);
            
            // execute query
            $stmt->execute();
            
            return $stmt;
        }
        
        // sum measures of type $type from all devices for each day
        function sumOfType($type){
            
            // select all query
            $query = "SELECT date, SUM(value) as dailyConsumptionTotal
                    FROM (
                        SELECT m1.*
                        FROM ".$this->table_name." m1
                        WHERE type = '".$type."' AND m1.id IN (
                            SELECT id
                            FROM ".$this->table_name." m2
                            WHERE m2.date = m1.date
                            ORDER BY deviceId)
                        ) m3
                    GROUP BY date";
            
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
        
        function deleteAll($type){
            $query = "DELETE FROM ".$this->table_name." WHERE type = '".$type."'";
            $stmt = $this->conn->prepare($query);
            $stmt->execute();
        }
    }
?>