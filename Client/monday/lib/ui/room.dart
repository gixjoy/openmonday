import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:monday/controller/light_controller.dart';
import 'package:monday/controller/outlet_controller.dart';
import 'package:monday/ui/basic_route_structure.dart';
import 'package:monday/common/monday_icons.dart';
import 'package:monday/model/device_model.dart';
import 'package:monday/controller/room_controller.dart';
import 'package:monday/ui/components/on_off_button.dart';
import 'package:monday/controller/device_controller.dart';
import 'package:monday/ui/device_config.dart';
import 'package:monday/ui/device_info.dart';
import 'package:monday/ui/components/custom_progress_indicator.dart';
import 'package:monday/ui/home.dart';
import 'package:monday/controller/shutter_controller.dart';
import 'package:monday/ui/shutter_control.dart';
import 'package:monday/model/shutter_model.dart';
import 'package:monday/common/r.dart';
import 'package:monday/common/r.dart';

class Room extends StatefulWidget {

  final String name;
  final String roomId;
  Room(this.name, this.roomId);

  @override
  State<StatefulWidget> createState() {
    return new RoomState();
  }
}

class RoomState extends State<Room> {

  Widget drawer;
  Future<List<DeviceModel>> devices;

  @override void initState(){
    super.initState();
    devices = RoomController.getRoomDevicesFromMonday(context, widget.roomId);
  }

  @override
  Widget build(BuildContext context) {

    String devNotAvailable = R.of(context).devNotAvailable;//because of a bug reported on https://github.com/flutter/flutter/issues/39593, we use class R instead of class S
    Widget body = FutureBuilder(
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<DeviceModel> devices = snapshot.data;
          if (devices.isNotEmpty) {
            return new Container(
              child: ListView(
                children: buildList(snapshot.data, widget.roomId, context),
              ),
            );
          }
          else {
            return new Center(
              child: Text(
                devNotAvailable,
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
      future: devices,
    );

    Widget appBar = buildAppBar(widget.name);
    return new BasicRouteStructure(appBar, body, drawer);
  }

  /*
  Create Appbar for Room route, with the name of the room inside the title
   */
  Widget buildAppBar(String title){
    return new AppBar(
      title: new Text(title),
      backgroundColor: Colors.transparent,
      elevation: 0.0,
      actions: <Widget>[
        Row(
          children: [
            IconButton(
              icon: Icon(
                Icons.delete,
                size: 32,
                color: Colors.grey[200],
              ),
              onPressed: (){
                _asyncConfirmDialog(context, widget.roomId);
              },
            ),
            Container(width:10)
          ]
        ),
      ]
    );
  }

  static Widget buildLeadingOnOffButton (Future<String> switchStatus,
      String deviceId, String deviceType) {
    return new FutureBuilder(
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          String swStatus = snapshot.data;
          if (swStatus != "") {
            return new OnOffButton(deviceId, deviceType, swStatus);
          }
          else
            return null;
        } else if (snapshot.hasError) {
          return Text("${snapshot.error}", style: Theme
              .of(context)
              .textTheme
              // ignore: deprecated_member_use
              .headline);
        } else {
          return CustomProgressIndicator();
        }
      },
      future: switchStatus,
    );
  }

  static Widget buildLeadingShutterButton (Future<ShutterModel> shutter) {
    return new FutureBuilder(
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          ShutterModel shutterMod = snapshot.data;
          return IconButton(
            onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) =>
                ShutterControl(shutterMod.id, shutterMod.name, shutterMod.openingLevel)));
            },
            icon: Icon(
              Monday.menu_1,
              size: 28,
              color: Colors.grey[200]
            )

          );
        } else if (snapshot.hasError) {
          return Text("${snapshot.error}", style: Theme
              .of(context)
              .textTheme
              // ignore: deprecated_member_use
              .headline);
        } else {
          return CustomProgressIndicator();
        }
      },
      future: shutter,
    );
  }

  /*
  Method for building the items of the list of devices
   */
  Widget buildListItem(DeviceModel device, BuildContext context)  {

    Widget leadingWidget;
    IconData devIcon;
    Widget popUpMenu = _buildPopUpMenu(context, device);

    switch(device.type){
      case "light":
        String deviceId = device.id;
        String deviceType = device.type;
        Future<String> switchStatus = LightController.getSwitchStatusFromMonday(
            context, deviceId);
        leadingWidget = buildLeadingOnOffButton(switchStatus, deviceId, deviceType);
        break;
      case "outlet":
        String deviceId = device.id;
        String deviceType = device.type;
        Future<String> switchStatus = OutletController.getSwitchStatusFromMonday(
            context, deviceId);
        leadingWidget = buildLeadingOnOffButton(switchStatus, deviceId, deviceType);
        break;
      case "climate":
        devIcon = Monday.fire;
        leadingWidget = Icon(
          devIcon,
          color: Colors.grey[200]
        );
        break;
      case "shutter":
        devIcon = Monday.menu_1;
        Future<ShutterModel> shutter = ShutterController.getSingleShutterFromMonday(
              context, device.id);
        leadingWidget = buildLeadingShutterButton(shutter);
        break;
      case "climate_sensor":
        devIcon = Monday.temperatire;
        leadingWidget = Icon(
          devIcon,
          color: Colors.grey[200]
        );
        break;
      case "alarm sensor":
        devIcon = Monday.shield;
        leadingWidget = Icon(
          devIcon,
          color: Colors.grey[200]
        );
        break;
    }
    return new Card(
      color: Colors.grey[200].withOpacity(0.2),
      child: ListTile(
        leading: Container(
          width: 80,
          child: leadingWidget,
        ),
        title: Text(
          device.name,
          style: TextStyle(
            color: Colors.grey[200]
          ),
        ),
        trailing: popUpMenu
      ),
    );
  }

  /*
  Method for building the list of the devices
   */
  List<Widget> buildList(List<DeviceModel> devices, String rId,
      BuildContext context) {
    List<Widget> devList = new List();
    devices.forEach((item) {
      String roomId = item.roomId;
      if (roomId == rId) {
        Widget newItem = buildListItem(item, context);
        devList.add(newItem);
      }
    });
    return devList;
  }

  /*
  This method is used for creating the popup menu that appears when tapping on
  trailing object of a ListTile object, eg.: Devices
   */
  Widget _buildPopUpMenu(BuildContext context, DeviceModel device) {
    return new PopupMenuButton(
      //color: Colors.grey[800],
      onSelected: (item) {
        switch (item) {
          case "Info":
            Navigator.push(context, MaterialPageRoute(builder: (context) =>
                DeviceInfo(device)));
            break;
          case "Edit":
            Navigator.push(context, MaterialPageRoute(builder: (context) =>
                DeviceConfig(device, "update")));
            break;
          case "Delete":
              DeviceController.removeDeviceFromRoomOnMonday(context, device);
              setState(() {
              });
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
          value: "Info",
          child: Text(R.of(context).devicesInfo),
        ),
        PopupMenuItem<String>(
          value: "Edit",
          child: Text(R.of(context).devicesEdit),
        ),
        PopupMenuItem<String>(
          value: "Delete",
          child: Text(R.of(context).devicesDelete),
        ),
      ],
    );
  }

  /*
  Method used for showing confirmation dialog when a room is about to be
  deleted from the system
   */
  Future<ConfirmAction> _asyncConfirmDialog(BuildContext context,
      String roomId) async {
    return showDialog<ConfirmAction>(
      context: context,
      barrierDismissible: false, // user must tap button for close dialog!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(R.of(context).warningMsg),
          content: Text(
              R.of(context).roomConfirmDeletion),
          actions: <Widget>[
            FlatButton(
              child: Text(R.of(context).no),
              onPressed: () {
                Navigator.of(context).pop(ConfirmAction.CANCEL);
              },
            ),
            FlatButton(
              child: Text(R.of(context).yes),
              onPressed: () async {
                if(await RoomController.deleteRoomOnMonday(context, roomId)) {
                  Navigator.of(context).pop(ConfirmAction.ACCEPT);
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Home())
                  );
                }
              }
            ),
          ],
        );
      },
    );
  }
}

enum ConfirmAction { CANCEL, ACCEPT }