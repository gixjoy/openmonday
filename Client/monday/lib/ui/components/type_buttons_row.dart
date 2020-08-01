import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:monday/common/utils.dart';
import 'package:monday/common/r.dart';

class TypeButtonsRow extends StatefulWidget {

  final List<String> buttonsText;
  TypeButtonsRow(this.buttonsText);

  @override
  State<StatefulWidget> createState() {
    return new TypeButtonsRowState();
  }
}

class TypeButtonsRowState extends State<TypeButtonsRow> {

  String selectedChoice = "";

  buildCategoriesList(){
    List<Widget> types = List();
    widget.buttonsText.forEach((item) {
      types.add(
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
                String type;
                if(selectedChoice == R.of(context).deviceLight)
                  type = "light";
                if(selectedChoice == R.of(context).deviceOutlet)
                  type = "outlet";
                if(selectedChoice == R.of(context).deviceClimate)
                  type = "climate";
                if(selectedChoice == R.of(context).deviceShutter)
                  type = "shutter";
                if(selectedChoice == R.of(context).deviceClimateSensor)
                  type = "climate_sensor";
                if(selectedChoice == R.of(context).deviceAlarmSensor)
                  type = "alarm";
                Utils.deviceType = type;
              });
            },
          )
        )
      );
    });
    return types;
  }

  @override
  Widget build(BuildContext context){
    ListView scrollableRow = new ListView(scrollDirection: Axis.horizontal,
                                        children: buildCategoriesList());
    return new Container(
      height: 60,
      //padding: const EdgeInsets.only(bottom:50),
      child: scrollableRow,
    );
  }
}