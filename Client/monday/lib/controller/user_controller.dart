import 'package:flutter/cupertino.dart';
import 'package:monday/common/shared_prefs.dart';
import 'package:monday/common/utils.dart';
import 'package:flutter/material.dart';
import 'package:monday/common/api_com.dart';
import 'package:crypt/crypt.dart';
import 'package:monday/common/server_response.dart';
import 'package:monday/common/r.dart';

class UserController {

  /*
  This method is for checking if password and repeatPassword fields are the same
  in Registration route.
   */
  static bool checkPasswords (String password, String rpPassword) {
    if (password == rpPassword)
      return true;
    else
      return false;
  }

  /*
  This method is used to save user infos in shared preferences
   */
  static Future<void> savePreferences(String password) async {
    SharedPrefs.setUserPassword(password);
    print ("Shared preferences updated");
    //print ("URL: " + await SharedPrefs.getMondayHostname());
    //print ("username: " + await SharedPrefs.getUserusername());
    //print("PASSWORD: " + await SharedPrefs.getUserPassword());
  }

  /*
  Method used for updating a user on Monday DB by update API
   */
  static void saveUserData(BuildContext context, String password) {
    String pwd = cypherString(password);
    sendUserUpdateRequest(context, pwd);
  }

  /*
  Method used for cyphering user password before to send it to Monday server
   */
  static String cypherString(String pwd){
    var cypher = new Crypt.sha256(pwd, salt: "abcdefghijklmnop");
    return cypher.toString();
  }

  /*
  Method used to send user parameters to update.php API on Monday server
   */
  static void sendUserUpdateRequest(BuildContext context, String pwd) async {
    String username = await SharedPrefs.getClientId();
    String hostname = await SharedPrefs.getMondayHostname();
    String sessionToken = await SharedPrefs.getSessionToken();
    Map data = {
      "username" : username,
      "password" : pwd,
      "sessionToken" : sessionToken
    };
    ServerResponse response = await ApiCom.sendRequestToMondayAPI(context, data,
        hostname, "user/update.php");
    if (response.statusCode == 200) {
      savePreferences(pwd);
      Navigator.pop(context);
    }
    if (response.statusCode == 503){
      Utils.showDialogPanel(R.of(context).warningMsg, R.of(context).controllerUsernameAlreadyInUseError, context);
    }
  }

  /*
  This method is used to check if all the fields in Registration route have been
  correctly filled.
  It returns true if all fields a filled.
  False otherwise.
   */
  static bool checkPasswordFields(BuildContext context, String password,
      String rpPassword) {
    if (!UserController.checkPasswords(password, rpPassword)){
      Utils.showDialogPanel(R.of(context).warningMsg, R.of(context).controllerSamePasswordError, context);
      return false;
    }
    else {
      //print ("User update form correctly filled");
      return true;
    }
  }
}