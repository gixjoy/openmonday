import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:monday/ui/basic_route_structure.dart';
import 'package:monday/model/notification_model.dart';
import 'package:monday/common/utils.dart';
import 'package:monday/common/r.dart';

class NotificationInfo extends StatelessWidget {

  NotificationModel notification;

  NotificationInfo(this.notification);

  static const double topDistance = 20;

  Widget drawer;

  @override
  Widget build(BuildContext context) {

    /*
    AppBar
     */
    Widget appBar = new AppBar(
      title: new Text(R.of(context).notificationInfoTitle),
      backgroundColor: Colors.transparent,
      elevation: 0.0,
    );

    Widget body = buildBody(context, notification);

    return new BasicRouteStructure(appBar, body, drawer);
  }

  /*
  Method used for building the body of BasicRouteStructure object created inside
  build method
   */
  Widget buildBody(BuildContext context, NotificationModel notification) {
    return new Container(
      padding: EdgeInsets.only(left: 20, top: 40),
      child: ListView(
        children: [
          Row(
            children: [
              Container(
                child: Text(
                  R.of(context).notificationInfoDate+": " + Utils.getDateFromString(notification.date),
                  style: TextStyle(
                    color: Colors.grey[200],
                    fontSize: 20,
                  )
                ),
              ),
            ],
          ),
          Row(
            children: [
              Container(
                padding: EdgeInsets.only(top:10),
                child: Text(
                  R.of(context).notificationInfoTime+": " + Utils.getTimeFromString(notification.date),
                  style: TextStyle(
                    color: Colors.grey[200],
                    fontSize: 20,
                  )
                ),
              )
            ],
          ),
          Container(
            padding: EdgeInsets.only(top: topDistance),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.only(top:20),
                  width: MediaQuery.of(context).size.width*0.8,
                  child: Text(
                    R.of(context).notificationInfoMessage+':  \n\n' + notification.message,
                    style: TextStyle(
                      color: Colors.grey[200],
                      fontSize: 20,
                    )
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
