import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:my_voicee/constants/app_colors.dart';
import 'package:my_voicee/constants/app_images_path.dart';
import 'package:my_voicee/customWidget/appButton/ButtonWidget.dart';

class NoInternet extends StatelessWidget {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: appColor,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(top: 40.0),
              child: textWidget(
                  'Ooops!No or slow internet connection, please try again.',
                  TextStyle(
                      color: colorWhite,
                      fontSize: 22.0,
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w600,
                      letterSpacing: -0.4)),
            ),
            SizedBox(
              height: 150,
              child: SpinKitCircle(
                color: colorWhite,
                size: 100.0,
              ),
            ),
            SizedBox(
              height: 150,
              child: Image.asset(
                no_internet,
                height: 80.0,
                width: 80.0,
              ),
            ),
            _btnLoginWidget(context),
          ],
        ),
      ),
    );
  }

  Widget textWidget(text, style) {
    return Container(
      margin: EdgeInsets.only(left: 15.0, right: 15.0, bottom: 10.0, top: 20.0),
      child: Text(
        '$text',
        style: style,
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _btnLoginWidget(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 20.0, right: 20.0, top: 20.0, bottom: 50.0),
      width: MediaQuery.of(context).size.width,
      child: ButtonWidget(
        'Okay',
        null,
        () => Navigator.of(context).pop(true),
        true,
        btnColor: colorWhite,
        margin: EdgeInsets.only(top: 15.0, bottom: 10.0),
        padding: EdgeInsets.all(0.0),
        textStyle: TextStyle(
          color: colorBlack,
          fontSize: 18.0,
          fontFamily: 'Roboto',
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
