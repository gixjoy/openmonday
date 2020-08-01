import 'package:flutter/material.dart';
import 'package:monday/common/api_com.dart';
import 'package:monday/common/shared_prefs.dart';
import 'package:monday/common/utils.dart';
import 'package:monday/model/room_model.dart';
import 'dart:convert';
import 'package:monday/common/server_response.dart';
import 'package:monday/model/device_model.dart';
import 'package:monday/common/r.dart';

class RoomController {

  /*
  This method is used for sending room data to Monday room/create.php API
   */
  static Future<bool> sendNewRoomData(BuildContext context, String roomName,
      String roomCategory, String roomButtonImgPath) async{
    String hostname = await SharedPrefs.getMondayHostname();
    String sessionToken = await SharedPrefs.getSessionToken();
    String clientId = await SharedPrefs.getClientId();
    Map data = {
      "clientId":clientId,
      "sessionToken": sessionToken,
      "roomName": roomName,
      "roomCategory": roomCategory,
      "roomButtonImgPath": roomButtonImgPath
    };
    ServerResponse response = await ApiCom.sendRequestToMondayAPI(context, data, hostname,
        "room/create.php");
    if (response.statusCode == 200) {//Room correctly created on Monday DB
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
  This method is used to get rooms data from Monday, for drawing buttons in
  home route
   */
  static Future<List<RoomModel>> getRoomsFromMonday(BuildContext context) async {
    String hostname = await SharedPrefs.getMondayHostname();
    String sessionToken = await SharedPrefs.getSessionToken();
    String clientId = await SharedPrefs.getClientId();
    Map data = {
      "clientId":clientId,
      "sessionToken": sessionToken,
    };
    ServerResponse response = await ApiCom.sendRequestToMondayAPI(context, data, hostname,
        "room/read.php");
    if (response.statusCode == 200) {//rooms found
      var roomsMap = jsonDecode(response.body);
      var roomListModel = RoomListModel.fromJson(roomsMap);
      return roomListModel.records;
    }
    if (response.statusCode == 201){//no room found
      List<RoomModel> records = List(0);
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
  This method is used for getting room devices from Monday
   */
  static Future<List<DeviceModel>> getRoomDevicesFromMonday (BuildContext context,
      String roomId) async {
    String hostname = await SharedPrefs.getMondayHostname();
    String sessionToken = await SharedPrefs.getSessionToken();
    String clientId = await SharedPrefs.getClientId();
    Map data = {
      "clientId":clientId,
      "sessionToken": sessionToken,
      "roomId" : roomId
    };
    ServerResponse response = await ApiCom.sendRequestToMondayAPI(context, data, hostname,
        "room/read_devices.php");
    if (response.statusCode == 200) {//devices found
      var devicesMap = jsonDecode(response.body);
      var deviceListModel = DeviceListModel.fromJson(devicesMap);
      return deviceListModel.records;
    }
    if (response.statusCode == 201){//no devices found
      List<DeviceModel> records = List(0);
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
    Method used to read device room name from Monday
  */
  static Future<String> getDeviceRoomFromMonday(BuildContext context,
      DeviceModel device) async {
    String clientId = await SharedPrefs.getClientId();
    String hostname = await SharedPrefs.getMondayHostname();
    String sessionToken = await SharedPrefs.getSessionToken();
    Map data = {
      "clientId":clientId,
      "sessionToken":sessionToken,
      "roomId":device.roomId
    };
    ServerResponse response = await ApiCom.sendRequestToMondayAPI(context, data, hostname,
        "room/read_one.php");
    if (response.statusCode == 200) {//Response correctly received
      var roomMap = jsonDecode(response.body);
      var roomModel = RoomModel.fromJson(roomMap);
      return roomModel.name;
    }
    if (response.statusCode == 201){//no room found
      return "";
    }
    if (response.statusCode == 400){//bad request ---> Room not associated
      return "";
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
  This method is used for deleting specific room on Monday
   */
  static Future<bool> deleteRoomOnMonday(BuildContext context, String roomId) async{
    String hostname = await SharedPrefs.getMondayHostname();
    String sessionToken = await SharedPrefs.getSessionToken();
    String clientId = await SharedPrefs.getClientId();
    Map data = {
      "clientId":clientId,
      "sessionToken":sessionToken,
      "roomId":roomId,
    };
    ServerResponse response = await ApiCom.sendRequestToMondayAPI(context, data, hostname,
        "room/delete.php");
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
}