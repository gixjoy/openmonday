import 'package:flutter/material.dart';
import 'package:monday/common/api_com.dart';
import 'dart:convert';
import 'package:monday/common/shared_prefs.dart';
import 'package:monday/common/utils.dart';
import 'package:monday/model/home_model.dart';
import 'package:monday/ui/login.dart';
import 'package:monday/common/server_response.dart';
import 'package:monday/common/r.dart';

class HomeController {

  /*
  This method gets lastAccess field from response coming from Monday
   */
  static Future<String> getLastUpdate(Future<String> response) async {
    if (response != null) {
      String res = await response;
      Map homeMap = jsonDecode(res);
      var home = HomeModel.fromJson(homeMap);
      //print('Last access detected: ${home.lastAccess}');
      return home.lastUpdate;
    }
    else
      return "---";
  }

  /*
  This method gets the consumptions field from response coming from Monday
   */
  static Future<String> getLastConsumptions(Future<String> response) async {
    if (response != null) {
      String res = await response;
      Map homeMap = jsonDecode(res);
      var home = HomeModel.fromJson(homeMap);
      //print('Last consumptions detected: ${home.humidity}');
      return home.consumptions;
    }
    else
      return "---";
  }

  /*
  This method gets the humidity field from response coming from Monday
   */
  static Future<String> getLastHumidity(Future<String> response) async {
    if (response != null) {
      String res = await response;
      Map homeMap = jsonDecode(res);
      var home = HomeModel.fromJson(homeMap);
      //print('Last humidity detected: ${home.humidity}');
      return home.humidity;
    }
    else
      return "---";
  }

  /*
  This method gets the temperature field from response coming from Monday
   */
  static Future<String> getLastTemperature(Future<String> response) async {
    if (response != null) {
      String res = await response;
      Map homeMap = jsonDecode(res);
      var home = HomeModel.fromJson(homeMap);
      //print('Last temperature detected: ${home.temperature}');
      return home.temperature;
    }
    else
      return "---";
  }

  /*
  This method gets the battery level of climate_sensor, coming from Monday
   */
  static Future<String> getLastBatteryLevel(Future<String> response) async {
    if (response != null) {
      String res = await response;
      Map homeMap = jsonDecode(res);
      var home = HomeModel.fromJson(homeMap);
      //print('Last battery level detected: ${home.batteryLevel}');
      return home.batteryLevel;
    }
    else
      return "---";
  }

  /*
  This method gets the date pf the last climate measure made by climate_sensor,
  coming from Monday
   */
  static Future<String> getLastMeasureDate(Future<String> response) async {
    if (response != null) {
      String res = await response;
      Map homeMap = jsonDecode(res);
      var home = HomeModel.fromJson(homeMap);
      //print('Last measure date detected: ${home.lastMeasureDate}');
      return home.lastMeasureDate;
    }
    else
      return "---";
  }

  /*
    Method used to get Home Route fields from database on Monday
     */
  static Future<String> getHomeDataFromMonday(BuildContext context) async {
    String hostname = await SharedPrefs.getMondayHostname();
    String clientId = await SharedPrefs.getClientId();
    String sessionToken = await SharedPrefs.getSessionToken();
    Map data = {
      "clientId":clientId,
      "sessionToken": sessionToken
    };
    ServerResponse response = await ApiCom.sendRequestToMondayAPI(context, data, hostname,
        "home/get_data.php");
    if (response.statusCode == 200) {//Response correctly received
      return response.body;
    }
    if (response.statusCode == 401 || response.statusCode == 402) {//session timeout expired, require new login
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Login(false)));
      return null;
    }
    else {//internal error, data incomplete
      Utils.showDialogPanel(
          R.of(context).warningMsg, R.of(context).showErrorMessageIncompleteData, context);
      return null;
    }
  }
}