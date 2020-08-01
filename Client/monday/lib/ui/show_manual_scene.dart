import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:monday/controller/scene_controller.dart';
import 'package:monday/ui/basic_route_structure.dart';
import 'package:monday/common/utils.dart';
import 'package:monday/common/monday_icons.dart';
import 'package:monday/ui/components/custom_progress_indicator.dart';
import 'package:monday/model/action_model.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:monday/ui/components/on_off_panel_scene_action.dart';
import 'package:monday/ui/edit_manual_scene.dart';
import 'package:monday/ui/scene.dart';
import 'package:monday/common/r.dart';

class ShowManualScene extends StatefulWidget{

  String sceneName;
  String sceneId;
  ShowManualScene(this.sceneName, this.sceneId);

  @override
  State<StatefulWidget> createState(){
    return new ShowManualSceneState();
  }
}

class ShowManualSceneState extends State<ShowManualScene> {

  Widget drawer;

  @override
  Widget build(BuildContext context) {

    Widget appBar = new AppBar(
      title: new Text(widget.sceneName),
      backgroundColor: Colors.transparent,
      elevation: 0.0,
      actions: <Widget>[
        Row(
          children: [
            IconButton(
              icon: Icon(
                Icons.edit,
                size: 32,
                color: Colors.grey[200],
              ),
              onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) =>
                  EditManualScene(widget.sceneName, widget.sceneId))).then((value) {
                  Utils.actions = List();
                });
              },
            ),
            Container(width: 10),
            IconButton(
              icon: Icon(
                Icons.delete,
                size: 32,
                color: Colors.grey[200],
              ),
              onPressed: (){
                _asyncConfirmDialog(context, widget.sceneId);
              },
            ),
            Container(width:10)
          ]
        ),
      ]
    );

    Widget actionTextSection = Utils.buildTextRow(
        R.of(context).showSceneActionText,
        Utils.helloTextSize, Utils.mainTextColor, 20, 20);

    //Actions section
    Future<List<ActionModel>> actions = SceneController.getSceneActionsFromMonday(context, widget.sceneId);

    Widget actionsList = FutureBuilder(
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<ActionModel> devices = snapshot.data;
          if (devices.isNotEmpty) {
            return new ListView(
                children: buildList(snapshot.data, context),
            );
          }
          else {
            return new Center(
                child: Text(
                    R.of(context).showSceneNoDevConfigured,
                    style: TextStyle(
                      color: Colors.grey[200],
                      fontSize: 18,
                    )
                )
            );
          }
        } else if (snapshot.hasError) {
          return Text("${snapshot.error}", style: Theme
              .of(context)
              .textTheme
              .headline);
        } else {
          return new CustomProgressIndicator();
        }
      },
      future: actions,
    );

    Widget body = new GestureDetector(
      onTap: (){
        FocusScope.of(context).unfocus();
      },
      child: ListView(
        children: [
          Container(
            height: 70,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  height: 60,
                  child: actionTextSection,
                ),
              ]
            )
          ),
          Container(height:10),
          Container(
            height: 500,
            child: actionsList
          ),
          Container(
            height: 10
          ),
        ]
      ),
    );

    return new BasicRouteStructure(appBar, body, drawer);
  }

  /*
  Method for building the items of the list of devices
   */
  Widget buildListItem(ActionModel action, BuildContext context) {
    var leadingWidget;
    IconData devIcon;
    switch (action.deviceType) {
      case "light":
        devIcon = Monday.lightbulb;
        leadingWidget = Icon(
            devIcon,
            color: Colors.grey[200],
        );
        break;
      case "outlet":
        devIcon = Monday.power;
        leadingWidget = Icon(
            devIcon,
            color: Colors.grey[200]
        );
        break;
      case "climate":
        devIcon = Monday.fire;
        leadingWidget = Icon(
            devIcon,
            color: Colors.grey[200]
        );
        break;
      case "shutter":
        devIcon = Monday.menu_1;
        leadingWidget = Icon(
            devIcon,
            color: Colors.grey[200]
        );
        break;
      case "climate_sensor":
        devIcon = Monday.temperatire;
        leadingWidget = Icon(
            devIcon,
            color: Colors.grey[200]
        );
        break;
      case "alarm_sensor":
        devIcon = Monday.shield;
        leadingWidget = Icon(
            devIcon,
            color: Colors.grey[200]
        );
        break;
    }
    return new GestureDetector(
      onTap: (){
        _showModalOnOffAction(action);
      },
      child: Card(
        color: Colors.grey[200].withOpacity(0.2),
        child: ListTile(
          leading: leadingWidget,
          title: Row(
            children: [
              Text(
                action.deviceName,
                style: TextStyle(
                    color: Colors.grey[200]
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTimeItem(ActionModel action) {
    return new GestureDetector(
      onTap: () {
        DatePicker.showTimePicker(
          context,
          theme: DatePickerTheme(
            backgroundColor: Colors.grey[600],
            containerHeight: 220.0,
            itemStyle: TextStyle(
              color: Colors.grey[200],
            ),
          ),
          showTitleActions: false,
          showSecondsColumn: true,
          onConfirm: (time) {

          },
          currentTime: Utils.convertSecondsToHMS(action.command),
          locale: LocaleType.it,
        );
      },
      child: Card(
        color: Colors.grey[200].withOpacity(0.2),
        child: ListTile(
          leading: Icon(
            Monday.clock,
            color: Colors.grey[200]
          ),
          title: Row(
            children: [
              Text(
                action.deviceName,
                style: TextStyle(
                    color: Colors.grey[200]
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /*
  Method for building the list of the devices
   */
  List<Widget> buildList(List<ActionModel> actions, BuildContext context) {
    List<Widget> actionList = new List();
    actions.forEach((item) {
      if (item.deviceType == "clock"){
        Widget timeItem = buildTimeItem(item);
        actionList.add(timeItem);
      }
      else {
        Widget newItem = buildListItem(item, context);
        actionList.add(newItem);
      }
    });
    return actionList;
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
              OnOffPanelSceneAction(action),

              Container(
                height: 10
              ),
            ]
          ),
        );
      }
    );
  }

  /*
  Method used for showing confirmation dialog when a scene is about to be
  deleted from the system
   */
  Future<ConfirmAction> _asyncConfirmDialog(BuildContext context,
      String sceneId) async {
    return showDialog<ConfirmAction>(
      context: context,
      barrierDismissible: false, // user must tap button for close dialog!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(R.of(context).warningMsg),
          content: Text(
              R.of(context).showSceneDeleteConfirmation),
          actions: <Widget>[
            FlatButton(
              child: Text(R.of(context).no),
              onPressed: () {
                Navigator.of(context).pop(ConfirmAction.CANCEL);
              },
            ),
            FlatButton(
              child: Text(R.of(context).yes),
              onPressed: () async {
                if(await SceneController.deleteManualSceneOnMonday(context, sceneId)) {
                  Navigator.of(context).pop(ConfirmAction.ACCEPT);
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Scene())
                  );
                }
              }
            ),
          ],
        );
      },
    );
  }
}

enum ConfirmAction { CANCEL, ACCEPT }

