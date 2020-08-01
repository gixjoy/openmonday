class ConsumptionConditionModel {

  String value;
  String operator;
  String enabled;

  ConsumptionConditionModel(this.value, this.operator, this.enabled);

  ConsumptionConditionModel.fromJson(Map<String, dynamic> json) :
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