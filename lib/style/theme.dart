import 'dart:ui';

import 'package:flutter/cupertino.dart';

class ColorsTheme {
  const ColorsTheme();

  static const Color loginGradientStart = const Color(0xFF123391);
  static const Color loginGradientEnd = const Color(0xFF123391);
  static const Color dashboardGradientStart = const Color(0xFF123391);
  static const Color imageGradientStart = const Color(0xFF000000);
  static const Color imageGradientEnd = const Color(0x50000000);
  static const Color dashboardGradientEnd = const Color(0xFF123391);

  static const dashBoardGradient = const LinearGradient(
    colors: const [loginGradientStart, loginGradientEnd],
    stops: const [0.0, 1.0],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
}
