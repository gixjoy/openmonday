import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:monday/common/shared_prefs.dart';
import 'package:monday/controller/service_locator.dart';
import 'package:monday/ui/login.dart';
import 'package:monday/ui/registration.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:monday/controller/notification_controller.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:random_string/random_string.dart';
import 'dart:math' show Random;

final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
final notifications = FlutterLocalNotificationsPlugin();
String firebaseToken = "";

void main() async {
  //Main app section
  WidgetsFlutterBinding.ensureInitialized();

  //Local notification initialization
  NotificationController.initLocalNotificationSystem(notifications);

  //Firebase notifications section
  //_firebaseMessaging.requestNotificationPermissions();
  //_configureFirebase();
  //_registerToFirebase();

  setupLocator();
  if (await SharedPrefs.getRegistrationDone()) {
    runApp(
      new Login(false)
    );
  }
  else {
    runApp(
        new Registration()
    );
  }
}

/*
Needed for Firebase notifications configuration
 */
void _configureFirebase(){
  _firebaseMessaging.configure(
    onMessage: (Map<String, dynamic> message) async {
      print("onMessage: $message");
      //print(message["notification"]["body"]);
      NotificationController.showNotification(notifications,
          "Monday", message["notification"]["body"]);
    },
    onBackgroundMessage: BackgroundNotificationHandler,
    onLaunch: (Map<String, dynamic> message) async {
      print("onLaunch: $message");
      //_navigateToItemDetail(message);
    },
    onResume: (Map<String, dynamic> message) async {
      print("onResume: $message");
      
    },
  );
}

/*
Used for handling background notifications
 */
Future<dynamic> BackgroundNotificationHandler(Map<String, dynamic> message) {
  if (message.containsKey('data')) {
    // Handle data message
    final dynamic data = message['data'];
    print("Background data received [data]: " + message['data'].toString());
  }
}

/*
Used for registering client to Firebase (getting a firebase token) and for saving
clientId (when needed) to Shared Preferences
 */
_registerToFirebase() async {
    //_firebaseMessaging.subscribeToTopic("notifications");
    String token = await _firebaseMessaging.getToken();
    //print("Firebase token: " + token);
    firebaseToken = token;
    String clientId = await SharedPrefs.getClientId();
    if (clientId == null) {
      clientId = randomAlphaNumeric(10);
      await SharedPrefs.setClientId(clientId);
      print("Client ID: " + clientId);
    }
    print("Client ID: " + clientId);
    await SharedPrefs.setFirebaseToken(firebaseToken);
    print("ClientId successfully saved to Shared Preferences");
    print("Firebase token successfully saved to Shared Preferences");
}



