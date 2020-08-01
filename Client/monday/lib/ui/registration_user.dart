import 'package:flutter/material.dart';
import 'package:monday/ui/basic_route_structure.dart';
import 'package:monday/common/utils.dart';
import 'package:monday/ui/components/text_input_field.dart';
import 'package:monday/controller/registration_controller.dart';
import 'package:monday/common/r.dart';
import 'package:monday/common/r.dart';

const String _kFontFam = 'Monday';

class RegistrationUser extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    return new MaterialApp (
      home: new RegistrationUserRoute(),
      debugShowCheckedModeBanner: false
    );
  }
}

class RegistrationUserRoute extends StatelessWidget {
  static const IconData right_arrow = const IconData(0xe80d, fontFamily: _kFontFam);
  static final usernameController = TextEditingController();
  static final passwordController = TextEditingController();
  static final rpController = TextEditingController();

  @override
  Widget build (BuildContext context) {
    Widget appBar;

    /*
    First line of Registration route
     */
    Widget registrationText = Container(
      padding: const EdgeInsets.only(top:35, bottom:35),
      child: Text(
        R.of(context).regUserText,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 25,
          fontWeight: FontWeight.w400,
          color: Colors.grey[Utils.mainTextColor],
        ),
      ),
    );

    /*
    Second line of Registration route
     */
    Widget username = new TextInputField('Username', usernameController, false, true);

    /*
    Third line of Registration route
     */
    Widget password = new TextInputField(R.of(context).regUserMinChar,
        passwordController, true, true);

    /*
    Fourth line of Registration route
     */
    Widget repeatPassword = new TextInputField(R.of(context).regUserRepeatPwd, rpController, true, true);

    Widget body = new GestureDetector(
      onTap: (){
        FocusScope.of(context).unfocus();
      },
      child: Container(
        child: ListView(
          children: [
            registrationText,
            username,
            Container(
              height: 30
            ),
            password,
            Container(
              height: 30
            ),
            repeatPassword,
            Container(
              height: 100
            ),
            IconButton(
              onPressed: () async {
               if (RegistrationController.checkRegistrationForm(context,
                   usernameController.text, passwordController.text, rpController.text)) {
                 RegistrationController.saveRegistrationData(context,
                     usernameController.text, passwordController.text);
               }
              },
              padding: const EdgeInsets.only(top:10),
              icon: Icon(
                right_arrow,
                color: Colors.grey[200],
                size: 50,
              ),
            ),
          ],
        ),
      ),
    );
    Widget drawer;

    return new BasicRouteStructure(appBar, body, drawer);
  }
}