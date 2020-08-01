import 'dart:convert';

DeviceListModel welcomeFromJson(String str) => DeviceListModel.fromJson(json.decode(str));

String welcomeToJson(DeviceListModel data) => json.encode(data.toJson());

class DeviceModel {
  String id;
  String name;
  String description;
  String type;/*
            * 1 = light
            * 2 = outlet
            * 3 = climate
            * 4 = shutter
            * 5 = climate_sensor
            * 6 = alarm sensor
            */
  String roomId;
  String status;
  String enabled;
  String ip;

  DeviceModel({this.id, this.name,  this.description, this.type, this.roomId,
      this.status, this.enabled, this.ip});

  DeviceModel.fromJson(Map<String, dynamic> json) :
    id = json["id"],
    name = json["name"],
    description = json["description"],
    type = json["type"],
    roomId = json["roomId"],
    status = json["status"],
    enabled = json["enabled"],
    ip = json["ip"]
  ;

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "description": description,
    "type": type,
    "roomId": roomId,
    "status":status,
    "enabled":enabled,
    "ip":ip
  };
}

class DeviceListModel {
    List<DeviceModel> records;

    DeviceListModel ({
        this.records,
    });

    factory DeviceListModel .fromJson(Map<String, dynamic> json) => DeviceListModel(
        records: List<DeviceModel>.from(json["records"].map((x) => DeviceModel.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "records": List<dynamic>.from(records.map((x) => x.toJson())),
    };
}