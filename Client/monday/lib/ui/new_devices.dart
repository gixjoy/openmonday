import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:monday/controller/device_controller.dart';
import 'package:monday/ui/basic_route_structure.dart';
import 'package:monday/model/device_model.dart';
import 'package:monday/ui/device_config.dart';
import 'package:monday/ui/components/custom_progress_indicator.dart';
import 'package:monday/common/r.dart';

class NewDevices extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return new NewDevicesState();
  }
}

class NewDevicesState extends State<NewDevices> {

  Widget drawer;

  static Widget buildListItem (List<DeviceModel> newDevs, BuildContext context, DeviceModel newDev){
    return new Container(
      padding: EdgeInsets.only(top: 5, bottom: 5),
      height: 65,
      child:RaisedButton(
        color: Colors.grey[800].withOpacity(0.5),
        onPressed: () async {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) =>
            DeviceConfig(newDev, "create")));
        },
        child: Center(
          child: Text(
            newDev.description,
            style: TextStyle(
              color: Colors.grey[200],
              fontSize: 17,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  static List<Widget> buildDevicesList(BuildContext context,
      List<DeviceModel> devices){
    List<Widget> result = List();
    devices.forEach((item) {
      DeviceModel dev = item;
      Widget device = buildListItem(devices, context, dev);
      result.add(device);
    });
    return result;
  }

  @override
  Widget build(BuildContext context) {

    final Widget appBar = new AppBar(
      title: new Text(R.of(context).newDevicesTitle),
      backgroundColor: Colors.transparent,
      elevation: 0.0,
    );
    //print("Running new discovery on Monday...");
    Future<List<DeviceModel>> devices = DeviceController
        .getNewDevicesFromMonday(context);

    Widget body = FutureBuilder(
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<DeviceModel> newDevices = snapshot.data;
          if(newDevices.isNotEmpty)
            return new Container(
              child: ListView(
                children: buildDevicesList(context, newDevices),
              )
            );
          else
            return new Center(
              child: Text(
                R.of(context).newDevicesNoDevFound,
                style: TextStyle(
                  color: Colors.grey[200],
                  fontSize: 18,
                ),
              )
            );
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
}