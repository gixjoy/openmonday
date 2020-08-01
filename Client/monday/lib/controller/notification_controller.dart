import 'package:flutter/material.dart';
import 'package:monday/common/api_com.dart';
import 'package:monday/common/shared_prefs.dart';
import 'package:monday/common/utils.dart';
import 'package:monday/model/notification_model.dart';
import 'dart:convert';
import 'package:monday/common/server_response.dart';
import 'package:monday/ui/login.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:monday/common/r.dart';

class NotificationController {

  static void initLocalNotificationSystem(FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) {
    // initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
    var initializationSettingsAndroid = new AndroidInitializationSettings(
        'app_icon');
    var initializationSettingsIOS = IOSInitializationSettings(
        onDidReceiveLocalNotification: (id, title, body, payload) =>
            onSelectNotification(payload));
    var initializationSettings = InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);
  }

  static void showNotification(FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin,
      String title, String body) async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        '0', 'monday', 'monday notification channel',
        importance: Importance.Max, priority: Priority.High, ticker: 'ticker');
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
        0, title, body, platformChannelSpecifics,
        payload: 'item x');
  }

  static Future onSelectNotification(String payload) {
    if (payload != null) {
      print('notification payload: ' + payload);
    }
  }

  /*
  This method is used to get light devices from Monday
   */
  static Future<List<NotificationModel>> getNotificationsFromMonday(BuildContext context) async {
    String hostname = await SharedPrefs.getMondayHostname();
    String sessionToken = await SharedPrefs.getSessionToken();
    String clientId = await SharedPrefs.getClientId();
    Map data = {
      "clientId":clientId,
      "sessionToken": sessionToken,
    };
    ServerResponse response = await ApiCom.sendRequestToMondayAPI(context, data, hostname,
        "notification/read.php");
    if (response.statusCode == 200) {//lights found
      var notificationsMap = jsonDecode(response.body);
      var notificationListModel = NotificationListModel.fromJson(notificationsMap);
      return notificationListModel.records;
    }
    if (response.statusCode == 201){//no lights found
      List<NotificationModel> records = List(0);
      return records;
    }
    if (response.statusCode == 400){//bad request
      Utils.showDialogPanel(
        R.of(context).warningMsg, R.of(context).controllerSysError, context);
      return null;
    }
    if (response.statusCode == 402){//token not valid
      Utils.showDialogPanel(
        R.of(context).warningMsg, R.of(context).controllerTokenError, context);
      return null;
    }
    else {//internal error, data incomplete
      Utils.showDialogPanel(
        R.of(context).warningMsg, R.of(context).controllerSysError, context);
      return null;
    }
  }

  /*
    Method used to remove a notification from Monday
  */
  static Future<bool> deleteNotificationFromRoomOnMonday(BuildContext context,
      NotificationModel notification) async {
    String clientId = await SharedPrefs.getClientId();
    String hostname = await SharedPrefs.getMondayHostname();
    String sessionToken = await SharedPrefs.getSessionToken();
    String id = notification.id;
    Map data = {
      "clientId":clientId,
      "sessionToken":sessionToken,
      "id":id,
    };
    ServerResponse response = await ApiCom.sendRequestToMondayAPI(context, data, hostname,
        "notification/delete.php");
    if (response.statusCode == 200) {//Response correctly received
      return true;
    }
    if (response.statusCode == 402) {//session token expired, require new login
      Navigator.push(context, MaterialPageRoute(builder: (context) => Login(false)));
      return null;
    }
    else {//internal error, data incomplete
      Utils.showDialogPanel(
          R.of(context).warningMsg, R.of(context).controllerSysError, context);
      return null;
    }
  }

  /*
    Method used to remove a notification from Monday
  */
  static Future<bool> deleteAllNotificationsFromMonday(BuildContext context) async {
    String clientId = await SharedPrefs.getClientId();
    String hostname = await SharedPrefs.getMondayHostname();
    String sessionToken = await SharedPrefs.getSessionToken();
    Map data = {
      "clientId":clientId,
      "sessionToken":sessionToken
    };
    ServerResponse response = await ApiCom.sendRequestToMondayAPI(context, data, hostname,
        "notification/delete_all.php");
    if (response.statusCode == 200) {//Response correctly received
      return true;
    }
    if (response.statusCode == 402) {//session token expired, require new login
      Navigator.push(context, MaterialPageRoute(builder: (context) => Login(false)));
      return null;
    }
    else {//internal error, data incomplete
      Utils.showDialogPanel(
          R.of(context).warningMsg, R.of(context).controllerSysError, context);
      return null;
    }
  }
}