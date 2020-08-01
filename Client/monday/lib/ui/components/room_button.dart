import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:monday/model/room_model.dart';
import 'package:monday/ui/room.dart';

class RoomButton extends StatelessWidget{
  final RoomModel room;
  RoomButton(this.room);

  @override
  Widget build(BuildContext context){
    return new GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context) =>
            Room(room.name, room.id)));
      },
      child: Container(
        padding: const EdgeInsets.only(top:15, left: 15),
        child: Container(
          width: 110,
          height: 140,
          decoration: new BoxDecoration(
            borderRadius: new BorderRadius.circular(10.0),
            image: DecorationImage(
              image:AssetImage(room.imgPath),
              fit:BoxFit.cover,
            ),
          ),
          child: Container(
            padding: EdgeInsets.only(bottom:100),
            child: Center (
              child: Text(
                room.name,
                style: TextStyle(
                  color: Colors.grey[200]
                ),
              ),
            ),
          ),
        ),
      )
    );
  }
}