import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:monday/controller/notification_controller.dart';
import 'package:monday/ui/basic_route_structure.dart';
import 'package:monday/model/notification_model.dart';
import 'package:monday/common/monday_icons.dart';
import 'package:monday/ui/components/custom_progress_indicator.dart';
import 'package:monday/ui/notification_info.dart';
import 'package:monday/ui/home.dart';
import 'package:monday/common/r.dart';

class Notifications extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return new NotificationsState();
  }
}

class NotificationsState extends State<Notifications> {

  Widget drawer;

  @override
  Widget build(BuildContext context) {

    Future<List<NotificationModel>> notifications =
      NotificationController.getNotificationsFromMonday(context);

      /*
    AppBar
     */
    Widget appBar = buildAppBar(context);

    Widget body = FutureBuilder(
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<NotificationModel> lights = snapshot.data;
          if (lights.isNotEmpty) {
            return new Container(
              child: ListView(
                children: buildList(snapshot.data, context),
              ),
            );
          }
          else {
            return new Center(
              child: Text(
                R.of(context).notificationsNoNotificationAvailable,
                style: TextStyle(
                  color: Colors.grey[200],
                  fontSize: 18,
                )
              )
            );
          }
        } else if (snapshot.hasError) {
          return Text("${snapshot.error}", style: Theme
              .of(context)
              .textTheme
              .headline);
        } else {
          return CustomProgressIndicator();
        }
      },
      future: notifications,
    );

    return new BasicRouteStructure(appBar, body, drawer);
  }

  /*
  Method for building the items of the list of devices
   */
  Widget buildListItem(NotificationModel notification,
      BuildContext context) {
    String name = notification.getTruncatedMessage();
    Widget popUpMenu = _buildPopUpMenu(context, notification);
    return new Card(
      color: Colors.grey[200].withOpacity(0.2),
      child: Column (
        children: [
          ListTile(
            leading: Icon(
              Monday.chat,
              color: Colors.grey[200],
            ),
            title: Row(
              children: [
                Text(
                  name,
                  style: TextStyle(
                    color: Colors.grey[200]
                  ),
                ),
              ],
            ),
            trailing: popUpMenu,
          ),
          Container(
            padding: EdgeInsets.only(bottom: 10, right:58),
            child: Text(
              notification.date,
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey[200],
              ),
            ),
          )
        ],
      ),
    );
  }

  /*
  Method for building the list of the devices
   */
  List<Widget> buildList(List<NotificationModel> notifications, BuildContext context){
    List<Widget> devList = new List();
    notifications.forEach((item) {
      Widget newItem = buildListItem (item, context);
      devList.add(newItem);
    });
    return devList;
  }

  /*
  This method is used for creating the popup menu that appears when tapping on
  trailing object of a ListTile object, eg.: Devices
   */
  Widget _buildPopUpMenu(BuildContext context, NotificationModel notification) {
    return new PopupMenuButton(
      //color: Colors.grey[800],
      onSelected: (item) {
        switch (item) {
          case "Show":
            Navigator.push(context, MaterialPageRoute(builder: (context) =>
                NotificationInfo(notification)));
            break;
          case "Delete":
              _asyncConfirmDialog (context, notification);
            break;
        }
      },
      child: IconButton(
        icon: Icon(
          Icons.more_vert,
          color: Colors.grey[200],
        ),
      ),
      itemBuilder: (BuildContext context) =>
      <PopupMenuEntry<String>>[
        PopupMenuItem<String>(
          value: "Show",
          child: Text(R.of(context).notificationsShow),
        ),
        PopupMenuItem<String>(
          value: "Delete",
          child: Text(R.of(context).notificationsDelete),
        ),
      ],
    );
  }

  /*
  Method used for showing confirmation dialog when a notification is about to be
  deleted from the system (on single item of the list of notifications)
   */
  Future<ConfirmAction> _asyncConfirmDialog(BuildContext context,
      NotificationModel notification) async {
    return showDialog<ConfirmAction>(
      context: context,
      barrierDismissible: false, // user must tap button for close dialog!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(R.of(context).warningMsg),
          content: Text(R.of(context).notificationsDeleteOneConf),
          actions: <Widget>[
            FlatButton(
              child: Text(R.of(context).no),
              onPressed: () {
                Navigator.of(context).pop(ConfirmAction.CANCEL);
              },
            ),
            FlatButton(
              child: Text(R.of(context).yes),
              onPressed: () {
                Navigator.of(context).pop(ConfirmAction.ACCEPT);
                NotificationController.deleteNotificationFromRoomOnMonday(context,
                    notification);
                setState(() {

                });
              },
            )
          ],
        );
      },
    );
  }

  Widget buildAppBar(BuildContext context) {
    return new AppBar(
      title: new Text(R.of(context).notificationsTitle),
      backgroundColor: Colors.transparent,
      elevation: 0.0,
      actions: <Widget>[
        Container(
          padding: EdgeInsets.only(right:20),
          child: IconButton(
            icon: Icon(
                Icons.delete,
                color: Colors.grey[200]
            ),
            onPressed: () {
              _asyncConfirmDialogTrashAll(context);
            },
          ),
        ),
      ],
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: Colors.grey[200]),
        onPressed: () async {
          Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => Home()));
        }
      ),
    );
  }

  /*
  Method used for showing confirmation dialog when all notifications are about
  to be deleted from the system from trashbin button on the appbar
   */
  Future<ConfirmAction> _asyncConfirmDialogTrashAll(BuildContext context) async {
    return showDialog<ConfirmAction>(
      context: context,
      barrierDismissible: false, // user must tap button for close dialog!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(R.of(context).warningMsg),
          content: Text(
              R.of(context).notificationsDeleteConf),
          actions: <Widget>[
            FlatButton(
              child: Text(R.of(context).no),
              onPressed: () {
                Navigator.of(context).pop(ConfirmAction.CANCEL);
              },
            ),
            FlatButton(
              child: Text(R.of(context).yes),
              onPressed: () {
                Navigator.of(context).pop(ConfirmAction.ACCEPT);
                NotificationController.deleteAllNotificationsFromMonday(context);
                setState(() {

                });
              },
            )
          ],
        );
      },
    );
  }
}

enum ConfirmAction { CANCEL, ACCEPT }

