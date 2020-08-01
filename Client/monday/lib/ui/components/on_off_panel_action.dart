import 'package:flutter/material.dart';
import 'package:monday/common/monday_icons.dart';
import 'package:monday/model/action_model.dart';
import 'package:monday/common/r.dart';

class OnOffPanelAction extends StatefulWidget{

  ActionModel action;
  OnOffPanelAction(this.action);

  @override
  State<StatefulWidget> createState(){
    return new OnOffPanelActionState();
  }
}

class OnOffPanelActionState extends State<OnOffPanelAction> {

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
    if (widget.action.command == "on") {
      onButtonColor = Colors.blueAccent;
      offButtonColor = Colors.grey[400];
    }
    else {
      onButtonColor = Colors.grey[400];
      offButtonColor = Colors.blueAccent;
    }

    return Container(
      height: 150,
      padding: EdgeInsets.only(top:15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.0),
        border: Border.all(
            width: 2,
            color: Colors.grey[600]
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            //padding: EdgeInsets.only(bottom: 10),
            child: Column(
              children: [
                IconButton(
                  onPressed: () {
                    setState(() {
                      if (onButtonEnabled) {
                        onButtonEnabled = false;
                        onButtonColor = Colors.grey[200];
                        onTextColor = Colors.grey[200];
                      }
                      else {
                        onButtonEnabled = true;
                        onButtonColor = Colors.blueAccent;
                        onTextColor = Colors.blueAccent;
                        offButtonEnabled = false;
                        offButtonColor = Colors.grey[200];
                        offTextColor = Colors.grey[200];

                        Navigator.pop(context);
                      }
                    });
                    widget.action.command = "on";
                  },
                  icon: Icon(
                      onButton,
                      size: 32,
                      color: onButtonColor
                  )
                ),

                Container(
                  height: 15,
                ),

                IconButton(
                  onPressed: () {
                    setState(() {
                      if (offButtonEnabled) {
                        offButtonEnabled = false;
                        offButtonColor = Colors.grey[200];
                        offTextColor = Colors.grey[200];
                      }
                      else {
                        offButtonEnabled = true;
                        offButtonColor = Colors.blueAccent;
                        offTextColor = Colors.blueAccent;
                        onButtonEnabled = false;
                        onButtonColor = Colors.grey[200];
                        onTextColor = Colors.grey[200];

                        Navigator.pop(context);
                      }
                    });
                    widget.action.command = "off";
                  },
                  icon: Icon(
                      offButton,
                      size: 32,
                      color: offButtonColor
                  )
                ),
              ]
            ),
          ),

          Container(
              width: 30
          ),

          Container(
            padding: EdgeInsets.only(top:12),
            child: Column(
              children: [
                Text(
                  R.of(context).onOffPanelOnLabel,
                  style: TextStyle(
                      color: onTextColor,
                      fontSize: 16
                  ),
                ),
                Container(
                  height: 45
                ),
                Text(
                  R.of(context).onOffPanelOffLabel,
                  style: TextStyle(
                      color: offTextColor,
                      fontSize: 16
                  ),
                ),
              ]
            ),
          ),
          Container(
            width: 60
          ),
        ],
      ),
    );
  }
}