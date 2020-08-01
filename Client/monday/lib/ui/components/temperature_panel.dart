import 'package:flutter/material.dart';
import 'package:monday/common/monday_icons.dart';
import 'package:monday/common/utils.dart';
import 'package:monday/common/r.dart';

class TemperaturePanel extends StatefulWidget{

  @override
  State<StatefulWidget> createState(){
    return new TemperaturePanelState();
  }
}

class TemperaturePanelState extends State<TemperaturePanel> {

  bool enabled = false;
  Color widgetColor;
  IconData tempButton = Monday.toggle_off;
  Color minorSignColor = Colors.grey[200];
  Color equalSignColor = Colors.grey[200];
  Color greaterSignColor = Colors.grey[200];
  int temperature = int.parse(Utils.temperatureCondition.value);
  String signSelected = Utils.temperatureCondition.operator;

  @override
  Widget build(BuildContext context){

    if(Utils.temperatureCondition.enabled == '0'){
      enabled = false;
    }
    else
      enabled = true;
    if (enabled) {
      widgetColor = Colors.blueAccent;
      tempButton = Monday.toggle_on;
    }
    else {
      widgetColor = Colors.grey[400];
      tempButton = Monday.toggle_off;
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
                  R.of(context).temperaturePanelLabel,
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
                        tempButton = Monday.toggle_off;
                        signSelected = "";
                        minorSignColor = Colors.grey[200];
                        equalSignColor = Colors.grey[200];
                        greaterSignColor = Colors.grey[200];
                        Utils.resetTemperatureCondition();
                        Utils.climateEditModeEnabled = 1;
                      }
                      else {
                        enabled = true;
                        tempButton = Monday.toggle_on;
                        Utils.temperatureCondition.enabled = '1';
                        Utils.climateEditModeEnabled = 1;
                      }
                    });
                  },
                  icon: Icon(
                    tempButton,
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
            Monday.temperatire,
            size: 32,
            color: Colors.grey[200],
          ),
          Text(
            "°C",
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
                    Utils.temperatureCondition.enabled = '1';
                    Utils.temperatureCondition.operator = '<';
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
                    Utils.temperatureCondition.enabled = '1';
                    Utils.temperatureCondition.operator = '=';
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
                    Utils.temperatureCondition.enabled = '1';
                    Utils.temperatureCondition.operator = '>';
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
                    temperature++;
                    Utils.temperatureCondition.value = temperature.toString();
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
                  temperature.toString(),
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
                    temperature--;
                    Utils.temperatureCondition.value = temperature.toString();
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