import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:monday/controller/scene_controller.dart';
import 'package:monday/ui/basic_route_structure.dart';
import 'package:monday/ui/components/text_input_field.dart';
import 'package:monday/common/utils.dart';
import 'package:monday/common/monday_icons.dart';
import 'package:monday/ui/scene.dart';
import 'package:monday/ui/devices_action.dart';
import 'package:monday/ui/components/custom_drag_list.dart';
import 'package:monday/ui/components/custom_progress_indicator.dart';
import 'package:monday/model/action_model.dart';
import 'package:monday/common/r.dart';

class EditManualScene extends StatefulWidget{

  String sceneName;
  String sceneId;
  EditManualScene(this.sceneName, this.sceneId);

  @override
  State<StatefulWidget> createState(){
    return new EditManualSceneState();
  }
}

class EditManualSceneState extends State<EditManualScene> {

  Widget drawer;
  Future<List<ActionModel>> actions;

  @override
  void initState(){
    super.initState();
    actions = SceneController.getSceneActionsFromMonday(context, widget.sceneId);
  }

  @override
  Widget build(BuildContext context) {

    List<ActionModel> mergeActions = List();//handles the merge between actions and Utils.actions

    Widget appBar = new AppBar(
      title: Text(R.of(context).editManualSceneTitle),
      backgroundColor: Colors.transparent,
      elevation: 0.0,
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: Colors.grey[200]),
        onPressed: () async {
          Utils.actionsEditModeEnabled = 0;
          Navigator.pop(context);
        }
      ),
    );

    final sceneNameController = TextEditingController();
    Widget sceneName = new TextInputField(widget.sceneName, sceneNameController, false, true);

    Widget actionTextSection = Utils.buildTextRow(
        R.of(context).editManualSceneAction,
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
              height: 280,
              child: createReorderableScrollableList(mergeActions)
            );
          }
          else {
            return new Container(
              height: 280,
              child: Center(
                child: Text(
                    R.of(context).editManualSceneNoAction,
                    style: TextStyle(
                      color: Colors.grey[200],
                      fontSize: 18,
                    )
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
      actionsList = new Container(
        height: 280,
        child: createReorderableScrollableList(Utils.actions)
      );

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
                            MaterialPageRoute(builder: (context) => DevicesAction("manual"))
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
          Container(
            height: 10
          ),
          IconButton(
            onPressed: () async {
              String sceneName = sceneNameController.text;
              if(Utils.actionsEditModeEnabled == 0) {//add action button has not been pressed
                if (await SceneController.updateManualSceneOnMonday(
                    context, sceneName,
                    widget.sceneId, mergeActions)) {
                  Utils.actionsEditModeEnabled = 0;
                  Utils.actions = List();
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => Scene()));
                }
              }
              else{
                if (await SceneController.updateManualSceneOnMonday(
                    context, sceneName,
                    widget.sceneId, Utils.actions)) {
                  Utils.actionsEditModeEnabled = 0;
                  Utils.actions = List();
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => Scene()));
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
  Method used for creating custom draglist
   */
  Widget createReorderableScrollableList(List<ActionModel> actions){
    return new CustomDragList(actions);
  }
}

