import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:monday/model/action_model.dart';
import 'package:monday/common/monday_icons.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:monday/ui/components/on_off_panel_action.dart';

class ActionButton extends StatefulWidget{

  final ActionModel action;
  ActionButton(this.action);

  @override
  ActionButtonState createState() => ActionButtonState();

}

class ActionButtonState extends State<ActionButton> {

  @override
  Widget build(BuildContext context) {
    Icon iconType;
    switch (widget.action.deviceType) {
      case "light":
        iconType =
        new Icon(Monday.lightbulb, color: Colors.grey[200], size: 32,);
        break;
      case "outlet":
        iconType = new Icon(Monday.power, color: Colors.grey[200], size: 32,);
        break;
      case "climate":
        iconType = new Icon(Monday.fire, color: Colors.grey[200], size: 32,);
        break;
      case "shutter":
        iconType = new Icon(Monday.menu, color: Colors.grey[200], size: 32,);
        break;
      case "climate_sensor":
        iconType =
        new Icon(Monday.temperatire, color: Colors.grey[200], size: 32,);
        break;
      case "alarm sensor":
        iconType = new Icon(Monday.shield, color: Colors.grey[200], size: 32,);
        break;
      case "clock":
        iconType = new Icon(Monday.clock, color: Colors.grey[200], size: 32,);
        break;
    }
    return new Container(
      width: 335,
      child: GestureDetector(
        onTap: () {
          if (widget.action.deviceType == "clock") {
            DatePicker.showTimePicker(
              context,
              theme: DatePickerTheme(
                backgroundColor: Colors.grey[600],
                containerHeight: 220.0,
                itemStyle: TextStyle(
                  color: Colors.grey[200],
                ),
              ),
              showTitleActions: true,
              showSecondsColumn: true,
              onConfirm: (time) {
                int seconds = (time.hour * 3600) + (time.minute * 60) +
                    time.second;
                widget.action.command = seconds.toString();
                //Navigator.pop(context);//go back to previous route
              },
              currentTime: DateTime(
                  0, 0, 0, 0, 0, int.parse(widget.action.command)),
              locale: LocaleType.it,
            );
          }
          else
            _showModalOnOffAction(context, widget.action);
        },
        child: Card(
            color: Colors.grey[200].withOpacity(0.2),
            child: ListTile(
              leading: iconType,
              title: Row(
                children: [
                  Text(
                    widget.action.deviceName,
                    style: TextStyle(
                        color: Colors.grey[200]
                    ),
                  ),
                ],
              ),
              trailing: IconButton(
                icon: Icon(
                  Icons.delete,
                  size: 24,
                  color: Colors.grey[200],
                ),
              ),
            )
        ),
      ),
    );
  }

  void _showModalOnOffAction(BuildContext context, ActionModel action) {
    showModalBottomSheet<void>(
        backgroundColor: Colors.transparent.withOpacity(0.8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        context: context,
        builder: (BuildContext context) {
          return Container(
            margin: const EdgeInsets.only(top: 5, left: 15, right: 15),
            height: 200,
            child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  OnOffPanelAction(action),

                  Container(
                      height: 10
                  ),
                ]
            ),
          );
        }
    );
  }
}



