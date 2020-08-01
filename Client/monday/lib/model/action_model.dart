import 'dart:convert';

ActionListModel welcomeFromJson(String str) => ActionListModel.fromJson(json.decode(str));

String welcomeToJson(ActionListModel data) => json.encode(data.toJson());

class ActionModel {

  String id;
  String deviceId;
  String deviceName;
  String deviceType;
  String command;//can be "on", "off", "up", "down" or the number of seconds to wait for

  ActionModel(this.id, this.deviceId, this.deviceName, this.deviceType, this.command);

  ActionModel.fromJson(Map<String, dynamic> json) :
    id = json["actionId"],
    deviceId = json["deviceId"],
    deviceName = json["deviceName"],
    deviceType = json["deviceType"],
    command = json["command"]
  ;

  Map<String, dynamic> toJson() => {
    "actionId":id,
    "deviceId":deviceId,
    "deviceName":deviceName,
    "deviceType":deviceType,
    "command":command
  };

  void setAction(String action){
    this.command = action;
  }
}

class ActionListModel {
    List<ActionModel> records;

    ActionListModel ({
        this.records,
    });

    factory ActionListModel .fromJson(Map<String, dynamic> json) => ActionListModel(
        records: List<ActionModel>.from(json["records"].map((x) => ActionModel.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "records": List<dynamic>.from(records.map((x) => x.toJson())),
    };
}