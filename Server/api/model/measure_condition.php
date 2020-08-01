<?php
    class MeasureCondition{
     
        // database connection and table name
        private $conn;
        private $table_name = "MeasureCondition";
     
        // object properties
        public $id;
        public $type;
        public $operator;
        public $value;
     
        // constructor with $db as database connection
        public function __construct($db){
            $this->conn = $db;
        }
        
        // read all measure conditions
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
        
        function readId($id){
            
            // select all query
            $query = "SELECT *
                FROM
                    " . $this->table_name."
                WHERE id=".$id;
            
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
        
        // create measure condition
        function create(){
            // query to insert new record
            $query = "INSERT INTO
                    " . $this->table_name . "
                SET
                    type=:type, operator=:operator, value=:value";
            // prepare query
            $stmt = $this->conn->prepare($query);
            
            // sanitize
            $this->type=htmlspecialchars(strip_tags($this->type));
            $this->value=htmlspecialchars(strip_tags($this->value));
            
            // bind values
            $stmt->bindParam(":type", $this->type);
            $stmt->bindParam(":operator", $this->operator);
            $stmt->bindParam(":value", $this->value);
            
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
    }
?>