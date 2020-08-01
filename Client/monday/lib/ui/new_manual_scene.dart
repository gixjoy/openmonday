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
import 'package:monday/common/r.dart';

class NewManualScene extends StatefulWidget{

  @override
  State<StatefulWidget> createState(){
    return new NewManualSceneState();
  }
}

class NewManualSceneState extends State<NewManualScene> {

  Widget drawer;

  @override
  Widget build(BuildContext context) {

    final sceneNameController = TextEditingController();
    Widget sceneName = new TextInputField(R.of(context).newManualSceneInputText, sceneNameController, false, true);

    /*
    AppBar
     */
    Widget appBar = new AppBar(
      title: new Text(R.of(context).newManualSceneTitle),
      backgroundColor: Colors.transparent,
      elevation: 0.0,
    );

    Widget actionTextSection = Utils.buildTextRow(
        R.of(context).newManualSceneAction,
        Utils.helloTextSize, Utils.mainTextColor, 20, 20);

    //Actions Row
    Widget devicesList = Container();
    if (Utils.actions.isEmpty) {
      devicesList = Center(
        child: Container(
          padding: EdgeInsets.only(top:150),
          height: 280,
          child: Text(
            R.of(context).newManualSceneNoAction,
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
        height: 280,
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
          devicesList,
          Container(
            height: 10
          ),
          IconButton(
            onPressed: () async {
              String sceneName = sceneNameController.text;
              if (await SceneController.createManualScene(context, sceneName,
                  Utils.actions)) {
                Utils.actions = List();
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) =>
                  Scene()));
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
  Widget createReorderableScrollableList(){
    return new CustomDragList(Utils.actions);
  }
}

