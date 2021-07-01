import 'package:flutter/material.dart';
import 'package:fm_fit/fm_fit.dart';
import 'package:my_voicee/constants/app_colors.dart';
import 'package:my_voicee/constants/app_constants.dart';

class NoDataWidget extends StatelessWidget {
  final String txt;
  final FmFit fit;
  final String url;

  const NoDataWidget({Key key, this.txt, this.fit, this.url}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: fit.t(30.0), bottom: fit.t(20.0)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
                text: txt == '' ? '' : '$txt\n',
                style: TextStyle(
                  fontSize: url != null ? fit.t(12.0) : fit.t(14.0),
                  color: appColor,
                  fontWeight: FontWeight.w400,
                  fontFamily: robotoBold,
                ),
                children: <TextSpan>[
                  TextSpan(
                    text: url != null ? url : '',
                    style: TextStyle(
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.bold,
                        fontFamily: robotoBold,
                        color: redColor,
                        fontSize: url != null ? fit.t(12.0) : fit.t(9.0)),
                  )
                ]),
          ),
        ],
      ),
    );
  }
}
