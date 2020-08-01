import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:monday/ui/login.dart';
import 'package:monday/ui/new_room.dart';
import 'package:monday/model/room_model.dart';
import 'package:monday/ui/components/room_button.dart';
import 'package:monday/ui/devices.dart';
import 'package:monday/ui/user_account.dart';
import 'package:monday/ui/notification.dart';
import 'package:monday/ui/chart.dart';
import 'package:monday/ui/scene.dart';
import 'package:monday/ui/new_manual_scene.dart';
import 'package:monday/ui/new_automated_scene.dart';
import 'package:monday/model/action_model.dart';
import 'package:monday/model/time_condition_model.dart';
import 'package:monday/model/temperature_condition_model.dart';
import 'package:monday/model/humidity_condition_model.dart';
import 'package:monday/model/consumption_condition_model.dart';
import 'dart:ui';
import 'package:monday/controller/client_controller.dart';
import 'package:monday/ui/system_info.dart';
import 'package:monday/common/r.dart';

const String _kFontFam = 'Monday';

class Utils {

  //Colors
  static int _mainTextColor = 200;
  static int _littleTextColor = 500; //color to be used for little text representation
  static int _backgroundColor = 800; //color to be used for background

  //Sizes
  static double _mainTextSize = 18;
  static double _helloTextSize = 18;
  static double _littleTextSize = 16;
  static double _iconSize = 30;

  //Icons
  static IconData _menuIcon = const IconData(0xe800, fontFamily: _kFontFam); //icon for AppBar menu
  static IconData _lightbulbIcon = const IconData(0xe802, fontFamily: _kFontFam); //icon for lights
  static IconData _temperatureIcon = const IconData(0xe803, fontFamily: _kFontFam); //icon for temperature
  static IconData _humidityIcon = const IconData(0xe804, fontFamily: _kFontFam); //icon for temperature
  static IconData _fireIcon = const IconData(0xe808, fontFamily: _kFontFam); //icon for heating system
  static IconData _shadeIcon = const IconData(0xe801, fontFamily: _kFontFam); //icon for shutters
  static IconData _shieldIcon = const IconData(0xf132, fontFamily: _kFontFam); //icon for alarm
  static IconData _consumptionIcon = const IconData(0xe805, fontFamily: _kFontFam); //icon for consumptions
  static IconData _outletIcon = const IconData(0xe806, fontFamily: _kFontFam); //icon for outlet
  static IconData _plusIcon = const IconData(0xe80e, fontFamily: _kFontFam); //icon for plus sign in Home route, for adding rooms
  static IconData _newDevsIcon = const IconData(0xe814, fontFamily: _kFontFam);
  static IconData torso = const IconData(0xe815, fontFamily: _kFontFam);
  static IconData device_hub = const IconData(0xe81a, fontFamily: _kFontFam);
  static IconData cog_alt = const IconData(0xe81b, fontFamily: _kFontFam);
  static IconData chart_bar = const IconData(0xe81c, fontFamily: _kFontFam);
  static IconData help = const IconData(0xe81d, fontFamily: _kFontFam);
  static IconData logout = const IconData(0xe81e, fontFamily: _kFontFam);
  static IconData bell_alt = const IconData(0xf0f3, fontFamily: _kFontFam);
  static IconData circle_empty = const IconData(0xf10c, fontFamily: _kFontFam);

  //Global variables
  static String roomCategory = "";
  static String roomButtonImgPath = "";
  static RoomModel selectedRoom = new RoomModel();
  static String deviceType = "";
  static String selectedTime = "";

  //Global variables for Scene management
  static List<ActionModel> actions = List();
  static TimeConditionModel timeCondition = new TimeConditionModel('10', '00',
      List(), List(), '0', '0');
  static TemperatureConditionModel temperatureCondition =
    new TemperatureConditionModel('20', '','0');
  static HumidityConditionModel humidityCondition = new HumidityConditionModel('50', '', '0');
  static ConsumptionConditionModel consumptionCondition =
    new ConsumptionConditionModel('1000', '', '0');
  static String sceneType = "";
  static int climateEditModeEnabled = 0;//it is used for automated scenes, for showing climate conditions. It is set to 1 from within EditAutomatedScene
  static int consumptionEditModeEnabled = 0;//it is used for automated scenes, for showing consumption conditions. It is set to 1 from within EditAutomatedScene
  static int timeEditModeEnabled = 0;//it is used for automated scenes, for showing time conditions. It is set to 1 from within EditAutomatedScene
  static int actionsEditModeEnabled = 0;//it is used for automated and manual scenes, when scenes and actions are edited

  static void resetTemperatureCondition(){
    temperatureCondition = new TemperatureConditionModel('20', '','0');
  }

  static void resetHumidityCondition(){
    humidityCondition = new HumidityConditionModel('50', '', '0');
  }

  static void resetConsumptionCondition(){
    consumptionCondition = new ConsumptionConditionModel('1000', '', '0');
  }

  static void resetTimeCondition(){
    timeCondition = new TimeConditionModel('10', '00', List(), List(), '0', '0');
  }

  /*
  It creates a text row in the home route
   */
  static Container buildTextRow(String text, double size, int color,
      double topPadding, double leftPadding){
    return Container(
      padding: EdgeInsets.only(top:topPadding),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.only(top:10, left:leftPadding),
            child: Row(
              children: [
                Container(
                  child: Text(
                    text,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: size,
                      color: Colors.grey[color],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /*
  It creates button for adding new elements like scenes, rooms, etc.
   */
  static Widget createAddButton(BuildContext context, String destinationRoute) {
    return new Container(
      padding: const EdgeInsets.only(top:15, left: 20),
      child: Container(
        width: 100,
        height: 120,
        color: Colors.transparent,
        child: RaisedButton(
          color: Colors.grey[200].withOpacity(0.20),
          shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(10.0)),
          onPressed: () {
            if (destinationRoute == "NewRoom")
              Navigator.push(context,
                MaterialPageRoute(builder: (context) => NewRoom()));
            if(destinationRoute == "NewAutomatedScene") {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => NewAutomatedScene()));
            }
            if(destinationRoute == "NewManualScene") {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => NewManualScene()));
            }
          },
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.only(top:40),
                child: Icon(
                  _plusIcon,
                  color: Colors.grey[_mainTextColor],
                  size: 28,
                ),
              ),
              Container(
                padding: const EdgeInsets.only(top:15),
                child: Text(
                  R.of(context).homeAddRoom,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: Colors.grey[_mainTextColor],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /*
  It creates a device button in the home view
   */
  static Widget createIconButton(BuildContext context, IconData icon,
      String label, double iconSize, Widget newRoute) {
    return new Container(
      padding: const EdgeInsets.only(top:25, left: 20),
      child: Container(
        width: 90,
        height: 120,
        color: Colors.transparent,
        child: RaisedButton(
          color: Colors.grey[200].withOpacity(0.20),
          shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(10.0)),
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => newRoute)
            );
          },
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.only(top:30),
                child: Icon(
                  icon,
                  color: Colors.grey[_mainTextColor],
                  size: iconSize,
                ),
              ),
              Container(
                padding: const EdgeInsets.only(top:15),
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w400,
                    color: Colors.grey[_mainTextColor],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /*
  It creates the "New devices" button in the home view
   */
  static Widget createNewDeviceButton(BuildContext context, IconData icon,
      String label, double iconSize, StatefulWidget newRoute) {
    return new Container(
      padding: const EdgeInsets.only(top:25, left: 20),
      child: Container(
        width: 90,
        height: 120,
        color: Colors.transparent,
        child: RaisedButton(
          color: Colors.grey[200].withOpacity(0.20),
          shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(10.0)),
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => newRoute)
            );
          },
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.only(top:30),
                child: Icon(
                  icon,
                  color: Colors.grey[_mainTextColor],
                  size: iconSize,
                ),
              ),
              Container(
                padding: const EdgeInsets.only(top:15),
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w400,
                    color: Colors.grey[_mainTextColor],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /*
  It creates an item for the drawer of the Scaffold in the home page screen
   */
  static Widget createDrawerItem (BuildContext context, Widget route,
      String itemName) {
    IconData itemIcon;
    if(itemName == R.of(context).drawerUserAccount)
      itemIcon = torso;
    if(itemName == R.of(context).drawerNotifications)
      itemIcon = bell_alt;
    if(itemName == R.of(context).drawerDevices)
      itemIcon = device_hub;
    if(itemName == R.of(context).drawerScenes)
      itemIcon = cog_alt;
    if(itemName == R.of(context).drawerCharts)
      itemIcon = chart_bar;
    if(itemName == R.of(context).drawerInfo)
      itemIcon = help;
    if(itemName == R.of(context).drawerLogout)
      itemIcon = logout;
    return Container(
      //padding: EdgeInsets.only(top:10),
      decoration: new BoxDecoration (
        //borderRadius: new BorderRadius.circular(10.0),
      ),
      child: ListTile(
        leading: Icon(
          itemIcon,
          size: 28,
          color: Colors.grey[200],
        ),
        title: Text(
          itemName,
          style: TextStyle(
            color: Colors.grey[200]
          )
        ),
        onTap: () {
          if(itemName == "Logout") {
            ClientController.logout(context);
            Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => route));
          }
          else
            Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => route));
          // Then close the drawer
          //Navigator.pop(context);
        },
      ),
    );
  }

  /*
  It creates the drawer for the home page screen
   */
  static Drawer createDrawer(BuildContext context){
    return Drawer(
      child: Stack(
          children: <Widget> [
              //first child be the blur background
              BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.grey[800].withOpacity(0.5)
                    )
                  )
              ),
              ListView(
                  padding: EdgeInsets.zero,
                  children: <Widget>[
                    UserAccountsDrawerHeader(
                      accountName: Text(
                        "",
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey[200]
                        ),
                      ),
                      currentAccountPicture: CircleAvatar(
                        backgroundColor:
                            Theme.of(context).platform == TargetPlatform.iOS
                                ? Colors.blue
                                : Colors.white,
                        child: Text(
                          "Monday",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.blueAccent,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: ExactAssetImage('assets/images/background.jpg'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    createDrawerItem(context, UserAccount(), R.of(context).drawerUserAccount),
                    createDrawerItem(context, Notifications(), R.of(context).drawerNotifications),
                    createDrawerItem(context, Devices(), R.of(context).drawerDevices),
                    createDrawerItem(context, Scene(), R.of(context).drawerScenes),
                    createDrawerItem(context, Chart(), R.of(context).drawerCharts),
                    createDrawerItem(context, SystemInfo(), R.of(context).drawerInfo),
                    createDrawerItem(context, Login(false), R.of(context).drawerLogout),
                  ]
              )
          ]
      )
    );
  }


  /*
  This method is used for creating the top row in Home route
   */
  static Widget createMeasuresRowList(List<Widget> measures){
    ListView scrollableRow = new ListView(scrollDirection: Axis.horizontal,
                                        children: measures);
    return new Container(
      height: 80,
      child: scrollableRow,
    );
  }

  /*
  It creates the list of horizontal scrollable big buttons for devices and rooms
  in the home view
   */
  static Widget createBigHorizontalScrollableList(List<Widget> buttons) {
    ListView scrollableRow = new ListView(scrollDirection: Axis.horizontal,
                                        children: buttons);
    return new Container(
      height: 150,
      //padding: const EdgeInsets.only(bottom:50),
      child: scrollableRow,
    );
  }

  /*
  It creates a list of horizontal scrollable small buttons
   */
  static Widget createSmallHorizontalScrollableList(List<Widget> buttons){
    ListView scrollableRow = new ListView(scrollDirection: Axis.horizontal,
                                        children: buttons);
    return new Container(
      height: 60,
      //padding: const EdgeInsets.only(bottom:50),
      child: scrollableRow,
    );
  }

  /*
  It creates an alert dialog with specified title and body contents
   */
  static void showDialogPanel(String title, String body, BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
            title: new Text(title),
            content: new Text(body),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20)),
            ),
            backgroundColor: Colors.grey[200],
            actions: <Widget>[
              new FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: new Text("Chiudi"))
            ]
        );
      }
    );
  }

  /*
  This method is used for creating measure text and icon to show on top
  of Home route, inside measuresRow section
   */
  static Widget buildMeasureContainer(BuildContext context, String text,
      IconData icon){
    return new GestureDetector (
      onTap: (){
        Navigator.push(context, MaterialPageRoute(
            builder: (BuildContext context) => new Chart()
        ));
      },
      child: Container(
        padding: const EdgeInsets.only(left: 20),
        child: Row (
          children: [
            Container( //Average temperature value
              child: Text(
                text,
                style: TextStyle(
                  fontSize: Utils.mainTextSize,
                  color: Colors.grey[Utils.mainTextColor],
                ),
              ),
            ),
            Container( //Temperature Icon
              child: Icon(
                icon,
                size: Utils.iconSize,
                color: Colors.grey[Utils.mainTextColor],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /*
  This method creates the text rows inside the route
  Text is the text shown in the route
   */
  static Widget createTextRow(String text, double topPadding, double bottomPadding){
    return new Container(
      padding: EdgeInsets.only(top: topPadding, bottom: bottomPadding),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: Colors.grey[Utils.mainTextColor],
        ),
      ),
    );
  }

  /*
  Method used for creating a scrollable list of all rooms created inside Monday
   */
  static Future<List<Widget>> buildRoomButtons(BuildContext context,
      Future<List<RoomModel>> records) async {
    List<RoomModel> rooms = await records;
    List<Widget> buttons = List();
    rooms.forEach((item) {
      Widget button = new RoomButton(item);
      buttons.add(button);
    });
    Widget addRoomButton = Utils.createAddButton(context, "NewRoom");
    buttons.add(addRoomButton);
    return buttons;
  }

  static String getDateFromString(String date){
    List<String> list = date.split('\ ');
    String result = list[0];
    return result;
  }

  static String getTimeFromString(String date){
    List<String> list = date.split('\ ');
    String result = list[1].trim();
    return result;
  }

  static DateTime convertSecondsToHMS (String seconds){
    int secs = int.parse(seconds);
    int hours =  (secs/3600).floor();
    int subtotal = secs-(hours*3600);
    int minutes = (subtotal/60).floor();
    int finalSecs = secs-(minutes*60);
    DateTime dt = new DateTime(0,0,0,hours,minutes,finalSecs);
    return dt;
  }

  /*
  Method used for checking characters inserted into TextInputField forms
   */
  static bool validateInputText(String val){
    if(val.contains("\/") || val.contains("\'") || val.contains("\&") ||
          val.contains("\$") || val.contains("\-") || val.contains("\^") ||
          val.contains("\<") || val.contains("\>") || val.contains('\,') ||
          val.contains("\.") || val.contains("\\") || val.contains("\"") ||
          val.contains ("\+") || val.contains("*") || val.contains("\=") ||
          val.contains("\(") || val.contains("\)") || val.contains("\{") ||
          val.contains("\}") || val.contains("\_") || val.contains("\?") ||
          val.contains("\;") || val.contains("\:"))
      return false;
    else
      return true;
  }

  /*
  Getters methods
   */
  static int get mainTextColor => _mainTextColor;

  static double get mainTextSize => _mainTextSize;

  static int get backgroundColor => _backgroundColor;

  static double get helloTextSize => _helloTextSize;

  static double get littleTextSize => _littleTextSize;

  static int get littleTextColor => _littleTextColor;

  static double get iconSize => _iconSize;

  static IconData get menuIcon => _menuIcon;

  static IconData get lightbulbIcon => _lightbulbIcon;

  static IconData get temperatureIcon => _temperatureIcon;

  static IconData get humidityIcon => _humidityIcon;

  static IconData get fireIcon => _fireIcon;

  static IconData get shadeIcon => _shadeIcon;

  static IconData get shieldIcon => _shieldIcon;

  static IconData get consumptionIcon => _consumptionIcon;

  static IconData get outletIcon => _outletIcon; //icon for outlet

  static IconData get newDevsIcon =>
      _newDevsIcon; //icon for all devices button in home route
}