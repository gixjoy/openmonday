<?php 

class Mosquitto {
    
    private $broker = 'localhost';
    private $port = '1883';
    private $username = 'MOSQUITTO_USERNAME';
    private $pwd = 'MOSQUITTO_PASSWORD';
    
    private $client;
    
    // get a client connection to Mosquitto
    public function getClient($clientId){
        $this->client = new Mosquitto\Client($clientId);
        $this->client->setCredentials($this->username, $this->pwd);
        $this->client->connect($this->broker, $this->port, 60);
        
        return $this->client;
    }
}

?>