import 'dart:convert';
import 'package:monday/model/device_model.dart';

ShutterListModel welcomeFromJson(String str) => ShutterListModel.fromJson(json.decode(str));

String welcomeToJson(ShutterListModel data) => json.encode(data.toJson());

class ShutterModel extends DeviceModel {

  String message;
  String openingLevel;

  ShutterModel({
    this.message,
    this.openingLevel,
  });

  ShutterModel.fromJson(Map<String, dynamic> json) :
    message = json["message"],
    openingLevel = json["openingLevel"].toString(),
    super.fromJson(json)
  ;

  Map<String, dynamic> toJson() => {
    "message": message,
    "openingLevel": openingLevel
  };
}

class ShutterListModel {
    List<ShutterModel> records;

    ShutterListModel ({
        this.records,
    });

    factory ShutterListModel .fromJson(Map<String, dynamic> json) => ShutterListModel(
        records: List<ShutterModel>.from(json["records"].map((x) => ShutterModel.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "records": List<dynamic>.from(records.map((x) => x.toJson())),
    };
}