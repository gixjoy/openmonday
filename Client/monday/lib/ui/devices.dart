import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:monday/common/shared_prefs.dart';
import 'package:monday/ui/basic_route_structure.dart';
import 'package:monday/common/monday_icons.dart';
import 'package:monday/model/device_model.dart';
import 'package:monday/controller/device_controller.dart';
import 'package:monday/ui/components/custom_progress_indicator.dart';
import 'package:monday/ui/device_config.dart';
import 'package:monday/ui/device_info.dart';
import 'package:monday/ui/home.dart';
import 'package:monday/common/utils.dart';
import 'package:monday/common/r.dart';

class Devices extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return new DevicesState();
  }
}

class DevicesState extends State<Devices>{

  Widget drawer;

  @override
  Widget build(BuildContext context) {

    Future<List<DeviceModel>> devices = DeviceController.getAllDevicesFromMonday(context);

    Widget appBar = new AppBar(
      title: new Text(R.of(context).devices),
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

    String devNotAvailable = R.of(context).devNotAvailable;

    Widget body = FutureBuilder(
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<DeviceModel> devices = snapshot.data;
          if (devices.isNotEmpty) {
            return new Container(
              child: ListView(
                children: buildList(snapshot.data, context),
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

    return new BasicRouteStructure(appBar, body, drawer);
  }

  /*
  Method for building the items of the list of devices
   */
  Widget buildListItem(DeviceModel device, BuildContext context) {
    var leadingWidget;
    IconData devIcon;
    Widget popUpMenu = _buildPopUpMenu(context, device);

    switch (device.type) {
      case "light":
        devIcon = Monday.lightbulb;
        leadingWidget = Icon(
            devIcon,
            color: Colors.grey[200]
        );
        break;
      case "outlet":
        devIcon = Monday.power;
        leadingWidget = Icon(
            devIcon,
            color: Colors.grey[200]
        );
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
        leadingWidget = Icon(
            devIcon,
            color: Colors.grey[200]
        );
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
        leading: leadingWidget,
        title: Row(
          children: [
            Text(
              device.name,
              style: TextStyle(
                  color: Colors.grey[200]
              ),
            ),
          ],
        ),
        trailing: popUpMenu,
      ),
    );
  }

  /*
  Method for building the list of the devices
   */
  List<Widget> buildList(List<DeviceModel> devices, BuildContext context) {
    List<Widget> devList = new List();
    devices.forEach((item) {
      if(item.type != "clock") {
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
            _asyncConfirmDialog(context, device);
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
  Method used for showing confirmation dialog when a device is about to be
  deleted from the system
   */
  Future<ConfirmAction> _asyncConfirmDialog(BuildContext context,
      DeviceModel device) async {
    return showDialog<ConfirmAction>(
      context: context,
      barrierDismissible: false, // user must tap button for close dialog!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(R.of(context).warningMsg),
          content: Text(
              R.of(context).deleteConfirmation),
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
                if(! await DeviceController.deleteDeviceFromMonday(context, device)){
                  Navigator.of(context).pop(ConfirmAction.ACCEPT);
                  Utils.showDialogPanel(
                  R.of(context).warningMsg, R.of(context).deviceRemovalMsg, context);
                }
                else
                  Navigator.of(context).pop(ConfirmAction.ACCEPT);
                setState(() {});
                if(device.type == "climate")
                  SharedPrefs.setClimateControllerEnabled(false);
                if(device.type == "climate_sensor")
                  SharedPrefs.setClimateSensorEnabled(false);
              },
            )
          ],
        );
      },
    );
  }
}

enum ConfirmAction { CANCEL, ACCEPT }