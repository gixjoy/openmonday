import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:monday/common/utils.dart';
import 'package:monday/common/r.dart';
import 'package:monday/common/r.dart';

class TextInputField extends StatelessWidget{

  TextEditingController textController;
  String label;
  bool isPassword;
  bool isEnabled;
  TextInputField(this.label, this.textController, this.isPassword, this.isEnabled);

  @override
  Widget build(BuildContext context){
    Color textColor = Colors.grey[200];
    double fontSize = 14;
    if (!isEnabled) {
      //textColor = Colors.blueAccent;
      fontSize = 20;
    }
    return new Container(
      height:60,
      padding: EdgeInsets.only(left:20, right:20),
      child: TextFormField(
        enabled: isEnabled,
        obscureText: isPassword,
        controller: textController,
        style: TextStyle(
          color: Colors.grey[200],
        ),
        autovalidate: true,
        validator: (String val) {//Used for validating input fields
          if(val.contains("\/") || val.contains("\'") || val.contains("\@") ||
          val.contains("\$") || val.contains("\-") || val.contains("\^") ||
          val.contains("\<") || val.contains("\>") || val.contains('\,') ||
          val.contains("\.") || val.contains("\\") || val.contains("\"") ||
          val.contains ("\+") || val.contains("*") || val.contains("\=") ||
          val.contains("\(") || val.contains("\)") || val.contains("\{") ||
          val.contains("\}") || val.contains("\_")){
            return "Inserted chars are not allowed";
          }
          else{
            return null;
          }
        },
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(
            color: textColor,
            fontSize: fontSize,
            backgroundColor: Colors.transparent,
          ),
          enabledBorder: new OutlineInputBorder(
            borderRadius: new BorderRadius.circular(25.0),
            borderSide: new BorderSide(
              color: Colors.grey[200],
            )
          ),
          border: new OutlineInputBorder(
            borderRadius: new BorderRadius.circular(25.0),
            borderSide: new BorderSide(
              color: Colors.grey[200],
            )
          ),
        ),
        cursorColor: Colors.grey[200],
      ),
    );
  }
}