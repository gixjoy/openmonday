import 'package:flutter/material.dart';
import 'package:monday/common/shared_prefs.dart';
import 'package:monday/ui/basic_route_structure.dart';
import 'package:monday/ui/components/text_input_field.dart';
import 'package:monday/controller/user_controller.dart';
import 'package:monday/common/utils.dart';
import 'package:monday/ui/components/custom_progress_indicator.dart';
import 'package:monday/ui/home.dart';
import 'package:monday/common/monday_icons.dart';
import 'package:monday/common/r.dart';
import 'package:monday/common/r.dart';

class UserAccount extends StatefulWidget {

  State<StatefulWidget> createState(){
    return new UserAccountState();
  }
}

class UserAccountState extends State<UserAccount> {

  static final usernameController = TextEditingController();
  static final passwordController = TextEditingController();
  static final rpController = TextEditingController();

  @override
  Widget build (BuildContext context) {

    Future<String> user = SharedPrefs.getUserName();
    Widget username = FutureBuilder(
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          String uname = snapshot.data;
          return new TextInputField('Username: ' + uname, usernameController, false,
              false);
        } else if (snapshot.hasError) {
          return Text("${snapshot.error}", style: Theme
              .of(context)
              .textTheme
              .headline);
        } else {
          return CustomProgressIndicator();
        }
      },
      future: user,
    );

    Widget appBar = new AppBar(
      title: new Text(R.of(context).userAccountTitle),
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

    Widget editPasswordText = Container(
      padding: EdgeInsets.only(left:32, right:20, bottom:30),
      child: Text(
        R.of(context).userAccountEditPasswordText,
        style: TextStyle(
          fontSize: 20,
          color: Colors.grey[200]
        ),
      )
    );

    Widget password = new TextInputField(R.of(context).userAccountPasswordLength, passwordController, true, true);

    Widget repeatPassword = new TextInputField(R.of(context).userAccountRepeatPassword, rpController, true, true);

    Widget body = GestureDetector(
      onTap: (){
        FocusScope.of(context).unfocus();
      },
      child: Container(
        padding: EdgeInsets.only(top:40),
        child: ListView(
          children: [
            username,
            Container(height:30),
            editPasswordText,
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
                String password = passwordController.text;
                if (!Utils.validateInputText(password))
                  Utils.showDialogPanel(R.of(context).warningMsg,
                    R.of(context).textInputWrongChars, context);
                else {
                  if (password != null && password != "" &&
                      password.length >= 8) {
                    if (UserController.checkPasswordFields(context,
                        passwordController.text, rpController.text)) {
                      UserController.saveUserData(
                          context, passwordController.text);
                      passwordController.clear();
                      rpController.clear();
                    }
                  }
                  else
                    Utils.showDialogPanel(R.of(context).warningMsg,
                        R.of(context).userAccountNewPasswordLengthMsg, context);
                }
              },
              icon: Icon(
                Monday.keyboard_arrow_right,
                color: Colors.grey[200],
                size: 50,
              ),
            ),
          ],
        ),
      )
    );
    Widget drawer;

    return new BasicRouteStructure(appBar, body, drawer);
  }
}