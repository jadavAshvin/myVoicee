import 'package:flutter/material.dart';
import 'package:fm_fit/fm_fit.dart';
import 'package:my_voicee/constants/app_colors.dart';
import 'package:my_voicee/customWidget/SocialMediaCustomButton.dart';
import 'package:my_voicee/utils/Utility.dart';

class WaitingScreen extends StatefulWidget {
  @override
  _WaitingScreenState createState() => _WaitingScreenState();
}

class _WaitingScreenState extends State<WaitingScreen> {
  FmFit fit = FmFit(width: 750);

  @override
  Widget build(BuildContext context) {
    fit = FmFit(width: MediaQuery.of(context).size.width);
    if (MediaQuery.of(context).size.width > 600) {
      fit.scale = 1.0 + MediaQuery.of(context).size.aspectRatio;
    } else {
      fit.scale = 1.0;
    }
    return Scaffold(
        backgroundColor: appColor,
        body: Stack(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(left: fit.t(16.0), right: fit.t(16.0)),
              child: Center(
                child: Text(
                  'Your Account is under review, Please wait till the system review it !!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: colorWhite,
                    fontWeight: FontWeight.bold,
                    fontSize: 30.0,
                    fontFamily: 'Roboto',
                  ),
                ),
              ),
            ),
            Positioned(
              left: fit.t(24.0),
              bottom: fit.t(24.0),
              right: fit.t(24.0),
              child: Container(
                child: SocialMediaCustomButton(
                  btnText: 'Okay',
                  buttonColor: colorWhite,
                  onPressed: _onOkAccept,
                  size: 18.0,
                  splashColor: colorAcceptBtnSplash,
                  textColor: colorAcceptBtn,
                ),
              ),
            )
          ],
        ));
  }

  void _onOkAccept() {
    clearDataLocally();
    Navigator.pushNamedAndRemoveUntil(
        context, '/login', ModalRoute.withName('/'));
  }
}
