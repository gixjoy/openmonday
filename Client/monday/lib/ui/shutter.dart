import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:monday/controller/shutter_controller.dart';
import 'package:monday/ui/basic_route_structure.dart';
import 'package:monday/ui/device_info.dart';
import 'package:monday/model/shutter_model.dart';
import 'package:monday/controller/device_controller.dart';
import 'package:monday/ui/device_config.dart';
import 'package:monday/ui/components/custom_progress_indicator.dart';
import 'package:monday/common/utils.dart';
import 'package:monday/common/monday_icons.dart';
import 'package:monday/ui/shutter_control.dart';
import 'package:monday/common/r.dart';

class Shutter extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return new ShadeState();
  }
}

class ShadeState extends State<Shutter> {

  Widget drawer;

  @override
  Widget build(BuildContext context) {

    Future<List<ShutterModel>> devices = ShutterController.getShuttersFromMonday(context);

    /*
    AppBar
     */
    Widget appBar = new AppBar(
      title: new Text(R.of(context).shutterTitle),
      backgroundColor: Colors.transparent,
      elevation: 0.0,
    );

    Widget body = FutureBuilder(
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<ShutterModel> shutters = snapshot.data;
          if (shutters.isNotEmpty) {
            return new Container(
              child: ListView(
                children: buildList(snapshot.data, context),
              ),
            );
          }
          else {
            return new Center(
              child: Text(
                R.of(context).devNotAvailable,
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
  Widget buildListItem(ShutterModel shutter, BuildContext context) {
    String name = shutter.name;
    Widget popUpMenu = _buildPopUpMenu(context, shutter);
    return new Card(
      color: Colors.grey[200].withOpacity(0.2),
      child: ListTile(
        leading: IconButton(
          onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) =>
                ShutterControl(shutter.id, shutter.name, shutter.openingLevel)));
          },
          icon: Icon(
            Monday.menu_1,
            size: 28,
            color: Colors.grey[200]
          ),
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
    );
  }

  /*
  Method for building the list of the devices
   */
  List<Widget> buildList(List<ShutterModel> devices, BuildContext context){
    List<Widget> devList = new List();
    devices.forEach((item) {
      Widget newItem = buildListItem (item, context);
      devList.add(newItem);
    });
    return devList;
  }

  /*
  This method is used for creating the popup menu that appears when tapping on
  trailing object of a ListTile object, eg.: Devices
   */
  Widget _buildPopUpMenu(BuildContext context, ShutterModel device) {
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
      ShutterModel device) async {
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
              },
            )
          ],
        );
      },
    );
  }
}

enum ConfirmAction { CANCEL, ACCEPT }