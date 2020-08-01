import 'package:flutter/material.dart';
import 'package:monday/common/api_com.dart';
import 'package:monday/common/shared_prefs.dart';
import 'package:monday/common/utils.dart';
import 'package:monday/model/chart_actual_sample_model.dart';
import 'package:monday/model/chart_daily_sample_model.dart';
import 'package:monday/model/chart_monthly_sample_model.dart';
import 'dart:convert';
import 'package:monday/common/server_response.dart';
import 'package:monday/common/r.dart';
import 'package:monday/common/r.dart';

class ChartController {

  /*
  This method is used to get device actual consumption from Monday.
  It only returns a single ChartActualSampleModel object
   */
  static Future<ChartActualSampleModel> getActualConsumptionsFromMonday(
      BuildContext context, String deviceId) async {
    String hostname = await SharedPrefs.getMondayHostname();
    String sessionToken = await SharedPrefs.getSessionToken();
    String clientId = await SharedPrefs.getClientId();
    String time = "now";
    Map data = {
      "clientId": clientId,
      "sessionToken": sessionToken,
      "deviceId": deviceId,
      "time": time
    };
    ServerResponse response = await ApiCom.sendRequestToMondayAPI(
        context, data, hostname,
        "chart/read_specific_consumptions.php");
    if (response.statusCode == 200) { //values found
      var samplesMap = jsonDecode(response.body);
      var sampleModel = ChartActualSampleModel.fromJson(samplesMap);
      return sampleModel;
    }
    if (response.statusCode == 400) { //bad request
      Utils.showDialogPanel(
          R.of(context).warningMsg,
          R.of(context).controllerSysError,
          context);
      return null;
    }
    if (response.statusCode == 402) { //token not valid
      Utils.showDialogPanel(
          R.of(context).warningMsg, R.of(context).controllerTokenError,
          context);
      return null;
    }
    else { //internal error, data incomplete
      Utils.showDialogPanel(
          R.of(context).warningMsg,
          R.of(context).controllerSysError,
          context);
      return null;
    }
  }

  /*
  This method is used to get device daily consumptions from Monday
   */
  static Future<List<ChartDailySampleModel>> getDailyConsumptionsFromMonday(
      BuildContext context, String deviceId) async {
    String hostname = await SharedPrefs.getMondayHostname();
    String sessionToken = await SharedPrefs.getSessionToken();
    String clientId = await SharedPrefs.getClientId();
    String time = "daily";
    Map data = {
      "clientId": clientId,
      "sessionToken": sessionToken,
      "deviceId": deviceId,
      "time": time
    };
    ServerResponse response = await ApiCom.sendRequestToMondayAPI(
        context, data, hostname,
        "chart/read_specific_consumptions.php");
    if (response.statusCode == 200) { //device found
      var samplesMap = jsonDecode(response.body);
      var sampleListModel = ChartDailySampleListModel.fromJson(samplesMap);
      return sampleListModel.records;
    }
    if (response.statusCode == 400) { //bad request
      Utils.showDialogPanel(
          R.of(context).warningMsg,
          R.of(context).controllerSysError,
          context);
      return null;
    }
    if (response.statusCode == 402) { //token not valid
      Utils.showDialogPanel(
          R.of(context).warningMsg, R.of(context).controllerTokenError,
          context);
      return null;
    }
    else { //internal error, data incomplete
      Utils.showDialogPanel(
          R.of(context).warningMsg,
          R.of(context).controllerSysError,
          context);
      return null;
    }
  }

  /*
  This method is used to get device monthly consumptions from Monday
   */
  static Future<List<ChartMonthlySampleModel>> getMonthlyConsumptionsFromMonday(
      BuildContext context, String deviceId) async {
    String hostname = await SharedPrefs.getMondayHostname();
    String sessionToken = await SharedPrefs.getSessionToken();
    String clientId = await SharedPrefs.getClientId();
    String time = "monthly";
    Map data = {
      "clientId": clientId,
      "sessionToken": sessionToken,
      "deviceId": deviceId,
      "time": time
    };
    ServerResponse response = await ApiCom.sendRequestToMondayAPI(
        context, data, hostname,
        "chart/read_specific_consumptions.php");
    if (response.statusCode == 200) { //device found
      var samplesMap = jsonDecode(response.body);
      var sampleListModel = ChartMonthlySampleListModel.fromJson(samplesMap);
      return sampleListModel.records;
    }
    if (response.statusCode == 400) { //bad request
      Utils.showDialogPanel(
          R.of(context).warningMsg,
          R.of(context).controllerSysError,
          context);
      return null;
    }
    if (response.statusCode == 402) { //token not valid
      Utils.showDialogPanel(
          R.of(context).warningMsg, R.of(context).controllerTokenError,
          context);
      return null;
    }
    else { //internal error, data incomplete
      Utils.showDialogPanel(
          R.of(context).warningMsg,
          R.of(context).controllerSysError,
          context);
      return null;
    }
  }

  /*
  This method is used to get device actual value of specified type from Monday.
  It only returns a single ChartActualSampleModel object
   */
  static Future<ChartActualSampleModel> getActualValueFromMonday(
      BuildContext context, String valueType) async {
    String hostname = await SharedPrefs.getMondayHostname();
    String sessionToken = await SharedPrefs.getSessionToken();
    String clientId = await SharedPrefs.getClientId();
    String time = "now";
    String apiName = "";
    switch(valueType){
      case "consumption":
        apiName = "read_consumptions";
        break;
      case "temperature":
        apiName = "read_temperatures";
        break;
      case "humidity":
        apiName = "read_humidities";
        break;
    }
    Map data = {
      "clientId": clientId,
      "sessionToken": sessionToken,
      "time": time
    };
    ServerResponse response = await ApiCom.sendRequestToMondayAPI(
        context, data, hostname,
        "chart/"+apiName+".php");
    if (response.statusCode == 200) { //values found
      var samplesMap = jsonDecode(response.body);
      var sampleModel = ChartActualSampleModel.fromJson(samplesMap);
      return sampleModel;
    }
    if (response.statusCode == 400) { //bad request
      Utils.showDialogPanel(
          R.of(context).warningMsg,
          R.of(context).controllerSysError,
          context);
      return null;
    }
    if (response.statusCode == 402) { //token not valid
      Utils.showDialogPanel(
          R.of(context).warningMsg, R.of(context).controllerTokenError,
          context);
      return null;
    }
    else { //internal error, data incomplete
      Utils.showDialogPanel(
          R.of(context).warningMsg,
          R.of(context).controllerSysError,
          context);
      return null;
    }
  }

  /*
  This method is used to get device daily values of specified type from Monday
   */
  static Future<List<ChartDailySampleModel>> getDailyValuesFromMonday(
      BuildContext context, String valueType) async {
    String hostname = await SharedPrefs.getMondayHostname();
    String sessionToken = await SharedPrefs.getSessionToken();
    String clientId = await SharedPrefs.getClientId();
    String time = "daily";
    String apiName = "";
    switch(valueType){
      case "consumption":
        apiName = "read_consumptions";
        break;
      case "temperature":
        apiName = "read_temperatures";
        break;
      case "humidity":
        apiName = "read_humidities";
        break;
    }
    Map data = {
      "clientId": clientId,
      "sessionToken": sessionToken,
      "time": time
    };
    ServerResponse response = await ApiCom.sendRequestToMondayAPI(
        context, data, hostname,
        "chart/"+apiName+".php");
    if (response.statusCode == 200) { //device found
      var samplesMap = jsonDecode(response.body);
      var sampleListModel = ChartDailySampleListModel.fromJson(samplesMap);
      return sampleListModel.records;
    }
    if (response.statusCode == 400) { //bad request
      Utils.showDialogPanel(
          R.of(context).warningMsg,
          R.of(context).controllerSysError,
          context);
      return null;
    }
    if (response.statusCode == 402) { //token not valid
      Utils.showDialogPanel(
          R.of(context).warningMsg, R.of(context).controllerTokenError,
          context);
      return null;
    }
    else { //internal error, data incomplete
      Utils.showDialogPanel(
          R.of(context).warningMsg,
          R.of(context).controllerSysError,
          context);
      return null;
    }
  }

  /*
  This method is used to get device monthly values of specified type from Monday
   */
  static Future<List<ChartMonthlySampleModel>> getMonthlyValuesFromMonday(
      BuildContext context, String valueType) async {
    String hostname = await SharedPrefs.getMondayHostname();
    String sessionToken = await SharedPrefs.getSessionToken();
    String clientId = await SharedPrefs.getClientId();
    String time = "monthly";
    String apiName = "";
    switch(valueType){
      case "consumption":
        apiName = "read_consumptions";
        break;
      case "temperature":
        apiName = "read_temperatures";
        break;
      case "humidity":
        apiName = "read_humidities";
        break;
    }
    Map data = {
      "clientId": clientId,
      "sessionToken": sessionToken,
      "time": time
    };
    ServerResponse response = await ApiCom.sendRequestToMondayAPI(
        context, data, hostname,
        "chart/"+apiName+".php");
    if (response.statusCode == 200) { //device found
      var samplesMap = jsonDecode(response.body);
      var sampleListModel = ChartMonthlySampleListModel.fromJson(samplesMap);
      return sampleListModel.records;
    }
    if (response.statusCode == 400) { //bad request
      Utils.showDialogPanel(
          R.of(context).warningMsg,
          R.of(context).controllerSysError,
          context);
      return null;
    }
    if (response.statusCode == 402) { //token not valid
      Utils.showDialogPanel(
          R.of(context).warningMsg, R.of(context).controllerTokenError,
          context);
      return null;
    }
    else { //internal error, data incomplete
      Utils.showDialogPanel(
          R.of(context).warningMsg,
          R.of(context).controllerSysError,
          context);
      return null;
    }
  }
}