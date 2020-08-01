<?php
    class User{
     
        // database connection and table name
        private $conn;
        private $table_name = "User";
     
        // object properties
        public $id;
        public $username;
        public $password;
        public $enabled;
        public $sessionTimeout;
     
        // constructor with $db as database connection
        public function __construct($db){
            $this->conn = $db;
        }
        
        // read all users
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
        
        // read specific user
        function readUser($username){
            
            // select query
            $query = "SELECT *
                FROM
                    " . $this->table_name ."
                WHERE username = '".$username."'"; 
            
            // prepare query statement
            $stmt = $this->conn->prepare($query);
            
            // execute query
            $stmt->execute();
            
            return $stmt;
        }
        
        // read username of admin user (the first user who registered to the system)
        /*function readAdminUsername(){
            
            // select query
            $query = "SELECT id, username
                FROM
                    " . $this->table_name ."
                ORDER BY id
                LIMIT 1";
            
            // prepare query statement
            $stmt = $this->conn->prepare($query);
            
            // execute query
            $stmt->execute();
            $stmt->fetch(PDO::FETCH_ASSOC);
            extract($stmt);
            
            return $username;
        }*/
        
        // create user
        function create(){
            // query to insert record
            $query = "INSERT INTO
                    " . $this->table_name . "
                SET
                    username=:username, password=:password, enabled=1";
            // prepare query
            $stmt = $this->conn->prepare($query);
            
            // sanitize
            $this->username=htmlspecialchars(strip_tags($this->username));
            $this->password=htmlspecialchars(strip_tags($this->password));
            
            // bind values
            $stmt->bindParam(":username", $this->username);
            $stmt->bindParam(":password", $this->password);
            
            // execute query
            if($stmt->execute()){
                return true;
            }
            else {
                //var_dump($stmt->errorInfo());
                return false;
            }
        }
        
        // login user
        function login($username, $password){
            // select all query
            $query = "SELECT *
                    FROM
                        " . $this->table_name . " 
                    WHERE
                        username='".$username."' AND password='".$password."'";
            // prepare query statement
            $stmt = $this->conn->prepare($query);
            // execute query
            $stmt->execute();
            $num = $stmt->rowCount();
            if($num > 0) {//user exists
                // retrieve our table contents
                // fetch() is faster than fetchAll()
                // http://stackoverflow.com/questions/2770630/pdofetchall-vs-pdofetch-in-a-loop
                while ($row = $stmt->fetch(PDO::FETCH_ASSOC)){
                    // extract row
                    // this will make $row['name'] to
                    // just $name only
                    extract($row);
                }
                if ($enabled == 0) 
                    return 0; //return int for not enabled
                else
                    return 1; //return int for enabled
            }
            else 
                return 2; //return int for user not existing
        }
        
        /*function updateSessionTimeout($username, $sessionTimeout){
            $query = "UPDATE
                        " . $this->table_name . "
                        SET sessionTimeout = " .$sessionTimeout ."
                        WHERE username = '" . $username ."'";
            $stmt = $this->conn->prepare($query);
            if($stmt->execute())
                return true;
            else
                return false;
        }*/
        
        function updateUserPassword($username, $password){
            $query = "UPDATE
                        " . $this->table_name . "
                        SET password = '" .$password ."' 
                        WHERE username = '" . $username ."'";
            $stmt = $this->conn->prepare($query);
            if($stmt->execute())
                return true;
            else
                return false;
        }
        
        /*function setSessionToken($client, $sessionToken){
            $query = "UPDATE
                        " . $this->table_name . "
                        SET sessionToken = '" .$sessionToken ."'
                        WHERE clientId = '" . $clientId ."'";
            $stmt = $this->conn->prepare($query);
            if($stmt->execute())
                return true;
            else
                return false;
        }*/
        
        function validateRequest($username, $userSessionToken){
            $stmt = $this->readUser($username);
            $row = $stmt->fetch(PDO::FETCH_ASSOC);
            extract($row);
            if($sessionTimeout > time() && $sessionToken == $userSessionToken) 
                return true;
            else
                return false;
        }
        
        function updateCurrentAccess($username, $currentAccess){
            $query = "UPDATE
                        " . $this->table_name . "
                        SET currentAccess = '" .$currentAccess ."'
                        WHERE username = '" . $username ."'";
            $stmt = $this->conn->prepare($query);
            if($stmt->execute())
                return true;
            else
                return false;
        }        
    }
?>