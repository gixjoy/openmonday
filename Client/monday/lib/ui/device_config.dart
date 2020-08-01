import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:monday/common/shared_prefs.dart';
import 'package:monday/controller/room_controller.dart';
import 'package:monday/ui/basic_route_structure.dart';
import 'package:monday/model/device_model.dart';
import 'package:monday/ui/components/room_buttons_row_selection.dart';
import 'package:monday/ui/components/text_input_field.dart';
import 'package:monday/common/utils.dart';
import 'package:monday/model/room_model.dart';
import 'package:monday/ui/components/type_buttons_row.dart';
import 'package:monday/controller/device_controller.dart';
import 'package:monday/ui/new_devices.dart';
import 'package:monday/ui/device_info.dart';
import 'package:monday/ui/components/custom_progress_indicator.dart';
import 'package:monday/common/monday_icons.dart';
import 'package:monday/common/r.dart';

class DeviceConfig extends StatelessWidget {

  DeviceModel device;
  String action;//action to be performed when forward button is pressed
  DeviceConfig(this.device, this.action);

  //Drawer
  Widget drawer;


  @override
  Widget build(BuildContext context) {

    //Device name field
    TextEditingController nameController = TextEditingController();
    Widget devNameField = new TextInputField(R.of(context).devInfoName, nameController, false, true);

    Future<bool> climateControllerEnabled = SharedPrefs.getClimateControllerEnabled();
    Future<bool> climateSensorEnabled = SharedPrefs.getClimateSensorEnabled();
    Future<Widget> futureTypesRow = buildTypeSelectionRow(context,
        climateControllerEnabled, climateSensorEnabled);
    Future<List<RoomModel>> rooms = RoomController.getRoomsFromMonday(context);

    Widget appBar = new AppBar(
      title: new Text(R.of(context).devConfigTitle),
      backgroundColor: Colors.transparent,
      elevation: 0.0,
    );

    //Types row
    Widget typeTextRow = Container(
      padding: EdgeInsets.only(top:20, bottom: 20),
      child: Center(
        child: Text(
          R.of(context).devConfigSelectDeviceText,
          style: TextStyle(
            color: Colors.grey[200],
            fontSize: 18
          )
        )
      )
    );

    Widget typesRow = FutureBuilder (
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return snapshot.data;
        } else if (snapshot.hasError) {
          return Text("${snapshot.error}",style: Theme.of(context).textTheme.headline);
        } else {
          return CustomProgressIndicator();
        }
      },
      future: futureTypesRow,
    );

    //Text field for room selection
    Widget roomSelection = FutureBuilder (
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<RoomModel> roomList = snapshot.data;
          if (roomList.isNotEmpty)
            return Utils.createTextRow(
              R.of(context).roomSelectionDevice, 20, 20);
          else {
            return Utils.createTextRow(
              "", 20, 20);
          }
        } else if (snapshot.hasError) {
          return Text("${snapshot.error}",style: Theme.of(context).textTheme.headline);
        } else {
          return CustomProgressIndicator();
        }
      },
      future: rooms,
    );

    //Rooms row
    Widget roomButtons = FutureBuilder (
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<RoomModel> roomList = snapshot.data;
          if (roomList.isNotEmpty)
            return new RoomButtonsRowSelection(roomList, true);
          else {
            return new Container (
              padding: EdgeInsets.only(bottom:100),
              child: Center (
                child: Text(
                  R.of(context).roomNotAvailable,
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 18
                  ),
                ),
              ),
            );
          }
        } else if (snapshot.hasError) {
          return Text("${snapshot.error}",style: Theme.of(context).textTheme.headline);
        } else {
          return CustomProgressIndicator();
        }
      },
      future: rooms,
    );

    Widget body = new GestureDetector(
      onTap: (){
        FocusScope.of(context).unfocus();
      },
      child: Container(
        child: ListView(
          children: [
            Container(
              height: 20,
            ),
            devNameField,
            typeTextRow,
            typesRow,
            roomSelection,
            roomButtons,
            Container (
              padding: const EdgeInsets.only(top:30),
              child: IconButton(//button for sending data to Monday
                onPressed: () async {
                  //DeviceModel
                  device.name = nameController.text;
                  if(!Utils.validateInputText((device.name)))
                    Utils.showDialogPanel(R.of(context).warningMsg,
                    R.of(context).textInputWrongChars, context);
                  else {
                    if(device.name != "") {
                      if(device.type == "climate")//reset climate controller availability for the types to choose among
                        SharedPrefs.setClimateControllerEnabled(false);
                      if(device.type == "climate_sensor")//reset climate sensor availability for the types to choose among
                        SharedPrefs.setClimateSensorEnabled(false);
                      device.type = Utils.deviceType;
                      if (device.type != "") {
                        nameController.text = ""; //refresh text of name controller
                        if (Utils.selectedRoom != null)
                          device.roomId = Utils.selectedRoom.id;
                        if (await DeviceController.updateDeviceOnMonday(
                            context, device)) {
                          Utils.selectedRoom = null;
                          Utils.deviceType = null;
                          //Navigator.pop(context, true);
                          if (action == "update") {//see DeviceInfo edit button
                            Navigator.pushReplacement(
                              context, MaterialPageRoute(builder: (context) =>
                              DeviceInfo(device)));
                          }
                          else//see NewDevices forward button
                            Navigator.pushReplacement(
                              context, MaterialPageRoute(builder: (context) =>
                              NewDevices()));
                        }
                      }
                      else{
                        Utils.showDialogPanel(
                          R.of(context).devWarningTypeSelectionTitle,
                          R.of(context).devWarningTypeSelectionBody, context);
                      }
                    }
                    else{
                      Utils.showDialogPanel(
                        R.of(context).devWarningTypeSelectionTitle,
                        R.of(context).devWarningNameSelectionBody,  context);
                    }
                  }
                },
                icon: Icon(
                  Monday.keyboard_arrow_right,
                  color: Colors.grey[200],
                  size: 60,
                ),
              ),
            ),
          ]
        )
      ),
    );

    return new BasicRouteStructure(appBar, body, drawer);
  }

  /*
  It creates the list of images paths (strings) for the buttons to show
  inside the route
   */
  Future<List<String>> getImgPaths(Future<List<RoomModel>> records) async{
    List<RoomModel> rooms = await records;
    List<String> result = List();
    rooms.forEach((item){
      result.add(item.imgPath);
    });
    return result;
  }

  /*Used for building the types row with correct types, considering that climate
  sensor and climate controller have already been installed or not.
  The system only allows to install one climate controller and one climate_sensor,
  so when they have already been installed and configured, the corresponding types
  are not shown in row types during configuration of new devices.
   */
  Future<Widget> buildTypeSelectionRow(BuildContext context,
      Future<bool> climateControllerEnabled, Future<bool> climateSensorEnabled) async {
    List<String> typeItems;
    if (await climateControllerEnabled != null && await climateControllerEnabled){
      typeItems = [R.of(context).deviceLight, R.of(context).deviceOutlet,
        R.of(context).deviceShutter, R.of(context).deviceClimateSensor,
        R.of(context).deviceAlarmSensor];
      if (await climateSensorEnabled != null && await climateSensorEnabled){
        typeItems = [R.of(context).deviceLight, R.of(context).deviceOutlet,
        R.of(context).deviceShutter, R.of(context).deviceAlarmSensor];
      }
    }
    else {
      typeItems = [R.of(context).deviceLight, R.of(context).deviceOutlet,
        R.of(context).deviceClimate, R.of(context).deviceShutter, R.of(context).deviceClimateSensor,
        R.of(context).deviceAlarmSensor];
      if (await climateSensorEnabled != null && await climateSensorEnabled){
        typeItems = [R.of(context).deviceLight, R.of(context).deviceOutlet,
        R.of(context).deviceClimate, R.of(context).deviceShutter, R.of(context).deviceAlarmSensor];
      }
    }
    return new TypeButtonsRow(typeItems);
  }
}