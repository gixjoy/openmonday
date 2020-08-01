import 'package:flutter/material.dart';
import 'package:monday/controller/room_controller.dart';
import 'package:monday/ui/alarm.dart';
import 'package:monday/ui/heater.dart';
import 'package:monday/ui/light.dart';
import 'package:monday/ui/outlet.dart';
import 'package:monday/common/utils.dart';
import 'package:monday/ui/basic_route_structure.dart';
import 'package:monday/ui/shutter.dart';
import 'package:monday/controller/home_controller.dart';
import 'package:monday/model/room_model.dart';
import 'package:monday/ui/new_devices.dart';
import 'package:monday/common/monday_icons.dart';
import 'package:monday/ui/components/custom_progress_indicator.dart';
import 'dart:async';
import 'package:monday/ui/surveillance.dart';
import 'package:monday/common/r.dart';
import 'package:monday/common/r.dart';

  //Constant values
  const double _rowLeftPadding = 20;
  const List<Widget> deviceButtons = [];

class Home extends StatefulWidget {

  /*final String username;
  Home(this.username);*/

  @override
  State<StatefulWidget> createState(){
    return new HomeState();
  }
}

class HomeState extends State<Home> {

  /*String username;
  HomeState(this.username);*/

  /*
  Initialize notification system
   */
  @override
  void initState() {
    super.initState();

    /*String broker = widget.hostname;
    mqClient = new MQClient(broker);
    mqClient.connect();*/
  }

  @override
  Widget build (BuildContext context) {

    Future<String> homeData = HomeController.getHomeDataFromMonday(context);
    Future<List<RoomModel>> rooms = RoomController.getRoomsFromMonday(context);
    Future<String> lastTemperature = HomeController.getLastTemperature(homeData);
    Future<String> lastHumidity = HomeController.getLastHumidity(homeData);
    Future<String> lastBatteryLevel = HomeController.getLastBatteryLevel(homeData);
    Future<String> lastMeasureDate = HomeController.getLastMeasureDate(homeData);

    //Consumptions section
    Widget consumptionsSection = new FutureBuilder<String> (
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Utils.buildMeasureContainer(context, snapshot.data.toString()+' W/h',
              Utils.consumptionIcon);
        } else if (snapshot.hasError) {
          return Text("${snapshot.error}",style: Theme.of(context).textTheme.headline);
        } else {
          return CustomProgressIndicator();
        }
      },
      future: HomeController.getLastConsumptions(homeData),
    );

    //Humidity section
    Widget humiditySection = FutureBuilder<String> (
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Utils.buildMeasureContainer(context, snapshot.data.toString()+' %',
              Monday.droplet);
        } else if (snapshot.hasError) {
          return Text("${snapshot.error}",style: Theme.of(context).textTheme.headline);
        } else {
          return CustomProgressIndicator();
        }
      },
      future: HomeController.getLastHumidity(homeData),
    );

    //Temperature section
    Widget temperatureSection = FutureBuilder<String> (
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Utils.buildMeasureContainer(context, snapshot.data.toString()+' °C',
              Utils.temperatureIcon);
        } else if (snapshot.hasError) {
          return Text("${snapshot.error}",style: Theme.of(context).textTheme.headline);
        } else {
          return CustomProgressIndicator();
        }
      },
      future: HomeController.getLastTemperature(homeData),
    );

    List<Widget> measures = [
      temperatureSection,
      humiditySection,
      consumptionsSection,
    ];

    // Measures row
    Widget measuresRow = Utils.createMeasuresRowList(measures);

    // Welcome text Row
    Widget welcomeSection = Utils.buildTextRow(
        R.of(context).homeWelcome,
        Utils.helloTextSize, Utils.mainTextColor, 0, _rowLeftPadding);

    // Last access Row
    String updatedOn = R.of(context).homeUpdatedOn;
    Widget lastUpdateSection = FutureBuilder<String> (
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Utils.buildTextRow(
                 updatedOn + ": " + snapshot.data.toString(),
                14, Utils.mainTextColor, 10, _rowLeftPadding);
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}",style: Theme.of(context).textTheme.headline);
          } else {
            return CustomProgressIndicator();
          }
        },
        future: HomeController.getLastUpdate(homeData),
    );

    // Devices text Row
    Widget devicesTextSection = Utils.buildTextRow(
        R.of(context).homeDevices,
        Utils.helloTextSize, Utils.mainTextColor, 20, _rowLeftPadding);

    // Room text row
    Widget roomsTextSection = Utils.buildTextRow(
        R.of(context).homeRooms, Utils.helloTextSize, Utils.mainTextColor,
        15, _rowLeftPadding);

    //Devices buttons
    Widget newButton = Utils.createNewDeviceButton(
        context, Monday.new_releases,
        R.of(context).homeNewButton, Utils.iconSize + 6, new NewDevices());
    Widget alarmButton = Utils.createIconButton(
        context, Icons.vpn_key,
        R.of(context).homeAlarmButton, Utils.iconSize + 6, new Alarm());
    Widget lightButton = Utils.createIconButton(
        context, Monday.lightbulb,
        R.of(context).homeLightButton, Utils.iconSize + 6, new Light());
    Widget heatingButton = Utils.createIconButton(
        context, Monday.fire,
        R.of(context).homeClimateButton, Utils.iconSize + 6, new Heater(lastTemperature, lastHumidity,
        lastBatteryLevel, lastMeasureDate));
    Widget shadeButton = Utils.createIconButton(
        context, Monday.menu_1,
        R.of(context).homeShutterButton, Utils.iconSize + 6, new Shutter());
    Widget outletButton = Utils.createIconButton(
        context, Monday.power,
        R.of(context).homeOutletButton, Utils.iconSize + 6, new Outlet());
    Widget surveillanceButton = Utils.createIconButton(
        context, Monday.videocam,
        R.of(context).homeSurveillanceButton, Utils.iconSize + 6, new Surveillance());

    //Devices Row
    List<Widget> devices = [
      newButton,
      alarmButton,
      heatingButton,
      lightButton,
      shadeButton,
      outletButton,
      surveillanceButton
    ];
    Widget devicesList = Utils.createBigHorizontalScrollableList(devices);

    //Rooms row
    Widget roomsList = FutureBuilder (
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Utils.createBigHorizontalScrollableList(snapshot.data);
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}",style: Theme.of(context).textTheme.headline);
          } else {
            return CustomProgressIndicator();
          }
        },
        future: Utils.buildRoomButtons(context, rooms),
    );


    //List with all elements to put on the Home route
    List<Widget> homeRouteElements = [
      measuresRow,
      welcomeSection,
      lastUpdateSection,
      devicesTextSection,
      devicesList,
      roomsTextSection,
      roomsList
    ];

    /*
    appBar, body and drawer are the components of the Scaffold containing all
    the elements of the Home route
     */
    Widget appBar = new AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0.0,
      leading: Builder(
        builder: (BuildContext context) {
          return IconButton(
            icon: Icon(Utils.menuIcon),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          );
        },
      ),
    );

    /*Widget body = new Container (
      child: ListView(children: homeRouteElements),
    );*/

    Widget body = new Container(
      child: new Center(
        child: new RefreshIndicator(
          child: ListView(children: homeRouteElements),
          onRefresh: _refreshHome,
        )
      )
    );

    //Widget drawer = Utils.createDrawer(context);
    Widget drawer = Theme(
      data: Theme.of(context).copyWith(canvasColor: Colors.transparent),
      child: Utils.createDrawer(context)
    );

    return new MaterialApp (
      home: new BasicRouteStructure(appBar, body, drawer),
      debugShowCheckedModeBanner: false,
    );
  }

  Future<void> _refreshHome() async{
    setState(() {

    });
  }
}