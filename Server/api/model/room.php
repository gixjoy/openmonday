<?php
    class Room{
     
        // database connection and table name
        private $conn;
        private $table_name = "Room";
     
        // object properties
        public $id;
        public $name;
        public $category;
        public $imgPath;
     
        // constructor with $db as database connection
        public function __construct($db){
            $this->conn = $db;
        }
        
        // read all rooms
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
        
        // read room with specific name
        function readRoomWithName($name){
            
            // select query
            $query = "SELECT *
                FROM
                    " . $this->table_name ."
                WHERE name = '".$name."'";
            
            // prepare query statement
            $stmt = $this->conn->prepare($query);
            
            // execute query
            $stmt->execute();
            
            return $stmt;
        }
        
        // read room with specific id
        function readRoomWithId($id){
            
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
        
        // create room
        function create(){
            // query to insert new record
            $query = "INSERT INTO
                    " . $this->table_name . "
                SET
                    name=:name, category=:category, imgPath=:imgPath";
            // prepare query
            $stmt = $this->conn->prepare($query);
            
            // sanitize
            $this->name=htmlspecialchars(strip_tags($this->name));
            $this->category=htmlspecialchars(strip_tags($this->category));
            $this->imgPath=htmlspecialchars(strip_tags($this->imgPath));
            
            // bind values
            $stmt->bindParam(":name", $this->name);
            $stmt->bindParam(":category", $this->category);
            $stmt->bindParam(":imgPath", $this->imgPath);
            
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