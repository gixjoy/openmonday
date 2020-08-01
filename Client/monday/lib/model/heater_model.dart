class HeaterModel {

  final String message;
  final String id;
  final String sw;
  final String setTemperature;
  final String enabled;

  HeaterModel(this.message, this.id, this.sw, this.setTemperature, this.enabled);

  HeaterModel.fromJson(Map<String, dynamic> json)
    : message = json['message'],
      id = json['id'],
      sw = json['switch'].toString(),
      setTemperature = json['setTemperature'],
      enabled = json['enabled'].toString();

  Map<String, dynamic> toJson() => {
    'message' : message,
    'id' : id,
    'switch' : sw,
    'setTemperature' : setTemperature,
    'enabled' : enabled
  };
}