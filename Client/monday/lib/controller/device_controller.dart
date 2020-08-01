import 'package:flutter/material.dart';
import 'package:monday/common/api_com.dart';
import 'package:monday/common/shared_prefs.dart';
import 'package:monday/common/utils.dart';
import 'package:monday/model/device_model.dart';
import 'package:monday/ui/login.dart';
import 'dart:convert';
import 'package:monday/common/server_response.dart';
import 'package:monday/common/r.dart';

class DeviceController {
  /*
    Method used to update device on Monday after first configuration
  */
  static Future<bool> updateDeviceOnMonday(BuildContext context,
      DeviceModel device) async {
    String clientId = await SharedPrefs.getClientId();
    String hostname = await SharedPrefs.getMondayHostname();
    String sessionToken = await SharedPrefs.getSessionToken();
    String id = device.id;
    String name = device.name;
    String type = device.type;
    String roomId = device.roomId;
    Map data = {
      "clientId":clientId,
      "sessionToken":sessionToken,
      "id":id,
      "name":name,
      "type":type,
      "roomId":roomId,
    };
    ServerResponse response = await ApiCom.sendRequestToMondayAPI(context, data, hostname,
        "device/update.php");
    if (response.statusCode == 200) {//Response correctly received
      if (type == "climate") { //check if climate controller and sensor have been configured
        SharedPrefs.setClimateControllerEnabled(true);
      }
      if (type == "climate_sensor") {
        SharedPrefs.setClimateSensorEnabled(true);
      }
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
    Method used to read all new devices from Monday
  */
  static Future<List<DeviceModel>> getNewDevicesFromMonday(BuildContext context) async {
    String clientId = await SharedPrefs.getClientId();
    String hostname = await SharedPrefs.getMondayHostname();
    String sessionToken = await SharedPrefs.getSessionToken();
    Map data = {
      "clientId":clientId,
      "sessionToken":sessionToken,
    };
    ServerResponse response = await ApiCom.sendRequestToMondayAPI(context, data, hostname,
        "discovery/discovery.php");
    if (response.statusCode == 200) {//Response correctly received
      var devicesMap = jsonDecode(response.body);
      var deviceListModel = DeviceListModel.fromJson(devicesMap);
      return deviceListModel.records;
    }
    if (response.statusCode == 201){//no room found
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
    Method used to read all devices from Monday
  */
  static Future<List<DeviceModel>> getAllDevicesFromMonday(BuildContext context) async {
    String clientId = await SharedPrefs.getClientId();
    String hostname = await SharedPrefs.getMondayHostname();
    String sessionToken = await SharedPrefs.getSessionToken();
    Map data = {
      "clientId":clientId,
      "sessionToken":sessionToken,
    };
    ServerResponse response = await ApiCom.sendRequestToMondayAPI(context, data, hostname,
        "device/read.php");
    if (response.statusCode == 200) {//Response correctly received
      var devicesMap = jsonDecode(response.body);
      var deviceListModel = DeviceListModel.fromJson(devicesMap);
      return deviceListModel.records;
    }
    if (response.statusCode == 201){//no room found
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
  This method is used to get device status from Monday
   */
  static Future<String> getDeviceStatusFromMonday(BuildContext context,
      String deviceId) async {
    String hostname = await SharedPrefs.getMondayHostname();
    String sessionToken = await SharedPrefs.getSessionToken();
    String clientId = await SharedPrefs.getClientId();
    Map data = {
      "clientId":clientId,
      "sessionToken": sessionToken,
      "deviceId" : deviceId
    };
    ServerResponse response = await ApiCom.sendRequestToMondayAPI(context, data, hostname,
        "device/read_device_status.php");
    if (response.statusCode == 200) {//device found
      var deviceMap = jsonDecode(response.body);
      var deviceModel = DeviceModel.fromJson(deviceMap);
      return deviceModel.status;
    }
    if (response.statusCode == 201){//no device found
      return "";
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
    Method used to delete device on Monday
  */
  static Future<bool> deleteDeviceFromMonday(BuildContext context,
      DeviceModel device) async {
    String clientId = await SharedPrefs.getClientId();
    String hostname = await SharedPrefs.getMondayHostname();
    String sessionToken = await SharedPrefs.getSessionToken();
    String id = device.id;
    String type = device.type;
    Map data = {
      "clientId":clientId,
      "sessionToken":sessionToken,
      "id":id,
    };
    ServerResponse response = await ApiCom.sendRequestToMondayAPI(context, data, hostname,
        "device/delete.php");
    if (response.statusCode == 200) {//Response correctly received
      if (type == "climate")//check if climate controller and sensor have been configured
        SharedPrefs.setClimateControllerEnabled(false);
      if (type == "climate_sensor")
        SharedPrefs.setClimateSensorEnabled(false);
      return true;
    }
    if (response.statusCode == 402) {//session token expired, require new login
      Navigator.push(context, MaterialPageRoute(builder: (context) => Login(false)));
      return null;
    }
    if (response.statusCode == 501) {//error on database side because device belongs to scenes actions
      return false;
    }
    else {//internal error, data incomplete
      Utils.showDialogPanel(
          R.of(context).warningMsg, R.of(context).controllerSysError, context);
      return null;
    }
  }

  /*
    Method used to remove a device from a room on Monday
  */
  static Future<bool> removeDeviceFromRoomOnMonday(BuildContext context,
      DeviceModel device) async {
    String clientId = await SharedPrefs.getClientId();
    String hostname = await SharedPrefs.getMondayHostname();
    String sessionToken = await SharedPrefs.getSessionToken();
    String id = device.id;
    Map data = {
      "clientId":clientId,
      "sessionToken":sessionToken,
      "id":id,
    };
    ServerResponse response = await ApiCom.sendRequestToMondayAPI(context, data, hostname,
        "device/remove_from_room.php");
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