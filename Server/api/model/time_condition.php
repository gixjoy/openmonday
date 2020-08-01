<?php
    class TimeCondition{
     
        // database connection and table name
        private $conn;
        private $table_name = "TimeCondition";
     
        // object properties
        public $id;
        public $hour;
        public $minute;
        public $months;
        public $days;
        public $periodic;
        public $sceneId;
     
        // constructor with $db as database connection
        public function __construct($db){
            $this->conn = $db;
        }
        
        // read all time conditions
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
        
        // create time condition
        function create(){
            // query to insert new record
            $query = "INSERT INTO
                    " . $this->table_name . "
                (hour, minute, months, days, periodic, sceneId) VALUES (".
                $this->hour.",".$this->minute.",".$this->months.",".$this->days.","
                .$this->periodic.",".$this->sceneId.")";
            // prepare query
            $stmt = $this->conn->prepare($query);
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