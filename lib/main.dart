import 'dart:async';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:my_voicee/analytics/FirebaseAnalyticsUtil.dart';
import 'package:my_voicee/constants/app_colors.dart';
import 'package:my_voicee/constants/app_constants.dart';
import 'package:my_voicee/network/DioApiConfiguration.dart';
import 'package:my_voicee/postLogin/Topics/ChooseTopicsScreen.dart';
import 'package:my_voicee/postLogin/addPost/AddPostScreen.dart';
import 'package:my_voicee/postLogin/master_screen/MasterDashboardNew.dart';
import 'package:my_voicee/postLogin/master_screen/NotificationSceen.dart';
import 'package:my_voicee/postLogin/master_screen/dashboard/DashBoardScreen.dart';
import 'package:my_voicee/postLogin/profile/ProfileScreen.dart';
import 'package:my_voicee/prelogin/SplashScreen.dart';
import 'package:my_voicee/prelogin/TermsOfUse.dart';
import 'package:my_voicee/prelogin/WaitingScreen.dart';
import 'package:my_voicee/prelogin/login/loginScreen.dart';
import 'package:my_voicee/utils/Utility.dart';

import 'customWidget/noInternet/NoInternetWidget.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Set `enableInDevMode` to true to see reports while in debug mode
  // This is only to be used for confirming that reports are beingre
  // submitted as expected. It is not intended to be used for everyday
  // development.
  getStringDataLocally(key: cookie).then((value) {
    FirebaseMessaging().getToken().then((onToken) {
      writeStringDataLocally(key: fcmToken, value: onToken);
      if (value == null || value.isEmpty) {
        ApiDioConfiguration.initialize(ConfigConfig('', false));
      } else {
        ApiDioConfiguration.initialize(ConfigConfig('$value', true));
      }
    });
  });
  await Firebase.initializeApp();
  // Pass all uncaught errors from the framework to Crashlytics.
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
  runZoned<Future<void>>(() async {},
      onError: FirebaseCrashlytics.instance.recordError);
  return runApp(new VoiceeApp());
}

class VoiceeApp extends StatelessWidget {
  FirebaseAnalytics analytics = FirebaseAnalytics();

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'The Voicee',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: colorWhite,
          unselectedIconTheme: IconThemeData(color: colorGrey2),
          unselectedItemColor: colorGrey2,
          unselectedLabelStyle: TextStyle(
            fontFamily: "Roboto",
            fontWeight: FontWeight.w400,
            color: colorGrey2,
            fontSize: 11.0,
          ),
          elevation: 10.0,
          selectedItemColor: appColor,
          selectedIconTheme: IconThemeData(color: appColor),
          selectedLabelStyle: TextStyle(
            fontFamily: "Roboto",
            fontWeight: FontWeight.w400,
            color: appColor,
            fontSize: 11.0,
          ),
          showSelectedLabels: true,
          showUnselectedLabels: true,
          type: BottomNavigationBarType.fixed,
        ),
        visualDensity: VisualDensity.adaptivePlatformDensity,
        primarySwatch: MaterialColor(
          0xFF123391,
          const <int, Color>{
            50: const Color(0xFF123391),
            100: const Color(0xFF123391),
            200: const Color(0xFF123391),
            300: const Color(0xFF123391),
            400: const Color(0xFF123391),
            500: const Color(0xFF123391),
            600: const Color(0xFF123391),
            700: const Color(0xFF123391),
            800: const Color(0xFF123391),
            900: const Color(0xFF123391),
          },
        ),
      ),
      // Application's top-level routing table.
      routes: <String, WidgetBuilder>{
        '/login': (BuildContext context) => LoginScreen(),
        '/dashboardScreen': (BuildContext context) => DashBoardScreen(),
        '/topicScreen': (BuildContext context) => ChooseTopicsScreen(),
        '/addPostScreen': (context) => AddPostScreen(),
        '/userProfileScreen': (context) => ProfileScreen(),
        '/notificationScreen': (context) => NotificationScreen(),
        '/masterDashboard': (BuildContext context) =>
            MasterDashboardScreenNew(menuScreenContext: context),
        // '/personalInfoScreen': (BuildContext context) => TutorialVideo(),
        '/termsOfUse': (BuildContext context) => TermsOfUse(),
        '/waitingScreen': (BuildContext context) => WaitingScreen(),
        '/noInternet': (BuildContext context) => NoInternet(),
      },
      navigatorObservers: [
        FirebaseAnalyticsObserver(
            analytics: FirebaseAnalyticsUtil.instance.analytics)
      ],

      home: SplashScreen(),
    );
  }
}
