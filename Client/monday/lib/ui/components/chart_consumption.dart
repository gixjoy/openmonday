import 'package:flutter/material.dart';
import 'package:monday/model/chart_monthly_sample_model.dart';
import 'package:monday/model/chart_daily_sample_model.dart';
import 'package:monday/model/chart_actual_sample_model.dart';
import 'package:monday/controller/chart_controller.dart';
import 'package:monday/ui/components/chart_daily.dart';
import 'package:monday/ui/components/chart_monthly.dart';
import 'package:monday/common/utils.dart';
import 'package:monday/ui/components/custom_progress_indicator.dart';
import 'package:monday/common/r.dart';
import 'package:monday/common/r.dart';

class ChartConsumption extends StatelessWidget{

  String type;//can be "general" or "specific" per device
  String deviceId;
  ChartConsumption(this.type);
  ChartConsumption.withDeviceId(this.type, this.deviceId);

  @override
  Widget build(BuildContext context) {
    Future<ChartActualSampleModel> consActualValue;
    Future<List<ChartDailySampleModel>> consDailyValue;
    Future<List<ChartMonthlySampleModel>> consMonthlyValue;
    if (type == "specific"){
      consActualValue =
        ChartController.getActualConsumptionsFromMonday(context, deviceId);
      consDailyValue =
        ChartController.getDailyConsumptionsFromMonday(context, deviceId);
      consMonthlyValue =
      ChartController.getMonthlyConsumptionsFromMonday(context, deviceId);
    }
    if(type == "general") {
      consActualValue =
        ChartController.getActualValueFromMonday(context, "consumption");
      consDailyValue =
        ChartController.getDailyValuesFromMonday(context, "consumption");
      consMonthlyValue =
      ChartController.getMonthlyValuesFromMonday(context, "consumption");
    }
    Widget widActualValue = Center(
      child: Container(
        padding: EdgeInsets.only(top: 20),
        height: 220,
        child: FutureBuilder(
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              ChartActualSampleModel consValue = snapshot.data;
              if (double.parse(consValue.value) < 0)
                return Container(
                  padding: EdgeInsets.only(top: 60),
                  child: Text(
                    "-- W/h",
                    style: TextStyle(
                        color: Colors.grey[200],
                        fontSize: 30
                    ),
                  ),
                );
              else //actual consumptions
                return Container(
                  padding: EdgeInsets.only(top: 60),
                  child: Text(
                    consValue.value.toString() + " W/h",
                    style: TextStyle(
                        color: Colors.grey[200],
                        fontSize: 30
                    ),
                  ),
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
          future: consActualValue,
        ),
      ),
    );


    Widget widDailyValue = Center(
      child: Container(
        padding: EdgeInsets.only(top: 20),
        height: 220,
        child: FutureBuilder(
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<ChartDailySampleModel> sampleList = snapshot.data;
              if (sampleList.isEmpty)
                return Container(
                  padding: EdgeInsets.only(top: 60),
                  child: Text(
                    "-- W/h",
                    style: TextStyle(
                        color: Colors.grey[200],
                        fontSize: 30
                    ),
                  ),
                );
              else //actual consumptions
                return Container(
                  height: 220,
                  //child: new AreaAndLineChartBK.withDailySampleData(sampleList)
                  child: new DailyChart(sampleList, "consumption"),
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
          future: consDailyValue,
        ),
      ),
    );

    Widget widMonthlyValue = Center(
      child: Container(
        padding: EdgeInsets.only(top: 20),
        height: 220,
        child: FutureBuilder(
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<ChartMonthlySampleModel> sampleList = snapshot.data;
              if (sampleList.isEmpty)
                return Container(
                  padding: EdgeInsets.only(top: 60),
                  child: Text(
                    "-- W/h",
                    style: TextStyle(
                        color: Colors.grey[200],
                        fontSize: 30
                    ),
                  ),
                );
              else //actual consumptions
                return Container(
                    height: 220,
                    //child: new AreaAndLineChartBK.withMonthlySampleData(sampleList)
                    child: MonthlyChart(sampleList, "consumption")
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
          future: consMonthlyValue,
        ),
      ),
    );

    Widget chartArea;
    if(Utils.selectedTime == R.of(context).timeButtonNow)
      chartArea = widActualValue;
    if(Utils.selectedTime == R.of(context).timeButtonToday)
      chartArea = widDailyValue;
    if(Utils.selectedTime == R.of(context).timeButtonMonth)
      chartArea = widMonthlyValue;

    return chartArea;
  }
}