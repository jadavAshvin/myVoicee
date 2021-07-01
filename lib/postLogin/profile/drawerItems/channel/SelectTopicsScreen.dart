import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fm_fit/fm_fit.dart';
import 'package:my_voicee/constants/app_colors.dart';
import 'package:my_voicee/constants/app_images_path.dart';
import 'package:my_voicee/customWidget/Alert/top_alert.dart';
import 'package:my_voicee/customWidget/appLoader/custom_progress_loader.dart';
import 'package:my_voicee/models/AllTopicsModel.dart';
import 'package:my_voicee/models/commonResponse/CommonpiResponse.dart';
import 'package:my_voicee/models/errorResponse/customeError.dart';
import 'package:my_voicee/models/errorResponse/error_reponse.dart';
import 'package:my_voicee/postLogin/Topics/topicbloc/TopicsBloc.dart';
import 'package:my_voicee/utils/Utility.dart';

class SelectTopicsScreen extends StatefulWidget {
  @override
  _SelectTopicsScreenState createState() => _SelectTopicsScreenState();
}

class _SelectTopicsScreenState extends State<SelectTopicsScreen> {
  var _scaffoldKey = GlobalKey<ScaffoldState>();
  FmFit fit = FmFit(width: 750);
  List<Topics> _choices;
  TopicsBloc _bloc;
  StreamController apiResponseController;

  @override
  void initState() {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);
    apiResponseController = StreamController();
    _bloc = TopicsBloc(apiResponseController);
    _subscribeToApiResponse();
    _bloc.getAllTopics(context);
    _choices = <Topics>[];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    fit = FmFit(width: MediaQuery.of(context).size.width);
    if (MediaQuery.of(context).size.width > 700) {
      fit.scale = 1.0 + MediaQuery.of(context).size.aspectRatio;
    } else {
      fit.scale = 1.0;
    }
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: colorWhite,
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
            color: colorWhite,
            padding: EdgeInsets.only(
                top: fit.t(8.0),
                bottom: fit.t(8.0),
                left: fit.t(24.0),
                right: fit.t(24.0)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'All Topics',
                  style: TextStyle(
                      color: colorBlack,
                      fontSize: fit.t(18.0),
                      fontFamily: "Roboto",
                      fontWeight: FontWeight.w400,
                      letterSpacing: 1),
                ),
                Text(
                  'You can choose one topic',
                  style: TextStyle(
                      color: colorGrey,
                      fontSize: fit.t(12.0),
                      fontFamily: "Roboto",
                      fontWeight: FontWeight.w400,
                      letterSpacing: 1),
                ),
                SizedBox(
                  height: fit.t(10.0),
                ),
                _choices.length > 0
                    ? Container(
                        height: MediaQuery.of(context).size.height / 1.2,
                        child: ListView(
                          children: topicsPosition.toList(),
                        ),
                      )
                    : Container(),
              ],
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
    );
  }

  Iterable<Widget> get topicsPosition sync* {
    for (Topics topics in _choices) {
      yield Padding(
        padding: EdgeInsets.only(top: fit.t(8.0), right: fit.t(2.0)),
        child: Column(
          children: [
            ListTile(
              dense: true,
              contentPadding:
                  EdgeInsets.only(left: fit.t(8.0), right: fit.t(8.0)),
              leading: RichText(
                text: TextSpan(
                  text: topics.title,
                  style: TextStyle(
                      fontFamily: "Roboto",
                      color: Colors.black,
                      fontWeight: FontWeight.w400,
                      fontSize: fit.t(14.0)),
                ),
              ),
              onTap: () {
                Navigator.of(context).pop(topics);
              },
            ),
            Divider(
              color: Color.fromRGBO(243, 243, 243, 1),
            )
          ],
        ),
      );
    }
  }

  @override
  void dispose() {
    apiResponseController.close();
    super.dispose();
  }

  //listen to api response
  void _subscribeToApiResponse() {
    StreamSubscription subscription;
    subscription = apiResponseController.stream.listen((data) {
      if (data is AllTopicsModel) {
        _choices.clear();
        _choices = data.response;
        setState(() {});
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

  Widget _titleWidget() {
    return Container(
      child: Padding(
        padding: EdgeInsets.only(
            top: fit.t(8.0), left: fit.t(8.0), right: fit.t(8.0)),
        child: Container(
          child: Text(
            'Topics',
            style: TextStyle(
              fontFamily: 'Roboto',
              fontSize: fit.t(18.0),
              color: Colors.black,
              fontWeight: FontWeight.w400,
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
          width: fit.t(30.0),
          height: fit.t(30.0),
        ),
      ),
    );
  }
}
