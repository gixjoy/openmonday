import 'package:flutter/material.dart';
import 'package:monday/common/api_com.dart';
import 'package:monday/common/shared_prefs.dart';
import 'package:monday/common/utils.dart';
import 'package:monday/ui/login.dart';
import 'package:monday/model/shutter_model.dart';
import 'dart:convert';
import 'package:monday/common/server_response.dart';
import 'package:monday/common/r.dart';

class ShutterController {

  /*
  This method is used to get shutter devices from Monday
   */
  static Future<List<ShutterModel>> getShuttersFromMonday(BuildContext context) async {
    String hostname = await SharedPrefs.getMondayHostname();
    String sessionToken = await SharedPrefs.getSessionToken();
    String clientId = await SharedPrefs.getClientId();
    Map data = {
      "clientId":clientId,
      "sessionToken": sessionToken,
    };
    ServerResponse response = await ApiCom.sendRequestToMondayAPI(context, data, hostname,
        "shutter/read.php");
    if (response.statusCode == 200) {//shutters found
      var shutterMap = jsonDecode(response.body);
      var shutterListModel = ShutterListModel.fromJson(shutterMap);
      return shutterListModel.records;
    }
    if (response.statusCode == 201){//no shutters found
      List<ShutterModel> records = List(0);
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
  This method is used to get shutter devices from Monday
   */
  static Future<ShutterModel> getSingleShutterFromMonday(BuildContext context,
      String shutterId) async {
    String hostname = await SharedPrefs.getMondayHostname();
    String sessionToken = await SharedPrefs.getSessionToken();
    String clientId = await SharedPrefs.getClientId();
    Map data = {
      "clientId":clientId,
      "sessionToken": sessionToken,
      "id":shutterId
    };
    ServerResponse response = await ApiCom.sendRequestToMondayAPI(context, data, hostname,
        "shutter/read_one.php");
    if (response.statusCode == 200) {//shutters found
      var shutterMap = jsonDecode(response.body);
      var shutterModel = ShutterModel.fromJson(shutterMap);
      return shutterModel;
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
  This method is used for sending shutter opening level to Monday
   */
  static Future<bool> updateOpeningLevelOnMonday (BuildContext context,
      String deviceId, String openingLevel) async {
    String clientId = await SharedPrefs.getClientId();
    String hostname = await SharedPrefs.getMondayHostname();
    String sessionToken = await SharedPrefs.getSessionToken();
    Map data = {
      "clientId":clientId,
      "sessionToken":sessionToken,
      "id": deviceId,
      "openingLevel":openingLevel
    };
    ServerResponse response = await ApiCom.sendRequestToMondayAPI(context, data, hostname,
        "shutter/opening_level.php");
    if (response.statusCode == 200) {//Response correctly received
      return true;
    }
    if(response.statusCode == 201){//Shelly need to be calibrated
      Utils.showDialogPanel(
        R.of(context).warningMsg, R.of(context).controllerCalibrationError, context);
      return true;
    }
    if (response.statusCode == 402) {//session token expired, require new login
      Navigator.push(context, MaterialPageRoute(builder: (context) => Login(false)));
      return false;
    }
    if (response.statusCode == 503) { //error on Shelly side
      return false;
    }
    else {//internal error
      return false;
    }
  }

  /*
  This method is used for sending shutter opening level to Monday
   */
  static Future<bool> calibrateShutterOnMonday (BuildContext context,
      String deviceId) async {
    String clientId = await SharedPrefs.getClientId();
    String hostname = await SharedPrefs.getMondayHostname();
    String sessionToken = await SharedPrefs.getSessionToken();
    Map data = {
      "clientId":clientId,
      "sessionToken":sessionToken,
      "id": deviceId,
    };
    ServerResponse response = await ApiCom.sendRequestToMondayAPI(context, data, hostname,
        "shutter/calibrate.php");
    if (response.statusCode == 200) {//Response correctly received
      return true;
    }
    if (response.statusCode == 402) {//session token expired, require new login
      Navigator.push(context, MaterialPageRoute(builder: (context) => Login(false)));
      return false;
    }
    if (response.statusCode == 503) { //error on Shelly side
      Utils.showDialogPanel(
          R.of(context).warningMsg, R.of(context).controllerCommunicationError, context);
      return false;
    }
    else {//internal error
      Utils.showDialogPanel(
          R.of(context).warningMsg, R.of(context).controllerSysError, context);
      return false;
    }
  }
}