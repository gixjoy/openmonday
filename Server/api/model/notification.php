<?php
    class Notification{
     
        // database connection and table name
        private $conn;
        private $table_name = "Notification";
     
        // object properties
        public $id;
        public $message;
        public $date;
     
        // constructor with $db as database connection
        public function __construct($db){
            $this->conn = $db;
        }
        
        // read all records
        function readAll(){
            
            // select query
            $query = "SELECT *
                FROM
                    " . $this->table_name."
                ORDER BY id DESC";
            
            // prepare query statement
            $stmt = $this->conn->prepare($query);
            
            // execute query
            $stmt->execute();
            return $stmt;
        }
        
        // read only last record
        function readLast(){
            
            // select query
            $query = "SELECT *
                FROM
                    " . $this->table_name."
                ORDER BY date DESC LIMIT 1";
            
            // prepare query statement
            $stmt = $this->conn->prepare($query);
            
            // execute query
            $stmt->execute();
            return $stmt;
        }
        
        // read only last record
        function readLastWithMessage($message){
            
            // select query
            $query = "SELECT *
                FROM
                    " . $this->table_name."
                WHERE message = '".$message."' 
                ORDER BY date DESC LIMIT 1";
            
            // prepare query statement
            $stmt = $this->conn->prepare($query);
            
            // execute query
            $stmt->execute();
            return $stmt;
        }
        
        //create notification
        function create(){            
            $query = "INSERT INTO
                    " . $this->table_name . "
                SET
                    id=:id, message=:message, date=:date";
            
            $stmt = $this->conn->prepare($query);
            
            // sanitize
            $this->message=htmlspecialchars(strip_tags($this->message));
            $this->date=htmlspecialchars(strip_tags($this->date));
            
            // bind values
            $stmt->bindParam(":id", $this->id);
            $stmt->bindParam(":message", $this->message);
            $stmt->bindParam(":date", $this->date);
            
            // execute query
            if($stmt->execute()){
                return true;
            }
            else {
                var_dump($stmt->errorInfo());
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
        
        function deleteAll(){
            
            $query = "DELETE FROM ". $this->table_name;
            
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