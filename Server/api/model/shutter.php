<?php
    class Shutter{
     
        // database connection and table name
        private $conn;
        private $table_name = "Shutter";
     
        // object properties
        public $id;
        public $openingLevel;
     
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
        
        // read opening level status of the specified device
        function getLevelStatus($id){
            
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
                return $openingLevel;
            }
            else
                return -1;
        }
        
        //update opening level
        function updateOpeningLevel($id, $level){
        
            $query = "UPDATE ". $this->table_name ."
                SET openingLevel = ".$level.
                " WHERE id = '".$id."'";
            //echo $query;
            // prepare query statement
            $stmt = $this->conn->prepare($query);
            
            // execute query
            if($stmt->execute())
                return true;
            else{//error on database while updating opening level
                //var_dump($stmt->errorInfo());
                return false;
            }
        }
    }
?>