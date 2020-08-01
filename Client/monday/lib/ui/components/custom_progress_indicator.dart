import 'package:flutter/material.dart';

class CustomProgressIndicator extends StatelessWidget{

  @override
  Widget build (BuildContext context) {
    return new Center(
      child: new SizedBox(
        height: 50.0,
        width: 50.0,
        child: new CircularProgressIndicator(
          value: null,
          strokeWidth: 6.0,
        ),
      ),
    );
  }
}