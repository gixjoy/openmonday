import 'package:flutter/cupertino.dart';
import 'dart:convert';
import 'package:monday/common/utils.dart';
import 'dart:io';
import 'package:monday/common/server_response.dart';

class ApiCom{

  /*
   * Used for sending HTTPS request to Monday APIs
   */
  static Future<ServerResponse> sendRequestToMondayAPI(BuildContext context, Map data,
      String hostname, String api) async{
    var url = 'https://' + hostname + '/monday/api/' + api;
    HttpClient client = new HttpClient();
    client.badCertificateCallback = ((X509Certificate cert, String host,
        int port) => true);
    HttpClientRequest request = await client.postUrl(Uri.parse(url));
    request.headers.set('content-type', 'application/json');
    request.add(utf8.encode(json.encode(data)));
    //print("Data: "+json.encode(data));
    HttpClientResponse response = await request.close()
      .timeout(const Duration(seconds: 10))
      .catchError((e) {
          Utils.showDialogPanel("Warning!",
          "Server not available", context);
    });
    String reply = await response.transform(utf8.decoder).join();
    ServerResponse servres = ServerResponse(response.statusCode, reply);
    print("Response status: ${response.statusCode}");
    print(DateTime.now().toString() + " --- "+"Response body: ${reply}");
    return servres;
  }
}