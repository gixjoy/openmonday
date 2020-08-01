<?php
class DiscoveryRecord {
    public $ip;
    public $hostname;
    public $mac;//on database it is id column
    
    public function __construct($ip, $hostname, $mac){
        $this->ip = $ip;
        $this->hostname = $hostname;
        $this->mac = $mac;
    }
}
?>