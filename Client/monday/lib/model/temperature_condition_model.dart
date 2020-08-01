class TemperatureConditionModel {

  String value;
  String operator;
  String enabled;

  TemperatureConditionModel(this.value, this.operator, this.enabled);

  TemperatureConditionModel.fromJson(Map<String, dynamic> json) :
    value = json["value"],
    operator = json["operator"],
    enabled = json["enabled"].toString()
  ;

  Map<String, dynamic> toJson() => {
    "value":value,
    "operator":operator,
    "enabled":enabled
  };
}