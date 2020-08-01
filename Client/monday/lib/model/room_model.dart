import 'dart:convert';

RoomListModel welcomeFromJson(String str) => RoomListModel.fromJson(json.decode(str));

String welcomeToJson(RoomListModel data) => json.encode(data.toJson());

class RoomModel {
    String id;
    String name;
    String category;
    String imgPath;

    RoomModel({
        this.id,
        this.name,
        this.category,
        this.imgPath,
    });

    factory RoomModel.fromJson(Map<String, dynamic> json) => RoomModel(
        id: json["id"],
        name: json["name"],
        category: json["category"],
        imgPath: json["imgPath"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "category": category,
        "imgPath": imgPath,
    };
}

class RoomListModel {
    List<RoomModel> records;

    RoomListModel ({
        this.records,
    });

    factory RoomListModel .fromJson(Map<String, dynamic> json) => RoomListModel(
        records: List<RoomModel>.from(json["records"].map((x) => RoomModel.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "records": List<dynamic>.from(records.map((x) => x.toJson())),
    };
}