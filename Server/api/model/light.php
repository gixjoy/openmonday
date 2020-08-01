<?php
    class Light{
     
        // database connection and table name
        private $conn;
        private $table_name = "Light";
     
        // object properties
        public $id;
        public $switch;
     
        // constructor with $db as database connection
        public function __construct($db){
            $this->conn = $db;
        }
        
        // read all records
        function readAll(){
            
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
        
        // read only record with specified id
        function read($id){
            
            // select all query
            $query = "SELECT *
                FROM
                    " . $this->table_name . "
                WHERE id = '".$id."'";
            
            // prepare query statement
            $stmt = $this->conn->prepare($query);
            
            // execute query
            $stmt->execute();
            
            return $stmt;
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
        function updateSwitch($id){
            $stmt = $this->read($id);
            if($stmt->rowCount() > 0) {
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
                else//error while updating switch status on database
                    return -1;
            }
            else //there is no light device on database
                return -2;
        }
    }
?>