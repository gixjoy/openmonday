import 'package:flutter/material.dart';
import 'package:monday/common/monday_icons.dart';
import 'package:monday/common/utils.dart';
import 'package:monday/common/r.dart';

class HumidityPanel extends StatefulWidget{

  @override
  State<StatefulWidget> createState(){
    return new HumidityPanelState();
  }
}

class HumidityPanelState extends State<HumidityPanel> {

  bool enabled = false;
  Color widgetColor;
  IconData humButton = Monday.toggle_off;
  Color minorSignColor = Colors.grey[200];
  Color equalSignColor = Colors.grey[200];
  Color greaterSignColor = Colors.grey[200];
  int humidity = int.parse(Utils.humidityCondition.value);
  String signSelected = Utils.humidityCondition.operator;

  @override
  Widget build(BuildContext context){

    if(Utils.humidityCondition.enabled == '0'){
      enabled = false;
    }
    else
      enabled = true;
    if (enabled) {
      widgetColor = Colors.blueAccent;
      humButton = Monday.toggle_on;
    }
    else {
      widgetColor = Colors.grey[400];
      humButton = Monday.toggle_off;
    }
    switch(signSelected){
      case "<":
        minorSignColor = Colors.blueAccent;
        equalSignColor = Colors.grey[200];
        greaterSignColor = Colors.grey[200];
        break;
      case ">":
        minorSignColor = Colors.grey[200];
        equalSignColor = Colors.grey[200];
        greaterSignColor = Colors.blueAccent;
        break;
      case "=":
        minorSignColor = Colors.grey[200];
        equalSignColor = Colors.blueAccent;
        greaterSignColor = Colors.grey[200];
        break;
      case ""://default case when no operator has been selected
        minorSignColor = Colors.grey[200];
        equalSignColor = Colors.grey[200];
        greaterSignColor = Colors.grey[200];
    }
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.0),
        border: Border.all(
          width: 2,
          color: Colors.grey[600]
        ),
      ),
      child: Row(//Temperature row
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.only(bottom: 15),
            child: Column(
              children: [
                Text(
                  R.of(context).humidityPanelLabel,
                  style: TextStyle(
                    fontSize: 14,
                    color: widgetColor
                  )
                ),
                IconButton(
                  onPressed: (){
                    setState(() {
                      if (enabled) {
                        enabled = false;
                        humButton = Monday.toggle_off;
                        signSelected = "";
                        minorSignColor = Colors.grey[200];
                        equalSignColor = Colors.grey[200];
                        greaterSignColor = Colors.grey[200];
                        Utils.resetHumidityCondition();
                        Utils.climateEditModeEnabled = 1;
                      }
                      else {
                        enabled = true;
                        humButton = Monday.toggle_on;
                        Utils.humidityCondition.enabled = '1';
                        Utils.climateEditModeEnabled = 1;
                      }
                    });
                  },
                  icon: Icon(
                    humButton,
                    size: 32,
                    color: widgetColor
                  )
                ),
              ]
            ),
          ),
          Container(
            width: 20
          ),

          Icon(
            Monday.droplet,
            size: 32,
            color: Colors.grey[200],
          ),
          Text(
            "%",
            style: TextStyle(
              color: Colors.grey[200],
              fontSize: 20
            ),
          ),
          Container(
            width: 10
          ),

          Column(
            children:[
              IconButton(
                onPressed: (){
                  setState(() {
                    signSelected = "<";
                    Utils.humidityCondition.enabled = '1';
                    Utils.humidityCondition.operator = '<';
                    Utils.climateEditModeEnabled = 1;
                  });
                },
                icon: new Icon(
                  Icons.keyboard_arrow_left,
                  size: 32,
                  color: minorSignColor,
                ),
              ),
              IconButton(
                onPressed: (){
                  setState(() {
                    signSelected = "=";
                    Utils.humidityCondition.enabled = '1';
                    Utils.humidityCondition.operator = '=';
                    Utils.climateEditModeEnabled = 1;
                  });
                },
                icon: new Icon(
                  Monday.eq,
                  size: 20,
                  color: equalSignColor,
                ),
              ),
              IconButton(
                onPressed: (){
                  setState(() {
                    signSelected = ">";
                    Utils.humidityCondition.enabled = '1';
                    Utils.humidityCondition.operator = '>';
                    Utils.climateEditModeEnabled = 1;
                  });
                },
                icon: new Icon(
                  Icons.keyboard_arrow_right,
                  size: 32,
                  color: greaterSignColor,
                ),
              ),
            ]
          ),
          Container(
            width: 15
          ),

          Column(
            children:[
              IconButton(
                onPressed: (){
                  setState(() {
                    humidity++;
                    Utils.humidityCondition.value = humidity.toString();
                    Utils.climateEditModeEnabled = 1;
                  });
                },
                icon: new Icon(
                  Icons.add_circle_outline,
                  size: 30,
                  color: Colors.grey[200],
                ),
              ),
              Container(
                height: 10
              ),
              Container(
                child: Text(
                  humidity.toString(),
                  style: TextStyle(
                    fontSize: 20,
                    color: widgetColor
                  )
                ),
              ),
              Container(
                height: 10
              ),
              IconButton(
                onPressed: (){
                  setState(() {
                    humidity--;
                    Utils.humidityCondition.value = humidity.toString();
                    Utils.climateEditModeEnabled = 1;
                  });
                },
                icon: new Icon(
                  Icons.remove_circle_outline,
                  size: 30,
                  color: Colors.grey[200],
                ),
              ),
            ]
          )
        ]
      ),
    );
  }
}