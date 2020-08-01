import 'dart:convert';
import 'package:monday/model/device_model.dart';

class ChartActualSampleModel{

  String value;

  ChartActualSampleModel({
    this.value
  });

  ChartActualSampleModel.fromJson(Map<String, dynamic> json) :
    value = json["value"]
  ;

  Map<String, dynamic> toJson() => {
    "value": value
  };
}