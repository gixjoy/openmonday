import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:monday/model/time_condition_model.dart';
import 'package:monday/ui/basic_route_structure.dart';
import 'package:monday/ui/components/show_month_selection_grid.dart';
import 'package:monday/ui/components/show_day_selection_grid.dart';
import 'package:monday/common/utils.dart';
import 'package:monday/common/monday_icons.dart';
import 'package:monday/common/r.dart';

/*
This Route is only used for showing settings on TimeCondition, got from Monday for
 a specific scene. All touch functionalities can only be shown, with no
 possibility to tap on them.
 */

class ShowSceneTimeCondition extends StatefulWidget {

  TimeConditionModel timeCondition;
  ShowSceneTimeCondition(this.timeCondition);

  @override
  State<StatefulWidget> createState(){
    return new ShowSceneTimeConditionState(timeCondition.hour, timeCondition.minute,
    timeCondition.periodic);
  }
}

class ShowSceneTimeConditionState extends State<ShowSceneTimeCondition> {

  String _setHour;
  String _setMinute;
  String _setRepeat;
  ShowSceneTimeConditionState(this._setHour, this._setMinute, this._setRepeat);

  Color _timeColor = Colors.grey[600];

  Widget drawer;

  @override
  Widget build(BuildContext context) {

    /*
    AppBar
     */
    Widget appBar = new AppBar(
      title: new Text(R.of(context).timeCondTitle),
      backgroundColor: Colors.transparent,
      elevation: 0.0,
    );

    Widget monthTextSection = Utils.buildTextRow(
        R.of(context).timeCondMonthText,
        Utils.helloTextSize, Utils.mainTextColor, 20, 20);
    Widget monthSelection = new ShowMonthSelectionGrid(widget.timeCondition, [
      R.of(context).timeCondJan, R.of(context).timeCondFeb, R.of(context).timeCondMar,
      R.of(context).timeCondApr, R.of(context).timeCondMay, R.of(context).timeCondJun,
      R.of(context).timeCondJul, R.of(context).timeCondAug, R.of(context).timeCondSep,
      R.of(context).timeCondOct, R.of(context).timeCondNov, R.of(context).timeCondDec
    ], 200);

    Widget dayTextSection = Utils.buildTextRow(
        R.of(context).timeCondDayText,
        Utils.helloTextSize, Utils.mainTextColor, 20, 20);
    Widget daySelection = new ShowDaySelectionGrid(widget.timeCondition, [
      R.of(context).timeCondMon, R.of(context).timeCondTue, R.of(context).timeCondWed,
      R.of(context).timeCondThu, R.of(context).timeCondFri, R.of(context).timeCondSat,
      R.of(context).timeCondSun
    ], 140);

    Widget timeTextSection;
    if (widget.timeCondition.enabled == '1')
      timeTextSection = Utils.buildTextRow(
        R.of(context).timeCondTimeEnabled,
        Utils.helloTextSize, Utils.mainTextColor, 20, 20);
    else
      timeTextSection = Utils.buildTextRow(
        R.of(context).timeCondTimeDisabled,
        Utils.helloTextSize, Utils.mainTextColor, 20, 20);

    Widget timeSelection = buildTimeSelectionWidget();

    Widget enableRepeat = buildEnableRepeatButton(_setRepeat);

    Widget monthDaySelection = Container(
      height: 500,
      child: ListView(
        physics: ClampingScrollPhysics(),
        shrinkWrap: true,
        children:[
          monthTextSection,
          Container(
            height: 15
          ),
          monthSelection,
          dayTextSection,
          Container(
            height: 15
          ),
          daySelection,
        ]
      ),
    );

    Widget body;
    if(_setRepeat == '1')
      body = buildBodyWithMonthAndDaySections(timeTextSection,
          timeSelection, enableRepeat, monthDaySelection);
    else
      body = buildBodyWithNoMonthAndDaySections(timeTextSection,
        timeSelection, enableRepeat);

    return new BasicRouteStructure(appBar, body, drawer);
  }


  /*
  Used for building the enable button, for showing month and day selection
   */
  Widget buildEnableRepeatButton(String flag){
    if(_setRepeat == '1') {
      return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.only(left: 10),
              child: Text(
                  R.of(context).timeCondRepeatText,
                  style: TextStyle(
                      color: Colors.grey[200],
                      fontSize: 18
                  )
              ),
            ),
            Container(
              child: IconButton(
                icon: new Icon (
                  Monday.toggle_on,
                  color: Colors.blueAccent,
                  size: 40,
                ),
              ),
            ),
          ]
      );
    }
    else {
      return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.only(left: 10),
              child: Text(
                  R.of(context).timeCondRepeatText,
                  style: TextStyle(
                      color: Colors.grey[200],
                      fontSize: 18
                  )
              ),
            ),
            Container(
              child: IconButton(
                icon: new Icon (
                  Monday.toggle_off,
                  color: Colors.grey[600],
                  size: 40,
                ),
              ),
            ),
          ]
      );
    }
  }

  /*
  The method builds a body with no month or day selection sections.
  It is shown when "repeat" button is not enabled
   */
  Widget buildBodyWithNoMonthAndDaySections(Widget timeTextSection,
      Widget timeSelection, Widget enableRepeat){
    return new GestureDetector(
      onTap: (){
        FocusScope.of(context).unfocus();
      },
      child: ListView(
        children: [
          Container(
            height: 10
          ),
          timeTextSection,
          Container(
            height: 15
          ),
          timeSelection,
          Container(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              enableRepeat,
            ]
          ),
        ]
      ),
    );
  }

  /*
  The method builds a body with month and day selection sections.
  It is shown when "repeat" button is enabled
   */
  Widget buildBodyWithMonthAndDaySections(Widget timeTextSection,
      Widget timeSelection, Widget enableRepeat, Widget monthDaySelection){
    return new GestureDetector(
      onTap: (){
        FocusScope.of(context).unfocus();
      },
      child: ListView(
        children: [
          Container(
            height: 10
          ),
          timeTextSection,
          Container(
            height: 15
          ),
          timeSelection,
          Container(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              enableRepeat,
            ]
          ),
          monthDaySelection,
        ]
      ),
    );
  }

  /*
  Used for building time selection widget, allowing the user to choose a time
  for enabling the scene
   */
  Widget buildTimeSelectionWidget(){
    if(widget.timeCondition.enabled == '1')
      _timeColor = Colors.blueAccent;
    if (int.parse(_setMinute) < 10)
      _setMinute = "0"+_setMinute;
    return new Container(
      height: 100,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.0),
        border: Border.all(
          width: 2,
          color: Colors.grey[600]
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children:[
          Container(
            child: Text(
              _setHour,
              style: TextStyle(
                color: _timeColor,
                fontSize: 42,
              ),
            )
          ),

          Container(
            child: Text(
              ":",
              style: TextStyle(
                color: _timeColor,
                fontSize: 42,
              ),
            )
          ),

          Container(
            child: Text(
              _setMinute,
              style: TextStyle(
                color: _timeColor,
                fontSize: 42,
              ),
            )
          )
        ]
      )
    );
  }
}

