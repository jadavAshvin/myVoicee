import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fm_fit/fm_fit.dart';
import 'package:my_voicee/constants/app_colors.dart';
import 'package:my_voicee/constants/app_images_path.dart';

class BottomSheetWaitRecord extends StatefulWidget {
  final Function callBack;

  BottomSheetWaitRecord({this.callBack});

  @override
  _BottomSheetWaitRecordState createState() => _BottomSheetWaitRecordState();
}

class _BottomSheetWaitRecordState extends State<BottomSheetWaitRecord> {
  var _scaffoldKey = GlobalKey<ScaffoldState>();
  FmFit fit = FmFit(width: 750);
  var timerValue = "3";

  @override
  void initState() {
    Timer.periodic(Duration(seconds: 1), (Timer t) async {
      if (t.tick == 1) {
        if (mounted) {
          setState(() {
            timerValue = "2";
          });
        } else {
          t.cancel();
        }
      } else if (t.tick == 2) {
        if (mounted) {
          setState(() {
            timerValue = "1";
          });
        } else {
          t.cancel();
        }
      } else {
        t.cancel();
        if (mounted) widget.callBack();
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    fit = FmFit(width: MediaQuery.of(context).size.width);
    if (MediaQuery.of(context).size.width > 600) {
      fit.scale = 1.0 + MediaQuery.of(context).size.aspectRatio;
    } else {
      fit.scale = MediaQuery.of(context).size.aspectRatio;
    }
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.transparent,
      body: Container(
        height: MediaQuery.of(context).size.height,
        decoration: new BoxDecoration(
            color: Colors.white,
            borderRadius: new BorderRadius.only(
                topLeft: const Radius.circular(20.0),
                topRight: const Radius.circular(20.0))),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.only(top: fit.t(60.0), bottom: fit.t(8.0)),
                child: Text(
                  'Are you ready?',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 18.0,
                      fontFamily: 'Roboto',
                      color: Colors.black,
                      fontWeight: FontWeight.w500),
                )),
            SizedBox(
              height: fit.t(10.0),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.only(
                top: fit.t(15.0),
              ),
              child: Text(
                'Make sure you don\'t have any background noise',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color.fromRGBO(0, 0, 0, 0.4),
                  fontSize: 14.0,
                  fontFamily: "Roboto",
                ),
              ),
            ),
            Container(
                margin: EdgeInsets.all(fit.t(30.0)),
                child: Center(
                    child: Stack(
                  children: <Widget>[
                    Image.asset(
                      ic_ripple_image,
                      width: MediaQuery.of(context).size.width / 2,
                      height: MediaQuery.of(context).size.height / 4,
                    ),
                    Positioned(
                      top: 0,
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Center(
                        child: Text(
                          '$timerValue',
                          style: TextStyle(
                              color: appColor,
                              fontSize: 48.0,
                              fontFamily: "Roboto",
                              fontWeight: FontWeight.w500),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                )))
          ],
        ),
      ),
    );
  }
}
