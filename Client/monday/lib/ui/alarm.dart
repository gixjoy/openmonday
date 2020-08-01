import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:monday/ui/basic_route_structure.dart';
import 'package:monday/common/r.dart';

const String _kFontFam = 'Monday';

class Alarm extends StatelessWidget {

  static IconData _shieldIcon = const IconData(0xf132, fontFamily: _kFontFam); //icon for alarm
  static int _mainTextColor = 200;

  Widget drawer;

  @override
  Widget build(BuildContext context) {
    Widget appBar = new AppBar(
      title: new Text(R.of(context).alarmTitle),
      backgroundColor: Colors.transparent,
      elevation: 0.0,
    );

    Widget body = Container(
      child: ListView(
        children: [
          Container(
            height:100,
          ),
          IconButton(
            //onPressed: (),
            padding: const EdgeInsets.only(top:30),
            icon: Icon(
              Icons.vpn_key,
              color: Colors.green[500],
              size: 180,
            ),
          ),
          Container(
            padding: const EdgeInsets.only(top:180, bottom:40),
            child: Text(
              R.of(context).alarmStatus+': ATTIVATO',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: Colors.grey[_mainTextColor],
              ),
            ),
          ),
        ],
      ),
    );

    return new BasicRouteStructure(appBar, body, drawer);
  }
}