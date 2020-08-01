import 'package:flutter/material.dart';
import 'package:monday/common/monday_icons.dart';
import 'package:monday/common/utils.dart';
import 'package:monday/common/r.dart';

class ConsumptionPanel extends StatefulWidget{

  @override
  State<StatefulWidget> createState(){
    return new ConsumptionPanelState();
  }
}

class ConsumptionPanelState extends State<ConsumptionPanel> {

  bool enabled = false;
  Color widgetColor;
  IconData consButton = Monday.toggle_off;
  Color minorSignColor = Colors.grey[200];
  Color equalSignColor = Colors.grey[200];
  Color greaterSignColor = Colors.grey[200];
  String signSelected = Utils.consumptionCondition.operator;

  bool _buttonPressed = false;

  @override
  Widget build(BuildContext context) {

    int consumption = int.parse(Utils.consumptionCondition.value);
    if(Utils.consumptionCondition.enabled == '0'){
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
      child: Row( //Consumption row
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
                        onPressed: () {
                          setState(() {
                            if (enabled) {
                              enabled = false;
                              consButton = Monday.toggle_off;
                              signSelected = "";
                              minorSignColor = Colors.grey[200];
                              equalSignColor = Colors.grey[200];
                              greaterSignColor = Colors.grey[200];
                              Utils.resetConsumptionCondition();
                              Utils.consumptionEditModeEnabled = 1;
                            }
                            else {
                              enabled = true;
                              consButton = Monday.toggle_on;
                              Utils.consumptionCondition.enabled = '1';
                              Utils.consumptionEditModeEnabled = 1;
                            }
                          });
                        },
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
                    onPressed: () {
                      setState(() {
                        signSelected = "<";
                        Utils.consumptionCondition.enabled = '1';
                        Utils.consumptionCondition.operator = '<';
                        Utils.consumptionEditModeEnabled = 1;
                      });
                    },
                    icon: new Icon(
                      Icons.keyboard_arrow_left,
                      size: 32,
                      color: minorSignColor,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        signSelected = "=";
                        Utils.consumptionCondition.enabled = '1';
                        Utils.consumptionCondition.operator = '=';
                        Utils.consumptionEditModeEnabled = 1;
                      });
                    },
                    icon: new Icon(
                      Monday.eq,
                      size: 20,
                      color: equalSignColor,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        signSelected = ">";
                        Utils.consumptionCondition.enabled = '1';
                        Utils.consumptionCondition.operator = '>';
                        Utils.consumptionEditModeEnabled = 1;
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
                children: [
                  Listener(
                    onPointerDown: (details) {
                      _buttonPressed = true;
                      _increaseCounterWhilePressed();
                    },
                    onPointerUp: (details) {
                      _buttonPressed = false;
                    },
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
                    onPointerDown: (details) {
                      _buttonPressed = true;
                      _decreaseCounterWhilePressed();
                    },
                    onPointerUp: (details) {
                      _buttonPressed = false;
                    },
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

  void _decreaseCounterWhilePressed() async {

    while (_buttonPressed) {
      if (int.parse(Utils.consumptionCondition.value) > 0)
        setState(() {
          int consumption = int.parse(Utils.consumptionCondition.value);
          consumption--;
          Utils.consumptionCondition.value = consumption.toString();
          Utils.consumptionEditModeEnabled = 1;
        });

      // wait a bit
      await Future.delayed(Duration(milliseconds: 50));
    }
  }

  void _increaseCounterWhilePressed() async {

    while (_buttonPressed) {
      setState(() {
        int consumption = int.parse(Utils.consumptionCondition.value);
        consumption++;
        Utils.consumptionCondition.value = consumption.toString();
        Utils.consumptionEditModeEnabled = 1;
      });

      // wait a bit
      await Future.delayed(Duration(milliseconds: 50));
    }
  }
}