import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:monday/model/time_condition_model.dart';

class DaySelectionGrid extends StatefulWidget {

  final TimeConditionModel timeCondition;
  final List<String> buttonsText;
  final Function(List<String>) onSelectionChanged;
  final double containerHeight;
  DaySelectionGrid(this.timeCondition, this.buttonsText, this.containerHeight,
      {this.onSelectionChanged});

  @override
  State<StatefulWidget> createState() {
    return new DaySelectionGridState();
  }
}

class DaySelectionGridState extends State<DaySelectionGrid> {

  String selectedChoice = "";

  buildDaysGrid(BuildContext context){
    List<String> selectedChoices = widget.timeCondition.days;
    List<Widget> months = List();
    widget.buttonsText.forEach((item) {
      months.add(
        Padding(
          padding: const EdgeInsets.all(2),
          child: ChoiceChip(
            label: Text(
              item,
              style: TextStyle(
                color: Colors.black
              ),
            ),
            selected: selectedChoices.contains(item),
            selectedColor: Colors.blueAccent,
            backgroundColor: Colors.grey[800],
            onSelected: (selected) {
              setState((){
                selectedChoices.contains(item)
                  ? selectedChoices.remove(item)
                  : selectedChoices.add(item);
                widget.timeCondition.days = selectedChoices;
              });
            },
          )
        )
      );
    });
    selectedChoices.forEach((item){
      //print("DAY: " + item.toString());
    });
    return months;
  }

  @override
  Widget build(BuildContext context){
    GridView grid = new GridView.count(
      physics: ClampingScrollPhysics(),
      scrollDirection: Axis.vertical,
      crossAxisCount: 4,
      children: buildDaysGrid(context),
      shrinkWrap: true,
      childAspectRatio: 3/2
    );
    return new Container(
      height: widget.containerHeight,
      width: 80,
      padding: EdgeInsets.only(top:10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.0),
        border: Border.all(
          width: 2,
          color: Colors.grey[600]
        ),
      ),
      //padding: const EdgeInsets.only(bottom:50),
      child: grid,
    );
  }
}