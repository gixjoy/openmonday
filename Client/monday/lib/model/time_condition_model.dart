class TimeConditionModel {

  String hour;
  String minute;
  List<String> months;
  List<String> days;
  String periodic;
  String enabled;

  TimeConditionModel(this.hour, this.minute, this.months, this.days,
      this.periodic, this.enabled);

   TimeConditionModel.fromJson(Map<String, dynamic> json) {
     String d = json["days"].toString();
     String m = json["months"].toString();
     hour = json["hour"];
     minute = json["minute"];
     months = removeSpaceFromStringsList(m.substring(1, m.length - 1).split(","));
     days = removeSpaceFromStringsList(d.substring(1, d.length - 1).split(","));
     periodic = json["periodic"];
     enabled = json["enabled"].toString();
   }

   Map<String, dynamic> toJson() => {
    "hour":hour,
    "minute":minute,
    "months":months,
    "days":days,
    "periodic":periodic,
    "enabled":enabled
  };

   /*
   This method is used for cleaning strings got from Monday, when months and days
   arrays have to be converted into array from string. Additional chars are added
   to months and days when they are converted from arrays to strings, so this method
   removes all useless chars.
    */
   List<String> removeSpaceFromStringsList(List<String> array){
     List<String> result = List();
     array.forEach((element) {
       String el = element.replaceAll(" ", "");
       result.add(el);
     });
     return result;
  }
}