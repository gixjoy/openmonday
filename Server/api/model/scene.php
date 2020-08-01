<?php
    class Scene{
     
        // database connection and table name
        private $conn;
        private $table_name = "Scene";
     
        // object properties
        public $id;
        public $name;
        public $type;
        public $enabled;
        public $running;
     
        // constructor with $db as database connection
        public function __construct($db){
            $this->conn = $db;
        }
        
        // read all scenes
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
        
        function readType($type){
            
            // select all query
            $query = "SELECT *
                FROM
                    " . $this->table_name."
                WHERE type = '".$type."'";
            
            // prepare query statement
            $stmt = $this->conn->prepare($query);
            
            // execute query
            $stmt->execute();
            
            return $stmt;
        }
        
        // read specific scene
        function readOne($id){
            
            // select all query
            $query = "SELECT *
                FROM " . $this->table_name."
                WHERE id = ".$id;
            
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
        
        // create scene
        function create(){
            // query to insert new record
            $query = "INSERT INTO
                    " . $this->table_name . "
                SET
                    name=:name, type=:type, enabled=:enabled, running=0";
            // prepare query
            $stmt = $this->conn->prepare($query);
            
            // sanitize
            $this->name=htmlspecialchars(strip_tags($this->name));
            $this->type=htmlspecialchars(strip_tags($this->type));
            $this->enabled=htmlspecialchars(strip_tags($this->enabled));
            
            // bind values
            $stmt->bindParam(":name", $this->name);
            $stmt->bindParam(":type", $this->type);
            $stmt->bindParam(":enabled", $this->enabled);
            
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
                  WHERE id = ".$id;
            
            // prepare query statement
            $stmt = $this->conn->prepare($query);
            
            // execute query
            if($stmt->execute())
                return true;
            else
                return false;
        }
        
        function update($id, $name){
            $query = "UPDATE ". $this->table_name ."
                  SET name = '".$name."' 
                  WHERE id = ".$id;
            
            // prepare query statement
            $stmt = $this->conn->prepare($query);
            
            // execute query
            if($stmt->execute())
                return true;
            else
                return false;
        }
        
        function updateSceneStatus($id, $newStatus){
            $query = "UPDATE ". $this->table_name ."
                  SET enabled = '".$newStatus."'
                  WHERE id = ".$id;
            
            // prepare query statement
            $stmt = $this->conn->prepare($query);
            
            // execute query
            if($stmt->execute())
                return true;
            else
                return false;
        }
        
        function updateSceneRunning($id, $newRunning){
            $query = "UPDATE ". $this->table_name ."
                  SET running = '".$newRunning."'
                  WHERE id = ".$id;
            
            // prepare query statement
            $stmt = $this->conn->prepare($query);
            
            // execute query
            if($stmt->execute())
                return true;
            else
                return false;
        }
        
        function readRunning($sceneId){
            $query = "SELECT *
                FROM
                    " . $this->table_name."
                WHERE id = ".$sceneId;
            
            // prepare query statement
            $stmt = $this->conn->prepare($query);
            
            // execute query
            $stmt->execute();
            $row = $stmt->fetch(PDO::FETCH_ASSOC);
            extract($row);
            
            return $running;
        }
    }
?>