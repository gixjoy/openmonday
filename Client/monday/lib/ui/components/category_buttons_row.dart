import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:monday/common/utils.dart';

class CategoryButtonsRow extends StatefulWidget {

  final List<String> buttonsText;
  CategoryButtonsRow(this.buttonsText);

  @override
  State<StatefulWidget> createState() {
    return new CategoryButtonsRowState();
  }
}

class CategoryButtonsRowState extends State<CategoryButtonsRow> {

  String selectedChoice = "";

  buildCategoriesList(){
    List<Widget> categories = List();
    widget.buttonsText.forEach((item) {
      categories.add(
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
                Utils.roomCategory = selectedChoice;
              });
            },
          )
        )
      );
    });
    return categories;
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