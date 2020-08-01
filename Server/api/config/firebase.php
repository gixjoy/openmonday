<?php 

    require '/var/www/html/monday/process/vendor/autoload.php';
    use Kreait\Firebase;
    use Kreait\Firebase\Messaging\CloudMessage;
    use Kreait\Firebase\Factory;
    use Kreait\Firebase\Messaging\Notification;
    
    class FireBaseNotification {
        
        public function sendNotificationToFirebase($text, $deviceToken) {
            $factory = (new Factory()) ->withServiceAccount('/var/www/html/monday/FIREBASE_PRIVATE_KEY_FILE.json');
            
            $messaging = $factory->createMessaging();
            
            $notification = Notification::create('Monday', $text);
            
            $message = CloudMessage::withTarget('token', $deviceToken)
            ->withNotification($notification) // optional
            //->withData($data) // optional
            ;
            
            $messaging->send($message);
        }
    }

?>