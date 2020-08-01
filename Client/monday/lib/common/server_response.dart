/*
Class used for understanding response coming from Monday server in each controller
 */

class ServerResponse{

  int statusCode;
  String body;
  ServerResponse(this.statusCode, this.body);
}