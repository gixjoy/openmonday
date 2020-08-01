import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs {
  ///
  /// Instantiation of the SharedPreferences library
  ///
  static final String _kRegistrationDone = "registrationDone";
  static final String _kMondayHostname = "mondayHostname";
  static final String _kUserName = "userName";
  static final String _kUserPassword = "userPassword";
  static final String _kSessionTimeout = "sessionTimeout";
  static final String _kSessionToken = "sessionToken";
  static final String _kClimateControllerEnabled = "climateControllerEnabled";
  static final String _kClimateSensorEnabled = "climateSensorEnabled";
  static final String _kFirebaseToken = "firebaseToken";
  static final String _kClientId = "clientId";

  /// -----------------------------------------------------------------------
  /// Method that returns True if the user registration has already been done
  /// -----------------------------------------------------------------------
  static Future<bool> getRegistrationDone() async {
	  final SharedPreferences prefs = await SharedPreferences.getInstance();
  	return prefs.getBool(_kRegistrationDone) ?? false;
  }

  /// ----------------------------------------------------------
  /// Method that sets user registration as done
  /// ----------------------------------------------------------
  static Future<bool> setRegistrationDone(bool value) async {
	  final SharedPreferences prefs = await SharedPreferences.getInstance();
	  return prefs.setBool(_kRegistrationDone, value);
  }

  /// -----------------------------------------------------------------------
  /// Method that returns Monday remote url
  /// -----------------------------------------------------------------------
  static Future<String> getMondayHostname() async {
	  final SharedPreferences prefs = await SharedPreferences.getInstance();
  	return prefs.getString(_kMondayHostname);
  }

  /// ----------------------------------------------------------
  /// Method that sets Monday remote url
  /// ----------------------------------------------------------
  static Future<bool> setMondayHostname(String value) async {
	  final SharedPreferences prefs = await SharedPreferences.getInstance();
	  return prefs.setString(_kMondayHostname, value);
  }

  /// ----------------------------------------------------------
  /// Method that removes Monday url from shared preferences
  /// ----------------------------------------------------------
  static Future<bool> removeMondayUrl() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.remove(_kMondayHostname);
  }

  /// -----------------------------------------------------------------------
  /// Method that returns username
  /// -----------------------------------------------------------------------
  static Future<String> getUserName() async {
	  final SharedPreferences prefs = await SharedPreferences.getInstance();
  	return prefs.getString(_kUserName);
  }

  /// ----------------------------------------------------------
  /// Method that sets username
  /// ----------------------------------------------------------
  static Future<bool> setUsername(String value) async {
	  final SharedPreferences prefs = await SharedPreferences.getInstance();
	  return prefs.setString(_kUserName, value);
  }

  /// -----------------------------------------------------------------------
  /// Method that returns user password
  /// -----------------------------------------------------------------------
  static Future<String> getUserPassword() async {
	  final SharedPreferences prefs = await SharedPreferences.getInstance();
  	return prefs.getString(_kUserPassword);
  }

  /// ----------------------------------------------------------
  /// Method that sets user password
  /// ----------------------------------------------------------
  static Future<bool> setUserPassword(String value) async {
	  final SharedPreferences prefs = await SharedPreferences.getInstance();
	  return prefs.setString(_kUserPassword, value);
  }

  /// -----------------------------------------------------------------------
  /// Method that returns a session time from the last login of the user
  /// -----------------------------------------------------------------------
  static Future<int> getSessionTimeout() async {
	  final SharedPreferences prefs = await SharedPreferences.getInstance();
  	return prefs.getInt(_kSessionTimeout);
  }

  /// ----------------------------------------------------------
  /// Method that sets user session time
  /// ----------------------------------------------------------
  static Future<bool> setSessionTimeout(int value) async {
	  final SharedPreferences prefs = await SharedPreferences.getInstance();
	  return prefs.setInt(_kSessionTimeout, value);
  }

  /// -----------------------------------------------------------------------
  /// Method that returns a session token from the last login of the user
  /// -----------------------------------------------------------------------
  static Future<String> getSessionToken() async {
	  final SharedPreferences prefs = await SharedPreferences.getInstance();
  	return prefs.getString(_kSessionToken);
  }

  /// ----------------------------------------------------------
  /// Method that sets user session token
  /// ----------------------------------------------------------
  static Future<bool> setSessionToken(String value) async {
	  final SharedPreferences prefs = await SharedPreferences.getInstance();
	  return prefs.setString(_kSessionToken, value);
  }

  /// ----------------------------------------------------------
  /// Method that removes user session time from shared preferences
  /// ----------------------------------------------------------
  static Future<bool> removeSessionTimeout() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.remove(_kSessionTimeout);
  }

  /// ----------------------------------------------------------
  /// Method that sets climateControllerEnabled property
  /// ----------------------------------------------------------
  static Future<bool> setClimateControllerEnabled(bool value) async {
	  final SharedPreferences prefs = await SharedPreferences.getInstance();
	  return prefs.setBool(_kClimateControllerEnabled, value);
  }

  /// ----------------------------------------------------------
  /// Method that gets climateControllerEnabled property
  /// ----------------------------------------------------------
  static Future<bool> getClimateControllerEnabled() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_kClimateControllerEnabled);
  }

  /// ----------------------------------------------------------
  /// Method that sets climateSensorEnabled property
  /// ----------------------------------------------------------
  static Future<bool> setClimateSensorEnabled(bool value) async {
	  final SharedPreferences prefs = await SharedPreferences.getInstance();
	  return prefs.setBool(_kClimateSensorEnabled, value);
  }

  /// ----------------------------------------------------------
  /// Method that gets climateSensorEnabled property
  /// ----------------------------------------------------------
  static Future<bool> getClimateSensorEnabled() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_kClimateSensorEnabled);
  }

  /// -----------------------------------------------------------------------
  /// Method that returns a Firebase token for notification system
  /// -----------------------------------------------------------------------
  static Future<String> getFirebaseToken() async {
	  final SharedPreferences prefs = await SharedPreferences.getInstance();
  	return prefs.getString(_kFirebaseToken);
  }

  /// ----------------------------------------------------------
  /// Method that sets Firebase token for notification system
  /// ----------------------------------------------------------
  static Future<bool> setFirebaseToken(String value) async {
	  final SharedPreferences prefs = await SharedPreferences.getInstance();
	  return prefs.setString(_kFirebaseToken, value);
  }

  /// -----------------------------------------------------------------------
  /// Method that returns the client id for the mobile device the app is running on
  /// -----------------------------------------------------------------------
  static Future<String> getClientId() async {
	  final SharedPreferences prefs = await SharedPreferences.getInstance();
  	return prefs.getString(_kClientId);
  }

  /// ----------------------------------------------------------
  /// Method that sets the client id for the mobile device the app is running on
  /// ----------------------------------------------------------
  static Future<bool> setClientId(String value) async {
	  final SharedPreferences prefs = await SharedPreferences.getInstance();
	  return prefs.setString(_kClientId, value);
  }
}