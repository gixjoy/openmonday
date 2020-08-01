import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:monday/model/action_model.dart';
import 'package:monday/ui/basic_route_structure.dart';
import 'package:monday/model/device_model.dart';
import 'package:monday/controller/device_controller.dart';
import 'package:monday/common/monday_icons.dart';
import 'package:monday/ui/components/on_off_panel_device.dart';
import 'package:monday/ui/components/custom_progress_indicator.dart';
import 'package:monday/common/utils.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:monday/common/r.dart';
import 'package:monday/ui/components/shutter_panel.dart';

class DevicesAction extends StatefulWidget {

  String sceneType;
  DevicesAction(this.sceneType);

  @override
  State<StatefulWidget> createState(){
    return new DevicesActionState();
  }
}

class DevicesActionState extends State<DevicesAction> {

  Widget drawer;

  @override
  Widget build(BuildContext context) {
    Future<List<DeviceModel>> devices = DeviceController.getAllDevicesFromMonday(context);

    /*
      AppBar
    */
    Widget appBar = new AppBar(
      title: new Text(R.of(context).devConfigTitle),
      backgroundColor: Colors.transparent,
      elevation: 0.0,
    );

    Widget devicesList = FutureBuilder(
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<DeviceModel> devices = snapshot.data;
          if (devices.isNotEmpty) {
            return new ListView(
                children: buildList(snapshot.data, context),
            );
          }
          else {
            return new Center(
                child: Text(
                    R.of(context).devActionNoDevice,
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
          return new CustomProgressIndicator();
        }
      },
      future: devices,
    );

    Widget body = new ListView(
      children: [
        Container(
          height: 450,
          child: devicesList
        ),
        Container(
          height: 50
        ),
      ],
    );

    return new BasicRouteStructure(appBar, body, drawer);
  }

  /*
  Method for building the items of the list of devices
   */
  Widget buildListItem(DeviceModel device, BuildContext context) {
    var leadingWidget;
    IconData devIcon;
    switch (device.type) {
      case "light":
        devIcon = Monday.lightbulb;
        leadingWidget = Icon(
            devIcon,
            color: Colors.grey[200],
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
      case "alarm_sensor":
        devIcon = Monday.shield;
        leadingWidget = Icon(
            devIcon,
            color: Colors.grey[200]
        );
        break;
      case "clock":
        devIcon = Monday.clock;
        leadingWidget = Icon(
            devIcon,
            color: Colors.grey[200]
        );
        break;
    }
    return new GestureDetector(
      onTap: (){
        if(device.type == "shutter")
          _showModalShutterAction(device);
        else
          _showModalOnOffAction(device);
      },
      child: Card(
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
        ),
      ),
    );
  }

  Widget buildTimeItem(DeviceModel device) {
    return new GestureDetector(
      onTap: () {
        DatePicker.showTimePicker(
          context,
          theme: DatePickerTheme(
            backgroundColor: Colors.grey[600],
            containerHeight: 220.0,
            itemStyle: TextStyle(
              color: Colors.grey[200],
            ),
          ),
          showTitleActions: true,
          showSecondsColumn: true,
          onConfirm: (time) {
            int seconds = (time.hour*3600)+(time.minute*60)+time.second;
            ActionModel action = new ActionModel("", device.id,
              device.name, device.type, seconds.toString());
              Utils.actions.add(action);
              Navigator.pop(context);//close the modalSheet
          },
          currentTime: DateTime.now(),
          locale: LocaleType.it,
        );
      },
      child: Card(
        color: Colors.grey[200].withOpacity(0.2),
        child: ListTile(
          leading: Icon(
            Monday.clock,
            color: Colors.grey[200]
          ),
          title: Row(
            children: [
              Text(
                "Timer",
                style: TextStyle(
                    color: Colors.grey[200]
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /*
  Method for building the list of the devices
   */
  List<Widget> buildList(List<DeviceModel> devices, BuildContext context) {
    List<Widget> devList = new List();
    devices.forEach((item) {
      if (item.type == "clock"){
        Widget newItem = buildTimeItem(item);
        devList.add(newItem);
      }
      else {
        if (widget.sceneType == "manual") {
          if(item.type != "climate_sensor" && item.type != "climate") {//in manual scene must not be possible to turn on/off heaters
            Widget newItem = buildListItem(item, context);
            devList.add(newItem);
          }
        }
        else{
          if(item.type != "climate_sensor") {
            Widget newItem = buildListItem(item, context);
            devList.add(newItem);
          }
        }
      }
    });
    return devList;
  }

  void _showModalOnOffAction(DeviceModel device) {
    showModalBottomSheet<void>(
      backgroundColor: Colors.transparent.withOpacity(0.8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      context: context,
      builder: (BuildContext context) {
        return Container(
          margin: const EdgeInsets.only(top: 5, left: 15, right: 15),
          height: 200,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              OnOffPanelDevice(device),

              Container(
                height: 10
              ),
            ]
          ),
        );
      }
    );
  }

  void _showModalShutterAction(DeviceModel device) {
    showModalBottomSheet<void>(
      backgroundColor: Colors.transparent.withOpacity(0.8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      context: context,
      builder: (BuildContext context) {
        return Container(
          margin: const EdgeInsets.only(top: 5, left: 15, right: 15),
          height: 310,
          child: ShutterPanel(device)
        );
      }
    );
  }
}

