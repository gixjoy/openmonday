import 'package:flutter/material.dart';
import 'package:drag_list/drag_list.dart';
import 'package:monday/ui/components/action_button.dart';
import 'package:monday/model/action_model.dart';
import 'package:monday/ui/components/on_off_panel_action.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:monday/common/utils.dart';
import 'package:monday/ui/components/shutter_panel_action.dart';

class CustomDragList extends StatefulWidget{

  List<ActionModel> actions;
  CustomDragList(this.actions);

  @override
  CustomDragListState createState() => new CustomDragListState();
}

class CustomDragListState extends State<CustomDragList>{

  @override
  Widget build(BuildContext context){

    List<ActionButton> actionButtons = new List();
    int i = 0;
    widget.actions.forEach((item){
      ActionButton button = new ActionButton(item);
      actionButtons.add(button);
      i++;
    });

    return new DragList<ActionButton>(
      items: actionButtons,
      itemExtent: 60,
      handleBuilder: (context) {
        return Container(
          height: 36,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(
                Icons.keyboard_arrow_up,
                size: 18,
                color: Colors.grey[200]
              ),
              Icon(
                Icons.keyboard_arrow_down,
                size: 18,
                color: Colors.grey[200]
              )
            ]
          )
        );
      },
      itemBuilder: (context, item, handle) {
        return Padding(
          padding: EdgeInsets.all(3.0),
          child: Container(
            height: 60,
            //color: Colors.grey[800],
            decoration: BoxDecoration(
              color: Colors.grey[800],
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(width:30),
                handle,
                Spacer(),
                Text(
                  item.value.action.deviceName,
                  style: TextStyle(color: Colors.grey[200], fontSize: 16),
                ),
                Spacer(),
                IconButton(
                  onPressed: (){
                    if (item.value.action.deviceType != "clock" &&
                        item.value.action.deviceType != "shutter")
                      _showModalOnOffAction(item.value.action);
                    if(item.value.action.deviceType == "shutter")
                      _showModalShutterAction(item.value.action);
                    else {
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
                          int seconds = (time.hour*3600)+(time.minute*60)+time.second;
                          print(seconds);
                          item.value.action.command = seconds.toString();
                          setState(() {

                          });
                        },
                        currentTime: Utils.convertSecondsToHMS(item.value.action.command),
                        locale: LocaleType.it,
                      );
                    }
                  },
                  icon: Icon (Icons.arrow_drop_down, color: Colors.grey[200]),
                  iconSize: 32,
                ),
                Container(width: 10),
                IconButton(
                  onPressed: (){
                    widget.actions.remove(item.value.action);
                    setState(() {

                    });
                  },
                  icon: Icon (Icons.delete, color: Colors.grey[200]),
                  iconSize: 32,
                ),
                Container(width:10),
              ]
            ),
          ),
        );
      },
      onItemReorder: (from, to) {
        if (from < to) {
          ActionModel actionFrom = widget.actions[from];
          for (int i = from; i < to; i++) {
            widget.actions[i] = widget.actions[i + 1];
          }
          widget.actions[to] = actionFrom;
        }
        else {
          ActionModel actionFrom = widget.actions[from];
          for (int i = from; i > to; i--) {
            widget.actions[i] = widget.actions[i - 1];
          }
          widget.actions[to] = actionFrom;
        }
        setState(() {

        });
      },
    );
  }

  void _showModalOnOffAction(ActionModel action) {
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

  void _showModalShutterAction(ActionModel action) {
    showModalBottomSheet<void>(
      backgroundColor: Colors.transparent.withOpacity(0.8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      context: context,
      builder: (BuildContext context) {
        return Container(
          margin: const EdgeInsets.only(top: 5, left: 15, right: 15),
          height: 310,
          child: ShutterPanelAction(action)
        );
      }
    );
  }
}