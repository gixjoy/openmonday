import 'dart:convert';
import 'package:monday/model/device_model.dart';

LightListModel welcomeFromJson(String str) => LightListModel.fromJson(json.decode(str));

String welcomeToJson(LightListModel data) => json.encode(data.toJson());

class LightModel extends DeviceModel {

  String message;
  String switchStatus;

  LightModel({
    this.message,
    this.switchStatus,
  });

  LightModel.fromJson(Map<String, dynamic> json) :
    message = json["message"],
    switchStatus = json["switchStatus"].toString(),
    super.fromJson(json)
  ;

  Map<String, dynamic> toJson() => {
    "message": message,
    "switchStatus": switchStatus
  };
}

class LightListModel {
    List<LightModel> records;

    LightListModel ({
        this.records,
    });

    factory LightListModel .fromJson(Map<String, dynamic> json) => LightListModel(
        records: List<LightModel>.from(json["records"].map((x) => LightModel.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "records": List<dynamic>.from(records.map((x) => x.toJson())),
    };
}