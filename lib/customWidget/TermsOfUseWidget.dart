import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fm_fit/fm_fit.dart';
import 'package:my_voicee/constants/app_colors.dart';
import 'package:my_voicee/constants/app_images_path.dart';
import 'package:my_voicee/prelogin/TermsOfUseNew.dart';
import 'package:my_voicee/prelogin/WebViewTermsPrivacy.dart';

class TermsOfUseWidget extends StatefulWidget {
  final Function(bool selectedItem) onReportClick;

  TermsOfUseWidget(this.onReportClick);

  @override
  _TermsOfUseWidgetState createState() => _TermsOfUseWidgetState();
}

class _TermsOfUseWidgetState extends State<TermsOfUseWidget> {
  Color color = Color(0xccE4A244);
  FmFit fit = FmFit(width: 750);
  bool isEnable = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    fit = FmFit(width: MediaQuery.of(context).size.width);
    if (MediaQuery.of(context).size.width > 600) {
      fit.scale = 1.0 + MediaQuery.of(context).size.aspectRatio;
    } else {
      fit.scale = 1.0;
    }
    return Center(
      child: Container(
          padding: EdgeInsets.symmetric(
              horizontal: fit.t(20.0), vertical: fit.t(10.0)),
          width: fit.t(MediaQuery.of(context).size.width),
          height: fit.t(MediaQuery.of(context).size.height),
          margin: EdgeInsets.only(top: fit.t(10.0)),
          child: Stack(
            children: <Widget>[
              ListView(
                physics: NeverScrollableScrollPhysics(),
                children: <Widget>[
                  SizedBox(
                    height: fit.t(60.0),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(fit.t(5.0)),
                      color: Colors.white,
                    ),
                    margin: EdgeInsets.only(
                        top: fit.t(30.0),
                        left: fit.t(10.0),
                        right: fit.t(10.0)),
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      children: <Widget>[
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(fit.t(4.0)),
                                topRight: Radius.circular(fit.t(4.0))),
                            color: btnAppColor,
                          ),
                          height: fit.t(50.0),
                          child: Center(
                            child: Image.asset(
                              ic_logo_small,
                              color: Colors.white,
                              height: fit.t(20.0),
                              width: fit.t(20.0),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(fit.t(4.0)),
                          bottomRight: Radius.circular(fit.t(4.0))),
                      color: Colors.white,
                    ),
                    margin: EdgeInsets.only(
                        top: fit.t(0.0), left: fit.t(10.0), right: fit.t(10.0)),
                    child: Column(
                      children: <Widget>[
                        _termsOfUseWidget(),
                        SizedBox(
                          height: fit.t(20.0),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            GestureDetector(
                              onTap: () => Navigator.of(context).pop(),
                              child: Container(
                                margin: EdgeInsets.only(
                                    left: fit.t(24.0),
                                    right: fit.t(24.0),
                                    bottom: fit.t(10.0),
                                    top: fit.t(8.0)),
                                decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.circular(fit.t(24.0)),
                                    color: btnAppColor),
                                height: fit.t(35.0),
                                child: Center(
                                  child: Container(
                                    padding: EdgeInsets.only(
                                        top: fit.t(4.0),
                                        bottom: fit.t(4.0),
                                        left: fit.t(20.0),
                                        right: fit.t(20.0)),
                                    child: Text(
                                      'Cancel',
                                      style: TextStyle(
                                          fontSize: fit.t(18.0),
                                          fontFamily: "Roboto",
                                          color: Colors.white,
                                          fontWeight: FontWeight.w800),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: isEnable
                                  ? () => widget.onReportClick(true)
                                  : () {},
                              child: Container(
                                margin: EdgeInsets.only(
                                    left: fit.t(24.0),
                                    right: fit.t(24.0),
                                    bottom: fit.t(10.0),
                                    top: fit.t(8.0)),
                                decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.circular(fit.t(24.0)),
                                  color: isEnable
                                      ? btnAppColor
                                      : btnAppColor.withOpacity(0.5),
                                ),
                                height: fit.t(35.0),
                                child: Center(
                                  child: Container(
                                    padding: EdgeInsets.only(
                                        top: fit.t(4.0),
                                        bottom: fit.t(4.0),
                                        left: fit.t(20.0),
                                        right: fit.t(20.0)),
                                    child: Text('Accept',
                                        style: TextStyle(
                                            fontSize: fit.t(20.0),
                                            fontFamily: "Roboto",
                                            color: isEnable
                                                ? Colors.white
                                                : Colors.white.withOpacity(0.5),
                                            fontWeight: FontWeight.w600)),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: fit.t(10.0),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Positioned(
                right: 0,
                top: fit.t(80.0),
                child: GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: Container(
                    height: fit.t(30.0),
                    width: fit.t(30.0),
                    child: Icon(
                      Icons.close,
                      color: appColor,
                      size: fit.t(15.0),
                    ),
                    decoration: BoxDecoration(
                        shape: BoxShape.circle, color: colorWhite),
                  ),
                ),
              ),
            ],
          )),
    );
  }

  Widget _termsOfUseWidget() {
    return Container(
      margin: EdgeInsets.only(
          bottom: Platform.isAndroid ? fit.t(10.0) : fit.t(50.0)),
      child: Align(
        alignment: Alignment.lerp(Alignment.center, Alignment.center, 0.2),
        child: Container(
          margin: EdgeInsets.only(top: fit.t(20.0)),
          child: Row(
            children: [
              Checkbox(
                checkColor: Colors.white,
                activeColor: appColor,
                value: this.isEnable,
                onChanged: (bool value) {
                  setState(() {
                    this.isEnable = value;
                  });
                },
              ),
              RichText(
                softWrap: true,
                textAlign: TextAlign.center,
                text: TextSpan(
                  text: "I agree to the ",
                  style: TextStyle(
                      fontFamily: "Roboto",
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                      decoration: TextDecoration.none,
                      fontSize: fit.t(14.0)),
                  children: <TextSpan>[
                    TextSpan(
                      text: 'Terms of use',
                      style: TextStyle(
                          fontFamily: "Roboto",
                          color: appColor,
                          decoration: TextDecoration.underline,
                          fontWeight: FontWeight.w500,
                          fontSize: fit.t(14.0)),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          //privacy policy
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => TermsOfUseOther()));
                        },
                    ),
                    TextSpan(
                        text: ' | ',
                        style: TextStyle(
                            fontFamily: "Roboto",
                            color: colorBlack,
                            decoration: TextDecoration.none,
                            fontSize: fit.t(14.0))),
                    TextSpan(
                      text: 'Privacy policy',
                      style: TextStyle(
                          fontFamily: "Roboto",
                          color: appColor,
                          decoration: TextDecoration.underline,
                          fontWeight: FontWeight.w500,
                          fontSize: fit.t(14.0)),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          //privacy policy
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => WebViewTermsPrivacy(
                                      url:
                                          'https://voicee.co/privacy_policy.html',
                                      title: "Privacy policy")));
                        },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
