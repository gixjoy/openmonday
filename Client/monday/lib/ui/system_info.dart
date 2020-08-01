import 'package:flutter/material.dart';
import 'package:monday/common/shared_prefs.dart';
import 'package:monday/ui/basic_route_structure.dart';
import 'package:monday/ui/components/text_input_field.dart';
import 'package:monday/controller/user_controller.dart';
import 'package:monday/common/utils.dart';
import 'package:monday/ui/components/custom_progress_indicator.dart';
import 'package:monday/ui/home.dart';
import 'package:monday/common/monday_icons.dart';
import 'package:monday/common/r.dart';

class SystemInfo extends StatefulWidget {

  State<StatefulWidget> createState(){
    return new SystemInfoState();
  }
}

class SystemInfoState extends State<SystemInfo> {

  static final usernameController = TextEditingController();
  static final passwordController = TextEditingController();
  static final rpController = TextEditingController();

  @override
  Widget build (BuildContext context) {

    Widget appBar = new AppBar(
      title: new Text(R.of(context).systemInfoTitle),
      backgroundColor: Colors.transparent,
      elevation: 0.0,
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: Colors.grey[200]),
        onPressed: () async {
          Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => Home()));
        }
      ),
    );

    Widget mosquittoSection =  Center(
      child: Text(
        R.of(context).systemInfoMosquittoText,
        style: TextStyle(
          color: Colors.grey[200],
          fontSize: 18,
        ),
      )
    );

    Widget mosquittoUsername =  Container(
      padding: EdgeInsets.only(left:30),
      child: SelectableText(
        "username:  mqtt_user",
        style: TextStyle(
          color: Colors.grey[200],
          fontSize: 14,
        ),
      )
    );

    Widget mosquittoPwd =  Container(
      padding: EdgeInsets.only(left:30),
      child: SelectableText(
        "password:  M0nday20!098!",
        style: TextStyle(
          color: Colors.grey[200],
          fontSize: 14,
        ),
      )
    );

    Widget body = Container(
      padding: EdgeInsets.only(top:40),
      child: ListView(
        children: [
          mosquittoSection,
          Container(height:40),
          mosquittoUsername,
          Container(height:20),
          mosquittoPwd,
          Container(height:100),
        ],
      ),
    );
    Widget drawer;

    return new BasicRouteStructure(appBar, body, drawer);
  }
}