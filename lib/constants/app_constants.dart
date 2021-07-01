import 'package:flutter/material.dart';
import 'package:my_voicee/models/AllTopicsModel.dart';

//Fonts
const String robotoBlack = 'assets/fonts/roboto/Roboto-Black.ttf';
const String robotoBlackItalic = 'assets/fonts/roboto/Roboto-BlackItalic.ttf';
const String robotoBold = 'assets/fonts/roboto/Roboto-Bold.ttf';
const String robotoBoldItalic = 'assets/fonts/roboto/Roboto-BoldItalic.ttf';
const String robotoItalic = 'assets/fonts/roboto/Roboto-Italic.ttf';
const String robotoLight = 'assets/fonts/roboto/Roboto-Light.ttf';
const String robotoLightItalic = 'assets/fonts/roboto/Roboto-LightItalic.ttf';
const String robotoMedium = 'assets/fonts/roboto/Roboto-Medium.ttf';
const String robotoMediumItalic = 'assets/fonts/roboto/Roboto-MediumItalic.ttf';
const String robotoRegular = 'assets/fonts/roboto/Roboto-Regular.ttf';
const String robotoThinItalic = 'assets/fonts/roboto/Roboto-ThinItalic.ttf';

const passwordLength = 25;
const emailLength = 80;
const userNameLength = 40;
const phoneLength = 12;
const zipCodeLength = 12;
const splashDuration = 2200;
const animationDuration = 200;

bool isShowTut = false;

//app gradient color
const Gradient gradientApp = LinearGradient(
  begin: FractionalOffset.bottomCenter,
  end: FractionalOffset.topCenter,
  colors: [
    Color(0xFF83CCE7),
    Color(0xFF83CCE7),
  ],
  tileMode: TileMode.repeated,
);

const Gradient gradientAppWhite = LinearGradient(
  begin: FractionalOffset.bottomCenter,
  end: FractionalOffset.topCenter,
  colors: [
    Color(0xFFFFFFFF),
    Color(0xFFFFFFFF),
  ],
  tileMode: TileMode.repeated,
);
//toolbar gradient color
const Gradient gradientAppToolBar = LinearGradient(colors: [
  Color(0xFF83CCE7),
  Color(0xFF83CCE7),
  Color(0xFF83CCE7),
  Color(0xFF83CCE7),
]);

//api constants
final String clientSecretTwitter =
    "HIH2qsobbv9M2l4Vej6RRwtNNkYbV8ZinAkfw4GsL9r8xbiSSy";
final String clientKeyTwitter = "c2ENUxCmNoYDhvY43fxaHuIH6";
final String session = 'my_voicee_session';
final String toMailId = 'contact@voicee.co';
final String fbStringToken = 'my_voicee_fb_token';
final String mailSubject = 'voicee support';
final String mailBody = 'Please write your feedback or issue here...';
final distictAcPcData = 'my_voicee_distictAcPcData';
final stateData = 'my_voicee_stateData';
final countryData = 'my_voicee_countryData';
final cookie = 'my_voicee_cookie';
final fcmToken = 'my_voicee_fcmToken';

final orderExpiryTime = 'my_voicee_order_expiry';
final refreshToken = 'refreshToken';
final userData = 'my_voicee_user_data';
final String latitude = 'my_voicee_lat';
final String longitude = 'my_voicee_lng';
final String userId = 'my_voicee_user_id';
final String password = 'my_voicee_user_password';
final String language = 'my_voicee_app_language';
final String address = 'my_voicee_address';
final String userName = 'my_voicee_userName';
final String dashBoardData = 'my_voicee_dashboard_list';
final String historyCall = 'my_voicee_history_call_time';
final String dashboardCall = 'my_voicee_dash_call_time';
final String hitApiHistory = 'my_voicee_history_api_call';
final String dashboardCallApi = 'my_voicee_dashboardCallApi';
final String historyList = 'my_voicee_history_list';
final String fbToken = 'fbStringToken;';
List<Topics> selectedTopic = [];

///login type constant
final int isFacebook = 1;
final int isGoogle = 2;
final int isTWitter = 3;
final int isApple = 4;

//api flags
const int NO_INTERNET_FLAG = 1000;
const int ERROR_EXCEPTION_FLAG = 1001;
const int LOGIN_FLAG = 1002;
const int GET_PROFILE = 1008;
const int UPDATE_PROFILE = 1009;
const int GET_COUNTRIES = 1011;
const int GET_STATES = 1010;
const int GET_DISTRICT_AC_PC = 1012;
const int UPDATE_USER_DETAIL = 1013;
const int GET_ALL_POSTS = 1014;
const int UP_DOWN_VOTE_POSTS = 1015;
const int UPLOAD_FILE = 1016;
const int ADD_POST = 1017;
const int GET_A_POST = 1018;
const int ADD_COMMENT = 1019;
const int GET_UP_VOTES = 1020;
const int GET_DOWN_VOTES = 1021;
const int GET_SHARES = 1022;
const int GET_COMMENTS = 1023;
const int GET_ALL_REACTIONS = 1024;
const int UPLOAD_PROFILE_PIC = 1025;
const int GET_AC_PC = 1026;
const int REPORT_POST = 1027;
const int GET_OTHER_PROFILE = 1028;
const int SEARCH_RESULT = 1029;
const int GET_USER_COMMENTS = 1031;
const int UP_DOWN_VOTE_COMMENTS = 1032;
const int TOPICS_FLAG = 1033;
const int SAVE_TOPICS_FLAG = 1034;
const int GET_OTP_FLAG = 1035;
const int VERIFY_OTP_FLAG = 1036;
const int GET_CHANNELS_FLAG = 1037;
const int CREATE_CHANNELS_FLAG = 1038;
const int UPDATED_CHANNELS_FLAG = 1039;
const int GET_FOLLOWERS = 1040;
const int GET_FOLLOWINGS = 1041;
const int USER_FOLLOW = 1042;
const int NOTIFICATIONS_FLAG = 1043;
const int REPORT_USER = 1044;
