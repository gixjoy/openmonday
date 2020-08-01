import 'package:flutter/material.dart';
import 'package:monday/common/monday_icons.dart';
import 'package:monday/model/action_model.dart';
import 'package:monday/common/r.dart';

class OnOffPanelSceneAction extends StatefulWidget{

  ActionModel action;
  OnOffPanelSceneAction(this.action);

  @override
  State<StatefulWidget> createState(){
    return new OnOffPanelSceneActionState();
  }
}

class OnOffPanelSceneActionState extends State<OnOffPanelSceneAction> {

  bool onButtonEnabled = false;
  IconData onButton = Monday.toggle_on;
  Color onButtonColor = Colors.grey[400];
  Color onTextColor = Colors.grey[200];

  bool offButtonEnabled = false;
  IconData offButton = Monday.toggle_off;
  Color offButtonColor = Colors.grey[400];
  Color offTextColor = Colors.grey[200];

  @override
  Widget build(BuildContext context) {

    Icon commandButton;
    Text commandText;

    if (widget.action.command == "on") {
      onButtonColor = Colors.blueAccent;
      offButtonColor = Colors.grey[400];
      commandButton = Icon(
        onButton,
        size: 32,
        color: onButtonColor
      );
      commandText = Text(
        R.of(context).onOffPanelOnLabel,
        style: TextStyle(
            color: onTextColor,
            fontSize: 16
        ),
      );
    }
    else {
      onButtonColor = Colors.grey[400];
      offButtonColor = Colors.blueAccent;
      commandButton = Icon(
        offButton,
        size: 32,
        color: offButtonColor
      );
      commandText = Text(R.of(context).onOffPanelOffLabel,
        style: TextStyle(
              color: offTextColor,
              fontSize: 16
        )
      );
    }

    return Container(
      height: 150,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.0),
        border: Border.all(
            width: 2,
            color: Colors.grey[600]
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                //padding: EdgeInsets.only(bottom: 10),
                child: Column(
                  children: [
                    commandButton,
                  ]
                ),
              ),

              Container(
                  width: 30
              ),

              Container(
                child: Column(
                  children: [
                    commandText
                  ]
                ),
              ),
              Container(width:10)
            ],
          ),
        ]
      )
    );
  }
}