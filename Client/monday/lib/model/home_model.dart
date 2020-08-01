class HomeModel {

  final String temperature;
  final String humidity;
  final String consumptions;
  final String lastUpdate;
  final String batteryLevel;
  final String lastMeasureDate;

  HomeModel(this.temperature, this.humidity, this.consumptions, this.lastUpdate,
      this.batteryLevel, this.lastMeasureDate);

  HomeModel.fromJson(Map<String, dynamic> json)
    : temperature = json['temperature'],
      humidity = json['humidity'],
      consumptions = json['consumptions'],
      lastUpdate = json['lastUpdate'],
      batteryLevel = json['battery'],
      lastMeasureDate = json['lastMeasureDate'];

  Map<String, dynamic> toJson() => {
    'temperature' : temperature,
    'humidity' : humidity,
    'consumptions' : consumptions,
    'lastUpdate' : lastUpdate,
    'battery' : batteryLevel,
    'lastMeasureDate' : lastMeasureDate
  };
}