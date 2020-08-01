<?php
    
    class Device{
     
        // database connection and table name
        private $conn;
        private $table_name = "Device";
     
        // object properties
        public $id;
        public $name;
        public $description;
        public $type;
        public $roomId;
        public $status;
        public $enabled;
        public $ip;
     
        // constructor with $db as database connection
        public function __construct($db){
            $this->conn = $db;
        }
        
        
        //Function for updating device table when a new device is configured
        function updateDevice($id, $name, $type, $roomId){
            if ($roomId == null) //update query with no field roomId set
                $query = "UPDATE ". $this->table_name ."
                      SET name = '".$name."', type = '".$type."', enabled = 1
                      WHERE id = '".$id."'";
            else
                $query = "UPDATE ". $this->table_name ."
                      SET name = '".$name."', type = '".$type."', roomId = ".$roomId.", enabled = 1  
                      WHERE id = '".$id."'";
            //echo $query;
            // prepare query statement
            $stmt = $this->conn->prepare($query);
            //echo $query;
            
            // execute query
            if($stmt->execute())
                return true;
            else {
                //var_dump($stmt->errorInfo());
                return false;
            }
        }
        
        //Method used for setting roomId to null for a specific device
        function removeRoom($id){
            $query = "UPDATE ". $this->table_name ."
                  SET roomId = NULL 
                  WHERE id = '".$id."'";
            //echo $query;
                // prepare query statement
            $stmt = $this->conn->prepare($query);
            
            // execute query
            if($stmt->execute())
                return true;
            else
                return false;
        }
        
        function updateDeviceIP($id, $ip){
            
            $query = "UPDATE ". $this->table_name ."
                  SET ip = '".$ip."' 
                  WHERE id = '".$id."'";
                
            // prepare query statement
            $stmt = $this->conn->prepare($query);
            
            // execute query
            if($stmt->execute())
                return true;
            else
                return false;
        }
        
        function updateDeviceStatus($id, $status){
            
            $query = "UPDATE ". $this->table_name ."
                  SET status = '".$status."'
                  WHERE id = '".$id."'";
            
            // prepare query statement
            $stmt = $this->conn->prepare($query);
            
            // execute query
            if($stmt->execute())
                return true;
            else
                return false;
        }
        
        
        // read all devices
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
        
        // read all devices not enabled
        function readNotEnabled(){
            
            // select all query
            $query = "SELECT *
                FROM
                    " . $this->table_name."
                WHERE enabled = 0";
            
            // prepare query statement
            $stmt = $this->conn->prepare($query);
            
            // execute query
            $stmt->execute();
            
            return $stmt;
        }
        
        // read all enabled devices
        function readEnabled(){
            
            // select all query
            $query = "SELECT *
                FROM
                    " . $this->table_name."
                WHERE enabled = 1";
            
            // prepare query statement
            $stmt = $this->conn->prepare($query);
            
            // execute query
            $stmt->execute();
            
            return $stmt;
        }
        
        // read status of specified device
        function getDeviceStatus($id){
            
            // select all query
            $query = "SELECT status
                FROM
                    " . $this->table_name."
                WHERE id = '".$id."'";
            
            // prepare query statement
            $stmt = $this->conn->prepare($query);
            
            // execute query
            $stmt->execute();
            
            if ($stmt->rowCount() > 0) {
                $row = $stmt->fetch(PDO::FETCH_ASSOC);
                extract($row);
                return $status;
            }
            else
                return -1;
        }
        
        // read specific device
        function readDevice($id){
            
            // select query
            $query = "SELECT *
                FROM
                    " . $this->table_name ."
                WHERE id = '".$id."'";
            
            // prepare query statement
            $stmt = $this->conn->prepare($query);
            
            // execute query
            $stmt->execute();
            
            return $stmt;
        }
        
        // read devices with specified type
        function readType($type){
            
            // select query
            $query = "SELECT *
                FROM
                    " . $this->table_name ."
                WHERE type = '".$type."'";
            
            // prepare query statement
            $stmt = $this->conn->prepare($query);
            
            // execute query
            $stmt->execute();
            
            return $stmt;
        }
        
        // read devices with specified room id
        function readRoom($roomId){
            
            // select query
            $query = "SELECT *
                FROM
                    " . $this->table_name ."
                WHERE roomId = '".$roomId."'";
            
            // prepare query statement
            $stmt = $this->conn->prepare($query);
            
            // execute query
            $stmt->execute();
            
            return $stmt;
        }
        
        // create device
        function create(){
            // query to insert record
            $query = "INSERT INTO
                    " . $this->table_name . "
                SET
                    id=:id, description=:description, ip=:ip";
            // prepare query
            $stmt = $this->conn->prepare($query);
            
            // sanitize
            $this->username=htmlspecialchars(strip_tags($this->id));
            $this->password=htmlspecialchars(strip_tags($this->ip));
            
            // bind values
            $stmt->bindParam(":id", $this->id);
            $stmt->bindParam(":description", $this->description);
            $stmt->bindParam(":ip", $this->ip);
            
            // execute query
            if($stmt->execute()){
                return true;
            }
            else {
                //var_dump($stmt->errorInfo());
                return false;
            }
        }
        
        function delete($id){
            
            $query = "DELETE FROM ". $this->table_name ."
                  WHERE id = '".$id."'";
            
            // prepare query statement
            $stmt = $this->conn->prepare($query);
            
            // execute query
            if($stmt->execute())
                return true;
            else
                return false;
        }
    }
?>