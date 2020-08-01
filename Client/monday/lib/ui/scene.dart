import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:monday/ui/basic_route_structure.dart';
import 'package:monday/common/utils.dart';
import 'package:monday/ui/components/scene_button.dart';
import 'package:monday/controller/scene_controller.dart';
import 'package:monday/model/scene_model.dart';
import 'package:monday/ui/components/custom_progress_indicator.dart';
import 'package:monday/ui/show_manual_scene.dart';
import 'package:monday/ui/show_automated_scene.dart';
import 'package:monday/ui/home.dart';
import 'package:monday/common/r.dart';

class Scene extends StatefulWidget {

  @override
  State<StatefulWidget> createState(){
    return new SceneState();
  }
}

class SceneState extends State<Scene> {

  Future<List<SceneModel>> mScenes;
  Future<List<SceneModel>> aScenes;

  Widget drawer;

  @override
  void initState(){
    super.initState();
    mScenes = SceneController.readManualScene(context);
    aScenes = SceneController.readAutomatedScene(context);
  }

  @override
  Widget build(BuildContext context) {

    Widget appBar = new AppBar(
      title: new Text(R.of(context).scenesTitle),
      backgroundColor: Colors.transparent,
      elevation: 0.0,
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: Colors.grey[200]),
        onPressed: () async {
          Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => Home()));
        }
      ),
    );

    //Automated scenes section
    Widget automatedTextRow = Utils.buildTextRow(
        R.of(context).scenesAutomated,
        Utils.helloTextSize, Utils.mainTextColor, 20, 20);

    Widget automatedScenesList = FutureBuilder(
      builder: (context, snapshot) {
        List<Widget> scenesButtonsList = List();
        scenesButtonsList.add(Utils.createAddButton(context, "NewAutomatedScene"));
        if (snapshot.hasData) {
          List<SceneModel> scenes = snapshot.data;
          if (scenes.isNotEmpty) {
            scenes.forEach((element) {
              scenesButtonsList.add(new SceneButton(Icons.power_settings_new,
                  element.name, element.id, element.enabled,
                  ShowAutomatedScene(element.name, element.id)));
            });
            return createBigHorizontalScrollableList(scenesButtonsList);
          }
          else
            return createBigHorizontalScrollableList(scenesButtonsList);
        } else if (snapshot.hasError) {
          return Text("${snapshot.error}", style: Theme
              .of(context)
              .textTheme
              .headline);
        } else {
          return new CustomProgressIndicator();
        }
      },
      future: aScenes,
    );

    //Manual scenes section
    Widget manualTextRow = Utils.buildTextRow(
        R.of(context).scenesManual,
        Utils.helloTextSize, Utils.mainTextColor, 20, 20);

    Widget manualScenesList = FutureBuilder(
      builder: (context, snapshot) {
        List<Widget> scenesButtonsList = List();
        scenesButtonsList.add(Utils.createAddButton(context, "NewManualScene"));
        if (snapshot.hasData) {
          List<SceneModel> scenes = snapshot.data;
          if (scenes.isNotEmpty) {
            scenes.forEach((element) {
              scenesButtonsList.add(new SceneButton(Icons.power_settings_new,
                  element.name, element.id, element.enabled,
                  ShowManualScene(element.name, element.id)));
            });
            return createBigHorizontalScrollableList(scenesButtonsList);
          }
          else
            return createBigHorizontalScrollableList(scenesButtonsList);
        } else if (snapshot.hasError) {
          return Text("${snapshot.error}", style: Theme
              .of(context)
              .textTheme
              .headline);
        } else {
          return new CustomProgressIndicator();
        }
      },
      future: mScenes,
    );

    List<Widget> routeElements = [
      Container(
        height: 30
      ),
      automatedTextRow,
      automatedScenesList,
      Container(
        height: 30
      ),
      manualTextRow,
      manualScenesList
    ];
    Widget body = new Container(
      child: new Center(
        child: ListView(children: routeElements),
      ),
    );

    return new BasicRouteStructure(appBar, body, drawer);
  }

  static Widget createBigHorizontalScrollableList(List<Widget> buttons) {
    ListView scrollableRow = new ListView(scrollDirection: Axis.horizontal,
                                        children: buttons);
    return new Container(
      height: 180,
      //padding: const EdgeInsets.only(bottom:50),
      child: scrollableRow,
    );
  }
}

