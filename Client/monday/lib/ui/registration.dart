import 'package:flutter/material.dart';
import 'package:monday/ui/basic_route_structure.dart';
import 'package:monday/common/utils.dart';
import 'package:monday/ui/components/text_input_field.dart';
import 'package:monday/controller/registration_controller.dart';
import 'package:monday/ui/login.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:monday/common/r.dart';
import 'package:monday/generated/l10n.dart';

const String _kFontFam = 'Monday';

class Registration extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    return new MaterialApp (
      home: new RegistrationRoute(),
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

class RegistrationRoute extends StatelessWidget {
  static const IconData right_arrow = const IconData(0xe80d, fontFamily: _kFontFam);
  static final urlController = TextEditingController();

  @override
  Widget build (BuildContext context) {
    Widget appBar;

    /*
    First line of Registration route
     */
    Widget registrationText = Container(
      padding: const EdgeInsets.only(top:50, bottom:35),
      child: Text(
        R.of(context).registrationTitle,
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
    Widget hostName = new TextInputField(R.of(context).registrationIPText, urlController, false, true);

    Widget body = new GestureDetector(
      onTap: (){
        FocusScope.of(context).unfocus();
      },
      child: Container(
        child: ListView(
          children: [
            registrationText,
            Container(
              height: 150,
            ),
            hostName,
            Container(
              height: 100,
            ),
            IconButton(
              onPressed: () async {
               if (!urlController.text.isEmpty) {
                 if (await RegistrationController.saveMondayHostname(context,
                     urlController.text))
                 Navigator.push(context,
                     MaterialPageRoute(builder: (context) => Login(true)));
               }
               else
                 Utils.showDialogPanel(R.of(context).warningMsg,
                     R.of(context).registrationIPNotice, context);
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