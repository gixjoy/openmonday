import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:monday/model/chart_daily_sample_model.dart';
import 'package:monday/common/r.dart';

class DailyChart extends StatefulWidget {

  List<ChartDailySampleModel> sampleList;
  String type;
  DailyChart(this.sampleList, this.type);

  @override
  _DailyChartState createState() => _DailyChartState();
}

class _DailyChartState extends State<DailyChart> {
  List<Color> gradientColors = [
    const Color(0xff23b6e6),
    const Color(0xff02d39a),
  ];

  bool showAvg = false;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        AspectRatio(
          aspectRatio: 1.70,
          child: Container(
            decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(
                  Radius.circular(18),
                ),
                color: const Color(0xff232d37)),
            child: Padding(
              padding: const EdgeInsets.only(right: 18.0, left: 12.0, top: 24, bottom: 12),
              child: LineChart(
                mainData(),
              ),
            ),
          ),
        ),
      ],
    );
  }

  LineChartData mainData() {
    String yAxisName ="";
    if (widget.type == "consumption")
      yAxisName = R.of(context).chartConsumption + " W/h";
    if(widget.type == "temperature")
      yAxisName = R.of(context).chartTemperature+" °C";
    if (widget.type == "humidity")
      yAxisName = R.of(context).chartHumidity+" %";
    double maxValue = getMax(widget.sampleList);
    List<FlSpot> flValues = List();
    widget.sampleList.forEach((item){
      FlSpot spot = new FlSpot(double.parse(item.hour), double.parse(item.value));
      flValues.add(spot);
    });
    int avg = getAverage(widget.sampleList);
    List<FlSpot> flAVGValues = List();
    widget.sampleList.forEach((item){
      FlSpot spot = new FlSpot(double.parse(item.hour), avg.roundToDouble());
      flAVGValues.add(spot);
    });
    return LineChartData(
      axisTitleData: FlAxisTitleData(
        show: true,
        leftTitle: AxisTitle(
          showTitle: true,
          titleText: yAxisName,
          textStyle: TextStyle(
            color: Colors.grey[200],
            fontSize: 12
          )
        ),
        bottomTitle: AxisTitle(
          showTitle: true,
          titleText: R.of(context).chartHour,
          textStyle: TextStyle(
            color: Colors.grey[200],
            fontSize: 12
          )
        ),
      ),
      gridData: FlGridData(
        show: true,
        drawVerticalLine: true,
        verticalInterval: 1,
        getDrawingHorizontalLine: (value) {
          return const FlLine(
            color: Color(0xff37434d),
            strokeWidth: 1,
          );
        },
        getDrawingVerticalLine: (value) {
          return const FlLine(
            color: Color(0xff37434d),
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: SideTitles(
          showTitles: true,
          reservedSize:22,
          textStyle:
              TextStyle(
                  color: const Color(0xff68737d),
                  fontWeight: FontWeight.bold,
                  fontSize: 14
              ),
          getTitles: (value) {
            switch (value.toInt()) {
              case 3:
                return '3';
              case 6:
                return '6';
              case 9:
                return '9';
              case 12:
                return '12';
              case 15:
                return '15';
              case 18:
                return '18';
              case 21:
                return '21';
              case 24:
                return '24';
            }
            return '';
          },
          margin: 8,
        ),
        leftTitles: SideTitles(
          showTitles: true,
          textStyle: TextStyle(
            color: const Color(0xff67727d),
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
          getTitles: (value) {
            if (value.toInt() == avg)
              return R.of(context).chartAvg;
            switch (value.toInt()) {
              case 0:
                return '0';
              case 10:
                return '10';
              case 50:
                return '50';
              case 100:
                return '100';
              case 1000:
                return '1K';
              case 2000:
                return '2K';
            }
            return '';
          },
          reservedSize: 28,
          margin: 12,
        ),
      ),
      borderData:
          FlBorderData(show: true, border: Border.all(color: const Color(0xff37434d), width: 1)),
      minX: 0,
      maxX: 24,//days on x axis
      minY: 0,
      maxY: maxValue,//max consumption measured by Shelly
      lineBarsData: [
        LineChartBarData(
          spots: flValues,
          isCurved: true,
          colors: gradientColors,
          barWidth: 2,
          isStrokeCapRound: true,
          dotData: const FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
            show: true,
            colors: gradientColors.map((color) => color.withOpacity(0.3)).toList(),
          ),
        ),
        LineChartBarData(//AVG data
          spots: flAVGValues,
          isCurved: true,
          colors: [
            ColorTween(begin: gradientColors[1], end: gradientColors[1]).lerp(0.2),
            ColorTween(begin: gradientColors[1], end: gradientColors[1]).lerp(0.2),
          ],
          barWidth: 3,
          isStrokeCapRound: true,
          dotData: const FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(show: true, colors: [
            ColorTween(begin: gradientColors[0], end: gradientColors[1]).lerp(0.2).withOpacity(0.1),
            ColorTween(begin: gradientColors[0], end: gradientColors[1]).lerp(0.2).withOpacity(0.1),
          ]),
        ),
      ],
    );
  }

  //Used for calculating average value of all items from "values" list
  static int getAverage(List<dynamic> values){
    int result = 0;
    values.forEach((item){
      result += double.parse(item.value).round();
    });
    result = (result/values.length).round();
    return result;
  }

  //Used for calculating the max value of all items from "values" list
  static double getMax(List<dynamic> values){
    double max = 0;
    values.forEach((item){
      if (double.parse(item.value) > max)
        max = double.parse(item.value);
    });
    return max;
  }
}