import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:monday/controller/outlet_controller.dart';
import 'package:monday/ui/basic_route_structure.dart';
import 'package:monday/ui/device_info.dart';
import 'package:monday/model/outlet_model.dart';
import 'package:monday/ui/components/on_off_button.dart';
import 'package:monday/controller/device_controller.dart';
import 'package:monday/ui/device_config.dart';
import 'package:monday/ui/components/custom_progress_indicator.dart';
import 'package:monday/common/utils.dart';
import 'package:monday/common/r.dart';

class Outlet extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return new OutletState();
  }
}

class OutletState extends State<Outlet> {

  Widget drawer;

  @override
  Widget build(BuildContext context) {

    Future<List<OutletModel>> devices = OutletController.getOutletsFromMonday(context);

    /*
    AppBar
    */
    Widget appBar = new AppBar(
        title: new Text(R.of(context).outletTitle),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      );

    Widget body = FutureBuilder(
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<OutletModel> outlets = snapshot.data;
          if (outlets.isNotEmpty) {
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
  Widget buildListItem(OnOffButton switchButton, OutletModel outlet,
      BuildContext context) {
    String name = outlet.name;
    Widget popUpMenu = _buildPopUpMenu(context, outlet);
    return new Card(
      color: Colors.grey[200].withOpacity(0.2),
      child: ListTile(
        leading: switchButton,
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
  List<Widget> buildList(List<OutletModel> devices, BuildContext context){
    List<Widget> devList = new List();
    devices.forEach((item) {
      String id = item.id;
      String switchStatus = item.switchStatus;
      OnOffButton switchButton = new OnOffButton(id, item.type, switchStatus);
      Widget newItem = buildListItem (switchButton, item, context);
      devList.add(newItem);
    });
    return devList;
  }

  /*
  This method is used for creating the popup menu that appears when tapping on
  trailing object of a ListTile object, eg.: Devices
   */
  Widget _buildPopUpMenu(BuildContext context, OutletModel device) {
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
      OutletModel device) async {
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