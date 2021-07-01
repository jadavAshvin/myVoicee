import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fm_fit/fm_fit.dart';
import 'package:my_voicee/constants/app_colors.dart';
import 'package:my_voicee/constants/app_constants.dart';
import 'package:my_voicee/constants/app_images_path.dart';
import 'package:my_voicee/customWidget/Alert/top_alert.dart';
import 'package:my_voicee/customWidget/SocialMediaCustomButton.dart';
import 'package:my_voicee/customWidget/circular_progress_widget/CircleProgress.dart';
import 'package:my_voicee/customWidget/pin_view.dart';
import 'package:my_voicee/models/GetAllPostsResponse.dart';
import 'package:my_voicee/models/UserResponse.dart';
import 'package:my_voicee/models/commonResponse/CommonpiResponse.dart';
import 'package:my_voicee/models/errorResponse/customeError.dart';
import 'package:my_voicee/models/errorResponse/error_reponse.dart';
import 'package:my_voicee/network/DioApiConfiguration.dart';
import 'package:my_voicee/postLogin/profile/profileBloc/ProfileBloc.dart';
import 'package:my_voicee/utils/Utility.dart';

class VerifyOTPScreen extends StatefulWidget {
  @override
  _VerifyOTPScreenState createState() => _VerifyOTPScreenState();
}

class _VerifyOTPScreenState extends State<VerifyOTPScreen>
    with TickerProviderStateMixin {
  var _scaffoldKey = GlobalKey<ScaffoldState>();
  FmFit fit = FmFit(width: 750);
  AnimationController controller;
  Animation<double> animation;
  Timer _t;
  final interval = const Duration(seconds: 1);

  final int timerMaxSeconds = 60;

  int currentSeconds = 0;

  UserData userData;

  String otpCode = "";

  String phone = "";
  bool isResend = false;

  String get timerText =>
      '${((timerMaxSeconds - currentSeconds) % 60).toString().padLeft(2, '0')}s';

  startTimeout([int milliseconds]) {
    var duration = interval;
    _t = Timer.periodic(duration, (timer) {
      if (mounted)
        setState(() {
          print(timer.tick);
          currentSeconds = timer.tick;
          currentSeconds = timer.tick;
          if (timer.tick >= timerMaxSeconds) timer.cancel();
        });
    });
  }

  ProfileBloc _bloc;
  StreamController apiResponseData;
  StreamController apiResponse;

  @override
  void initState() {
    startTimeout();
    apiResponseData = StreamController<List<AllPostResponse>>.broadcast();
    apiResponse = StreamController();
    _bloc = ProfileBloc(apiResponseData, apiResponse);
    _subscribeToApiResponse();
    controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 0));
    animation = Tween<double>(begin: 0, end: currentSeconds.toDouble())
        .animate(controller)
          ..addListener(() {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    phone = ModalRoute.of(context).settings.arguments;
    fit = FmFit(width: MediaQuery.of(context).size.width);
    if (MediaQuery.of(context).size.width > 700) {
      fit.scale = 1.0 + MediaQuery.of(context).size.aspectRatio;
    } else {
      fit.scale = 1.0;
    }
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: colorWhite,
        elevation: 0,
        leading: _leadingWidget(),
        centerTitle: true,
        title: _titleWidget(),
      ),
      body: Stack(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            color: colorWhite,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: fit.t(30.0),
                ),
                //name
                Container(
                  padding: EdgeInsets.only(left: fit.t(24.0)),
                  child: Text(
                    'Enter OTP sent to $phone',
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: fit.t(16.0),
                        fontWeight: FontWeight.w500,
                        color: Color.fromRGBO(0, 0, 0, 1)),
                  ),
                ),
                SizedBox(
                  height: fit.t(10.0),
                ),
                Container(
                    margin:
                        EdgeInsets.only(left: fit.t(25.0), right: fit.t(25.0)),
                    child: _smsCodeInputField()),
                Container(
                  margin:
                      EdgeInsets.only(left: fit.t(25.0), right: fit.t(25.0)),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        child: Text(
                          'Didn\'t received the OTP? Please wait',
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontFamily: 'Roboto',
                              fontWeight: FontWeight.w400,
                              fontSize: fit.t(14.0),
                              color: Color.fromRGBO(119, 113, 113, 1)),
                        ),
                      ),
                      Row(
                        children: [
                          Text("$timerText"),
                          Container(
                            height: fit.t(40.0),
                            width: fit.t(40.0),
                            child: AnimatedBuilder(
                              animation: controller,
                              builder: (context, child) {
                                return CustomPaint(
                                  foregroundPainter: CircleProgress(
                                      (currentSeconds / timerMaxSeconds) * 100,
                                      appColor,
                                      animation.value == 0.0
                                          ? Color(0x20464649)
                                          : Color(0x64464649)),
                                  child: Container(
                                    height: fit.t(20.0),
                                    width: fit.t(20.0),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: fit.t(20.0),
                ),
                timerText == "00s"
                    ? Center(
                        child: Container(
                          width: MediaQuery.of(context).size.width / 3,
                          height: fit.t(45.0),
                          child: SocialMediaCustomButton(
                            btnText: 'Resend',
                            buttonColor: colorAcceptBtn,
                            onPressed: _onResendClick,
                            size: 14.0,
                            splashColor: colorAcceptBtnSplash,
                            textColor: colorWhite,
                          ),
                        ),
                      )
                    : Container(),
              ],
            ),
          ),
          Positioned(
            bottom: fit.t(20.0),
            left: fit.t(50.0),
            right: fit.t(50.0),
            child: SocialMediaCustomButton(
              btnText: 'Verify',
              buttonColor: colorAcceptBtn,
              onPressed: _onContinue,
              size: fit.t(16.0),
              splashColor: colorAcceptBtnSplash,
              textColor: colorWhite,
            ),
          ),
        ],
      ),
    );
  }

  Widget _smsCodeInputField() {
    return PinView(
      count: 6, // describes the field number
      margin: EdgeInsets.all(fit.t(5.0)), // margin between the fields
      style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w500),
      submit: (String smsCode) {
        otpCode = smsCode;
        setState(() {});
      },
    );
  }

  Widget _titleWidget() {
    return Container(
      child: Padding(
        padding: EdgeInsets.only(
            top: fit.t(8.0), left: fit.t(8.0), right: fit.t(8.0)),
        child: Container(
          child: Text(
            'OTP Verification',
            style: TextStyle(
              fontFamily: 'Roboto',
              fontSize: fit.t(20.0),
              color: Colors.black,
            ),
          ),
        ),
      ),
    );
  }

  Widget _leadingWidget() {
    return InkWell(
      onTap: () => Navigator.of(context).pop(),
      child: Container(
        margin: EdgeInsets.only(left: fit.t(16.0)),
        child: Image.asset(
          ic_left_back,
          scale: 1.2,
        ),
      ),
    );
  }

  void _onContinue() {
    if (otpCode.isEmpty) {
      TopAlert.showAlert(context, "Please enter otp received.", true);
    } else if (otpCode.toString().length < 3) {
      TopAlert.showAlert(context, "Please enter valid otp.", true);
    } else {
      _bloc.callApiVerifyOtp(context, phone, otpCode);
    }
  }

  void _subscribeToApiResponse() {
    StreamSubscription subscription;
    subscription = apiResponse.stream.listen((data) {
      if (data is UserResponse) {
        userData = data.response;
        if (mounted) setState(() {});
      } else if (data is CommonApiReponse) {
        if (data.show_msg == 7) {
          writeStringDataLocally(key: cookie, value: data.response);
          ApiDioConfiguration.createNullConfiguration(
              ConfigConfig('${data.response}', true));
          Navigator.of(context).pop(true);
        } else if (data.show_msg == 6) {
          currentSeconds = 0;
          startTimeout();
          setState(() {});
        }
        TopAlert.showAlert(context, data.message, false);
      } else if (data is ErrorResponse) {
        TopAlert.showAlert(context, data.message, true);
      } else if (data is CustomError) {
        if (data.errorMessage == 'Check your internet connection.') {
          pushNamedIfNotCurrent(context, '/noInternet');
        } else {
          TopAlert.showAlert(
              _scaffoldKey.currentState.context, data.errorMessage, true);
        }
      } else if (data is Exception) {
        TopAlert.showAlert(_scaffoldKey.currentState.context,
            'Oops, Something went wrong please try again later.', true);
      }
    }, onError: (error) {
      if (error is CustomError) {
        TopAlert.showAlert(context, error.errorMessage, true);
      } else {
        TopAlert.showAlert(context, error.toString(), true);
      }
    });
  }

  void _onResendClick() {
    currentSeconds = 0;
    startTimeout();
    setState(() {});
    _bloc.callApiResendOtp(context, phone);
  }

  @override
  void dispose() {
    _t.cancel();
    apiResponseData.close();
    apiResponse.close();
    super.dispose();
  }
}
