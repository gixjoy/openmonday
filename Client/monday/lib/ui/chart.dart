import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:monday/ui/basic_route_structure.dart';
import 'package:monday/ui/components/time_buttons_row.dart';
import 'package:monday/ui/components/chart_consumption.dart';
import 'package:monday/ui/components/chart_temperature.dart';
import 'package:monday/ui/components/chart_humidity.dart';
import 'package:monday/ui/home.dart';
import 'package:monday/common/r.dart';

class Chart extends StatefulWidget {

  static ChartState of(BuildContext context) =>
      // ignore: deprecated_member_use
      context.ancestorStateOfType(const TypeMatcher<ChartState>());

  @override
  ChartState createState(){
    return new ChartState();
  }

}

class ChartState extends State<Chart>{

  Widget drawer;

  @override
  Widget build(BuildContext context){

    //App bar
    Widget appBar = new AppBar(
      title: new Text(R.of(context).chartTitle),
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

    /*
    Time selection section
     */
    Widget timeSelection = Container(
      padding: EdgeInsets.only(top:20, left:40),
        child: new TimeButtonsRow([R.of(context).timeButtonNow,
                                  R.of(context).timeButtonToday,
                                  R.of(context).timeButtonMonth], "Chart"),
    );

    /*
    Temperature chart section
     */
    Widget tempChartText = Center(
      child: Container(
        height:30,
        child: Text(
          R.of(context).chartTemperature,
          style: TextStyle(
            color: Colors.grey[200],
            fontSize: 20
          ),
        )
      ),
    );

    Widget temperatureChartArea = new ChartTemperature("general");

    /*
    Humidity chart section
     */
    Widget humidChartText = Center(
      child: Container(
        height:30,
        child: Text(
          R.of(context).chartHumidity,
          style: TextStyle(
            color: Colors.grey[200],
            fontSize: 20
          ),
        )
      ),
    );
    Widget humidityChartArea = new ChartHumidity("general");

    /*
    Consumption chart section
     */
    Widget consumptionChartText = Center(
      child: Container(
        height:30,
        child: Text(
          R.of(context).chartConsumption,
          style: TextStyle(
            color: Colors.grey[200],
            fontSize: 20
          ),
        )
      ),
    );
    Widget consumptionChartArea = new ChartConsumption("general");

    Widget verticalSpace = Container(
      height: 50
    );
    Widget body = ListView(
      children: [
        timeSelection,
        verticalSpace,
        tempChartText,
        temperatureChartArea,
        verticalSpace,
        humidChartText,
        humidityChartArea,
        verticalSpace,
        consumptionChartText,
        consumptionChartArea
      ]
    );
    return new BasicRouteStructure(appBar, body, drawer);
  }
}