import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:monday/ui/basic_route_structure.dart';
import 'package:monday/ui/components/consumption_panel.dart';
import 'package:monday/ui/components/humidity_panel.dart';
import 'package:monday/ui/components/temperature_panel.dart';
import 'package:monday/ui/components/text_input_field.dart';
import 'package:monday/common/utils.dart';
import 'package:monday/common/monday_icons.dart';
import 'package:monday/ui/scene_time_condition.dart';
import 'package:monday/ui/scene.dart';
import 'package:monday/ui/devices_action.dart';
import 'package:monday/ui/components/custom_drag_list.dart';
import'package:monday/controller/scene_controller.dart';
import 'package:monday/common/r.dart';

class NewAutomatedScene extends StatefulWidget {

  @override
  State<StatefulWidget> createState(){
    return new NewAutomatedSceneState();
  }
}

class NewAutomatedSceneState extends State<NewAutomatedScene> {

  Widget drawer;

  @override
  Widget build(BuildContext context) {

    final sceneNameController = TextEditingController();
    Widget sceneName = new TextInputField(R.of(context).newAutomatedSceneInputText, sceneNameController, false, true);

    /*
    AppBar
     */
    Widget appBar = new AppBar(
      title: new Text(R.of(context).newAutomatedSceneTitle),
      backgroundColor: Colors.transparent,
      elevation: 0.0,
    );

    Widget conditionTextSection = Utils.buildTextRow(
        R.of(context).newAutomatedSceneCondition,
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
        R.of(context).newAutomatedSceneAction,
        Utils.helloTextSize, Utils.mainTextColor, 20, 20);

    //Actions Row
    Widget devicesList = Container();
    if (Utils.actions.isEmpty) {
      devicesList = Center(
        child: Container(
          padding: EdgeInsets.only(top:80),
          height: 140,
          child: Text(
            R.of(context).newAutomatedSceneNoAction,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[200]
            ),
          )
        ),
      );
    }
    else {
      devicesList = Container(
        height: 140,
        child: createReorderableScrollableList()
      );
    }

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
          devicesList,

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
              Utils.timeCondition.enabled != '1')
                Utils.showDialogPanel(R.of(context).warningMsg,
                    R.of(context).newAutomatedSceneCondConf, context);
              else {
                if (await SceneController.createAutomatedScene(context, sceneName,
                  Utils.timeCondition, Utils.temperatureCondition,
                  Utils.humidityCondition, Utils.consumptionCondition,
                  Utils.actions)) {
                  Utils.actions = List();
                  Utils.resetTimeCondition();
                  Utils.resetConsumptionCondition();
                  Utils.resetHumidityCondition();
                  Utils.resetTemperatureCondition();
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) =>
                  Scene()));
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

  void _showModalClimate() {
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
              TemperaturePanel(),

              Container(
                height: 10
              ),

              HumidityPanel(),
            ]
          ),
        );
      }
    ).then((value){
      setState(() {

      });
    });
  }

  void _showModalConsumption() {
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
    if(Utils.timeCondition.enabled == '1')
      iconColor = Colors.blueAccent;
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
                MaterialPageRoute(builder: (context) => new SceneTimeCondition()))
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
                  R.of(context).newAutomatedScenePeriodic,
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

  /*
  It creates a climate condition button for the route
   */
  Widget buildClimateConditionButton(BuildContext context) {
    Color iconColor = Colors.grey[200];
    if(Utils.humidityCondition.enabled == '1' ||
        Utils.temperatureCondition.enabled == '1')
      iconColor = Colors.blueAccent;
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
            _showModalClimate();
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

  /*
  It creates a consumption condition button for the route
   */
  Widget buildConsumptionConditionButton(BuildContext context) {
    Color iconColor = Colors.grey[200];
    if(Utils.consumptionCondition.enabled == '1')
      iconColor = Colors.blueAccent;
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
            _showModalConsumption();
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

  /*
  Method used for creating custom draglist
   */
  Widget createReorderableScrollableList(){
    return new CustomDragList(Utils.actions);
  }
}

