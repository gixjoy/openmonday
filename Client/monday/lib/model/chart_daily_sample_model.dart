import 'dart:convert';
import 'package:monday/model/device_model.dart';

ChartDailySampleListModel welcomeFromJson(String str) => ChartDailySampleListModel.fromJson(json.decode(str));

String welcomeToJson(ChartDailySampleListModel data) => json.encode(data.toJson());

class ChartDailySampleModel{

  String hour;
  String value;

  ChartDailySampleModel({
    this.hour,
    this.value
  });

  ChartDailySampleModel.fromJson(Map<String, dynamic> json) :
    hour = json["hour"].toString(),
    value = json["value"]
  ;

  Map<String, dynamic> toJson() => {
    "hour": hour,
    "value": value
  };
}

class ChartDailySampleListModel {
  List<ChartDailySampleModel> records;

  ChartDailySampleListModel ({
      this.records,
  });

  factory ChartDailySampleListModel .fromJson(Map<String, dynamic> json) => ChartDailySampleListModel(
      records: List<ChartDailySampleModel>.from(json["records"].map((x) => ChartDailySampleModel.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
      "records": List<dynamic>.from(records.map((x) => x.toJson())),
  };
}