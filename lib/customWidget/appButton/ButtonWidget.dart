import 'package:flutter/material.dart';

class ButtonWidget extends StatelessWidget {
  final String btnText;
  final Function() onPressed;
  final padding;
  final margin;
  final btnColor;
  final isEnable;
  final textStyle;
  final imageData;

  ButtonWidget(this.btnText, this.imageData, this.onPressed, this.isEnable,
      {this.btnColor, this.margin, this.textStyle, this.padding});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70.0,
      child: Card(
        elevation: 4.0,
        shadowColor: btnColor,
        color: btnColor,
        margin: margin,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: FlatButton(
          colorBrightness: Brightness.light,
          splashColor: btnColor,
          onPressed: isEnable ? onPressed : null,
          child: Opacity(
            opacity: isEnable ? 1.0 : 0.5,
            child: imageData != null
                ? Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Image.asset(
                        imageData,
                        height: 20.0,
                        width: 20.0,
                      ),
                      SizedBox(
                        width: 10.0,
                      ),
                      Text(
                        '$btnText',
                        style: textStyle,
                        textAlign: TextAlign.center,
                      )
                    ],
                  )
                : Text(
                    '$btnText',
                    style: textStyle,
                    textAlign: TextAlign.center,
                  ),
          ),
        ),
      ),
    );
  }
}
