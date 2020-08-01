import 'package:flutter/material.dart';
import 'package:monday/common/monday_icons.dart';
import 'package:monday/model/temperature_condition_model.dart';
import 'package:monday/common/r.dart';

/*
This Widget is only used for showing settings on TemperaturePanel, for
TemperatureConditions got from Monday. This panel is the same as TemperaturePanel
but the only difference is that buttons can not be pushed.
 */
class ShowTemperaturePanel extends StatefulWidget{

  TemperatureConditionModel temperatureCondition;
  ShowTemperaturePanel(this.temperatureCondition);

  @override
  State<StatefulWidget> createState(){
    return new ShowTemperaturePanelState();
  }
}

class ShowTemperaturePanelState extends State<ShowTemperaturePanel> {

  bool enabled = false;
  Color widgetColor;
  IconData tempButton = Monday.toggle_off;
  Color minorSignColor = Colors.grey[200];
  Color equalSignColor = Colors.grey[200];
  Color greaterSignColor = Colors.grey[200];

  @override
  Widget build(BuildContext context){
    int temperature = int.parse(widget.temperatureCondition.value);
    String signSelected = widget.temperatureCondition.operator;
    if(widget.temperatureCondition.enabled == '0'){
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
                icon: new Icon(
                  Icons.keyboard_arrow_left,
                  size: 32,
                  color: minorSignColor,
                ),
              ),
              IconButton(
                icon: new Icon(
                  Monday.eq,
                  size: 20,
                  color: equalSignColor,
                ),
              ),
              IconButton(
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