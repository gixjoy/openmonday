import 'package:flutter/material.dart';
import 'package:monday/common/api_com.dart';
import 'package:monday/common/shared_prefs.dart';
import 'package:monday/common/utils.dart';
import 'dart:convert';
import 'package:monday/common/server_response.dart';
import 'package:monday/model/action_model.dart';
import 'package:monday/model/consumption_condition_model.dart';
import 'package:monday/model/humidity_condition_model.dart';
import 'package:monday/model/scene_model.dart';
import 'package:monday/model/temperature_condition_model.dart';
import 'package:monday/model/time_condition_model.dart';
import 'package:monday/common/r.dart';

class SceneController {

  /*
  This method is used for creating new manual scene on Monday
   */
  static Future<bool> createManualScene(BuildContext context, String sceneName,
      List<ActionModel> actions) async{
    String hostname = await SharedPrefs.getMondayHostname();
    String sessionToken = await SharedPrefs.getSessionToken();
    String clientId = await SharedPrefs.getClientId();
    ActionListModel actionList = ActionListModel(records: actions);
    Map data = {
      "clientId":clientId,
      "sessionToken":sessionToken,
      "sceneName":sceneName,
      "actions":actionList
    };
    ServerResponse response = await ApiCom.sendRequestToMondayAPI(context, data, hostname,
        "scene/create_manual.php");
    if (response.statusCode == 200) {
      return true;
    }
    if (response.statusCode == 503) { //Service unavailable)
      Utils.showDialogPanel(
          R.of(context).warningMsg, R.of(context).controllerMondayNotAvailableError, context);
      return false;
    }
    if (response.statusCode == 400) {
      Utils.showDialogPanel(
          R.of(context).warningMsg, R.of(context).controllerAllFieldsNeeded, context);
      return false;
    }
    else
      return false;
  }

  /*
  This method is used for creating new manual scene on Monday
   */
  static Future<bool> createAutomatedScene(BuildContext context, String sceneName,
      TimeConditionModel timeCond,
      TemperatureConditionModel tempCond,
      HumidityConditionModel humCond,
      ConsumptionConditionModel consCond,
      List<ActionModel> actions) async{
    String hostname = await SharedPrefs.getMondayHostname();
    String sessionToken = await SharedPrefs.getSessionToken();
    String clientId = await SharedPrefs.getClientId();
    ActionListModel actionList = ActionListModel(records: actions);
    Map data = {
      "clientId":clientId,
      "sessionToken":sessionToken,
      "sceneName":sceneName,
      "timeCondition":timeCond,
      "temperatureCondition":tempCond,
      "humidityCondition":humCond,
      "consumptionCondition":consCond,
      "actions":actionList
    };
    ServerResponse response = await ApiCom.sendRequestToMondayAPI(context, data, hostname,
        "scene/create_automated.php");
    if (response.statusCode == 200) {
      return true;
    }
    if (response.statusCode == 503) { //Service unavailable)
      Utils.showDialogPanel(
          R.of(context).warningMsg, R.of(context).controllerMondayNotAvailableError, context);
      return false;
    }
    if (response.statusCode == 400) {
      Utils.showDialogPanel(
          R.of(context).warningMsg, R.of(context).controllerAllFieldsNeeded, context);
      return false;
    }
    else
      return false;
  }

  /*
  This method is used for reading manual scenes list from Monday
   */
  static Future<List<SceneModel>> readManualScene(BuildContext context) async{
    String hostname = await SharedPrefs.getMondayHostname();
    String sessionToken = await SharedPrefs.getSessionToken();
    String clientId = await SharedPrefs.getClientId();
    Map data = {
      "clientId":clientId,
      "sessionToken":sessionToken
    };
    ServerResponse response = await ApiCom.sendRequestToMondayAPI(context, data, hostname,
        "scene/read_manual.php");
    if (response.statusCode == 200) {
      var sceneModelMap = jsonDecode(response.body);
      var sceneListModel = SceneListModel.fromJson(sceneModelMap);
      return sceneListModel.records;
    }
    if (response.statusCode == 503) { //Service unavailable)
      Utils.showDialogPanel(
          R.of(context).warningMsg, R.of(context).controllerMondayNotAvailableError, context);
      return null;
    }
    if (response.statusCode == 400) {
      Utils.showDialogPanel(
          R.of(context).warningMsg, R.of(context).controllerAllFieldsNeeded, context);
      return null;
    }
    else
      return null;
  }

  /*
  This method is used for reading automated scenes list from Monday
   */
  static Future<List<SceneModel>> readAutomatedScene(BuildContext context) async{
    String hostname = await SharedPrefs.getMondayHostname();
    String sessionToken = await SharedPrefs.getSessionToken();
    String clientId = await SharedPrefs.getClientId();
    Map data = {
      "clientId":clientId,
      "sessionToken":sessionToken
    };
    ServerResponse response = await ApiCom.sendRequestToMondayAPI(context, data, hostname,
        "scene/read_automated.php");
    if (response.statusCode == 200) {
      var sceneModelMap = jsonDecode(response.body);
      var sceneListModel = SceneListModel.fromJson(sceneModelMap);
      return sceneListModel.records;
    }
    if (response.statusCode == 503) { //Service unavailable)
      Utils.showDialogPanel(
          R.of(context).warningMsg, R.of(context).controllerMondayNotAvailableError, context);
      return null;
    }
    if (response.statusCode == 400) {
      Utils.showDialogPanel(
          R.of(context).warningMsg, R.of(context).controllerAllFieldsNeeded, context);
      return null;
    }
    else
      return null;
  }

  /*
  This method is used for reading TimeCondition of scene with given ID on Monday
   */
  static Future<TimeConditionModel> readSceneTimeCondition(BuildContext context,
      String sceneId) async{
    String hostname = await SharedPrefs.getMondayHostname();
    String sessionToken = await SharedPrefs.getSessionToken();
    String clientId = await SharedPrefs.getClientId();
    Map data = {
      "clientId":clientId,
      "sessionToken":sessionToken,
      "sceneId":sceneId
    };
    ServerResponse response = await ApiCom.sendRequestToMondayAPI(context, data, hostname,
        "scene/read_time_condition.php");
    if (response.statusCode == 200) {
      var timeConditionModelMap = jsonDecode(response.body);
      var timeConditionModel = TimeConditionModel.fromJson(timeConditionModelMap);
      return timeConditionModel;
    }
    if (response.statusCode == 503) { //Service unavailable)
      Utils.showDialogPanel(
          R.of(context).warningMsg, R.of(context).controllerMondayNotAvailableError, context);
      return null;
    }
    if (response.statusCode == 400) {
      Utils.showDialogPanel(
          R.of(context).warningMsg, R.of(context).controllerAllFieldsNeeded, context);
      return null;
    }
    else
      return null;
  }

  /*
  This method is used for reading TemperatureCondition of scene with given ID on Monday
   */
  static Future<TemperatureConditionModel> readSceneTemperatureCondition(BuildContext context,
      String sceneId) async{
    String hostname = await SharedPrefs.getMondayHostname();
    String sessionToken = await SharedPrefs.getSessionToken();
    String clientId = await SharedPrefs.getClientId();
    Map data = {
      "clientId":clientId,
      "sessionToken":sessionToken,
      "sceneId":sceneId
    };
    ServerResponse response = await ApiCom.sendRequestToMondayAPI(context, data, hostname,
        "scene/read_temperature_condition.php");
    if (response.statusCode == 200) {
      var tempConditionModelMap = jsonDecode(response.body);
      var tempConditionModel = TemperatureConditionModel.fromJson(tempConditionModelMap);
      return tempConditionModel;
    }
    if (response.statusCode == 503) { //Service unavailable)
      Utils.showDialogPanel(
          R.of(context).warningMsg, R.of(context).controllerMondayNotAvailableError, context);
      return null;
    }
    if (response.statusCode == 400) {
      Utils.showDialogPanel(
          R.of(context).warningMsg, R.of(context).controllerAllFieldsNeeded, context);
      return null;
    }
    else
      return null;
  }

  /*
  This method is used for reading HumidityCondition of scene with given ID on Monday
   */
  static Future<HumidityConditionModel> readSceneHumidityCondition(BuildContext context,
      String sceneId) async{
    String hostname = await SharedPrefs.getMondayHostname();
    String sessionToken = await SharedPrefs.getSessionToken();
    String clientId = await SharedPrefs.getClientId();
    Map data = {
      "clientId":clientId,
      "sessionToken":sessionToken,
      "sceneId":sceneId
    };
    ServerResponse response = await ApiCom.sendRequestToMondayAPI(context, data, hostname,
        "scene/read_humidity_condition.php");
    if (response.statusCode == 200) {
      var humConditionModelMap = jsonDecode(response.body);
      var humConditionModel = HumidityConditionModel.fromJson(humConditionModelMap);
      return humConditionModel;
    }
    if (response.statusCode == 503) { //Service unavailable)
      Utils.showDialogPanel(
          R.of(context).warningMsg, R.of(context).controllerMondayNotAvailableError, context);
      return null;
    }
    if (response.statusCode == 400) {
      Utils.showDialogPanel(
          R.of(context).warningMsg, R.of(context).controllerAllFieldsNeeded, context);
      return null;
    }
    else
      return null;
  }

  /*
  This method is used for reading ConsumptionCondition of scene with given ID on Monday
   */
  static Future<ConsumptionConditionModel> readSceneConsumptionCondition(BuildContext context,
      String sceneId) async{
    String hostname = await SharedPrefs.getMondayHostname();
    String sessionToken = await SharedPrefs.getSessionToken();
    String clientId = await SharedPrefs.getClientId();
    Map data = {
      "clientId":clientId,
      "sessionToken":sessionToken,
      "sceneId":sceneId
    };
    ServerResponse response = await ApiCom.sendRequestToMondayAPI(context, data, hostname,
        "scene/read_consumption_condition.php");
    if (response.statusCode == 200) {
      var consConditionModelMap = jsonDecode(response.body);
      var consConditionModel = ConsumptionConditionModel.fromJson(consConditionModelMap);
      return consConditionModel;
    }
    if (response.statusCode == 503) { //Service unavailable)
      Utils.showDialogPanel(
          R.of(context).warningMsg, R.of(context).controllerMondayNotAvailableError, context);
      return null;
    }
    if (response.statusCode == 400) {
      Utils.showDialogPanel(
          R.of(context).warningMsg, R.of(context).controllerAllFieldsNeeded, context);
      return null;
    }
    else
      return null;
  }

  /*
  This method is used for reading scene actions from Monday
   */
  static Future<List<ActionModel>> getSceneActionsFromMonday(BuildContext context, String sceneId) async{
    String hostname = await SharedPrefs.getMondayHostname();
    String sessionToken = await SharedPrefs.getSessionToken();
    String clientId = await SharedPrefs.getClientId();
    Map data = {
      "clientId":clientId,
      "sessionToken":sessionToken,
      "sceneId":sceneId
    };
    ServerResponse response = await ApiCom.sendRequestToMondayAPI(context, data, hostname,
        "scene/read_manual_actions.php");
    if (response.statusCode == 200) {
      var actionModelMap = jsonDecode(response.body);
      var actionListModel = ActionListModel.fromJson(actionModelMap);
      return actionListModel.records;
    }
    if (response.statusCode == 503) { //Service unavailable)
      Utils.showDialogPanel(
          R.of(context).warningMsg, R.of(context).controllerMondayNotAvailableError, context);
      return null;
    }
    if (response.statusCode == 400) {
      Utils.showDialogPanel(
          R.of(context).warningMsg, R.of(context).controllerAllFieldsNeeded, context);
      return null;
    }
    else
      return null;
  }

  /*
  This method is used for updating manual scene on Monday
   */
  static Future<bool> updateManualSceneOnMonday(BuildContext context, String sceneName,
      String sceneId, List<ActionModel> actions) async{
    String hostname = await SharedPrefs.getMondayHostname();
    String sessionToken = await SharedPrefs.getSessionToken();
    String clientId = await SharedPrefs.getClientId();
    ActionListModel actionList = ActionListModel(records: actions);
    Map data = {
      "clientId":clientId,
      "sessionToken":sessionToken,
      "sceneName":sceneName,
      "sceneId":sceneId,
      "actions":actionList
    };
    ServerResponse response = await ApiCom.sendRequestToMondayAPI(context, data, hostname,
        "scene/update_manual.php");
    if (response.statusCode == 200) {
      return true;
    }
    if (response.statusCode == 503) { //Service unavailable)
      Utils.showDialogPanel(
          R.of(context).warningMsg, R.of(context).controllerMondayNotAvailableError, context);
      return false;
    }
    if (response.statusCode == 400) {
      Utils.showDialogPanel(
          R.of(context).warningMsg, R.of(context).controllerAllFieldsNeeded, context);
      return false;
    }
    else
      return false;
  }

  /*
  This method is used for updating automated scene on Monday
   */
  static Future<bool> updateAutomatedSceneOnMonday(BuildContext context, String sceneName,
      String sceneId, List<ActionModel> actions,
      TimeConditionModel timeCondition,
      TemperatureConditionModel temperatureCondition,
      HumidityConditionModel humidityCondition,
      ConsumptionConditionModel consumptionCondition) async{
    String hostname = await SharedPrefs.getMondayHostname();
    String sessionToken = await SharedPrefs.getSessionToken();
    String clientId = await SharedPrefs.getClientId();
    ActionListModel actionList = ActionListModel(records: actions);
    Map data = {
      "clientId":clientId,
      "sessionToken":sessionToken,
      "sceneName":sceneName,
      "sceneId":sceneId,
      "timeCondition":timeCondition,
      "temperatureCondition":temperatureCondition,
      "humidityCondition":humidityCondition,
      "consumptionCondition":consumptionCondition,
      "actions":actionList,

    };
    ServerResponse response = await ApiCom.sendRequestToMondayAPI(context, data, hostname,
        "scene/update_automated.php");
    if (response.statusCode == 200) {
      return true;
    }
    if (response.statusCode == 503) { //Service unavailable)
      Utils.showDialogPanel(
          R.of(context).warningMsg, R.of(context).controllerMondayNotAvailableError, context);
      return false;
    }
    if (response.statusCode == 400) {
      Utils.showDialogPanel(
          R.of(context).warningMsg, R.of(context).controllerAllFieldsNeeded, context);
      return false;
    }
    else
      return false;
  }

  /*
  This method is used for deleting specific manual scene on Monday
   */
  static Future<bool> deleteManualSceneOnMonday(BuildContext context, String sceneId) async{
    String hostname = await SharedPrefs.getMondayHostname();
    String sessionToken = await SharedPrefs.getSessionToken();
    String clientId = await SharedPrefs.getClientId();
    Map data = {
      "clientId":clientId,
      "sessionToken":sessionToken,
      "sceneId":sceneId,
    };
    ServerResponse response = await ApiCom.sendRequestToMondayAPI(context, data, hostname,
        "scene/delete_manual.php");
    if (response.statusCode == 200) {
      return true;
    }
    if (response.statusCode == 503) { //Service unavailable)
      Utils.showDialogPanel(
          R.of(context).warningMsg, R.of(context).controllerMondayNotAvailableError, context);
      return false;
    }
    if (response.statusCode == 400) {
      Utils.showDialogPanel(
          R.of(context).warningMsg, R.of(context).controllerAllFieldsNeeded, context);
      return false;
    }
    else
      return false;
  }

  /*
  This method is used for deleting specific automated scene on Monday
   */
  static Future<bool> deleteAutomatedSceneOnMonday(BuildContext context, String sceneId) async{
    String hostname = await SharedPrefs.getMondayHostname();
    String sessionToken = await SharedPrefs.getSessionToken();
    String clientId = await SharedPrefs.getClientId();
    Map data = {
      "clientId":clientId,
      "sessionToken":sessionToken,
      "sceneId":sceneId,
    };
    ServerResponse response = await ApiCom.sendRequestToMondayAPI(context, data, hostname,
        "scene/delete_automated.php");
    if (response.statusCode == 200) {
      return true;
    }
    if (response.statusCode == 503) { //Service unavailable)
      Utils.showDialogPanel(
          R.of(context).warningMsg, R.of(context).controllerMondayNotAvailableError, context);
      return false;
    }
    if (response.statusCode == 400) {
      Utils.showDialogPanel(
          R.of(context).warningMsg, R.of(context).controllerAllFieldsNeeded, context);
      return false;
    }
    else
      return false;
  }

  /*
  This method is used for switching scene status on Monday
   */
  static Future<String> switchSceneStatusOnMonday(BuildContext context, String sceneId) async{
    String hostname = await SharedPrefs.getMondayHostname();
    String sessionToken = await SharedPrefs.getSessionToken();
    String clientId = await SharedPrefs.getClientId();
    Map data = {
      "clientId":clientId,
      "sessionToken":sessionToken,
      "sceneId":sceneId,
    };
    ServerResponse response = await ApiCom.sendRequestToMondayAPI(context, data, hostname,
        "scene/switch_scene_status.php");
    if (response.statusCode == 200) {
      var sceneModelMap = jsonDecode(response.body);
      var sceneModel = SceneModel.fromJson(sceneModelMap);
      return sceneModel.enabled;
    }
    if (response.statusCode == 503) { //Service unavailable)
      Utils.showDialogPanel(
          R.of(context).warningMsg, R.of(context).controllerMondayNotAvailableError, context);
      return null;
    }
    if (response.statusCode == 400) {
      Utils.showDialogPanel(
          R.of(context).warningMsg, R.of(context).controllerAllFieldsNeeded, context);
      return null;
    }
    else
      return null;
  }
}