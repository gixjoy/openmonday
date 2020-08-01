import 'package:flutter/cupertino.dart';
import 'package:local_auth/local_auth.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:monday/ui/home.dart';
import 'package:monday/controller/login_controller.dart';
import 'package:monday/common/r.dart';

class LocalAuthenticationService {

  final _auth = LocalAuthentication();
  bool _isProtectionEnabled = true;

  bool get isProtectionEnabled => _isProtectionEnabled;

  set isProtectionEnabled(bool enabled) => _isProtectionEnabled = enabled;

  bool isAuthenticated = false;

  Future<void> authenticate(BuildContext context) async {
    if (_isProtectionEnabled) {
      try {
        isAuthenticated = await _auth.authenticateWithBiometrics(
          localizedReason: 'Autenticazione richiesta',
          useErrorDialogs: true,
          stickyAuth: true,
        );
        if (isAuthenticated) {
          if (await LoginController.sendLoginPreferences(context))
            Navigator.push(context, MaterialPageRoute(builder: (context) =>
                Home()));
        }
      }
      on PlatformException catch (e) {
        print(e);
      }
    }
  }
}