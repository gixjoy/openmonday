import 'package:flutter/material.dart';
import 'package:monday/controller/scene_controller.dart';

class SceneButton extends StatefulWidget{

  final IconData buttonIcon;
  final String label;
  final String sceneId;
  String sceneStatus;
  final Widget newRoute;
  SceneButton(this.buttonIcon, this.label, this.sceneId, this.sceneStatus, this.newRoute);

  @override
  SceneButtonState createState() => new SceneButtonState();
}

class SceneButtonState extends State<SceneButton>{

  @override
  Widget build(BuildContext context) {
    Color littleButtonColor = Colors.grey[200];
    if (widget.sceneStatus == "1")
      littleButtonColor = Colors.blueAccent;

    return new GestureDetector(
      onTap: (){
        Navigator.push(context,
          MaterialPageRoute(builder: (context) => widget.newRoute)
        );
      },
      child: Container(
        padding: const EdgeInsets.only(top:25, left: 20),
        child: Container(
          width: 150,
          height: 150,
          decoration: BoxDecoration(
            color: Colors.grey[800],
            borderRadius: BorderRadius.circular(16)
          ),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.only(left:80),
                width: 120,
                child: IconButton(
                  splashColor: Colors.transparent,
                  onPressed: () async {
                    if(await SceneController.switchSceneStatusOnMonday(context, widget.sceneId) == "1") {
                      littleButtonColor = Colors.blueAccent;
                      widget.sceneStatus = "1";
                    }
                    else {
                      littleButtonColor = Colors.grey[200];
                      widget.sceneStatus = "0";
                    }
                    setState(() {

                    });
                  },
                  icon: Icon(
                    widget.buttonIcon,
                    color: littleButtonColor,
                    size: 30,
                  ),
                  //alignment: Alignment.topRight,
                ),
              ),
              Container(height: 10),
              Container(
                padding: const EdgeInsets.only(top:15),
                child: Text(
                  widget.label,
                  style: TextStyle(
                    fontSize: 16,
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
}