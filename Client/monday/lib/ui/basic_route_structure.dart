import 'package:flutter/material.dart';
import 'package:monday/common/utils.dart';

class BasicRouteStructure extends StatelessWidget {

  /*
  Variables for the basic components of the Scaffold within every and each
  route
   */
  Widget appBar;
  Widget body;
  Widget drawer;
  BasicRouteStructure(Widget appBar, Widget body, Widget drawer) {
    this.appBar = appBar;
    this.body = body;
    this.drawer = drawer;
  }

  @override
  Widget build(BuildContext context){
    return new Container( //Main Container with size = infinite
      width: double.infinity,
      height: double.infinity,
      decoration: new BoxDecoration(
        image: new DecorationImage(
          image: new AssetImage("assets/images/background.jpg"), //bg image
          fit: BoxFit.cover,
        ),
      ),
      child: new Scaffold(
        backgroundColor: Colors.transparent,
        appBar: appBar,
        body: body,
        drawer: drawer,
      ),
    );
  }
}