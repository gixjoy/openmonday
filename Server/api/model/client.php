<?php
    class Client{
     
        // database connection and table name
        private $conn;
        private $table_name = "Client";
     
        // object properties
        public $clientId;
        public $userId;
        public $firebaseToken;
        public $sessionTimeout;
        public $sessionToken;
     
        // constructor with $db as database connection
        public function __construct($db){
            $this->conn = $db;
        }
        
        // read all clients
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
        
        function readOne($clientId){
            // select all query
            $query = "SELECT *
                FROM
                    " . $this->table_name." 
                WHERE clientId='".$clientId."'";
            
            // prepare query statement
            $stmt = $this->conn->prepare($query);
            
            // execute query
            $stmt->execute();
            
            return $stmt;
        }
        
        // create client
        function create(){
            // query to insert record
            $query = "INSERT INTO
                    " . $this->table_name . "
                SET
                    clientId=:clientId, userId=:userId, firebaseToken=:firebaseToken, 
                    sessionToken=:sessionToken";
            // prepare query
            $stmt = $this->conn->prepare($query);
            
            // sanitize
            $this->clientId=htmlspecialchars(strip_tags($this->clientId));
            $this->userId=htmlspecialchars(strip_tags($this->userId));
            $this->firebaseToken=htmlspecialchars(strip_tags($this->firebaseToken));
            $this->sessionToken=htmlspecialchars(strip_tags($this->sessionToken));
            $this->sessionTimeout=htmlspecialchars(strip_tags($this->sessionTimeout));
            
            // bind values
            $stmt->bindParam(":clientId", $this->clientId);
            $stmt->bindParam(":userId", $this->userId);
            $stmt->bindParam(":firebaseToken", $this->firebaseToken);
            $stmt->bindParam(":sessionToken", $this->sessionToken);
            
            // execute query
            if($stmt->execute()){
                return true;
            }
            else {
                //var_dump($stmt->errorInfo());
                return false;
            }
        }
        
        function updateFirebaseToken($clientId, $firebaseToken){
            $query = "UPDATE
                        " . $this->table_name . "
                        SET firebaseToken = " .$firebaseToken ."
                        WHERE clientId = '" . $clientId ."'";
            $stmt = $this->conn->prepare($query);
            if($stmt->execute())
                return true;
            else
                return false;
        }
        
        function updateSessionToken($clientId, $sessionToken){
            $query = "UPDATE
                        " . $this->table_name . "
                        SET sessionToken = '" .$sessionToken ."'
                        WHERE clientId = '" . $clientId ."'";
            $stmt = $this->conn->prepare($query);
            if($stmt->execute())
                return true;
            else
                return false;
        }
        
        function updateSessionTimeout($clientId, $sessionTimeout){
            $query = "UPDATE
                        " . $this->table_name . "
                        SET sessionTimeout = " .$sessionTimeout ."
                        WHERE clientId = '" . $clientId ."'";
            $stmt = $this->conn->prepare($query);
            if($stmt->execute())
                return true;
                else
                    return false;
        }
        
        function validateRequest($clientId, $clientSessionToken){
            $stmt = $this->readOne($clientId);
            $row = $stmt->fetch(PDO::FETCH_ASSOC);
            extract($row);
            if($sessionTimeout > time() && $sessionToken == $clientSessionToken)
                return true;
            else
                return false;
        }
    }
?>