import 'package:flutter/material.dart';
import 'package:monday/common/api_com.dart';
import 'package:monday/common/shared_prefs.dart';
import 'package:monday/common/utils.dart';
import 'package:monday/ui/login.dart';
import 'dart:convert';
import 'package:monday/model/heater_model.dart';
import 'package:monday/common/server_response.dart';
import 'package:monday/common/r.dart';

class HeaterController {

  /*
  This method is used for getting last set temperature value from Monday
   */
  static Future<HeaterModel> getHeaterDataFromMonday (BuildContext context) async {
    String clientId = await SharedPrefs.getClientId();
    String hostname = await SharedPrefs.getMondayHostname();
    String sessionToken = await SharedPrefs.getSessionToken();
    Map data = {
      "clientId":clientId,
      "sessionToken":sessionToken
    };
    ServerResponse response = await ApiCom.sendRequestToMondayAPI(context, data, hostname,
        "heater/read.php");
    if (response.statusCode == 200 || response.statusCode == 201) {//Response correctly received
      Map heaterMap = jsonDecode(response.body);
      var heater = HeaterModel.fromJson(heaterMap);
      return heater;
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
  This method is used for updating set temperature on Monday
   */
  static Future<bool> sendTemperatureToMonday (BuildContext context,
      String temperature) async {
    String clientId = await SharedPrefs.getClientId();
    String hostname = await SharedPrefs.getMondayHostname();
    String sessionToken = await SharedPrefs.getSessionToken();
    Map data = {
      "clientId":clientId,
      "sessionToken":sessionToken,
      "temperature":temperature
    };
    ServerResponse response = await ApiCom.sendRequestToMondayAPI(context, data, hostname,
        "heater/update.php");
    if (response.statusCode == 200) {//Response correctly received
      return true;
    }
    if (response.statusCode == 402) {//session token expired, require new login
      Navigator.push(context, MaterialPageRoute(builder: (context) => Login(false)));
      return false;
    }
    else {//internal error, data incomplete
      Utils.showDialogPanel(
          R.of(context).warningMsg, R.of(context).controllerSysError, context);
      return false;
    }
  }

  /*
  This method is used for switching heaters on/off on Monday
   */
  static Future<String> updateEnabledOnMonday (BuildContext context,
      String deviceId) async {
    String clientId = await SharedPrefs.getClientId();
    String hostname = await SharedPrefs.getMondayHostname();
    String sessionToken = await SharedPrefs.getSessionToken();
    Map data = {
      "clientId":clientId,
      "sessionToken":sessionToken,
      "id": deviceId
    };
    ServerResponse response = await ApiCom.sendRequestToMondayAPI(context, data, hostname,
        "heater/enable.php");
    Map heaterMap = jsonDecode(response.body);
    var heater = HeaterModel.fromJson(heaterMap);
    if (response.statusCode == 200) {//Response correctly received
      return heater.enabled;
    }
    if (response.statusCode == 402) {//session token expired, require new login
      Navigator.push(context, MaterialPageRoute(builder: (context) => Login(false)));
      return null;
    }
    if (response.statusCode == 503) { //error on Shelly side
      Utils.showDialogPanel(
          R.of(context).warningMsg, R.of(context).controllerCommunicationError, context);
      return null;
    }
    else {//internal error
      Utils.showDialogPanel(
          R.of(context).warningMsg, R.of(context).controllerSysError, context);
      return null;
    }
  }
}