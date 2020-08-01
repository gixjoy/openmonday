<?php
    class AccessHistory{
     
        // database connection and table name
        private $conn;
        private $table_name = "AccessHistory";
     
        // object properties
        public $id;
        public $userId;
        public $lastAccess;
     
        // constructor with $db as database connection
        public function __construct($db){
            $this->conn = $db;
        }
        
        // read record with specific userId
        function getLastAccess($userId){
            
            // select query
            $query = "SELECT *
                FROM
                    " . $this->table_name ."
                WHERE userId = '".$userId."' 
                ORDER BY id DESC";
            
            // prepare query statement
            $stmt = $this->conn->prepare($query);
            
            // execute query
            $stmt->execute();
            $row = $stmt->fetch(PDO::FETCH_ASSOC);
            extract($row);
            return $lastAccess;
        }
    }
?>