import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:monday/controller/heater_controller.dart';
import 'package:monday/ui/basic_route_structure.dart';
import 'package:monday/common/utils.dart';
import 'package:monday/ui/components/circular_slider.dart';
import 'package:monday/model/heater_model.dart';
import 'package:monday/common/monday_icons.dart';
import 'package:monday/ui/components/custom_progress_indicator.dart';
import 'dart:math' as math;
import 'package:monday/ui/new_automated_scene.dart';
import 'package:monday/common/r.dart';

const String _kFontFam = 'Monday';

class Heater extends StatelessWidget {

  Future<String> temperature;
  Future<String> humidity;
  Future<String> battery;
  Future<String> lastMeasureDate;
  Heater(this.temperature, this.humidity, this.battery, this.lastMeasureDate);

  //Icons
  static int _mainTextColor = 200;
  static IconData _scheduleIcon = const IconData(0xe836, fontFamily: _kFontFam); //icon for calendar schedule
  static IconData _batt_full = const IconData(0xe816, fontFamily: _kFontFam);//icon for battery full
  static IconData _batt_low = const IconData(0xe819, fontFamily: _kFontFam);//icon for battery low
  static IconData _batt_70percent = const IconData(0xe817, fontFamily: _kFontFam);//icon for battery 70%
  static IconData _batt_50percent = const IconData(0xe818, fontFamily: _kFontFam);//icon for battery 50%

  Widget drawer;

  @override
  Widget build(BuildContext context) {

    Future<HeaterModel> heater = HeaterController.getHeaterDataFromMonday(context);
    String selectedTemperature = "";

    //App bar
    Widget appBar = new AppBar(
      title: new Text(R.of(context).deviceClimate),
      backgroundColor: Colors.transparent,
      elevation: 0.0,
    );

    //Temperature section
    Widget temperatureSection = FutureBuilder<String> (
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Row(
            children: [
              Container( //Last temperature value
                //padding: const EdgeInsets.only(top:30),
                child: Text(
                  snapshot.data.toString() + ' °C',
                  style: TextStyle(
                    fontSize: Utils.mainTextSize,
                    color: Colors.grey[200],
                  ),
                ),
              ),
              Container( //Temperature Icon
                //padding: const EdgeInsets.only(top:30, left: 10, right:30),
                child: Icon(
                  Utils.temperatureIcon,
                  size: Utils.iconSize,
                  color: Colors.grey[200],
                ),
              ),
            ],
          );
        } else if (snapshot.hasError) {
          return Text("${snapshot.error}",style: Theme.of(context).textTheme.headline);
        } else {
          return CustomProgressIndicator();
        }
      },
      future: temperature,
    );

    //Humidity section
    Widget humiditySection = FutureBuilder<String> (
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Row (
            children: [
              Container( //Last humidity value
                padding: const EdgeInsets.only(top:30, left:30),
                child: Text(
                  snapshot.data.toString() + ' % ',
                  style: TextStyle(
                    fontSize: Utils.mainTextSize,
                    color: Colors.grey[_mainTextColor],
                  ),
                ),
              ),
              Container( //Humidity icon
                padding: const EdgeInsets.only(top:30),
                child: Icon(
                  Monday.droplet,
                  size: Utils.iconSize,
                  color: Colors.grey[_mainTextColor],
                ),
              ),
            ],
          );
        } else if (snapshot.hasError) {
          return Text("${snapshot.error}",style: Theme.of(context).textTheme.headline);
        } else {
          return CustomProgressIndicator();
        }
      },
      future: humidity,
    );

    //Slider section
    Widget sliderSection = FutureBuilder<HeaterModel> (
      builder: (context, snapshot) {
        String initValue = "";
        if (snapshot.hasData) {
          String message = snapshot.data.message;
          if (message != "No heater records found.") {
            selectedTemperature = snapshot.data.setTemperature;
            if (selectedTemperature == "--") { //default init value for position when
              // temperature has not still set for the first time
              initValue = "20";
            }
            else {
              initValue = selectedTemperature;
            }
            return new CircularSlider(selectedTemperature, initValue,
                snapshot.data.enabled.toString(), snapshot.data.id.toString());
          }
          else
            return new Container (
              padding: EdgeInsets.only(top:160),
                child: Center (
                  child: Text(
                    R.of(context).heaterNoDeviceFound,
                    style: TextStyle(
                      color: Colors.grey[200],
                      fontSize: 18
                    )
                  )
                )
            );
        } else if (snapshot.hasError) {
          return Text("${snapshot.error}",style: Theme.of(context).textTheme.headline);
        } else {
          return CustomProgressIndicator();
        }
      },
      future: heater,
    );

    //Get climate_sensor battery charge
    Widget sensorCharge = FutureBuilder<String> (
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          String batteryLevel = snapshot.data;
          if (batteryLevel != "--")
            return buildSensorChargeRow(context, int.parse(batteryLevel));
          else
            return new Container();
        } else if (snapshot.hasError) {
          return Text("${snapshot.error}",style: Theme.of(context).textTheme.headline);
        } else {
          return CustomProgressIndicator();
        }
      },
      future: battery,
    );

    //Get climate_sensor last measure date
    Widget lastDate = FutureBuilder<String> (
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          String date = snapshot.data;
          if (date != "--")
            return buildLastMeasureDateRow(context, date);
          else
            return new Container();
        } else if (snapshot.hasError) {
          return Text("${snapshot.error}",style: Theme.of(context).textTheme.headline);
        } else {
          return CustomProgressIndicator();
        }
      },
      future: lastMeasureDate,
    );


    Widget body = Container(
      child: ListView(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.only(top:30, right: 10),
                child: temperatureSection,
              ),
              Container(//Schedule Icon
                padding: EdgeInsets.only(left:15),
                child: IconButton(
                  onPressed: (){
                    Navigator.push(context,
                            MaterialPageRoute(builder: (context) => NewAutomatedScene())
                    );
                  },
                  padding: const EdgeInsets.only(top:10),
                  icon: Icon(
                    _scheduleIcon,
                    color: Colors.green[500],
                    size: 50,
                  ),
                ),
              ),
              humiditySection,
            ],
          ),
          sliderSection,
          sensorCharge,
          lastDate
        ],
      ),
    );
    return new BasicRouteStructure(appBar, body, drawer);
  }

  /*
  Used for building the row with informations about climate_sensor battery charge
  value
   */
  Widget buildSensorChargeRow (BuildContext context, int charge){
    IconData batteryLevel;
    Color iconColor = Colors.grey[200];
    if (charge == 100)
      batteryLevel = _batt_full;
    if (charge < 100 && charge >= 70)
      batteryLevel = _batt_70percent;
    if (charge < 70 && charge > 30)
      batteryLevel = _batt_50percent;
    if (charge < 30 && charge >= 0) {
      batteryLevel = _batt_low;
      iconColor = Colors.red;
    }
    return new Container(
      padding: EdgeInsets.only(top:60),
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              R.of(context).heaterSensorLife+": ",
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[200]
              ),
            ),
            Text(
              " "+charge.toString()+ "% ",
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[200]
              ),
            ),

            Transform.rotate(
              angle: 270 * math.pi / 180,
              child: Icon(
                batteryLevel,
                size: Utils.iconSize,
                color: iconColor,
              ),
            ),
          ],
        ),
      )
    );
  }

  /*
  Used for building the row with informations about climate_sensor battery charge
  value
   */
  Widget buildLastMeasureDateRow (BuildContext context, String date) {
    return new Container(
        padding: EdgeInsets.only(top: 40),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                R.of(context).heaterDetectedOn+": " + date,
                style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[200]
                ),
              ),
            ],
          ),
        )
    );
  }
}