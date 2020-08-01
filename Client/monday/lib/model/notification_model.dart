import 'dart:convert';

NotificationListModel welcomeFromJson(String str) => NotificationListModel.fromJson(json.decode(str));

String welcomeToJson(NotificationListModel data) => json.encode(data.toJson());

class NotificationModel{

  String id;
  String message;
  String date;

  NotificationModel({
    this.id,
    this.message,
    this.date,
  });

  NotificationModel.fromJson(Map<String, dynamic> json) :
    id = json["id"],
    message = json["message"],
    date = json["date"]
  ;

  Map<String, dynamic> toJson() => {
    "id": id,
    "message": message,
    "date": date
  };

  /*
  Used for truncating messages with length bigger than 22 characters
   */
  String getTruncatedMessage(){
    int truncateAt = 22;
    String ellipsis = "...";
    String truncated = this.message;
    if (this.message.length > truncateAt){
      truncated = this.message.substring(0, truncateAt-ellipsis.length)+ellipsis;
    }
    return truncated;
  }
}

class NotificationListModel {
    List<NotificationModel> records;

    NotificationListModel ({
        this.records,
    });

    factory NotificationListModel .fromJson(Map<String, dynamic> json) => NotificationListModel(
        records: List<NotificationModel>.from(json["records"].map((x) => NotificationModel.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "records": List<dynamic>.from(records.map((x) => x.toJson())),
    };
}