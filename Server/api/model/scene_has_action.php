<?php
    class SceneHasAction{
     
        // database connection and table name
        private $conn;
        private $table_name = "SceneHasAction";
     
        // object properties
        public $sceneId;
        public $actionId;
     
        // constructor with $db as database connection
        public function __construct($db){
            $this->conn = $db;
        }
        
        // read all SceneHasAction records
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
        
        
        function readActionsWithSceneId($sceneId){
            
            // select all query
            $query = "SELECT *
                FROM
                    " . $this->table_name . "
                WHERE sceneId = ".$sceneId;
            
            // prepare query statement
            $stmt = $this->conn->prepare($query);
            
            // execute query
            $stmt->execute();
            
            return $stmt;
        }
        
        // create SceneHasAction record
        function create(){
            // query to insert new record
            $query = "INSERT INTO
                    " . $this->table_name . "
                SET
                    sceneId=:sceneId, actionId=:actionId";
            // prepare query
            $stmt = $this->conn->prepare($query);
            
            // sanitize
            $this->sceneId=htmlspecialchars(strip_tags($this->sceneId));
            $this->actionId=htmlspecialchars(strip_tags($this->actionId));
            
            // bind values
            $stmt->bindParam(":sceneId", $this->sceneId);
            $stmt->bindParam(":actionId", $this->actionId);
            
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
                  WHERE sceneId = '".$id."'";
            
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