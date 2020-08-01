import 'package:flutter/material.dart';
import 'package:monday/common/shared_prefs.dart';
import 'package:monday/controller/login_controller.dart';
import 'package:monday/ui/basic_route_structure.dart';
import 'package:monday/common/utils.dart';
import 'package:monday/ui/components/text_input_field.dart';
import 'package:monday/ui/home.dart';
import 'package:monday/controller/local_authentication_service.dart';
import 'package:monday/controller/service_locator.dart';
import 'package:monday/ui/registration_user.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:monday/common/r.dart';
import 'package:monday/common/utils.dart';
import 'package:monday/common/r.dart';
import 'package:monday/generated/l10n.dart';

const String _kFontFam = 'Monday';

class Login extends StatelessWidget {

  bool showRegistration;//if true a "Register" link is shown for registration
  Login(this.showRegistration);

  @override
  Widget build(BuildContext context) {

    return new MaterialApp (
      home: new LoginRoute(showRegistration),
      debugShowCheckedModeBanner: false,
      localizationsDelegates: [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: S.delegate.supportedLocales,
    );
  }
}

class LoginRoute extends StatelessWidget {

   bool showRegistration;//if true a "Register" link is shown for registration
    LoginRoute(this.showRegistration);

  static final IconData fingerprint = const IconData(0xe80c, fontFamily: _kFontFam);
  static final IconData rightArrow = const IconData(0xe80d, fontFamily: _kFontFam);
  final LocalAuthenticationService _localAuth = locator<LocalAuthenticationService>();
  static final usernameController = TextEditingController();
  static final passwordController = TextEditingController();


  final Widget loginText = Container(
    padding: const EdgeInsets.only(bottom:40),
    child: Text(
      'Login',
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 25,
        fontWeight: FontWeight.w400,
        color: Colors.grey[Utils.mainTextColor],
      ),
    ),
  );

  final Widget loginField = new TextInputField('Username', usernameController, false, true);
  final Widget password = new TextInputField('Password', passwordController, true, true);

  @override
  Widget build (BuildContext context) {

    //Initialize all global variables depending on locale
    Utils.selectedTime = R.of(context).timeButtonNow;

    Widget appBar;
    final Widget orText = Container(
      padding: const EdgeInsets.only(top:30, bottom:20),
      child: Text(
        R.of(context).loginOr,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: Colors.grey[Utils.mainTextColor],
        ),
      ),
    );

    Widget registerField = showRegistrationField(context, this.showRegistration);

    Widget body = new GestureDetector(
      onTap: (){
        FocusScope.of(context).unfocus();
      },
      child: Container(
        child: ListView(
          children: [
            Container(
              height:60,
            ),
            loginText,
            loginField,
            Container(
              height: 30,
            ),
            password,
            registerField,
            IconButton(
              onPressed: () async {
                String hostname = await SharedPrefs.getMondayHostname();
                if(!Utils.validateInputText(usernameController.text) ||
                !Utils.validateInputText(passwordController.text))
                  Utils.showDialogPanel(R.of(context).warningMsg,
                    R.of(context).textInputWrongChars, context);
                else{
                  if(await LoginController.sendLoginData(context, usernameController.text,
                      passwordController.text)) {
                    Navigator.pushReplacement(
                        context, MaterialPageRoute(builder: (context) =>
                        Home()));
                    //usernameController.clear();
                    //passwordController.clear();
                  }
                }
              },
              //padding: const EdgeInsets.only(top:10),
              icon: Icon(
                rightArrow,
                color: Colors.grey[200],
                size: 50,
              ),
            ),
            orText,
            IconButton(
              onPressed: () async {
                _localAuth.authenticate(context);
                },
              //padding: const EdgeInsets.only(top:20, right:20),
              icon: Icon(
                fingerprint,
                color: Colors.green[500],
                size: 80,
              ),
            ),
            Container(
              padding: const EdgeInsets.only(top:70),
              child: Text(
                R.of(context).loginTouchIcon,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Colors.grey[Utils.mainTextColor],
                ),
              ),
            ),
          ],
        ),
      ),
    );

    Widget drawer;

    return new BasicRouteStructure(appBar, body, drawer);
  }

  Widget showRegistrationField(BuildContext context, bool value){
    if (value) {
      return new Container(
        height: 50,
        padding: EdgeInsets.only(right: 30),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            InkWell(
              child: Text(
                  R.of(context).loginRegister,
                  style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[200],
                      decoration: TextDecoration.underline
                  )
              ),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(
                    builder: (context) => RegistrationUser()));
              },
            ),
          ],
        ),
      );
    }
    else{
      return new Container(
        height: 50,
      );
    }
  }
}