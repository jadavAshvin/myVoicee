import 'package:flutter/cupertino.dart';
import 'package:my_voicee/constants/app_colors.dart';

class Styles {
  const Styles();

  static var inputHintStyle = TextStyle(
    color: Color(0xFF262628),
    fontFamily: "Roboto",
    fontSize: 18.0,
  );

  static var textHeaderStyle = TextStyle(
    color: colorBlack,
    fontSize: 20.0,
    fontFamily: "Roboto",
    fontWeight: FontWeight.w500,
  );

  static var textLoginStyle = TextStyle(
    color: colorWhite.withOpacity(0.7),
    fontSize: 18.0,
    fontFamily: "Roboto",
    fontWeight: FontWeight.w400,
    letterSpacing: -0.2,
  );

  static var btnLoginTextStyle = TextStyle(
    color: colorWhite,
    fontSize: 18.0,
    fontWeight: FontWeight.w500,
    fontFamily: "Roboto",
    letterSpacing: 0.0,
  );

  static var textStyleLabelContinue = TextStyle(
    color: Color(0xFF777171),
    fontSize: 14.0,
    fontFamily: "Roboto",
  );

  static var textStyleLabelTypeHead = TextStyle(
    color: colorBlack,
    fontSize: 14.0,
    fontFamily: "Roboto",
  );
}
