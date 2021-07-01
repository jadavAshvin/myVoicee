import 'dart:io';
import 'dart:math';

import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:my_voicee/constants/app_constants.dart';
import 'package:my_voicee/customWidget/Alert/top_alert.dart';
import 'package:my_voicee/customWidget/ReportWidget.dart';
import 'package:my_voicee/customWidget/TermsOfUseWidget.dart';
import 'package:my_voicee/customWidget/radio_item.dart';
import 'package:my_voicee/utils/DialogParentWidget.dart';
import 'package:shared_preferences/shared_preferences.dart';

showSnackBar(String message, final scaffoldKey) {
  scaffoldKey.currentState.showSnackBar(new SnackBar(
    backgroundColor: Colors.red[600],
    content: new Text(
      message,
      style: new TextStyle(color: Colors.white),
    ),
  ));
}

String formatString(List x) {
  String formatted = '';
  for (var i in x) {
    formatted += '$i,';
  }
  return formatted.replaceRange(formatted.length - 1, formatted.length, '');
}

void pushNamedIfNotCurrent(BuildContext context, String routeName,
    {Object arguments}) {
  if (!isCurrent(routeName, context)) {
    pushNamed(routeName, context, arguments: arguments);
  }
}

void pushNamed(String routeName, BuildContext context, {Object arguments}) {
  Navigator.of(context).pushNamed(routeName, arguments: arguments);
}

bool isCurrent(String routeName, BuildContext context) {
  bool isCurrent = false;
  popUntil((route) {
    if (route.settings.name == routeName) {
      isCurrent = true;
    }
    return true;
  }, context);
  return isCurrent;
}

void popUntil(bool Function(Route) param0, BuildContext context) {
  Navigator.of(context).popUntil(param0);
}

onLogOutFromApplication(BuildContext context, [String isshow]) {
  try {
    checkInternetConnection().then((onValue) {
      !onValue
          ? TopAlert.showAlert(context, 'Check your internet connection.', true)
          : _apiCalllogout(context, isshow);
    });
  } catch (e) {
    print(e);
  }
}

_apiCalllogout(BuildContext context, String isshow) {
  try {
//    Map<String, dynamic> map = Map<String, dynamic>();
//    map.putIfAbsent('accesstoken', () => 'asdasf');
//    if (!baseUrl.contains('https://')) {
//      map.putIfAbsent('insecure', ()=>'cool');
//    }
//        .apiClient
//        .liveService
//        .apiPostRequest(context, '$baseUrl$apiLogout', map)
//        .then((response) {
//      clearDataLocally();
//      Navigator.pushNamedAndRemoveUntil(
//          context, '/preLogin', ModalRoute.withName('/'));
//      if (isshow == null) {
//        TopAlert.showAlert(
//            context, 'User Role has been changed please login again.', true);
//      } else {
//        TopAlert.showAlert(context, 'Logout successfully!', false);
//      }
//    });
  } catch (e) {
    print(e);
  }
}

closeAnyView(BuildContext context) async {
  Navigator.pop(context);
}

double round(double value, double places) {
  double mod = pow(10.0, places);
  return ((value * mod).round().toDouble() / mod);
}

List<TextInputFormatter> userNameMobileformatter() {
  List<TextInputFormatter> list = [];
  list.add(LengthLimitingTextInputFormatter(userNameLength));
  list.add(WhitelistingTextInputFormatter(RegExp("[a-zA-Z0-9]")));
  list.add(
      BlacklistingTextInputFormatter(RegExp('/^[^* | \ " : < > [ ] { } ` \ ( ) '
          ' ; @ . & \$]+\$/')));
  return list;
}

List<TextInputFormatter> mobileNumberFormatter() {
  List<TextInputFormatter> list = [];
  list.add(LengthLimitingTextInputFormatter(phoneLength));
  list.add(WhitelistingTextInputFormatter(RegExp("[0-9]")));
  list.add(
      BlacklistingTextInputFormatter(RegExp('/^[^* | \ " : < > [ ] { } ` \ ( ) '
          ' ; @ . & \$]+\$/')));
  return list;
}

List<TextInputFormatter> companyNameFormatter() {
  List<TextInputFormatter> list = [];
  list.add(LengthLimitingTextInputFormatter(userNameLength));
  list.add(WhitelistingTextInputFormatter(RegExp("[a-zA-Z0-9 ]")));
  list.add(
      BlacklistingTextInputFormatter(RegExp('/^[^* | \ " : < > [ ] { } ` \ ( ) '
          ' ; @ . & \$]+\$/')));
  return list;
}

double convertToTwoDecimalPlacesDigit(double value) {
  int decimals = 2;
  int fac = pow(10, decimals);
  double d = value;
  d = (d * fac).round() / fac;
  return d;
}

Future<SharedPreferences> saveLocal = SharedPreferences.getInstance();

writeStringDataLocally({String key, dynamic value}) async {
  final SharedPreferences localData = await saveLocal;
  localData.setString(key, value);
}

writeBoolDataLocally({String key, bool value}) async {
  final SharedPreferences localData = await saveLocal;
  localData.setBool(key, value);
}

getDataLocally({String key}) async {
  final SharedPreferences localData = await saveLocal;
  return localData.get(key);
}

Future<String> getStringDataLocally({String key}) async {
  final SharedPreferences localData = await saveLocal;
  return localData.getString(key);
}

getBoolDataLocally({String key}) async {
  final SharedPreferences localData = await saveLocal;
  return localData.getBool(key) == null ? false : localData.getBool(key);
}

clearDataLocally() async {
  final SharedPreferences localData = await saveLocal;
  localData.clear();
}

List<TextInputFormatter> nameformatter() {
  List<TextInputFormatter> list = [];
  int nameLength = 50;
  list.add(LengthLimitingTextInputFormatter(nameLength));
  list.add(WhitelistingTextInputFormatter(RegExp("[a-z A-Z 0-9]")));
  list.add(
    BlacklistingTextInputFormatter(
      RegExp('/^[^* | \ " : < > [ ] { } ` \ ( ) '
          ' ; @ . & \$]+\$/'),
    ),
  );
  return list;
}

Future<bool> checkInternetConnection() async {
  bool result = await DataConnectionChecker().hasConnection;
  if (result) {
    return true;
  } else {
    return false;
  }
}

checkInternetMessage(context) {
  TopAlert.showAlert(context, 'Check your internet connection.', true);
}

String getDeviceType() {
  if (Platform.isAndroid)
    return '1';
  else if (Platform.isIOS)
    return '2';
  else
    return '3';
}

String timeAgo(DateTime d) {
  Duration diff = DateTime.now().toUtc().difference(d);
  if (diff.inDays > 365)
    return "${(diff.inDays / 365).floor()} ${(diff.inDays / 365).floor() == 1 ? "year" : "years"} ago";
  if (diff.inDays > 30)
    return "${(diff.inDays / 30).floor()} ${(diff.inDays / 30).floor() == 1 ? "month" : "months"} ago";
  if (diff.inDays > 7)
    return "${(diff.inDays / 7).floor()} ${(diff.inDays / 7).floor() == 1 ? "week" : "weeks"} ago";
  if (diff.inDays > 0)
    return "${diff.inDays} ${diff.inDays == 1 ? "day" : "days"} ago";
  if (diff.inHours > 0)
    return "${diff.inHours} ${diff.inHours == 1 ? "hour" : "hours"} ago";
  if (diff.inMinutes > 0)
    return "${diff.inMinutes} ${diff.inMinutes == 1 ? "min" : "min"} ago";
  return " now";
}

String convertMilliToDate(int date, String format) {
  var _date = new DateTime.fromMillisecondsSinceEpoch(date);

  var timeFormatter = new DateFormat(format);
  return timeFormatter.format(_date);
}

showDialogReportUser(BuildContext context,
    {@required String title,
    @required String content,
    @required Function(GroupItem item) onReportClick}) {
  showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return MyDialog(
          elevation: 0.0,
          backgroundColor: Colors.black54,
          child: ReportWidget(title, content, onReportClick),
        );
      });
}

showDialogAcceptTerms(BuildContext context,
    {@required Function(bool item) onClick}) {
  showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Center(
          child: MyDialog(
            elevation: 0.0,
            backgroundColor: Colors.black54,
            child: Center(child: TermsOfUseWidget(onClick)),
          ),
        );
      });
}
