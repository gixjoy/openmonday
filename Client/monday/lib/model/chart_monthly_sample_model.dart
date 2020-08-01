import 'dart:convert';
import 'package:monday/model/device_model.dart';

ChartMonthlySampleListModel welcomeFromJson(String str) => ChartMonthlySampleListModel.fromJson(json.decode(str));

String welcomeToJson(ChartMonthlySampleListModel data) => json.encode(data.toJson());

class ChartMonthlySampleModel{

  String day;
  String value;

  ChartMonthlySampleModel({
    this.day,
    this.value
  });

  ChartMonthlySampleModel.fromJson(Map<String, dynamic> json) :
    day = json["day"].toString(),
    value = json["value"]
  ;

  Map<String, dynamic> toJson() => {
    "day": day,
    "value": value
  };
}

class ChartMonthlySampleListModel {
  List<ChartMonthlySampleModel> records;

  ChartMonthlySampleListModel ({
      this.records,
  });

  factory ChartMonthlySampleListModel .fromJson(Map<String, dynamic> json) => ChartMonthlySampleListModel(
      records: List<ChartMonthlySampleModel>.from(json["records"].map((x) => ChartMonthlySampleModel.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
      "records": List<dynamic>.from(records.map((x) => x.toJson())),
  };
}