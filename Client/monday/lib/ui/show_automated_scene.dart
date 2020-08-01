import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:monday/controller/scene_controller.dart';
import 'package:monday/model/time_condition_model.dart';
import 'package:monday/ui/basic_route_structure.dart';
import 'package:monday/common/utils.dart';
import 'package:monday/common/monday_icons.dart';
import 'package:monday/ui/components/custom_progress_indicator.dart';
import 'package:monday/model/action_model.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:monday/ui/components/on_off_panel_scene_action.dart';
import 'package:monday/ui/edit_automated_scene.dart';
import 'package:monday/ui/scene.dart';
import 'package:monday/ui/show_scene_time_condition.dart';
import 'package:monday/ui/components/show_consumption_panel.dart';
import 'package:monday/ui/components/show_temperature_panel.dart';
import 'package:monday/ui/components/show_humidity_panel.dart';
import 'package:monday/model/temperature_condition_model.dart';
import 'package:monday/model/humidity_condition_model.dart';
import 'package:monday/model/consumption_condition_model.dart';
import 'package:monday/ui/components/shutter_panel_action.dart';
import 'package:monday/common/r.dart';

class ShowAutomatedScene extends StatefulWidget{

  final String sceneName;
  final String sceneId;
  ShowAutomatedScene(this.sceneName, this.sceneId);

  @override
  State<StatefulWidget> createState(){
    return new ShowAutomatedSceneState();
  }
}

class ShowAutomatedSceneState extends State<ShowAutomatedScene> {

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
                  EditAutomatedScene(widget.sceneName, widget.sceneId))).then((value) {
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

    //Conditions section
    Widget timeButton = buildTimeConditionButton(context);
    Widget climateButton = buildClimateConditionButton(context);
    Widget consumptionsButton = buildConsumptionConditionButton(context);

    //Conditions Row
    List<Widget> conditions = [
      timeButton,
      climateButton,
      consumptionsButton,
    ];
    Widget conditionsList = Utils.createBigHorizontalScrollableList(conditions);

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
            height: 320,
            child: actionsList
          ),
          Container(
            height: 10
          ),
          conditionsList
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
        if(action.deviceType == "shutter")
          _showModalShutterAction(action);
        else
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
                if(await SceneController.deleteAutomatedSceneOnMonday(context, sceneId)) {
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

  void _showModalClimate(TemperatureConditionModel tempCondition,
      HumidityConditionModel humCondition) {

    Widget tempPanel = new ShowTemperaturePanel(Utils.temperatureCondition);
    Widget humPanel = new ShowHumidityPanel(Utils.humidityCondition);

    if(tempCondition.value != null)//show values got from Monday
      tempPanel = new ShowTemperaturePanel(tempCondition);

    if(humCondition.value != null)//show values got from Monday
      humPanel = new ShowHumidityPanel(humCondition);

    showModalBottomSheet<void>(
      backgroundColor: Colors.transparent.withOpacity(0.8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      context: context,
      builder: (BuildContext context) {
        return Container(
          margin: const EdgeInsets.only(top: 5, left: 15, right: 15),
          height: 350,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              tempPanel,

              Container(
                height: 10
              ),

              humPanel,
            ]
          ),
        );
      }
    ).then((value){
      setState(() {

      });
    });
  }

  void _showModalConsumption(ConsumptionConditionModel consCondition) {
    showModalBottomSheet<void>(
      backgroundColor: Colors.transparent.withOpacity(0.8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      context: context,
      builder: (BuildContext context) {
        return Container(
          margin: const EdgeInsets.only(top: 5, left: 15, right: 15),
          height: 250,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ShowConsumptionPanel(consCondition),

              Container(
                height: 10
              ),
            ]
          ),
        );
      }
    ).then((value) {
      setState(() {

      });
    });
  }

  /*
  It creates a time condition button for the route
   */
  Widget buildTimeConditionButton(BuildContext context) {

    Future<TimeConditionModel> timeCondition = SceneController.readSceneTimeCondition(context, widget.sceneId);
    Color iconColor = Colors.grey[200];

    Widget timeContainer = FutureBuilder(
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          TimeConditionModel timeCond = snapshot.data;
          if (timeCond.hour != null && timeCond.minute != null) {//check if time condition has been set by checking hour and minute(mandatory for a time condition)
            iconColor = Colors.blueAccent;
            timeCond.enabled = '1';
          }
          return new Container(
            padding: const EdgeInsets.only(top:25, left: 20),
            child: Container(
              width: 90,
              height: 120,
              color: Colors.transparent,
              child: RaisedButton(
                color: Colors.grey[200].withOpacity(0.20),
                shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(10.0)),
                onPressed: () {
                  if(timeCond.enabled == '1') {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (
                            context) => new ShowSceneTimeCondition(timeCond)))
                        .then((value) {
                      setState(() {

                      });
                    });
                  }
                },
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.only(top:30),
                      child: Icon(
                        Monday.calendar_full,
                        color: iconColor,
                        size: Utils.iconSize+6,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(top:15),
                      child: Text(
                        R.of(context).sceneAutoPeriodicText,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w400,
                          color: Colors.grey[200],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          );
        }
        else if (snapshot.hasError) {
          return Text("${snapshot.error}", style: Theme
              .of(context)
              .textTheme
              .headline);
        }
        else {
          return new CustomProgressIndicator();
        }
      },
      future: timeCondition,
    );
    return timeContainer;
  }

  /*
  It creates a climate condition button for the route
   */
  Widget buildClimateConditionButton(BuildContext context) {
    Future<TemperatureConditionModel> temperatureCondition = SceneController.readSceneTemperatureCondition(context, widget.sceneId);
    Future<HumidityConditionModel> humidityCondition = SceneController.readSceneHumidityCondition(context, widget.sceneId);
    Color iconColor = Colors.grey[200];

    TemperatureConditionModel tempCond;
    HumidityConditionModel humCond;

    Widget climateButton = FutureBuilder(
      builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
        if(snapshot.hasData){
          tempCond = snapshot.data[0];//get temperatureCondition from Monday
          humCond = snapshot.data[1];// get humidityCondition from Monday
          if (snapshot.data[0].value != null) {//check if temperatureCondition got from Monday has attributes != null
            iconColor = Colors.blueAccent;
          }
          if(snapshot.data[1].value != null) {//check if humidityCondition got from Monday has attributes != null
            iconColor = Colors.blueAccent;
          }
          return new Container(//build climate button with right color set
            padding: const EdgeInsets.only(top:25, left: 20),
            child: Container(
              width: 90,
              height: 120,
              color: Colors.transparent,
              child: RaisedButton(
                color: Colors.grey[200].withOpacity(0.20),
                shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(10.0)),
                onPressed: () {
                  if(iconColor != Colors.grey[200])//check if climate conditions are enabled
                    _showModalClimate(tempCond, humCond);
                },
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.only(top:30),
                      child: Icon(
                        Monday.cloud_sun,
                        color: iconColor,
                        size: Utils.iconSize+6,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(top:15),
                      child: Text(
                        R.of(context).sceneAutoClimateButtonText,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w400,
                          color: Colors.grey[200],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }
        else if (snapshot.hasError) {
          return Text("${snapshot.error}", style: Theme
              .of(context)
              .textTheme
              .headline);
        }
        else {
          return new CustomProgressIndicator();
        }
      },
      future: Future.wait([temperatureCondition, humidityCondition])
    );

    return climateButton;
  }

  /*
  It creates a consumption condition button for the route
   */
  Widget buildConsumptionConditionButton(BuildContext context) {
    Future<ConsumptionConditionModel> consumptionCondition = SceneController.readSceneConsumptionCondition(context, widget.sceneId);
    Color iconColor = Colors.grey[200];

    ConsumptionConditionModel consCond;

    Widget consumptionButton = FutureBuilder(
      builder: (context, snapshot) {
        if(snapshot.hasData){
          consCond = snapshot.data;//get consumptionCondition from Monday
          if (consCond.value != null) {//check if consumptionCondition got from Monday has attributes != null
            iconColor = Colors.blueAccent;
          }
          return new Container(
            padding: const EdgeInsets.only(top:25, left: 20),
            child: Container(
              width: 90,
              height: 120,
              color: Colors.transparent,
              child: RaisedButton(
                color: Colors.grey[200].withOpacity(0.20),
                shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(10.0)),
                onPressed: () {
                  if(iconColor != Colors.grey[200])//check if consumption condition is enabled
                    _showModalConsumption(consCond);
                },
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.only(top:30),
                      child: Icon(
                        Monday.flash_on,
                        color: iconColor,
                        size: Utils.iconSize+6,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(top:15),
                      child: Text(
                        R.of(context).sceneAutoConsButtonText,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w400,
                          color: Colors.grey[200],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }
        else if (snapshot.hasError) {
          return Text("${snapshot.error}", style: Theme
              .of(context)
              .textTheme
              .headline);
        }
        else {
          return new CustomProgressIndicator();
        }
      },
      future: consumptionCondition
    );

    return consumptionButton;
  }
}

enum ConfirmAction { CANCEL, ACCEPT }

