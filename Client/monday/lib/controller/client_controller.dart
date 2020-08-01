import 'package:flutter/cupertino.dart';
import 'package:monday/common/api_com.dart';
import 'package:monday/common/shared_prefs.dart';
import 'package:monday/common/utils.dart';
import 'package:flutter/material.dart';
import 'package:monday/common/server_response.dart';
import 'package:monday/common/r.dart';

class ClientController {
  /*
    Method used for logout from mobile app
   */
  static Future<bool> logout(BuildContext context) async {
    String hostname = await SharedPrefs.getMondayHostname();
    String clientId = await SharedPrefs.getClientId();
    Map data = {
      "clientId": clientId
    };
    ServerResponse response = await ApiCom.sendRequestToMondayAPI(context, data,
        hostname, "user/logout.php");
    if (response.statusCode == 200) { //User exists and enabled
      return true;
    }
    if (response.statusCode == 400 ||
        response.statusCode == 501) { //Data is incomplete or database error
      Utils.showDialogPanel(
          R.of(context).warningMsg, R.of(context).controllerLogoutError, context);
      return false;
    }
    else
      return false;
  }
}