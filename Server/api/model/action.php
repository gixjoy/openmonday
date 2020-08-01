<?php
    class Action{
     
        // database connection and table name
        private $conn;
        private $table_name = "Action";
     
        // object properties
        public $id;
        public $deviceId;
        public $command;
     
        // constructor with $db as database connection
        public function __construct($db){
            $this->conn = $db;
        }
        
        // read all actions
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
        
        function readId($actionId){
            
            // select all query
            $query = "SELECT *
                FROM
                    " . $this->table_name . "
                WHERE id = ".$actionId;
            
            // prepare query statement
            $stmt = $this->conn->prepare($query);
            
            // execute query
            $stmt->execute();
            
            return $stmt;
        }
        
        function readLastId(){
            $query = "SELECT *
                FROM
                    " . $this->table_name."
                ORDER BY id DESC LIMIT 1";
            
            // prepare query statement
            $stmt = $this->conn->prepare($query);
            
            // execute query
            $stmt->execute();
            $row = $stmt->fetch(PDO::FETCH_ASSOC);
            extract($row);
            
            return $id;
        }
        
        // create action
        function create(){
            // query to insert new record
            $query = "INSERT INTO
                    " . $this->table_name . "
                SET
                    id=:id, deviceId=:deviceId, command=:command";
            // prepare query
            $stmt = $this->conn->prepare($query);
            
            // sanitize
            $this->deviceId=htmlspecialchars(strip_tags($this->deviceId));
            $this->command=htmlspecialchars(strip_tags($this->command));
            
            // bind values
            $stmt->bindParam(":id", $this->id);
            $stmt->bindParam(":deviceId", $this->deviceId);
            $stmt->bindParam(":command", $this->command);
            
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
                  WHERE id = ".$id;
            
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