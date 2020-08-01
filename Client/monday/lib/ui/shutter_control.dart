import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:monday/ui/basic_route_structure.dart';
import 'package:flutter_xlider/flutter_xlider.dart';
import 'package:monday/controller/shutter_controller.dart';
import 'package:monday/common/utils.dart';
import 'package:monday/common/r.dart';
import 'package:monday/common/r.dart';

class ShutterControl extends StatefulWidget {

  final String shutterId;
  final String shutterName;
  final String openingLevel;
  ShutterControl(this.shutterId, this.shutterName, this.openingLevel);

  @override
  State createState() {
    return ShutterControlState();
  }

}

class ShutterControlState extends State<ShutterControl>{

  double _lowerValue = 0;
  double initValue = 0;

  Widget drawer;

  @override
  Widget build(BuildContext context) {

    Widget appBar = new AppBar(
      title: new Text(widget.shutterName),
      backgroundColor: Colors.transparent,
      elevation: 0.0,
      actions: <Widget>[
        IconButton(
          onPressed: (){
            ShutterController.calibrateShutterOnMonday(context, widget.shutterId);
          },
          icon: Icon(
            Icons.vertical_align_center,
            size: 32,
            color: Colors.grey[200]
          )
        )
      ]
    );

    Widget body = Container(
      height: 600,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 20,
            child: Text(
              R.of(context).shutterControlOpenText,
              style: TextStyle(
                color: Colors.grey[200],
                fontSize: 18
              ),
            )
          ),
          Container(
            height: 320,
            child: FlutterSlider(
              values: [initValue],
              fixedValues: [
                FlutterSliderFixedValue(percent: 0, value: "0%"),
                FlutterSliderFixedValue(percent: 10, value: "10%"),
                FlutterSliderFixedValue(percent: 20, value: "20%"),
                FlutterSliderFixedValue(percent: 30, value: "30%"),
                FlutterSliderFixedValue(percent: 40, value: "40%"),
                FlutterSliderFixedValue(percent: 50, value: "50%"),
                FlutterSliderFixedValue(percent: 60, value: "60%"),
                FlutterSliderFixedValue(percent: 70, value: "70%"),
                FlutterSliderFixedValue(percent: 80, value: "80%"),
                FlutterSliderFixedValue(percent: 90, value: "90%"),
                FlutterSliderFixedValue(percent: 100, value: "100%"),
              ],
              trackBar: FlutterSliderTrackBar(
                activeTrackBarHeight: 130,
                inactiveTrackBarHeight: 130,
                inactiveTrackBar: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.black12,
                  border: Border.all(width: 3, color: Colors.blue),
                ),
                activeTrackBar: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  color: Colors.blue.withOpacity(0.5)
                ),
              ),
              axis: Axis.vertical,
              onDragging: (handlerIndex, lowerValue, upperValue) async {
                _lowerValue = double.parse(lowerValue.toString().substring(0, lowerValue.toString().length-1));
                initValue = _lowerValue;
                if(await ShutterController.updateOpeningLevelOnMonday(context,
                    widget.shutterId, initValue.toString())) {
                  setState(() {});
                }
                else{
                  Utils.showDialogPanel(R.of(context).warningMsg, R.of(context).devNotReachable, context);
                  Navigator.pop(context);
                }
              },
              tooltip: FlutterSliderTooltip(
                direction: FlutterSliderTooltipDirection.left,
                alwaysShowTooltip: true,
              ),
              handlerAnimation: FlutterSliderHandlerAnimation(
                  curve: Curves.elasticOut,
                  reverseCurve: null,
                  duration: Duration(milliseconds: 700),
                  scale: 1.4),
            ),
          ),
          Container(
            height: 20,
            child: Text(
              R.of(context).shutterControlCloseText,
              style: TextStyle(
                color: Colors.grey[200],
                fontSize: 18
              ),
            )
          ),
        ]
      ),
    );

    return new BasicRouteStructure(appBar, body, drawer);
  }
}