import 'dart:convert';

SceneListModel welcomeFromJson(String str) => SceneListModel.fromJson(json.decode(str));

String welcomeToJson(SceneListModel data) => json.encode(data.toJson());

class SceneModel {

  String id;
  String name;
  String type;
  String enabled;

  SceneModel(this.id, this.name, this.type, this.enabled);

  SceneModel.fromJson(Map<String, dynamic> json) :
    id = json["id"],
    name = json["name"],
    type = json["type"],
    enabled = json["enabled"].toString()
  ;

  Map<String, dynamic> toJson() => {
    "id":id,
    "name":name,
    "type":type,
    "enabled":enabled
  };
}

class SceneListModel {
    List<SceneModel> records;

    SceneListModel ({
        this.records,
    });

    factory SceneListModel .fromJson(Map<String, dynamic> json) => SceneListModel(
        records: List<SceneModel>.from(json["records"].map((x) => SceneModel.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "records": List<dynamic>.from(records.map((x) => x.toJson())),
    };
}