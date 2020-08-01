import 'package:flutter/material.dart';
import 'package:monday/common/monday_icons.dart';
import 'package:monday/model/consumption_condition_model.dart';
import 'package:monday/common/r.dart';

/*
This Widget is only used for showing settings on ConsumptionPanel, for
ConsumptionConditions got from Monday. This panel is the same as ConsumptionPanel
but the only difference is that buttons can not be pushed.
 */

class ShowConsumptionPanel extends StatefulWidget{

  ConsumptionConditionModel consumptionCondition;
  ShowConsumptionPanel(this.consumptionCondition);

  @override
  State<StatefulWidget> createState(){
    return new ShowConsumptionPanelState();
  }
}

class ShowConsumptionPanelState extends State<ShowConsumptionPanel> {

  bool enabled = false;
  Color widgetColor;
  IconData consButton = Monday.toggle_off;
  Color minorSignColor = Colors.grey[200];
  Color equalSignColor = Colors.grey[200];
  Color greaterSignColor = Colors.grey[200];

  @override
  Widget build(BuildContext context) {
    int consumption = int.parse(widget.consumptionCondition.value);
    String signSelected = widget.consumptionCondition.operator;
    if(widget.consumptionCondition.enabled == '0'){
      enabled = false;
    }
    else
      enabled = true;
    if (enabled) {
      widgetColor = Colors.blueAccent;
      consButton = Monday.toggle_on;
    }
    else {
      widgetColor = Colors.grey[400];
      consButton = Monday.toggle_off;
    }
    switch (signSelected) {
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
    }
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.0),
        border: Border.all(
            width: 2,
            color: Colors.grey[600]
        ),
      ),
      child: Row( //Temperature row
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.only(bottom: 15),
              child: Column(
                  children: [
                    Text(
                        R.of(context).consumptionPanelLabel,
                        style: TextStyle(
                            fontSize: 14,
                            color: widgetColor
                        )
                    ),
                    IconButton(
                        icon: Icon(
                            consButton,
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
              Monday.flash_on,
              size: 32,
              color: Colors.grey[200],
            ),
            Text(
              "W/h",
              style: TextStyle(
                  color: Colors.grey[200],
                  fontSize: 20
              ),
            ),
            Container(
                width: 10
            ),

            Column(
                children: [
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
                children: [
                  Listener(
                    child: new Icon(
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
                        consumption.toString(),
                        style: TextStyle(
                            fontSize: 20,
                            color: widgetColor
                        )
                    ),
                  ),
                  Container(
                      height: 10
                  ),
                  Listener(
                    child: new Icon(
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