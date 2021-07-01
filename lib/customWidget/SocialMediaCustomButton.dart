import 'dart:io';

import 'package:flutter/material.dart';

class SocialMediaCustomButton extends StatelessWidget {
  final String btnText;
  final double size;
  final Function() onPressed;
  final splashColor;
  final Color buttonColor;
  final Color textColor;
  final image;
  bool enable;

  SocialMediaCustomButton(
      {this.btnText,
      this.size,
      this.enable,
      this.onPressed,
      this.splashColor,
      this.image,
      this.buttonColor,
      this.textColor});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        RaisedButton(
          color: enable ?? true ? buttonColor : buttonColor.withOpacity(0.5),
          textColor: enable ?? true ? textColor : textColor.withOpacity(0.5),
          onPressed: onPressed,
          shape: new RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5.0)),
          child: Padding(
            padding: EdgeInsets.all(size),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  btnText,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: "Roboto",
                    fontWeight: FontWeight.normal,
                    fontSize: size,
                  ),
                ),
              ],
            ),
          ),
          splashColor: splashColor,
        ),
        image != null
            ? Positioned(
                left: btnText == "Login with Apple"
                    ? 30.0
                    : Platform.isAndroid
                        ? 1.0
                        : 10.0,
                top: 0,
                bottom: 0,
                child: Image.asset(
                  image,
                  width: btnText == "Login with Apple" ? 20.0 : 50.0,
                  height: btnText == "Login with Apple" ? 20.0 : 50.0,
                ),
              )
            : Container(),
      ],
    );
  }
}
