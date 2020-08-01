import 'package:flutter/cupertino.dart';
import 'package:monday/common/shared_prefs.dart';
import 'package:monday/common/utils.dart';
import 'package:flutter/material.dart';
import 'package:monday/ui/login.dart';
import 'package:monday/common/api_com.dart';
import 'package:crypt/crypt.dart';
import 'package:monday/common/server_response.dart';
import 'package:monday/common/r.dart';

class RegistrationController {

  /*
  This method returns true if there are empty fields in the Registration route.
  False otherwise.
   */
  static bool checkEmptyFields (String username,
      String password, String repeatPassword) {
    if (username == "" || password == "" || repeatPassword == "") {
      print("Empty fields detected");
      return true;
    }
    else
      return false;
  }

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
  This method is used to save registration infos in shared preferences
   */
  static Future<void> savePreferences(String hostname,
      String username, String password, String clientId,
      String firebaseToken ) async {
    SharedPrefs.setMondayHostname(hostname);
    SharedPrefs.setUsername(username);
    SharedPrefs.setUserPassword(password);
    SharedPrefs.setRegistrationDone(true);
    SharedPrefs.setFirebaseToken(firebaseToken);
    SharedPrefs.setClientId(clientId);
    print ("Shared preferences set");
    //print ("URL: " + await SharedPrefs.getMondayHostname());
    //print ("username: " + await SharedPrefs.getUserusername());
    //print("PASSWORD: " + await SharedPrefs.getUserPassword());
  }

  /*
  Method used for creating a user on Monday DB by create API
   */
  static void saveRegistrationData(BuildContext context, String username,
      String password) {
    String pwd = cypherString(password);
    sendRegistrationRequest(context, username, pwd);
  }

  /*
  Method used for cyphering user password before to send it to Monday server
   */
  static String cypherString(String pwd){
    var cypher = new Crypt.sha256(pwd, salt: "abcdefghijklmnop");
    return cypher.toString();
  }

  /*
  Method used to save Monday hostname on SharedPreferences
   */
  static Future<bool> saveMondayHostname(BuildContext context, String hostname) async{
    if(await checkMondayAddressIsCorrect(context, hostname)) {
      SharedPrefs.setMondayHostname(hostname);
      return true;
    }
    else {
      return false;
    }
  }

  /*
  Method used to check if Monday responds on given address
   */
  static Future<bool> checkMondayAddressIsCorrect(BuildContext context, String hostname) async {
    Map data = {
      "command" : "ping"
    };
    ServerResponse response = await ApiCom.sendRequestToMondayAPI(context, data,
        hostname, "registration/ping.php")
        .timeout(const Duration(seconds: 2))
        .catchError((e) {
          Utils.showDialogPanel(R.of(context).warningMsg,
          "Monday non è raggiungibile all'indirizzo indicato", context);
          return false;
    });
    if (response.statusCode == 200) {
      return true;
    }
    else
      return false;
  }

  /*
  Method used to send user parameters to create.php API on Monday server
   */
  static void sendRegistrationRequest(BuildContext context,
      String username, String pwd) async {
    String hostname = await SharedPrefs.getMondayHostname();
    String clientId = await SharedPrefs.getClientId();
    String firebaseToken = await SharedPrefs.getFirebaseToken();
    Map data = {
      "username" : username,
      "password" : pwd,
      "clientId" : clientId,
      "firebaseToken" : firebaseToken
    };
    ServerResponse response = await ApiCom.sendRequestToMondayAPI(context, data,
        hostname, "user/create.php")
        .timeout(const Duration(seconds: 2))
        .catchError((e) {
          Utils.showDialogPanel(R.of(context).warningMsg,
          R.of(context).controllerMondayNotAvailableError, context);
    });
    if (response.statusCode == 200) {
      savePreferences(hostname, username, pwd, clientId, firebaseToken);
      Navigator.push(context, MaterialPageRoute(builder: (context) => Login(false)));
    }
    if (response.statusCode == 503){
      Utils.showDialogPanel(R.of(context).warningMsg, R.of(context).controllerUsernameAlreadyInUseError, context);
    }
    if (response.statusCode == 405){
      Utils.showDialogPanel(R.of(context).warningMsg, R.of(context).controllerSameLANError, context);
    }
  }

  /*
  This method is used to check if all the fields in Registration route have been
  correctly filled.
  It returns true if all fields a filled.
  False otherwise.
   */
  static bool checkRegistrationForm(BuildContext context, String username,
      String password, String rpPassword) {
    if (checkEmptyFields(username, password, rpPassword)) {
      Utils.showDialogPanel(R.of(context).warningMsg,
         R.of(context).controllerAllFieldsNeeded, context);
      return false;
    }
    if (!RegistrationController.checkPasswords(password, rpPassword)){
      Utils.showDialogPanel(R.of(context).warningMsg, R.of(context).controllerSamePasswordError, context);
      return false;
    }
    else {
      //print ("Registration form correctly filled");
      return true;
    }
  }
}