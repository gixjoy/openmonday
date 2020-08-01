import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:monday/ext_libs/flutter_circular_slider.dart';
import 'package:monday/controller/heater_controller.dart';

class CircularSlider extends StatefulWidget {

  String text;
  String initValue;
  String enabled;
  String deviceId;
  CircularSlider(this.text, this.initValue, this.enabled, this.deviceId);

  @override
  State<StatefulWidget> createState(){
    return new CircularSliderState();
  }
}

class CircularSliderState extends State<CircularSlider> {

  Color switchColor;

  @override
  Widget build(BuildContext context){
    if (widget.enabled == "1")
      switchColor = Colors.green;
    else
      switchColor = Colors.grey;
    return Container( //Circular slider for setting temperature
      padding: EdgeInsets.only(top:50),
      child: SingleCircularSlider(
        35, //divisions (20 degrees Celsius)
        int.parse(widget.initValue), //init value
        selectionColor: Color.fromRGBO(0, 102, 255, 0.8),
        onSelectionChange: (newInit, newEnd, laps) {
          setState(() {
            widget.initValue = newInit.toString();
            widget.text = newEnd.toString();
            if (newEnd == 0) {
              newEnd = 1;
              widget.text = newEnd.toString();
            }
            HeaterController.sendTemperatureToMonday(context, newEnd.toString());
          });
        },
        child: Padding(
          padding: const EdgeInsets.all(42.0),
          child: Center(
            child: Ink(
              decoration: BoxDecoration(
                border: Border.all(
                    color: switchColor,
                    width: 5.0
                ),
                color: Colors.transparent,
                shape: BoxShape.circle,
              ),
              child: InkWell(
                //This keeps the splash effect within the circle
                borderRadius: BorderRadius.circular(1000.0), //Something large to ensure a circle
                onTap: () async {
                  String switchStatus = await HeaterController.updateEnabledOnMonday(
                      context, widget.deviceId);
                  if (switchStatus != null) {
                    if (switchStatus == "0") {
                      switchColor = Colors.grey;
                      widget.enabled = "0";
                    }
                    else {
                      switchColor = Colors.green;
                      widget.enabled = "1";
                    }
                  }
                  else
                    switchColor = Colors.grey;
                  setState(() {});
                },
                child: Padding(
                  padding:EdgeInsets.all(20.0),
                  child: Text(
                    widget.text,
                    style: TextStyle(
                      fontSize: 22,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          )
        ),
      ),
    );
  }
}