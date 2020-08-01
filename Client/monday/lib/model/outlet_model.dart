import 'dart:convert';
import 'package:monday/model/device_model.dart';

OutletListModel welcomeFromJson(String str) => OutletListModel.fromJson(json.decode(str));

String welcomeToJson(OutletListModel data) => json.encode(data.toJson());

class OutletModel extends DeviceModel {

  String message;
  String switchStatus;

  OutletModel({
    this.message,
    this.switchStatus,
  });

  OutletModel.fromJson(Map<String, dynamic> json) :
    message = json["message"],
    switchStatus = json["switchStatus"].toString(),
    super.fromJson(json)
  ;

  Map<String, dynamic> toJson() => {
    "message": message,
    "switchStatus": switchStatus
  };
}

class OutletListModel {
    List<OutletModel> records;

    OutletListModel ({
        this.records,
    });

    factory OutletListModel .fromJson(Map<String, dynamic> json) => OutletListModel(
        records: List<OutletModel>.from(json["records"].map((x) => OutletModel.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "records": List<dynamic>.from(records.map((x) => x.toJson())),
    };
}