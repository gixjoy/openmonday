import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:monday/ui/basic_route_structure.dart';
import 'package:flutter_xlider/flutter_xlider.dart';
import 'package:monday/controller/shutter_controller.dart';
import 'package:monday/common/utils.dart';
import 'package:monday/model/action_model.dart';
import 'package:monday/model/device_model.dart';
import 'package:monday/common/r.dart';

class ShutterPanelAction extends StatefulWidget {

  final ActionModel action;
  ShutterPanelAction(this.action);

  @override
  State createState() {
    return ShutterPanelActionState();
  }
}

class ShutterPanelActionState extends State<ShutterPanelAction>{

  Widget drawer;

  @override
  Widget build(BuildContext context) {

    double initValue = double.parse(widget.action.command);

    return new Container(
      height: 290,
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
            height: 260,
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
              /*onDragging: (handlerIndex, lowerValue, upperValue) {
                _lowerValue = double.parse(lowerValue.toString().substring(0, lowerValue.toString().length-1));
                initValue = _lowerValue;
              },
              onDragCompleted: (handlerIndex, lowerValue, upperValue) {
                initValue = _lowerValue;
                ActionModel action = new ActionModel("", widget.device.id,
                      widget.device.name, widget.device.type, initValue.toString());
                Utils.actions.add(action);
                Navigator.pop(context);//close the modalSheet
                Navigator.pop(context);//go back to previous route
              },*/
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
  }
}