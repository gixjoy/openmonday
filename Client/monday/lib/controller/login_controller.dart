import 'package:flutter/cupertino.dart';
import 'package:monday/common/api_com.dart';
import 'package:monday/common/shared_prefs.dart';
import 'package:monday/common/utils.dart';
import 'package:flutter/material.dart';
import 'package:monday/controller/registration_controller.dart';
import 'package:monday/model/login_model.dart';
import 'dart:convert';
import 'package:monday/common/server_response.dart';
import 'package:monday/common/r.dart';

class LoginController {

  /*
    Method used to send login parameters from shared preferences to login.php API on Monday server.
    It is used when a fingerprint is used instead of username and password
     */
  static Future<bool> sendLoginPreferences(BuildContext context) async {
    String username = await SharedPrefs.getUserName();
    String clientId = await SharedPrefs.getClientId();
    String password = await SharedPrefs.getUserPassword();
    String hostname = await SharedPrefs.getMondayHostname();
    bool registrationDone = await SharedPrefs.getRegistrationDone();
    String firebaseToken = await SharedPrefs.getFirebaseToken();
    //print("Password saved: "+password);
    Map data = {
      "username":username,
      "password": password,
      "clientId": clientId,
      "firebaseToken": firebaseToken
    };
    ServerResponse response = await ApiCom.sendRequestToMondayAPI(context, data,
        hostname, "user/login.php");
    if (response.statusCode == 200) {//User exists and enabled
      saveSessionToken(response.body);
      if (!registrationDone){//in case user logins from another device performing login without registration
        await SharedPrefs.setRegistrationDone(true);
      }
      return true;
    }
    if (response.statusCode == 401) { //User exists but not enabled)--->Deprecated, users now don't need to be enabled by an admin, since registration can only happen from the same LAN where Monday is
      Utils.showDialogPanel(
          R.of(context).warningMsg, R.of(context).controllerUserNotEnabledError, context);
      return false;
    }
    if (response.statusCode == 403) {
      Utils.showDialogPanel(
          R.of(context).warningMsg, R.of(context).controllerWrongCredError, context);
      return false;
    }
    else
      return false;
  }

  /*
  Method used to save session toekn onto shared preferences after successfully login
   */
  static void saveSessionToken(String response) async {
     if (response != null) {
       Map loginMap = jsonDecode(response);
       var login = LoginModel.fromJson(loginMap);
       SharedPrefs.setSessionToken(login.sessionToken);
     }
     else
       SharedPrefs.setSessionToken(null);
   }

  /*
    Method used to send login parameters got from form fields to login.php API on Monday server
     */
  static Future<bool> sendLoginData(BuildContext context, String username,
      String password) async {
    String cypherPwd = RegistrationController.cypherString(password);
    String hostname = await SharedPrefs.getMondayHostname();
    bool registrationDone = await SharedPrefs.getRegistrationDone();
    String clientId = await SharedPrefs.getClientId();
    String firebaseToken = await SharedPrefs.getFirebaseToken();
    //print("Password saved: "+password);
    Map data = {
      "username":username,
      "password": cypherPwd,
      "clientId": clientId,
      "firebaseToken": firebaseToken
    };
    ServerResponse response = await ApiCom.sendRequestToMondayAPI(context, data,
        hostname, "user/login.php");
    if (response.statusCode == 200) {//User exists and enabled
      saveSessionToken(response.body);
      if (!registrationDone){//in case user logins from another device performing login without registration
        await SharedPrefs.setRegistrationDone(true);
        await SharedPrefs.setUserPassword(cypherPwd);
        await SharedPrefs.setUsername(username);
        print(username);
      }
      else {
        await SharedPrefs.setUsername(username);
        await SharedPrefs.setUserPassword(cypherPwd);
      }
      return true;
    }
    if (response.statusCode == 201) { //User exists but not enabled)
      Utils.showDialogPanel(
          R.of(context).warningMsg, R.of(context).controllerUserNotEnabledError, context);
      return false;
    }
    if (response.statusCode == 400) { //Data is incomplete, login fields missing
      Utils.showDialogPanel(
          R.of(context).warningMsg, R.of(context).controllerAllFieldsNeeded, context);
      return false;
    }
    if (response.statusCode == 403) {
      Utils.showDialogPanel(
          R.of(context).warningMsg, R.of(context).controllerWrongCredError, context);
      return false;
    }
    else
      return false;
  }
}