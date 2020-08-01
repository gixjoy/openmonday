import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:monday/ui/basic_route_structure.dart';
import 'package:monday/model/device_model.dart';
import 'package:monday/controller/room_controller.dart';
import 'package:monday/common/monday_icons.dart';
import 'package:monday/controller/device_controller.dart';
import 'package:monday/ui/components/time_buttons_row.dart';
import 'package:monday/ui/device_config.dart';
import 'package:monday/ui/components/chart_consumption.dart';
import 'package:monday/ui/components/custom_progress_indicator.dart';
import 'package:monday/ui/home.dart';
import 'package:monday/common/r.dart';
import 'package:monday/common/r.dart';

class DeviceInfo extends StatefulWidget {

  DeviceModel device;
  DeviceInfo(this.device);

  static DeviceInfoState of(BuildContext context) =>
      // ignore: deprecated_member_use
      context.ancestorStateOfType(const TypeMatcher<DeviceInfoState>());

  @override
  State<StatefulWidget> createState() {
    return new DeviceInfoState(device);
  }
}

class DeviceInfoState extends State<DeviceInfo> {

  DeviceModel device;
  DeviceInfoState(this.device);
  static const double topDistance = 20;

  Widget drawer;

  @override
  Widget build(BuildContext context) {
    Future<String> roomName = RoomController.getDeviceRoomFromMonday(
        context, device);
    Future<String> deviceStatus = DeviceController.getDeviceStatusFromMonday(
        context, device.id);

    Widget appBar = buildAppBar(context, device);

    Widget deviceName = Row(
      children: [
        Text(
            R.of(context).devInfoName+': ' + device.name,
            style: TextStyle(
              color: Colors.grey[200],
              fontSize: 20,
            )
        ),
      ],
    );

    Widget room = FutureBuilder(
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Container(
            padding: EdgeInsets.only(top: topDistance),
            child: Row(
              children: [
                Text(
                    R.of(context).devInfoRoom+': ' + snapshot.data.toString(),
                    style: TextStyle(
                      color: Colors.grey[200],
                      fontSize: 20,
                    )
                ),
              ],
            ),
          );
        }
        else if (snapshot.hasError) {
          return Text("${snapshot.error}", style: Theme
              .of(context)
              .textTheme
              .headline);
        } else {
          return CustomProgressIndicator();
        }
      },
      future: roomName,
    );

    Widget dStatus = FutureBuilder(
      builder: (context, snapshot) {
        String status;
        if (snapshot.hasData) {
          if (snapshot.data != "") {
            if (snapshot.data == "0") {
              status = "Error";
            }
            else
              status = "Working";
            return buildStatusIcon(status);
          }
          else
            return buildStatusIcon("Not available");
        } else if (snapshot.hasError) {
          return Text("${snapshot.error}", style: Theme
              .of(context)
              .textTheme
              .headline);
        } else {
          return CustomProgressIndicator();
        }
      },
      future: deviceStatus,
    );

    Widget typeRow = Container(
      padding: EdgeInsets.only(top: topDistance),
      child: Row(
        children: [
          Text(
              R.of(context).devInfoType+': ',
              style: TextStyle(
                color: Colors.grey[200],
                fontSize: 20,
              )
          ),
          dStatus,
        ],
      ),
    );

    Widget consumptionTextRow = Center (
      child: Container(
        padding: EdgeInsets.only(top: 10),
        child: Text(
          R.of(context).devInfoConsumption,
          style: TextStyle(
            color: Colors.grey[200],
            fontSize: 20,
          ),
        )
      )
    );

    Widget timeSelectionRow = Container(
      padding: EdgeInsets.only(top: topDistance, left:20),
      child: new TimeButtonsRow([R.of(context).timeButtonNow,
                                  R.of(context).timeButtonToday,
                                  R.of(context).timeButtonMonth], "DeviceInfo")
    );

    Widget chartArea = new ChartConsumption.withDeviceId(
        "specific", device.id);

    /*
    Device info section
     */
    Widget deviceInfo = Container(
      padding: EdgeInsets.only(top: topDistance),
      child: Row(
        children: [
          Text(
              'ID: ' + device.id,
              style: TextStyle(
                color: Colors.grey[200],
                fontSize: 14,
              )
          ),
          Container (
            padding: EdgeInsets.only(left:35),
            child: Text(
              'IP: ' + device.ip,
              style: TextStyle(
                color: Colors.grey[200],
                fontSize: 14,
              )
            ),
          ),
        ],
      ),
    );

    /*
    List of all Widgets inside this route
     */
    List<Widget>devInfoElements = [
      deviceName,
      room,
      typeRow,
      Container(
        padding: EdgeInsets.only(top: topDistance),
      ),
      consumptionTextRow,
      timeSelectionRow,
      chartArea,
      deviceInfo
    ];

    Widget body = new Center(
      child: Container (
        padding: EdgeInsets.only(left: 20, top: 40),
        child: ListView(children: devInfoElements)
      ),
    );


    return new BasicRouteStructure(appBar, body, drawer);
  }

  Future<void> _refreshView() async{
    setState(() {

    });
  }

  /*
  Method used for building device type icon, with respect to its status
   */
  Widget buildStatusIcon(String status){
    Color iconColor = Colors.grey[200];
    if (status == "Working")
      iconColor = Colors.blueAccent;
    Icon iconType;
    switch (device.type) {
      case "light":
        iconType = new Icon(Monday.lightbulb, color: iconColor, size: 35,);
        break;
      case "outlet":
        iconType = new Icon(Monday.power, color: iconColor, size: 35,);
        break;
      case "climate":
        iconType = new Icon(Monday.fire, color: iconColor, size: 35,);
        break;
      case "shutter":
        iconType = new Icon(Monday.menu, color: iconColor, size: 35,);
        break;
      case "climate_sensor":
        iconType = new Icon(Monday.temperatire, color: iconColor, size: 35,);
        break;
      case "alarm sensor":
        iconType = new Icon(Monday.shield, color: iconColor, size: 35,);
        break;
    }
    return iconType;
  }

  Widget buildAppBar(BuildContext context, DeviceModel device) {
    return new AppBar(
      title: new Text(R.of(context).devConfigTitle),
      backgroundColor: Colors.transparent,
      elevation: 0.0,
      actions: <Widget>[
        Container(
          padding: EdgeInsets.only(right:20),
          child: IconButton(
            icon: Icon(
                Icons.edit,
                color: Colors.grey[200]
            ),
            onPressed: () {
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (context) =>
                  DeviceConfig(device, "update")));
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
}
