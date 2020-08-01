<?php
    class Heater{
     
        // database connection and table name
        private $conn;
        private $table_name = "Heater";
     
        // object properties
        public $id;
        public $switch;
        public $setTemperature;
        public $enabled;
     
        // constructor with $db as database connection
        public function __construct($db){
            $this->conn = $db;
        }
        
        // read all records
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
        
        // read only last record
        function readLast(){
            
            // select all query
            $query = "SELECT *
                FROM
                    " . $this->table_name . "
                ORDER BY id DESC
                LIMIT 1";
            
            // prepare query statement
            $stmt = $this->conn->prepare($query);
            
            // execute query
            $stmt->execute();
            
            return $stmt;
        }
        
        //update set temperature
        function updateTemperature($temperature){
            //get last record id
            $stmt = $this->readLast();
            $row = $stmt->fetch(PDO::FETCH_ASSOC);
            extract($row);
            
            $query = "UPDATE ". $this->table_name ."
                SET setTemperature = ".$temperature. 
                " WHERE id = '".$id."'";
            // prepare query statement
            $stmt = $this->conn->prepare($query);
            
            // execute query
            if($stmt->execute())
                return true;
            else
                return false;
        }
        
        // read switch status of the specified device
        function getSwitchStatus($id){
            
            // select all query
            $query = "SELECT *
                FROM
                    " . $this->table_name . "
                WHERE id = '".$id."'";
            
            // prepare query statement
            $stmt = $this->conn->prepare($query);
            
            // execute query
            $stmt->execute();
            
            if ($stmt->rowCount() > 0) {
                $row = $stmt->fetch(PDO::FETCH_ASSOC);
                extract($row);
                return $switch;
            }
            else
                return -1;
        }
        
        //update switch status
        function updateSwitch(){
            //get last record id
            $stmt = $this->readLast();
            if($stmt->rowCount() > 0) {//there is a heating system device
                $row = $stmt->fetch(PDO::FETCH_ASSOC);
                extract($row);
    
                if($switch == 0)
                    $newSwitch = 1;
                else
                    $newSwitch = 0;
                
                $query = "UPDATE ". $this->table_name ."
                    SET switch = ".$newSwitch.
                    " WHERE id = '".$id."'";
                //echo $query;
                // prepare query statement
                $stmt = $this->conn->prepare($query);
                
                // execute query
                if($stmt->execute())
                    return $newSwitch;
                else
                    return -1;
            }
            else 
                return -2;//there are no heating system devices
        }
        
        //update enabled status
        function updateEnabled(){
            //get last record id
            $stmt = $this->readLast();
            if($stmt->rowCount() > 0) {//there is a heating system device
                $row = $stmt->fetch(PDO::FETCH_ASSOC);
                extract($row);
                
                if($enabled == 0)
                    $newEnabled = 1;
                else
                    $newEnabled = 0;
                    
                $query = "UPDATE ". $this->table_name ."
                SET enabled = ".$newEnabled.
                " WHERE id = '".$id."'";
                //echo $query;
                // prepare query statement
                $stmt = $this->conn->prepare($query);
                
                // execute query
                if($stmt->execute())
                    return $newEnabled;
                    else
                        return -1;
            }
            else
                return -2;//there are no heating system devices
        }
    }
?>