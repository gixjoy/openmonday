import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:monday/common/utils.dart';
import 'package:monday/model/room_model.dart';
import 'package:monday/common/monday_icons.dart';

class RoomButtonsRowSelection extends StatefulWidget {

  //final List<String> imgPaths;
  final List<RoomModel> rooms;
  final bool showText;//if true, room name is shown above the room button
  RoomButtonsRowSelection(this.rooms, this.showText);

  @override
  State<StatefulWidget> createState() {
    return new RoomButtonsRowSelectionState();
  }
}

class RoomButtonsRowSelectionState extends State<RoomButtonsRowSelection> {

  String selectedChoice = "";
  int index = 0;
  int selectedItem = -1;
  Widget selected;

  /*
  Builds the room buttons with no text above
   */
  List<Widget> buildRoomsList() {
    List<Widget> roomsWidget = List();
    widget.rooms.forEach((item) {
      index++;
      //print ("Index: $index");
      if (selectedItem == index) {
        selected = new Icon(
          Monday.ok_circled2,
          size: 50,
          color: Colors.blueAccent,
        );}
      else
        selected = null;
      roomsWidget.add(
        Container(
          padding: const EdgeInsets.only(top:15),
          child: Row(
            children: [
              RaisedButton(
                color: Colors.transparent,
                onPressed: () {
                  setState(() {
                    RoomModel selectedRoom = item;
                    selectedChoice = item.imgPath;
                    selectedItem = widget.rooms.indexOf(selectedRoom)+1;
                    index = 0;
                    Utils.selectedRoom = selectedRoom;
                    Utils.roomButtonImgPath = selectedChoice;
                    //print("Selected item: $selectedItem");
                    //print("Selected room image path: $selectedChoice");
                  });
                },
                child: Container(
                  width: 110,
                  height: 150,
                  decoration: new BoxDecoration(
                    borderRadius: new BorderRadius.circular(10.0),
                    image: DecorationImage(
                      image:AssetImage(item.imgPath),
                      fit:BoxFit.cover,
                    ),
                  ),
                  child: selected,
                ),
              ),
            ],
          ),
        ),
      );
    });
    return roomsWidget;
  }

  /*
  Builds room buttons with the specified text above
   */
  List<Widget> buildRoomsListWithText() {
    List<Widget> roomsWidget = List();
    widget.rooms.forEach((item) {
      index++;
      //print ("Index: $index");
      if (selectedItem == index) {
        selected = Container(
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.only(top:15),
                child: Text(
                  item.name,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: Colors.grey[200],
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.only(top:25),
                child: Icon(
                  Monday.ok_circled2,
                  size: 50,
                  color: Colors.blueAccent,
                ),
              ),
            ],
          ),
        );
      }
      else
        selected = Container(
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.only(top:15),
                child: Text(
                  item.name,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: Colors.grey[200],
                  ),
                ),
              ),
            ],
          ),
        );
      roomsWidget.add(
        Container(
          color: Colors.transparent,
          padding: const EdgeInsets.only(top:15),
          child: RaisedButton(
            color: Colors.transparent,
            onPressed: () {
              setState(() {
                RoomModel selectedRoom = item;
                selectedChoice = item.imgPath;
                selectedItem = widget.rooms.indexOf(selectedRoom)+1;
                index = 0;
                Utils.selectedRoom = selectedRoom;
                Utils.roomButtonImgPath = selectedChoice;
                //print("Selected item: $selectedItem");
                //print("Selected roomId: "+ Utils.selectedRoom.id.toString());
                //print("Selected room image path: $selectedChoice");
              });
            },
            child: Column(
              children: [
                Container(
                  width: 110,
                  height: 140,
                  decoration: new BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: new BorderRadius.circular(10.0),
                    image: DecorationImage(
                      image:AssetImage(item.imgPath),
                      fit:BoxFit.cover,
                    ),
                  ),
                  child: selected,
                ),
              ],
            ),
          ),
        ),
      );
    });
    return roomsWidget;
  }

  @override
  Widget build(BuildContext context){
    ListView scrollableRow = ListView();
    if (!widget.showText) {//if showText is false no text is shown on button
      scrollableRow = new ListView(scrollDirection: Axis.horizontal,
          children: buildRoomsList());
    }
    else {//if showText is true, the name of the room is shown on button
      scrollableRow = new ListView(scrollDirection: Axis.horizontal,
          children: buildRoomsListWithText());
    }
    return new Container(
      color: Colors.transparent,
      height: 160,
      //padding: const EdgeInsets.only(bottom:50),
      child: scrollableRow,
    );
  }
}