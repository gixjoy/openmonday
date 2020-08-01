<?php
    class SceneHasMeasureCondition{
     
        // database connection and table name
        private $conn;
        private $table_name = "SceneHasMeasureCondition";
     
        // object properties
        public $sceneId;
        public $measureConditionId;
     
        // constructor with $db as database connection
        public function __construct($db){
            $this->conn = $db;
        }
        
        // read all SceneHasMeasureCondition records
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
        
        function readWithSceneId($sceneId){
            $query = "SELECT *
                FROM
                    " . $this->table_name."
                WHERE sceneId=".$sceneId;
            
            // prepare query statement
            $stmt = $this->conn->prepare($query);
            
            // execute query
            $stmt->execute();
            
            return $stmt;
        }
        
        // create SceneHasMeasureCondition record
        function create(){
            // query to insert new record
            $query = "INSERT INTO
                    " . $this->table_name . "
                SET
                    sceneId=:sceneId, measureConditionId=:measureConditionId";
            // prepare query
            $stmt = $this->conn->prepare($query);
            
            // sanitize
            $this->sceneId=htmlspecialchars(strip_tags($this->sceneId));
            $this->measureConditionId=htmlspecialchars(strip_tags($this->measureConditionId));
            
            // bind values
            $stmt->bindParam(":sceneId", $this->sceneId);
            $stmt->bindParam(":measureConditionId", $this->measureConditionId);
            
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