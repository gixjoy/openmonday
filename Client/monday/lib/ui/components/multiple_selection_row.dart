import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:monday/common/utils.dart';
import 'package:monday/ui/device_info.dart';
import 'package:monday/ui/chart.dart';

class MultipleSelectionRow extends StatefulWidget {

  final List<String> buttonsText;
  final Function(List<String>) onSelectionChanged;
  MultipleSelectionRow(this.buttonsText, {this.onSelectionChanged});

  @override
  State<StatefulWidget> createState() {
    return new MultipleSelectionRowState();
  }
}

class MultipleSelectionRowState extends State<MultipleSelectionRow> {

  List<String> selectedChoices = List();
  String selectedChoice = "";

  buildCategoriesList(BuildContext context){
    List<Widget> months = List();
    widget.buttonsText.forEach((item) {
      months.add(
        Container(
          padding: const EdgeInsets.only(top:15, left: 20),
          child: ChoiceChip(
            label: Text(
              item,
              style: TextStyle(
                color: Colors.black
              ),
            ),
            selected: selectedChoices.contains(item),
            selectedColor: Colors.blueAccent,
            disabledColor: Colors.grey,
            onSelected: (selected) {
              setState((){
                selectedChoices.contains(item)
                  ? selectedChoices.remove(item)
                  : selectedChoices.add(item);
                //widget.onSelectionChanged(selectedChoices);
              });
            },
          )
        )
      );
    });
    return months;
  }

  @override
  Widget build(BuildContext context){
    ListView scrollableColumn = new ListView(
      scrollDirection: Axis.vertical,
      children: buildCategoriesList(context),
      shrinkWrap: true,
    );
    return new Container(
      height: 80,
      width: 80,
      //padding: const EdgeInsets.only(bottom:50),
      child: scrollableColumn,
    );
  }
}