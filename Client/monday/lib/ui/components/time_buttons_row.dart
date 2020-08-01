import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:monday/common/utils.dart';
import 'package:monday/ui/device_info.dart';
import 'package:monday/ui/chart.dart';

class TimeButtonsRow extends StatefulWidget {

  final List<String> buttonsText;
  final String invocationClass;
  TimeButtonsRow(this.buttonsText, this.invocationClass);

  @override
  State<StatefulWidget> createState() {
    return new TimeButtonsRowState();
  }
}

class TimeButtonsRowState extends State<TimeButtonsRow> {

  String selectedChoice = Utils.selectedTime;

  buildCategoriesList(BuildContext context){
    List<Widget> times = List();
    widget.buttonsText.forEach((item) {
      times.add(
        Container(
          padding: const EdgeInsets.only(top:15, left: 20),
          child: ChoiceChip(
            label: Text(
              item,
              style: TextStyle(
                color: Colors.black
              ),
            ),
            selected : selectedChoice == item,
            selectedColor: Colors.blueAccent,
            disabledColor: Colors.grey,
            onSelected: (selected) {
              setState(() {
                selectedChoice = item;
                Utils.selectedTime = selectedChoice;
                if (widget.invocationClass == "DeviceInfo")
                  DeviceInfo.of(context).setState((){});
                if(widget.invocationClass == "Chart")
                  Chart.of(context).setState((){});
              });
            },
          )
        )
      );
    });
    return times;
  }

  @override
  Widget build(BuildContext context){
    ListView scrollableRow = new ListView(scrollDirection: Axis.horizontal,
                                        children: buildCategoriesList(context));
    return new Container(
      height: 60,
      //padding: const EdgeInsets.only(bottom:50),
      child: scrollableRow,
    );
  }
}