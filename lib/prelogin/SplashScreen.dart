import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_voicee/analytics/FAEvent.dart';
import 'package:my_voicee/analytics/FAEventName.dart';
import 'package:my_voicee/analytics/FATracker.dart';
import 'package:my_voicee/analytics/FirebaseAnalyticsUtil.dart';
import 'package:my_voicee/constants/app_constants.dart';
import 'package:my_voicee/models/UserResponse.dart';
import 'package:my_voicee/utils/Utility.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  UserData data;

  @override
  void initState() {
    super.initState();
    isShowTut = false;
    FATracker tracker = FATracker();
    tracker.track(FAEvents(eventName: FIRST_OPEN_EVENT, attrs: null));
    FirebaseAnalyticsUtil.instance.hitEvent(FIRST_OPEN_EVENT, null);
    getStringDataLocally(key: userData).then((value) {
      if (value != null) if (value.isNotEmpty)
        data = UserData.fromJson(jsonDecode(value));
    });
    _startSplashScreenTimer();
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);
  }

  _startSplashScreenTimer() async {
    var _duration = Duration(milliseconds: splashDuration);
    return Timer(_duration, _navigationToNextPage);
  }

  void _navigationToNextPage() {
    getBoolDataLocally(key: session).then((onValue) {
      if (onValue) {
        if (mounted) {
          if (data != null) {
            if (data.is_approved == 1) {
              Navigator.pushReplacementNamed(context, '/masterDashboard');
            } else {
              Navigator.pushReplacementNamed(context, '/waitingScreen');
            }
          } else {
            Navigator.pushReplacementNamed(context, '/termsOfUse');
          }
        }
      } else {
        Navigator.pushReplacementNamed(context, '/login');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Container(),
      ),
    );
  }
}
