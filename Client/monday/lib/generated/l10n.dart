// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars

class S {
  S();
  
  static S current;
  
  static const AppLocalizationDelegate delegate =
    AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false) ? locale.languageCode : locale.toString();
    final localeName = Intl.canonicalizedLocale(name); 
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      S.current = S();
      
      return S.current;
    });
  } 

  static S of(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `or`
  String get loginOr {
    return Intl.message(
      'or',
      name: 'loginOr',
      desc: '',
      args: [],
    );
  }

  /// `Touch the icon for using your fingerprint`
  String get loginTouchIcon {
    return Intl.message(
      'Touch the icon for using your fingerprint',
      name: 'loginTouchIcon',
      desc: '',
      args: [],
    );
  }

  /// `Hello!`
  String get homeWelcome {
    return Intl.message(
      'Hello!',
      name: 'homeWelcome',
      desc: '',
      args: [],
    );
  }

  /// `Devices`
  String get homeDevices {
    return Intl.message(
      'Devices',
      name: 'homeDevices',
      desc: '',
      args: [],
    );
  }

  /// `Last update`
  String get homeUpdatedOn {
    return Intl.message(
      'Last update',
      name: 'homeUpdatedOn',
      desc: '',
      args: [],
    );
  }

  /// `Rooms`
  String get homeRooms {
    return Intl.message(
      'Rooms',
      name: 'homeRooms',
      desc: '',
      args: [],
    );
  }

  /// `Door`
  String get homeAlarmButton {
    return Intl.message(
      'Door',
      name: 'homeAlarmButton',
      desc: '',
      args: [],
    );
  }

  /// `New`
  String get homeNewButton {
    return Intl.message(
      'New',
      name: 'homeNewButton',
      desc: '',
      args: [],
    );
  }

  /// `Climate`
  String get homeClimateButton {
    return Intl.message(
      'Climate',
      name: 'homeClimateButton',
      desc: '',
      args: [],
    );
  }

  /// `Light`
  String get homeLightButton {
    return Intl.message(
      'Light',
      name: 'homeLightButton',
      desc: '',
      args: [],
    );
  }

  /// `Shutter`
  String get homeShutterButton {
    return Intl.message(
      'Shutter',
      name: 'homeShutterButton',
      desc: '',
      args: [],
    );
  }

  /// `Outlet`
  String get homeOutletButton {
    return Intl.message(
      'Outlet',
      name: 'homeOutletButton',
      desc: '',
      args: [],
    );
  }

  /// `Video`
  String get homeSurveillanceButton {
    return Intl.message(
      'Video',
      name: 'homeSurveillanceButton',
      desc: '',
      args: [],
    );
  }

  /// `Add`
  String get homeAddRoom {
    return Intl.message(
      'Add',
      name: 'homeAddRoom',
      desc: '',
      args: [],
    );
  }

  /// `User account`
  String get drawerUserAccount {
    return Intl.message(
      'User account',
      name: 'drawerUserAccount',
      desc: '',
      args: [],
    );
  }

  /// `Notifications`
  String get drawerNotifications {
    return Intl.message(
      'Notifications',
      name: 'drawerNotifications',
      desc: '',
      args: [],
    );
  }

  /// `Devices`
  String get drawerDevices {
    return Intl.message(
      'Devices',
      name: 'drawerDevices',
      desc: '',
      args: [],
    );
  }

  /// `Scenes`
  String get drawerScenes {
    return Intl.message(
      'Scenes',
      name: 'drawerScenes',
      desc: '',
      args: [],
    );
  }

  /// `Charts`
  String get drawerCharts {
    return Intl.message(
      'Charts',
      name: 'drawerCharts',
      desc: '',
      args: [],
    );
  }

  /// `System info`
  String get drawerInfo {
    return Intl.message(
      'System info',
      name: 'drawerInfo',
      desc: '',
      args: [],
    );
  }

  /// `Logout`
  String get drawerLogout {
    return Intl.message(
      'Logout',
      name: 'drawerLogout',
      desc: '',
      args: [],
    );
  }

  /// `Door`
  String get alarmTitle {
    return Intl.message(
      'Door',
      name: 'alarmTitle',
      desc: '',
      args: [],
    );
  }

  /// `Status`
  String get alarmStatus {
    return Intl.message(
      'Status',
      name: 'alarmStatus',
      desc: '',
      args: [],
    );
  }

  /// `Charts`
  String get chartTitle {
    return Intl.message(
      'Charts',
      name: 'chartTitle',
      desc: '',
      args: [],
    );
  }

  /// `Now`
  String get timeButtonNow {
    return Intl.message(
      'Now',
      name: 'timeButtonNow',
      desc: '',
      args: [],
    );
  }

  /// `Today`
  String get timeButtonToday {
    return Intl.message(
      'Today',
      name: 'timeButtonToday',
      desc: '',
      args: [],
    );
  }

  /// `Month`
  String get timeButtonMonth {
    return Intl.message(
      'Month',
      name: 'timeButtonMonth',
      desc: '',
      args: [],
    );
  }

  /// `Temperature`
  String get chartTemperature {
    return Intl.message(
      'Temperature',
      name: 'chartTemperature',
      desc: '',
      args: [],
    );
  }

  /// `Humidity`
  String get chartHumidity {
    return Intl.message(
      'Humidity',
      name: 'chartHumidity',
      desc: '',
      args: [],
    );
  }

  /// `Total Consumptions`
  String get chartConsumptions {
    return Intl.message(
      'Total Consumptions',
      name: 'chartConsumptions',
      desc: '',
      args: [],
    );
  }

  /// `Consumption`
  String get chartConsumption {
    return Intl.message(
      'Consumption',
      name: 'chartConsumption',
      desc: '',
      args: [],
    );
  }

  /// `Hours`
  String get chartHour {
    return Intl.message(
      'Hours',
      name: 'chartHour',
      desc: '',
      args: [],
    );
  }

  /// `Days`
  String get chartDays {
    return Intl.message(
      'Days',
      name: 'chartDays',
      desc: '',
      args: [],
    );
  }

  /// `Avg`
  String get chartAvg {
    return Intl.message(
      'Avg',
      name: 'chartAvg',
      desc: '',
      args: [],
    );
  }

  /// `Device`
  String get devConfigTitle {
    return Intl.message(
      'Device',
      name: 'devConfigTitle',
      desc: '',
      args: [],
    );
  }

  /// `Warning!`
  String get devWarningTypeSelectionTitle {
    return Intl.message(
      'Warning!',
      name: 'devWarningTypeSelectionTitle',
      desc: '',
      args: [],
    );
  }

  /// `Select a type for the new device`
  String get devWarningTypeSelectionBody {
    return Intl.message(
      'Select a type for the new device',
      name: 'devWarningTypeSelectionBody',
      desc: '',
      args: [],
    );
  }

  /// `Select a name for the new device`
  String get devWarningNameSelectionBody {
    return Intl.message(
      'Select a name for the new device',
      name: 'devWarningNameSelectionBody',
      desc: '',
      args: [],
    );
  }

  /// `Select a type for the device`
  String get devConfigSelectDeviceText {
    return Intl.message(
      'Select a type for the device',
      name: 'devConfigSelectDeviceText',
      desc: '',
      args: [],
    );
  }

  /// `Name`
  String get devInfoName {
    return Intl.message(
      'Name',
      name: 'devInfoName',
      desc: '',
      args: [],
    );
  }

  /// `Room`
  String get devInfoRoom {
    return Intl.message(
      'Room',
      name: 'devInfoRoom',
      desc: '',
      args: [],
    );
  }

  /// `Type`
  String get devInfoType {
    return Intl.message(
      'Type',
      name: 'devInfoType',
      desc: '',
      args: [],
    );
  }

  /// `Consumption`
  String get devInfoConsumption {
    return Intl.message(
      'Consumption',
      name: 'devInfoConsumption',
      desc: '',
      args: [],
    );
  }

  /// `Devices`
  String get devices {
    return Intl.message(
      'Devices',
      name: 'devices',
      desc: '',
      args: [],
    );
  }

  /// `Info`
  String get devicesInfo {
    return Intl.message(
      'Info',
      name: 'devicesInfo',
      desc: '',
      args: [],
    );
  }

  /// `Edit`
  String get devicesEdit {
    return Intl.message(
      'Edit',
      name: 'devicesEdit',
      desc: '',
      args: [],
    );
  }

  /// `Delete`
  String get devicesDelete {
    return Intl.message(
      'Delete',
      name: 'devicesDelete',
      desc: '',
      args: [],
    );
  }

  /// `No configured device`
  String get devActionNoDevice {
    return Intl.message(
      'No configured device',
      name: 'devActionNoDevice',
      desc: '',
      args: [],
    );
  }

  /// `No available device`
  String get devNotAvailable {
    return Intl.message(
      'No available device',
      name: 'devNotAvailable',
      desc: '',
      args: [],
    );
  }

  /// `Edit scene`
  String get editAutomatedSceneTitle {
    return Intl.message(
      'Edit scene',
      name: 'editAutomatedSceneTitle',
      desc: '',
      args: [],
    );
  }

  /// `Condition`
  String get editAutomatedSceneCondition {
    return Intl.message(
      'Condition',
      name: 'editAutomatedSceneCondition',
      desc: '',
      args: [],
    );
  }

  /// `Action`
  String get editAutomatedSceneAction {
    return Intl.message(
      'Action',
      name: 'editAutomatedSceneAction',
      desc: '',
      args: [],
    );
  }

  /// `No configured action`
  String get editAutomatedSceneNoAction {
    return Intl.message(
      'No configured action',
      name: 'editAutomatedSceneNoAction',
      desc: '',
      args: [],
    );
  }

  /// `It's necessary to configure at least one condition to move forward`
  String get editAutomatedSceneCondConf {
    return Intl.message(
      'It\'s necessary to configure at least one condition to move forward',
      name: 'editAutomatedSceneCondConf',
      desc: '',
      args: [],
    );
  }

  /// `It's necessary to select and operator for enabled conditions`
  String get editAutomatedSceneCondOperator {
    return Intl.message(
      'It\'s necessary to select and operator for enabled conditions',
      name: 'editAutomatedSceneCondOperator',
      desc: '',
      args: [],
    );
  }

  /// `Periodic`
  String get editAutomatedScenePeriodic {
    return Intl.message(
      'Periodic',
      name: 'editAutomatedScenePeriodic',
      desc: '',
      args: [],
    );
  }

  /// `Edit scene`
  String get editManualSceneTitle {
    return Intl.message(
      'Edit scene',
      name: 'editManualSceneTitle',
      desc: '',
      args: [],
    );
  }

  /// `Action`
  String get editManualSceneAction {
    return Intl.message(
      'Action',
      name: 'editManualSceneAction',
      desc: '',
      args: [],
    );
  }

  /// `No configured action`
  String get editManualSceneNoAction {
    return Intl.message(
      'No configured action',
      name: 'editManualSceneNoAction',
      desc: '',
      args: [],
    );
  }

  /// `No climate device found`
  String get heaterNoDeviceFound {
    return Intl.message(
      'No climate device found',
      name: 'heaterNoDeviceFound',
      desc: '',
      args: [],
    );
  }

  /// `Sensor battery`
  String get heaterSensorLife {
    return Intl.message(
      'Sensor battery',
      name: 'heaterSensorLife',
      desc: '',
      args: [],
    );
  }

  /// `Detected on`
  String get heaterDetectedOn {
    return Intl.message(
      'Detected on',
      name: 'heaterDetectedOn',
      desc: '',
      args: [],
    );
  }

  /// `Lights`
  String get lightTitleBar {
    return Intl.message(
      'Lights',
      name: 'lightTitleBar',
      desc: '',
      args: [],
    );
  }

  /// `Light`
  String get deviceLight {
    return Intl.message(
      'Light',
      name: 'deviceLight',
      desc: '',
      args: [],
    );
  }

  /// `Outlet`
  String get deviceOutlet {
    return Intl.message(
      'Outlet',
      name: 'deviceOutlet',
      desc: '',
      args: [],
    );
  }

  /// `Climate`
  String get deviceClimate {
    return Intl.message(
      'Climate',
      name: 'deviceClimate',
      desc: '',
      args: [],
    );
  }

  /// `Shutter`
  String get deviceShutter {
    return Intl.message(
      'Shutter',
      name: 'deviceShutter',
      desc: '',
      args: [],
    );
  }

  /// `Climate Sensor`
  String get deviceClimateSensor {
    return Intl.message(
      'Climate Sensor',
      name: 'deviceClimateSensor',
      desc: '',
      args: [],
    );
  }

  /// `Alarm sensor`
  String get deviceAlarmSensor {
    return Intl.message(
      'Alarm sensor',
      name: 'deviceAlarmSensor',
      desc: '',
      args: [],
    );
  }

  /// `Video`
  String get deviceVideo {
    return Intl.message(
      'Video',
      name: 'deviceVideo',
      desc: '',
      args: [],
    );
  }

  /// `Select a room for the device`
  String get roomSelectionDevice {
    return Intl.message(
      'Select a room for the device',
      name: 'roomSelectionDevice',
      desc: '',
      args: [],
    );
  }

  /// `No room available`
  String get roomNotAvailable {
    return Intl.message(
      'No room available',
      name: 'roomNotAvailable',
      desc: '',
      args: [],
    );
  }

  /// `Do you want to proceed deleting the room?`
  String get roomConfirmDeletion {
    return Intl.message(
      'Do you want to proceed deleting the room?',
      name: 'roomConfirmDeletion',
      desc: '',
      args: [],
    );
  }

  /// `Warning!`
  String get warningMsg {
    return Intl.message(
      'Warning!',
      name: 'warningMsg',
      desc: '',
      args: [],
    );
  }

  /// `Do you really want to remove the device?`
  String get deleteConfirmation {
    return Intl.message(
      'Do you really want to remove the device?',
      name: 'deleteConfirmation',
      desc: '',
      args: [],
    );
  }

  /// `Yes`
  String get yes {
    return Intl.message(
      'Yes',
      name: 'yes',
      desc: '',
      args: [],
    );
  }

  /// `No`
  String get no {
    return Intl.message(
      'No',
      name: 'no',
      desc: '',
      args: [],
    );
  }

  /// `Device belongs to one or more scenes. Please delete the scenes first`
  String get deviceRemovalMsg {
    return Intl.message(
      'Device belongs to one or more scenes. Please delete the scenes first',
      name: 'deviceRemovalMsg',
      desc: '',
      args: [],
    );
  }

  /// `Automated scene`
  String get newAutomatedSceneTitle {
    return Intl.message(
      'Automated scene',
      name: 'newAutomatedSceneTitle',
      desc: '',
      args: [],
    );
  }

  /// `Condition`
  String get newAutomatedSceneCondition {
    return Intl.message(
      'Condition',
      name: 'newAutomatedSceneCondition',
      desc: '',
      args: [],
    );
  }

  /// `Action`
  String get newAutomatedSceneAction {
    return Intl.message(
      'Action',
      name: 'newAutomatedSceneAction',
      desc: '',
      args: [],
    );
  }

  /// `No configured action`
  String get newAutomatedSceneNoAction {
    return Intl.message(
      'No configured action',
      name: 'newAutomatedSceneNoAction',
      desc: '',
      args: [],
    );
  }

  /// `It's necessary to configure at least one condition to move forward`
  String get newAutomatedSceneCondConf {
    return Intl.message(
      'It\'s necessary to configure at least one condition to move forward',
      name: 'newAutomatedSceneCondConf',
      desc: '',
      args: [],
    );
  }

  /// `It's necessary to select and operator for enabled conditions`
  String get newAutomatedSceneCondOperator {
    return Intl.message(
      'It\'s necessary to select and operator for enabled conditions',
      name: 'newAutomatedSceneCondOperator',
      desc: '',
      args: [],
    );
  }

  /// `Scene name`
  String get newAutomatedSceneInputText {
    return Intl.message(
      'Scene name',
      name: 'newAutomatedSceneInputText',
      desc: '',
      args: [],
    );
  }

  /// `Periodic`
  String get newAutomatedScenePeriodic {
    return Intl.message(
      'Periodic',
      name: 'newAutomatedScenePeriodic',
      desc: '',
      args: [],
    );
  }

  /// `New devices`
  String get newDevicesTitle {
    return Intl.message(
      'New devices',
      name: 'newDevicesTitle',
      desc: '',
      args: [],
    );
  }

  /// `No device found`
  String get newDevicesNoDevFound {
    return Intl.message(
      'No device found',
      name: 'newDevicesNoDevFound',
      desc: '',
      args: [],
    );
  }

  /// `Manual scene`
  String get newManualSceneTitle {
    return Intl.message(
      'Manual scene',
      name: 'newManualSceneTitle',
      desc: '',
      args: [],
    );
  }

  /// `Scene name`
  String get newManualSceneInputText {
    return Intl.message(
      'Scene name',
      name: 'newManualSceneInputText',
      desc: '',
      args: [],
    );
  }

  /// `Action`
  String get newManualSceneAction {
    return Intl.message(
      'Action',
      name: 'newManualSceneAction',
      desc: '',
      args: [],
    );
  }

  /// `No configured action`
  String get newManualSceneNoAction {
    return Intl.message(
      'No configured action',
      name: 'newManualSceneNoAction',
      desc: '',
      args: [],
    );
  }

  /// `New room`
  String get newRoomTitle {
    return Intl.message(
      'New room',
      name: 'newRoomTitle',
      desc: '',
      args: [],
    );
  }

  /// `Name`
  String get newRoomName {
    return Intl.message(
      'Name',
      name: 'newRoomName',
      desc: '',
      args: [],
    );
  }

  /// `Select a category for the room`
  String get newRoomCategorySelection {
    return Intl.message(
      'Select a category for the room',
      name: 'newRoomCategorySelection',
      desc: '',
      args: [],
    );
  }

  /// `Select a picture for the room`
  String get newRoomPicSelection {
    return Intl.message(
      'Select a picture for the room',
      name: 'newRoomPicSelection',
      desc: '',
      args: [],
    );
  }

  /// `or`
  String get newRoomOr {
    return Intl.message(
      'or',
      name: 'newRoomOr',
      desc: '',
      args: [],
    );
  }

  /// `Living`
  String get roomTypeLiving {
    return Intl.message(
      'Living',
      name: 'roomTypeLiving',
      desc: '',
      args: [],
    );
  }

  /// `Kitchen`
  String get roomTypeKitchen {
    return Intl.message(
      'Kitchen',
      name: 'roomTypeKitchen',
      desc: '',
      args: [],
    );
  }

  /// `Bedroom`
  String get roomTypeBedroom {
    return Intl.message(
      'Bedroom',
      name: 'roomTypeBedroom',
      desc: '',
      args: [],
    );
  }

  /// `Bathroom`
  String get roomTypeBathroom {
    return Intl.message(
      'Bathroom',
      name: 'roomTypeBathroom',
      desc: '',
      args: [],
    );
  }

  /// `Tiny room`
  String get roomTypeTiny {
    return Intl.message(
      'Tiny room',
      name: 'roomTypeTiny',
      desc: '',
      args: [],
    );
  }

  /// `Closet`
  String get roomTypeCloset {
    return Intl.message(
      'Closet',
      name: 'roomTypeCloset',
      desc: '',
      args: [],
    );
  }

  /// `Hallway`
  String get roomTypeHallway {
    return Intl.message(
      'Hallway',
      name: 'roomTypeHallway',
      desc: '',
      args: [],
    );
  }

  /// `Terrace`
  String get roomTypeTerrace {
    return Intl.message(
      'Terrace',
      name: 'roomTypeTerrace',
      desc: '',
      args: [],
    );
  }

  /// `Study`
  String get roomTypeStudy {
    return Intl.message(
      'Study',
      name: 'roomTypeStudy',
      desc: '',
      args: [],
    );
  }

  /// `Washing room`
  String get roomTypeWashing {
    return Intl.message(
      'Washing room',
      name: 'roomTypeWashing',
      desc: '',
      args: [],
    );
  }

  /// `Attic`
  String get roomTypeAttic {
    return Intl.message(
      'Attic',
      name: 'roomTypeAttic',
      desc: '',
      args: [],
    );
  }

  /// `Garage`
  String get roomTypeGarage {
    return Intl.message(
      'Garage',
      name: 'roomTypeGarage',
      desc: '',
      args: [],
    );
  }

  /// `Cellar`
  String get roomTypeCellar {
    return Intl.message(
      'Cellar',
      name: 'roomTypeCellar',
      desc: '',
      args: [],
    );
  }

  /// `Other`
  String get roomTypeOther {
    return Intl.message(
      'Other',
      name: 'roomTypeOther',
      desc: '',
      args: [],
    );
  }

  /// `Notifications`
  String get notificationsTitle {
    return Intl.message(
      'Notifications',
      name: 'notificationsTitle',
      desc: '',
      args: [],
    );
  }

  /// `Do you want to proceed deleting all notifications?`
  String get notificationsDeleteConf {
    return Intl.message(
      'Do you want to proceed deleting all notifications?',
      name: 'notificationsDeleteConf',
      desc: '',
      args: [],
    );
  }

  /// `Do you want to proceed deleting selected notification?`
  String get notificationsDeleteOneConf {
    return Intl.message(
      'Do you want to proceed deleting selected notification?',
      name: 'notificationsDeleteOneConf',
      desc: '',
      args: [],
    );
  }

  /// `Show`
  String get notificationsShow {
    return Intl.message(
      'Show',
      name: 'notificationsShow',
      desc: '',
      args: [],
    );
  }

  /// `Delete`
  String get notificationsDelete {
    return Intl.message(
      'Delete',
      name: 'notificationsDelete',
      desc: '',
      args: [],
    );
  }

  /// `No notification available`
  String get notificationsNoNotificationAvailable {
    return Intl.message(
      'No notification available',
      name: 'notificationsNoNotificationAvailable',
      desc: '',
      args: [],
    );
  }

  /// `Notification info`
  String get notificationInfoTitle {
    return Intl.message(
      'Notification info',
      name: 'notificationInfoTitle',
      desc: '',
      args: [],
    );
  }

  /// `Time`
  String get notificationInfoTime {
    return Intl.message(
      'Time',
      name: 'notificationInfoTime',
      desc: '',
      args: [],
    );
  }

  /// `Date`
  String get notificationInfoDate {
    return Intl.message(
      'Date',
      name: 'notificationInfoDate',
      desc: '',
      args: [],
    );
  }

  /// `Message`
  String get notificationInfoMessage {
    return Intl.message(
      'Message',
      name: 'notificationInfoMessage',
      desc: '',
      args: [],
    );
  }

  /// `Outlets`
  String get outletTitle {
    return Intl.message(
      'Outlets',
      name: 'outletTitle',
      desc: '',
      args: [],
    );
  }

  /// `Register`
  String get loginRegister {
    return Intl.message(
      'Register',
      name: 'loginRegister',
      desc: '',
      args: [],
    );
  }

  /// `You must provide an IP address or a hostname to continue`
  String get registrationIPNotice {
    return Intl.message(
      'You must provide an IP address or a hostname to continue',
      name: 'registrationIPNotice',
      desc: '',
      args: [],
    );
  }

  /// `Registration`
  String get registrationTitle {
    return Intl.message(
      'Registration',
      name: 'registrationTitle',
      desc: '',
      args: [],
    );
  }

  /// `Monday hostname or IP`
  String get registrationIPText {
    return Intl.message(
      'Monday hostname or IP',
      name: 'registrationIPText',
      desc: '',
      args: [],
    );
  }

  /// `Registration`
  String get regUserText {
    return Intl.message(
      'Registration',
      name: 'regUserText',
      desc: '',
      args: [],
    );
  }

  /// `Password (min 8 char.)`
  String get regUserMinChar {
    return Intl.message(
      'Password (min 8 char.)',
      name: 'regUserMinChar',
      desc: '',
      args: [],
    );
  }

  /// `Repeat password`
  String get regUserRepeatPwd {
    return Intl.message(
      'Repeat password',
      name: 'regUserRepeatPwd',
      desc: '',
      args: [],
    );
  }

  /// `Scenes`
  String get scenesTitle {
    return Intl.message(
      'Scenes',
      name: 'scenesTitle',
      desc: '',
      args: [],
    );
  }

  /// `Automated`
  String get scenesAutomated {
    return Intl.message(
      'Automated',
      name: 'scenesAutomated',
      desc: '',
      args: [],
    );
  }

  /// `Manual`
  String get scenesManual {
    return Intl.message(
      'Manual',
      name: 'scenesManual',
      desc: '',
      args: [],
    );
  }

  /// `Periodic condition`
  String get timeCondTitle {
    return Intl.message(
      'Periodic condition',
      name: 'timeCondTitle',
      desc: '',
      args: [],
    );
  }

  /// `Month`
  String get timeCondMonthText {
    return Intl.message(
      'Month',
      name: 'timeCondMonthText',
      desc: '',
      args: [],
    );
  }

  /// `Day`
  String get timeCondDayText {
    return Intl.message(
      'Day',
      name: 'timeCondDayText',
      desc: '',
      args: [],
    );
  }

  /// `Time - Enabled`
  String get timeCondTimeEnabled {
    return Intl.message(
      'Time - Enabled',
      name: 'timeCondTimeEnabled',
      desc: '',
      args: [],
    );
  }

  /// `Time - Disabled`
  String get timeCondTimeDisabled {
    return Intl.message(
      'Time - Disabled',
      name: 'timeCondTimeDisabled',
      desc: '',
      args: [],
    );
  }

  /// `Jan`
  String get timeCondJan {
    return Intl.message(
      'Jan',
      name: 'timeCondJan',
      desc: '',
      args: [],
    );
  }

  /// `Feb`
  String get timeCondFeb {
    return Intl.message(
      'Feb',
      name: 'timeCondFeb',
      desc: '',
      args: [],
    );
  }

  /// `Mar`
  String get timeCondMar {
    return Intl.message(
      'Mar',
      name: 'timeCondMar',
      desc: '',
      args: [],
    );
  }

  /// `Apr`
  String get timeCondApr {
    return Intl.message(
      'Apr',
      name: 'timeCondApr',
      desc: '',
      args: [],
    );
  }

  /// `May`
  String get timeCondMay {
    return Intl.message(
      'May',
      name: 'timeCondMay',
      desc: '',
      args: [],
    );
  }

  /// `Jun`
  String get timeCondJun {
    return Intl.message(
      'Jun',
      name: 'timeCondJun',
      desc: '',
      args: [],
    );
  }

  /// `Jul`
  String get timeCondJul {
    return Intl.message(
      'Jul',
      name: 'timeCondJul',
      desc: '',
      args: [],
    );
  }

  /// `Aug`
  String get timeCondAug {
    return Intl.message(
      'Aug',
      name: 'timeCondAug',
      desc: '',
      args: [],
    );
  }

  /// `Sep`
  String get timeCondSep {
    return Intl.message(
      'Sep',
      name: 'timeCondSep',
      desc: '',
      args: [],
    );
  }

  /// `Oct`
  String get timeCondOct {
    return Intl.message(
      'Oct',
      name: 'timeCondOct',
      desc: '',
      args: [],
    );
  }

  /// `Nov`
  String get timeCondNov {
    return Intl.message(
      'Nov',
      name: 'timeCondNov',
      desc: '',
      args: [],
    );
  }

  /// `Dec`
  String get timeCondDec {
    return Intl.message(
      'Dec',
      name: 'timeCondDec',
      desc: '',
      args: [],
    );
  }

  /// `Mon`
  String get timeCondMon {
    return Intl.message(
      'Mon',
      name: 'timeCondMon',
      desc: '',
      args: [],
    );
  }

  /// `Tue`
  String get timeCondTue {
    return Intl.message(
      'Tue',
      name: 'timeCondTue',
      desc: '',
      args: [],
    );
  }

  /// `Wed`
  String get timeCondWed {
    return Intl.message(
      'Wed',
      name: 'timeCondWed',
      desc: '',
      args: [],
    );
  }

  /// `Thu`
  String get timeCondThu {
    return Intl.message(
      'Thu',
      name: 'timeCondThu',
      desc: '',
      args: [],
    );
  }

  /// `Fri`
  String get timeCondFri {
    return Intl.message(
      'Fri',
      name: 'timeCondFri',
      desc: '',
      args: [],
    );
  }

  /// `Sat`
  String get timeCondSat {
    return Intl.message(
      'Sat',
      name: 'timeCondSat',
      desc: '',
      args: [],
    );
  }

  /// `Sun`
  String get timeCondSun {
    return Intl.message(
      'Sun',
      name: 'timeCondSun',
      desc: '',
      args: [],
    );
  }

  /// `Repeat`
  String get timeCondRepeatText {
    return Intl.message(
      'Repeat',
      name: 'timeCondRepeatText',
      desc: '',
      args: [],
    );
  }

  /// `Action`
  String get showSceneActionText {
    return Intl.message(
      'Action',
      name: 'showSceneActionText',
      desc: '',
      args: [],
    );
  }

  /// `Condition`
  String get showAutoSceneCondText {
    return Intl.message(
      'Condition',
      name: 'showAutoSceneCondText',
      desc: '',
      args: [],
    );
  }

  /// `No device configured`
  String get showSceneNoDevConfigured {
    return Intl.message(
      'No device configured',
      name: 'showSceneNoDevConfigured',
      desc: '',
      args: [],
    );
  }

  /// `Do you want to proceed deleting the scene?`
  String get showSceneDeleteConfirmation {
    return Intl.message(
      'Do you want to proceed deleting the scene?',
      name: 'showSceneDeleteConfirmation',
      desc: '',
      args: [],
    );
  }

  /// `Periodic`
  String get sceneAutoPeriodicText {
    return Intl.message(
      'Periodic',
      name: 'sceneAutoPeriodicText',
      desc: '',
      args: [],
    );
  }

  /// `Climate`
  String get sceneAutoClimateButtonText {
    return Intl.message(
      'Climate',
      name: 'sceneAutoClimateButtonText',
      desc: '',
      args: [],
    );
  }

  /// `Consumption`
  String get sceneAutoConsButtonText {
    return Intl.message(
      'Consumption',
      name: 'sceneAutoConsButtonText',
      desc: '',
      args: [],
    );
  }

  /// `Shutters`
  String get shutterTitle {
    return Intl.message(
      'Shutters',
      name: 'shutterTitle',
      desc: '',
      args: [],
    );
  }

  /// `Open`
  String get shutterControlOpenText {
    return Intl.message(
      'Open',
      name: 'shutterControlOpenText',
      desc: '',
      args: [],
    );
  }

  /// `Closed`
  String get shutterControlCloseText {
    return Intl.message(
      'Closed',
      name: 'shutterControlCloseText',
      desc: '',
      args: [],
    );
  }

  /// `The device is not reachable`
  String get devNotReachable {
    return Intl.message(
      'The device is not reachable',
      name: 'devNotReachable',
      desc: '',
      args: [],
    );
  }

  /// `Surveillance`
  String get surveillanceTitle {
    return Intl.message(
      'Surveillance',
      name: 'surveillanceTitle',
      desc: '',
      args: [],
    );
  }

  /// `User account`
  String get userAccountTitle {
    return Intl.message(
      'User account',
      name: 'userAccountTitle',
      desc: '',
      args: [],
    );
  }

  /// `New password must have at least 8 chars.`
  String get userAccountNewPasswordLengthMsg {
    return Intl.message(
      'New password must have at least 8 chars.',
      name: 'userAccountNewPasswordLengthMsg',
      desc: '',
      args: [],
    );
  }

  /// `Edit password`
  String get userAccountEditPasswordText {
    return Intl.message(
      'Edit password',
      name: 'userAccountEditPasswordText',
      desc: '',
      args: [],
    );
  }

  /// `Password (min 8 char.)`
  String get userAccountPasswordLength {
    return Intl.message(
      'Password (min 8 char.)',
      name: 'userAccountPasswordLength',
      desc: '',
      args: [],
    );
  }

  /// `Repeat password`
  String get userAccountRepeatPassword {
    return Intl.message(
      'Repeat password',
      name: 'userAccountRepeatPassword',
      desc: '',
      args: [],
    );
  }

  /// `Consumption`
  String get consumptionPanelLabel {
    return Intl.message(
      'Consumption',
      name: 'consumptionPanelLabel',
      desc: '',
      args: [],
    );
  }

  /// `Humidity`
  String get humidityPanelLabel {
    return Intl.message(
      'Humidity',
      name: 'humidityPanelLabel',
      desc: '',
      args: [],
    );
  }

  /// `Temperature`
  String get temperaturePanelLabel {
    return Intl.message(
      'Temperature',
      name: 'temperaturePanelLabel',
      desc: '',
      args: [],
    );
  }

  /// `On`
  String get onOffPanelOnLabel {
    return Intl.message(
      'On',
      name: 'onOffPanelOnLabel',
      desc: '',
      args: [],
    );
  }

  /// `Off`
  String get onOffPanelOffLabel {
    return Intl.message(
      'Off',
      name: 'onOffPanelOffLabel',
      desc: '',
      args: [],
    );
  }

  /// `A system error occurred. Please contact the administrator.`
  String get controllerSysError {
    return Intl.message(
      'A system error occurred. Please contact the administrator.',
      name: 'controllerSysError',
      desc: '',
      args: [],
    );
  }

  /// `Session token not valid`
  String get controllerTokenError {
    return Intl.message(
      'Session token not valid',
      name: 'controllerTokenError',
      desc: '',
      args: [],
    );
  }

  /// `Logout error`
  String get controllerLogoutError {
    return Intl.message(
      'Logout error',
      name: 'controllerLogoutError',
      desc: '',
      args: [],
    );
  }

  /// `A device communication error occurred`
  String get controllerCommunicationError {
    return Intl.message(
      'A device communication error occurred',
      name: 'controllerCommunicationError',
      desc: '',
      args: [],
    );
  }

  /// `The device is not reachable`
  String get controllerDevNotReachableError {
    return Intl.message(
      'The device is not reachable',
      name: 'controllerDevNotReachableError',
      desc: '',
      args: [],
    );
  }

  /// `User has not been enabled yet`
  String get controllerUserNotEnabledError {
    return Intl.message(
      'User has not been enabled yet',
      name: 'controllerUserNotEnabledError',
      desc: '',
      args: [],
    );
  }

  /// `Username or password wrong`
  String get controllerWrongCredError {
    return Intl.message(
      'Username or password wrong',
      name: 'controllerWrongCredError',
      desc: '',
      args: [],
    );
  }

  /// `Please fill all the required fields`
  String get controllerAllFieldsNeeded {
    return Intl.message(
      'Please fill all the required fields',
      name: 'controllerAllFieldsNeeded',
      desc: '',
      args: [],
    );
  }

  /// `Monday is not available`
  String get controllerMondayNotAvailableError {
    return Intl.message(
      'Monday is not available',
      name: 'controllerMondayNotAvailableError',
      desc: '',
      args: [],
    );
  }

  /// `Username already in use`
  String get controllerUsernameAlreadyInUseError {
    return Intl.message(
      'Username already in use',
      name: 'controllerUsernameAlreadyInUseError',
      desc: '',
      args: [],
    );
  }

  /// `Registration can be completed only from within the same LAN where Monday is`
  String get controllerSameLANError {
    return Intl.message(
      'Registration can be completed only from within the same LAN where Monday is',
      name: 'controllerSameLANError',
      desc: '',
      args: [],
    );
  }

  /// `Passwords do not match`
  String get controllerSamePasswordError {
    return Intl.message(
      'Passwords do not match',
      name: 'controllerSamePasswordError',
      desc: '',
      args: [],
    );
  }

  /// `Device must be calibrated`
  String get controllerCalibrationError {
    return Intl.message(
      'Device must be calibrated',
      name: 'controllerCalibrationError',
      desc: '',
      args: [],
    );
  }

  /// `System infos`
  String get systemInfoTitle {
    return Intl.message(
      'System infos',
      name: 'systemInfoTitle',
      desc: '',
      args: [],
    );
  }

  /// `Mosquitto credentials`
  String get systemInfoMosquittoText {
    return Intl.message(
      'Mosquitto credentials',
      name: 'systemInfoMosquittoText',
      desc: '',
      args: [],
    );
  }

  /// `Inserted chars not allowed. Only special characters allowed: #, !, @`
  String get textInputWrongChars {
    return Intl.message(
      'Inserted chars not allowed. Only special characters allowed: #, !, @',
      name: 'textInputWrongChars',
      desc: '',
      args: [],
    );
  }

  /// `Data incomplete. Please try again`
  String get showErrorMessageIncompleteData {
    return Intl.message(
      'Data incomplete. Please try again',
      name: 'showErrorMessageIncompleteData',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'it'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    if (locale != null) {
      for (var supportedLocale in supportedLocales) {
        if (supportedLocale.languageCode == locale.languageCode) {
          return true;
        }
      }
    }
    return false;
  }
}