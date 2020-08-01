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
import 'package:monday/ui/components/text_input_field.dart';
import 'package:monday/ui/scene.dart';
import 'package:monday/ui/scene_time_condition.dart';
import 'package:monday/ui/components/consumption_panel.dart';
import 'package:monday/ui/components/temperature_panel.dart';
import 'package:monday/ui/components/humidity_panel.dart';
import 'package:monday/model/temperature_condition_model.dart';
import 'package:monday/model/humidity_condition_model.dart';
import 'package:monday/model/consumption_condition_model.dart';
import 'package:monday/ui/components/custom_drag_list.dart';
import 'package:monday/ui/devices_action.dart';
import 'package:monday/common/r.dart';

class EditAutomatedScene extends StatefulWidget{

  final String sceneName;
  final String sceneId;
  EditAutomatedScene(this.sceneName, this.sceneId);

  @override
  State<StatefulWidget> createState(){
    return new EditAutomatedSceneState();
  }
}

class EditAutomatedSceneState extends State<EditAutomatedScene> {

  Future<List<ActionModel>> actions;//list of actions to get from Monday
  Future<TimeConditionModel> timeCondition;//time condition to get from Monday
  Future<TemperatureConditionModel> temperatureCondition;//temperature condition to get from Monday
  Future<HumidityConditionModel> humidityCondition;//humidity condition to get from Monday
  Future<ConsumptionConditionModel> consumptionCondition;//consumption condition to get from Monday
  Widget drawer;

  @override
  void initState(){
    super.initState();
    actions = SceneController.getSceneActionsFromMonday(context, widget.sceneId);
    timeCondition = SceneController.readSceneTimeCondition(context, widget.sceneId);
    temperatureCondition = SceneController.readSceneTemperatureCondition(context, widget.sceneId);
    humidityCondition = SceneController.readSceneHumidityCondition(context, widget.sceneId);
    consumptionCondition = SceneController.readSceneConsumptionCondition(context, widget.sceneId);
  }

  @override
  Widget build(BuildContext context) {

    List<ActionModel> mergeActions = List();//handles the merge between actions and Utils.actions

    Widget appBar = new AppBar(
      title: new Text(R.of(context).editAutomatedSceneTitle),
      backgroundColor: Colors.transparent,
      elevation: 0.0,
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: Colors.grey[200]),
        onPressed: () async {
          resetActionsFlagsConditions();
          Navigator.pop(context);
        }
      ),
    );

    final sceneNameController = TextEditingController();
    Widget sceneName = new TextInputField(widget.sceneName, sceneNameController, false, true);

    Widget conditionTextSection = Utils.buildTextRow(
        R.of(context).editAutomatedSceneCondition,
        Utils.helloTextSize, Utils.mainTextColor, 20, 20);

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

    Widget actionTextSection = Utils.buildTextRow(
        R.of(context).editAutomatedSceneAction,
        Utils.helloTextSize, Utils.mainTextColor, 20, 20);

    //Actions Row
    Widget actionsList;
    if(Utils.actionsEditModeEnabled == 0)
      actionsList = FutureBuilder(
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            mergeActions = snapshot.data;
            if (mergeActions.isNotEmpty) {
              return new Container(
                height: 140,
                child: createReorderableScrollableList(mergeActions)
              );
            }
            else {
              return new Center(
                  child: Text(
                      R.of(context).editAutomatedSceneNoAction,
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
                // ignore: deprecated_member_use
                .headline);
          } else {
            return new CustomProgressIndicator();
          }
        },
        future: actions,
      );
    else
      actionsList = Container(
        height: 140,
        child: createReorderableScrollableList(Utils.actions)
      );

    //Body section
    Widget body = new GestureDetector(
      onTap: (){
        FocusScope.of(context).unfocus();
      },
      child: ListView(
        children: [
          Container(
            height: 20
          ),
          sceneName,
          Container(height:10),
          Container(
            height: 70,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  height: 60,
                  child: actionTextSection,
                ),
                Container(width:50),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Container(
                    height: 48,
                    //padding: EdgeInsets.only(top:20),
                    decoration: BoxDecoration(
                      color: Colors.grey[600].withOpacity(0.4),
                      borderRadius: BorderRadius.circular(30)
                    ),
                    child: IconButton(
                      onPressed: (){
                        if(Utils.actionsEditModeEnabled == 0) {
                          Utils.actionsEditModeEnabled = 1;
                          Utils.actions = mergeActions;
                        }
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => DevicesAction("automated"))
                        ).then((value) {
                          setState(() {

                          });
                        });
                      },
                      icon: Icon(
                        Icons.add,
                        size: 25,
                        color: Colors.grey[200],
                      )
                    )
                  )
                ),
              ]
            )
          ),
          Container(height:10),
          actionsList,

          conditionTextSection,
          conditionsList,
          Container(
            height: 10
          ),
          IconButton(
            onPressed: () async {
              String sceneName = sceneNameController.text;
              if(Utils.consumptionCondition.enabled != '1' &&
              Utils.humidityCondition.enabled != '1' &&
              Utils.temperatureCondition.enabled != '1' &&
              Utils.timeCondition.enabled != '1')//If no condition has been enabled, then scene is not automated
                Utils.showDialogPanel(R.of(context).devWarningTypeSelectionTitle,
                    R.of(context).editAutomatedSceneCondConf, context);
              else {
                if(Utils.temperatureCondition.enabled == '1'&& Utils.temperatureCondition.operator == "" ||
                Utils.humidityCondition.enabled == '1'&& Utils.humidityCondition.operator == "" ||
                Utils.consumptionCondition.enabled == '1'&& Utils.consumptionCondition.operator == "")//if some measure panel has been enabled with no operatore selected, then don't go forward
                  Utils.showDialogPanel(R.of(context).devWarningTypeSelectionTitle,
                      R.of(context).editAutomatedSceneCondOperator, context);
                else {//let's update automated scene on Monday
                  if(Utils.actionsEditModeEnabled == 0) { //add action button has not been pressed
                    if (await SceneController.updateAutomatedSceneOnMonday(
                        context, sceneName, widget.sceneId, mergeActions,
                        Utils.timeCondition, Utils.temperatureCondition,
                        Utils.humidityCondition, Utils.consumptionCondition)) {
                      resetActionsFlagsConditions();
                      Navigator.pushReplacement(
                          context, MaterialPageRoute(builder: (context) =>
                          Scene()));
                    }
                  }
                  else {
                    if (await SceneController.updateAutomatedSceneOnMonday(
                        context, sceneName, widget.sceneId, Utils.actions,
                        Utils.timeCondition, Utils.temperatureCondition,
                        Utils.humidityCondition, Utils.consumptionCondition)) {
                      resetActionsFlagsConditions();
                      Navigator.pushReplacement(
                          context, MaterialPageRoute(builder: (context) =>
                          Scene()));
                    }
                  }
                }
              }
            },
            icon: Icon(
              Monday.ok_1,
              color: Colors.grey[200],
              size: 45,
            ),
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
          showTitleActions: true,
          showSecondsColumn: true,
          onConfirm: (time) {
            int seconds = (time.hour*3600)+(time.minute*60)+time.second;
            print(seconds);
            Utils.actions.add(action);
            Navigator.pop(context);//close the modalSheet
            //Navigator.pop(context);//go back to previous route
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

  void _showModalClimate(TemperatureConditionModel tempCondition,
      HumidityConditionModel humCondition) {

    Widget tempPanel = new TemperaturePanel();//show values got from Monday or default got from Utils
    Widget humPanel = new HumidityPanel();//show values got from Monday or default got from Utils

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
              ConsumptionPanel(),

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

    Color iconColor = Colors.grey[200];

    Widget timeContainer = FutureBuilder(
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          TimeConditionModel timeCond = snapshot.data;
          if(Utils.timeEditModeEnabled == 0) {
            if (timeCond.hour != null && timeCond.minute != null ||
                Utils.timeCondition.enabled == '1') { //check if time condition has been set by checking hour and minute(mandatory for a time condition)
              iconColor = Colors.blueAccent;
              Utils.timeCondition = timeCond;
              Utils.timeCondition.enabled = '1';
            }
          }
          else{
            if(Utils.timeCondition.enabled == '1')
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
                  Navigator.push(context,
                      MaterialPageRoute(builder: (
                        context) => new SceneTimeCondition()))
                      .then((value) {
                    setState(() {

                    });
                  });
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
                        R.of(context).editAutomatedScenePeriodic,
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
              // ignore: deprecated_member_use
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

    Color iconColor = Colors.grey[200];

    TemperatureConditionModel tempCond;
    HumidityConditionModel humCond;

    Widget climateButton;
    if(Utils.climateEditModeEnabled == 0) //0 means button is getting infos from Monday
      climateButton = FutureBuilder(
      builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
        if(snapshot.hasData){
          tempCond = snapshot.data[0];//get temperatureCondition from Monday
          humCond = snapshot.data[1];// get humidityCondition from Monday
          if (snapshot.data[0].value != null) {//check if temperatureCondition got from Monday has attributes != null
            iconColor = Colors.blueAccent;
            Utils.temperatureCondition = tempCond;
            Utils.temperatureCondition.enabled = '1';
          }
          if(snapshot.data[1].value != null) {//check if humidityCondition got from Monday has attributes != null
            iconColor = Colors.blueAccent;
            Utils.humidityCondition = humCond;
            Utils.humidityCondition.enabled = '1';
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
                  else//show default panels for temperature and humidity conditions
                    _showModalClimate(Utils.temperatureCondition, Utils.humidityCondition);
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
                        R.of(context).deviceClimate,
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
              // ignore: deprecated_member_use
              .headline);
        }
        else {
          return new CustomProgressIndicator();
        }
      },
      future: Future.wait([temperatureCondition, humidityCondition])
    );

    else { //button is getting infos from Utils.temperatureCondition and Utils.humidityCondition
      if(Utils.temperatureCondition.enabled == '1' || Utils.humidityCondition.enabled == '1')
        iconColor = Colors.blueAccent;
      climateButton = Container( //build climate button with right color set
        padding: const EdgeInsets.only(top: 25, left: 20),
        child: Container(
          width: 90,
          height: 120,
          color: Colors.transparent,
          child: RaisedButton(
            color: Colors.grey[200].withOpacity(0.20),
            shape: RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(10.0)),
            onPressed: () {
              _showModalClimate(Utils.temperatureCondition, Utils.humidityCondition);
            },
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.only(top: 30),
                  child: Icon(
                    Monday.cloud_sun,
                    color: iconColor,
                    size: Utils.iconSize + 6,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(top: 15),
                  child: Text(
                    R.of(context).deviceClimate,
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
    return climateButton;
  }

  /*
  It creates a consumption condition button for the route
   */
  Widget buildConsumptionConditionButton(BuildContext context) {
    Color iconColor = Colors.grey[200];

    ConsumptionConditionModel consCond;

    Widget consumptionButton;
    if(Utils.consumptionEditModeEnabled == 0) //0 means button is getting infos from Monday
      consumptionButton = FutureBuilder(
        builder: (context, snapshot) {
          if(snapshot.hasData){
            consCond = snapshot.data;//get consumptionCondition from Monday
            if (consCond.value != null) {//check if consumptionCondition got from Monday has attributes != null
              iconColor = Colors.blueAccent;
              Utils.consumptionCondition = consCond;
              Utils.consumptionCondition.enabled = '1';
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
                    else//show default panel for consumption condition
                      _showModalConsumption(Utils.consumptionCondition);
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
                          R.of(context).devInfoConsumption,
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
                // ignore: deprecated_member_use
                .headline);
          }
          else {
            return new CustomProgressIndicator();
          }
        },
        future: consumptionCondition
      );
    else{
      if(Utils.consumptionCondition.enabled == '1')
        iconColor = Colors.blueAccent;
      consumptionButton = FutureBuilder(
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
                    //show default panel for consumption condition
                    _showModalConsumption(Utils.consumptionCondition);
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
                          R.of(context).devInfoConsumption,
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
                // ignore: deprecated_member_use
                .headline);
          }
          else {
            return new CustomProgressIndicator();
          }
        },
        future: consumptionCondition
      );
    }

    return consumptionButton;
  }

  /*
  Method used for creating custom draglist
   */
  Widget createReorderableScrollableList(List<ActionModel> actions){
    return new CustomDragList(actions);
  }

  /*
  Method executed after scene update has been performed
   */
  void resetActionsFlagsConditions(){
    Utils.actions = List();
    Utils.resetTimeCondition();
    Utils.resetConsumptionCondition();
    Utils.resetHumidityCondition();
    Utils.resetTemperatureCondition();
    Utils.climateEditModeEnabled = 0;
    Utils.consumptionEditModeEnabled = 0;
    Utils.timeEditModeEnabled = 0;
    Utils.actionsEditModeEnabled = 0;
  }
}

enum ConfirmAction { CANCEL, ACCEPT }

