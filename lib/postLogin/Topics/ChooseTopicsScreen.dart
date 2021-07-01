import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:fm_fit/fm_fit.dart';
import 'package:my_voicee/constants/app_colors.dart';
import 'package:my_voicee/constants/app_constants.dart';
import 'package:my_voicee/constants/app_images_path.dart';
import 'package:my_voicee/customWidget/Alert/top_alert.dart';
import 'package:my_voicee/customWidget/SocialMediaCustomButton.dart';
import 'package:my_voicee/customWidget/appLoader/custom_progress_loader.dart';
import 'package:my_voicee/customWidget/super_tooltip.dart';
import 'package:my_voicee/models/AllTopicsModel.dart';
import 'package:my_voicee/models/UserResponse.dart';
import 'package:my_voicee/models/commonResponse/CommonpiResponse.dart';
import 'package:my_voicee/models/errorResponse/customeError.dart';
import 'package:my_voicee/models/errorResponse/error_reponse.dart';
import 'package:my_voicee/postLogin/Topics/topicbloc/TopicsBloc.dart';
import 'package:my_voicee/utils/Utility.dart';

class ChooseTopicsScreen extends StatefulWidget {
  @override
  _ChooseTopicsScreenState createState() => _ChooseTopicsScreenState();
}

class _ChooseTopicsScreenState extends State<ChooseTopicsScreen> {
  var _scaffoldKey = GlobalKey<ScaffoldState>();
  SuperTooltip tooltip;
  FmFit fit = FmFit(width: 750);
  UserData data;
  List<Topics> _filters;
  List<Topics> _choices;
  TopicsBloc _bloc;
  StreamController apiResponseController;
  GlobalKey _one = GlobalKey();

  @override
  void initState() {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);
    SchedulerBinding.instance.addPostFrameCallback((_) => showTooltip());
    apiResponseController = StreamController();
    _bloc = TopicsBloc(apiResponseController);
    _subscribeToApiResponse();
    _bloc.getAllTopics(context);
    _filters = <Topics>[];
    _choices = <Topics>[];
    super.initState();
  }

  @override
  void dispose() {
    apiResponseController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    fit = FmFit(width: MediaQuery.of(context).size.width);
    if (MediaQuery.of(context).size.width > 600) {
      fit.scale = 1.0 + MediaQuery.of(context).size.aspectRatio;
    } else {
      fit.scale = 1.0;
    }
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.only(
                  left: fit.t(16.0), right: fit.t(16.0), bottom: fit.t(0.0)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  _widgetAppLogo(),
                  SizedBox(
                    key: _one,
                    height: fit.t(70.0),
                  ),
                  Text(
                    'Choose minimum 3 topics to\nget started',
                    style: TextStyle(
                        color: colorBlack,
                        fontSize: fit.t(20.0),
                        fontFamily: "Roboto",
                        fontWeight: FontWeight.w500),
                  ),
                  SizedBox(
                    height: fit.t(20.0),
                  ),
                  _choices.length > 0
                      ? Container(
                          height:
                              MediaQuery.of(context).size.width - fit.t(130.0),
                          child: SingleChildScrollView(
                            child: Wrap(
                              children: topicsPosition.toList(),
                            ),
                          ),
                        )
                      : Container(),
                ],
              ),
            ),
            Positioned(
              bottom: fit.t(20.0),
              left: fit.t(30.0),
              right: fit.t(30.0),
              child: SocialMediaCustomButton(
                btnText: 'Continue',
                buttonColor: _filters.length > 2
                    ? colorAcceptBtn
                    : colorAcceptBtn.withOpacity(0.3),
                onPressed: _onContinue,
                size: fit.t(14.0),
                splashColor: colorAcceptBtnSplash,
                textColor: _filters.length > 2
                    ? colorWhite
                    : colorWhite.withOpacity(0.5),
              ),
            ),
            StreamBuilder<Object>(
              stream: _bloc.progressLoaderStream,
              builder: (context, snapshot) {
                return ProgressLoader(
                  fit: fit,
                  isShowLoader: snapshot.hasData ? snapshot.data : false,
                  color: appColor,
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Iterable<Widget> get topicsPosition sync* {
    for (Topics topics in _choices) {
      yield Padding(
        padding: const EdgeInsets.all(4.0),
        child: FilterChip(
          backgroundColor: Color(0xFFf0f0f0),
          checkmarkColor: Colors.white,
          label: Text(
            topics.title,
          ),
          showCheckmark: false,
          selected: _filters.contains(topics),
          selectedColor: appColor.withOpacity(0.9),
          labelPadding: const EdgeInsets.all(3.0),
          selectedShadowColor: colorWhite,
          labelStyle: TextStyle(
              color: !_filters.contains(topics) ? Colors.black87 : colorWhite,
              fontWeight: FontWeight.w500,
              fontSize: fit.t(14.0),
              fontFamily: "Roboto"),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(5),
            ),
          ),
          onSelected: (bool selected) {
            setState(
              () {
                topics.isChoosed = true;
                if (selected) {
                  _filters.add(topics);
                } else {
                  _filters.removeWhere(
                    (Topics name) {
                      return name == topics;
                    },
                  );
                }
              },
            );
          },
        ),
      );
    }
  }

  //listen to api response
  void _subscribeToApiResponse() {
    StreamSubscription subscription;
    subscription = apiResponseController.stream.listen((data) {
      if (data is AllTopicsModel) {
        _choices.clear();
        _choices = data.response;
        setState(() {
          isShowTut = true;
        });
      } else if (data is ErrorResponse) {
        if (data.show_msg == 1) {
          if (data.authType != null) {
            if (data.authType == "login") {
              Navigator.pushReplacementNamed(context, '/waitingScreen');
            } else {
              Navigator.pushReplacementNamed(context, '/termsOfUse');
            }
          } else {
            TopAlert.showAlert(
                _scaffoldKey.currentState.context, data.message, true);
          }
        } else {
          TopAlert.showAlert(
              _scaffoldKey.currentState.context, data.message, true);
        }
      } else if (data is CommonApiReponse) {
        if (data.message == 'Check your internet connection.') {
          pushNamedIfNotCurrent(context, '/noInternet');
        } else {
          TopAlert.showAlert(
              _scaffoldKey.currentState.context, data.message, false);
        }
        Navigator.pushNamedAndRemoveUntil(
            context, '/masterDashboard', ModalRoute.withName('/'));
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
        TopAlert.showAlert(
            _scaffoldKey.currentState.context, error.errorMessage, true);
      } else {
        TopAlert.showAlert(
            _scaffoldKey.currentState.context, error.toString(), true);
      }
    });
  }

  //App Logo widget
  Widget _widgetAppLogo() {
    return Center(
      child: Container(
        padding: EdgeInsets.only(top: fit.t(40.0)),
        child: Image.asset(
          logo_blue,
          width: fit.t(100.0),
          height: fit.t(150.0),
        ),
      ),
    );
  }

  void _onContinue() {
    isShowTut = true;
    if (_filters.length > 2) {
      List<String> data = [];
      for (Topics topic in _filters) {
        if (topic.isChoosed) data.add(topic.id);
      }
      _bloc.submitSelectedTopics(context, data);
    } else
      return;
  }

  void showTooltip() {
    if (tooltip?.isOpen ?? false) {
      tooltip.close();
    }

    // We create the tooltip on the first use
    tooltip = SuperTooltip(
      popupDirection: TooltipDirection.up,
      backgroundColor: Colors.amberAccent,
      myOffset: Offset(0, 75),
      borderRadius: fit.t(24.0),
      borderWidth: fit.t(2.0),
      borderColor: Colors.black,
      dismissOnTapOutside: false,
      maxWidth: MediaQuery.of(context).size.width / 1.2,
      touchThroughAreaShape: ClipAreaShape.oval,
      hasShadow: true,
      content: Material(
        child: Container(
          color: Colors.amberAccent,
          child: Wrap(
            children: [
              Text(
                "select minimum 3 topics and click 'continue'",
                softWrap: true,
                style: TextStyle(
                    fontWeight: FontWeight.bold, fontFamily: "Roboto"),
              ),
              Container(
                height: fit.t(2.0),
              ),
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  InkWell(
                      onTap: () => tooltip.close(),
                      child: Text(
                        " Skip all ",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontFamily: "Roboto"),
                      )),
                  Text("|"),
                  InkWell(
                      onTap: () => tooltip.close(),
                      child: Text(
                        " Next ",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontFamily: "Roboto"),
                      )),
                  SizedBox(
                    width: fit.t(10.0),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
    tooltip.show(_one.currentContext);
  }
}
