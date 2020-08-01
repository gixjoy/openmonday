import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:monday/ui/basic_route_structure.dart';
import 'package:monday/common/r.dart';

class Surveillance extends StatefulWidget {

  @override
  State<StatefulWidget> createState(){
    return new SurveillanceState();
  }
}

class SurveillanceState extends State<Surveillance> {

  @override
  void initState() {
    super.initState();
  }

  Widget drawer;

  @override
  Widget build(BuildContext context) {
    /*
    AppBar
     */
    Widget appBar = new AppBar(
      title: new Text(R.of(context).surveillanceTitle),
      backgroundColor: Colors.transparent,
      elevation: 0.0,
    );

    Widget body = ListView(
      children: [
        FloatingActionButton(
          onPressed: () {
            setState(() {
            });
          },
        ),
        Center(
          child: Container(),
        ),
      ],
    );

    return new BasicRouteStructure(appBar, body, drawer);
  }
}

