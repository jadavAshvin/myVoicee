import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fm_fit/fm_fit.dart';
import 'package:my_voicee/constants/app_colors.dart';
import 'package:my_voicee/constants/app_images_path.dart';
import 'package:my_voicee/customWidget/Alert/top_alert.dart';
import 'package:my_voicee/customWidget/SocialMediaCustomButton.dart';
import 'package:my_voicee/customWidget/appLoader/custom_progress_loader.dart';
import 'package:my_voicee/models/AllTopicsModel.dart';
import 'package:my_voicee/models/ChannelDataList.dart';
import 'package:my_voicee/models/commonResponse/CommonpiResponse.dart';
import 'package:my_voicee/models/errorResponse/customeError.dart';
import 'package:my_voicee/models/errorResponse/error_reponse.dart';
import 'package:my_voicee/postLogin/profile/drawerItems/channel/SelectTopicsScreen.dart';
import 'package:my_voicee/postLogin/profile/drawerItems/channel/bloc/ChannelBloc.dart';
import 'package:my_voicee/utils/Utility.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

class ChannelTypeScreen extends StatefulWidget {
  final Channels data;

  ChannelTypeScreen([this.data]);

  @override
  _ChannelTypeScreenState createState() => _ChannelTypeScreenState();
}

class _ChannelTypeScreenState extends State<ChannelTypeScreen> {
  var _scaffoldKey = GlobalKey<ScaffoldState>();
  FmFit fit = FmFit(width: 750);
  var screenFocusNode = FocusNode();
  var _inputController = TextEditingController();
  int radioValue1 = -1;
  Topics topicSelected;
  ChannelBloc _bloc;
  StreamController apiController;

  @override
  void initState() {
    if (widget.data.id != null) {
      topicSelected = Topics(
          title: widget.data.topic.title,
          img: widget.data.topic.img,
          createdAt: widget.data.topic.createdAt,
          id: widget.data.topic.id,
          isChoosed: false,
          isDeleted: widget.data.topic.isDeleted,
          v: widget.data.topic.v);
      _handleRadioValueChange1(widget.data.type);
    }
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);
    apiController = StreamController();
    _bloc = ChannelBloc(apiController);
    _subscribeToApiResponse();
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
      appBar: AppBar(
        backgroundColor: colorWhite,
        elevation: 0,
        leading: _leadingWidget(),
        centerTitle: true,
        title: _titleWidget(),
      ),
      body: Stack(
        children: [
          ListView(
            children: [
              GestureDetector(
                onTap: () async {
                  var result = await pushNewScreen(context,
                      screen: SelectTopicsScreen(), withNavBar: false);
                  if (result != null) {
                    if (result is Topics) {
                      if (mounted)
                        setState(() {
                          topicSelected = result;
                        });
                    }
                  }
                },
                child: Container(
                  color: colorWhite,
                  padding: EdgeInsets.only(
                      top: fit.t(16.0),
                      bottom: fit.t(16.0),
                      left: fit.t(24.0),
                      right: fit.t(24.0)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "Choose Topic",
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: colorBlack,
                              fontSize: fit.t(16.0),
                              fontFamily: "Roboto",
                            ),
                          ),
                          Icon(
                            Icons.arrow_forward_ios,
                            color: appColor,
                            size: fit.t(20.0),
                          )
                        ],
                      ),
                      topicSelected == null
                          ? Container()
                          : FilterChip(
                              backgroundColor: Color(0xFFf0f0f0),
                              checkmarkColor: Colors.white,
                              label: Text(
                                topicSelected.title + "   x",
                              ),
                              showCheckmark: false,
                              selected: true,
                              selectedColor: appColor.withOpacity(0.9),
                              labelPadding: EdgeInsets.all(3.0),
                              selectedShadowColor: colorWhite,
                              labelStyle: TextStyle(
                                  color: colorWhite,
                                  fontSize: fit.t(14.0),
                                  fontWeight: FontWeight.w400,
                                  fontFamily: "Roboto"),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(5),
                                ),
                              ),
                              onSelected: (bool selected) {
                                setState(
                                  () {
                                    topicSelected = null;
                                  },
                                );
                              },
                            )
                    ],
                  ),
                ),
              ),
              SizedBox(height: fit.t(8.0)),
              Container(
                width: MediaQuery.of(context).size.width,
                color: colorWhite,
                padding: EdgeInsets.only(
                    top: fit.t(8.0),
                    bottom: fit.t(8.0),
                    left: fit.t(24.0),
                    right: fit.t(24.0)),
                child: Text(
                  "Privacy",
                  style: TextStyle(
                      color: colorBlack,
                      backgroundColor: colorWhite,
                      fontSize: fit.t(16.0),
                      fontWeight: FontWeight.w500,
                      fontFamily: "Roboto"),
                ),
              ),
              Container(
                color: colorWhite,
                padding: EdgeInsets.only(
                  top: fit.t(8.0),
                  bottom: fit.t(8.0),
                ),
                child: RadioListTile(
                  onChanged: (value) {
                    _handleRadioValueChange1(value);
                  },
                  value: 1,
                  dense: true,
                  groupValue: radioValue1,
                  title: Text(
                    "Public Channel",
                    style: TextStyle(
                        fontSize: fit.t(14.0),
                        fontWeight: FontWeight.w400,
                        fontFamily: "Roboto"),
                  ),
                  subtitle: Text(
                    "Public channel can be found in search, anyone can join them.",
                    style: TextStyle(
                        fontSize: fit.t(12.0),
                        fontWeight: FontWeight.w400,
                        fontFamily: "Roboto"),
                  ),
                ),
              ),
              SizedBox(height: fit.t(2.0)),
              Container(
                color: colorWhite,
                padding: EdgeInsets.only(top: fit.t(0.0), bottom: fit.t(8.0)),
                child: RadioListTile(
                  onChanged: (value) {
                    _handleRadioValueChange1(value);
                  },
                  value: 2,
                  dense: true,
                  groupValue: radioValue1,
                  title: Text(
                    "Private Channel",
                    style: TextStyle(
                        fontSize: fit.t(14.0),
                        fontWeight: FontWeight.w400,
                        fontFamily: "Roboto"),
                  ),
                  subtitle: Text(
                    "Private channel can only be joined via an link.",
                    style: TextStyle(
                        fontSize: fit.t(12.0),
                        fontWeight: FontWeight.w400,
                        fontFamily: "Roboto"),
                  ),
                ),
              ),
              SizedBox(height: fit.t(8.0)),
              Container(
                width: MediaQuery.of(context).size.width,
                color: colorWhite,
                padding: EdgeInsets.only(
                    top: fit.t(8.0),
                    bottom: fit.t(8.0),
                    left: fit.t(24.0),
                    right: fit.t(24.0)),
                child: Text(
                  "Permanent link",
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: colorBlack,
                    backgroundColor: colorWhite,
                    fontSize: fit.t(16.0),
                    fontFamily: "Roboto",
                  ),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                height: fit.t(8.0),
                color: colorWhite,
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                color: colorWhite,
                padding: EdgeInsets.only(
                    top: fit.t(8.0),
                    bottom: fit.t(8.0),
                    left: fit.t(24.0),
                    right: fit.t(24.0)),
                child: TextField(
                  controller: _inputController,
                  cursorWidth: fit.t(1.0),
                  cursorColor: appColor,
                  autofocus: false,
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.done,
                  keyboardAppearance: Brightness.light,
                  decoration: InputDecoration(
                    hintText: "t.me/link",
                    hintStyle: TextStyle(
                        color: colorGrey2,
                        fontSize: fit.t(14.0),
                        fontWeight: FontWeight.w400,
                        fontFamily: "Roboto"),
                  ),
                  style: TextStyle(
                      color: colorBlack,
                      fontSize: fit.t(14.0),
                      fontWeight: FontWeight.w400,
                      fontFamily: "Roboto"),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                height: fit.t(8.0),
                color: colorWhite,
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                color: colorWhite,
                padding: EdgeInsets.only(
                    top: fit.t(8.0),
                    bottom: fit.t(8.0),
                    left: fit.t(24.0),
                    right: fit.t(24.0)),
                child: Text(
                  "If you set a permanent link, other people will be able to find and join your channel.",
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    color: colorGrey2,
                    backgroundColor: colorWhite,
                    fontSize: fit.t(12.0),
                    fontFamily: "Roboto",
                  ),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                height: fit.t(4.0),
                color: colorWhite,
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                color: colorWhite,
                padding: EdgeInsets.only(
                    top: fit.t(8.0),
                    bottom: fit.t(8.0),
                    left: fit.t(24.0),
                    right: fit.t(24.0)),
                child: Text(
                  "You can use a-z and 0-9 and underscores minimum length is 5 characters.",
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    color: colorGrey2,
                    backgroundColor: colorWhite,
                    fontSize: fit.t(12.0),
                    fontFamily: "Roboto",
                  ),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                height: fit.t(16.0),
                color: colorWhite,
              ),
              Container(
                margin: EdgeInsets.symmetric(
                    horizontal: fit.t(16.0), vertical: fit.t(30.0)),
                child: SocialMediaCustomButton(
                  btnText: widget.data.id == null ? 'Create' : 'Update',
                  buttonColor: colorAcceptBtn,
                  onPressed: _onCreateChannel,
                  size: fit.t(16.0),
                  splashColor: colorAcceptBtnSplash,
                  textColor: colorWhite,
                ),
              ),
            ],
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

  Widget _titleWidget() {
    return Container(
      child: Padding(
        padding: EdgeInsets.only(
            top: fit.t(8.0), left: fit.t(8.0), right: fit.t(8.0)),
        child: Container(
          child: Text(
            'Channel Type',
            style: TextStyle(
              fontFamily: 'Roboto',
              fontSize: fit.t(18.0),
              fontWeight: FontWeight.normal,
              color: Colors.black,
            ),
          ),
        ),
      ),
    );
  }

  void _handleRadioValueChange1(int value) {
    setState(() {
      radioValue1 = value;
    });
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

  void _subscribeToApiResponse() {
    StreamSubscription subscription;
    subscription = apiController.stream.listen((data) {
      if (data is ErrorResponse) {
        if (data.show_msg == 1) {
          if (data.authType != null) {
            if (data.authType == "login") {
              Navigator.pushReplacementNamed(context, '/waitingScreen');
            } else {
              Navigator.pushReplacementNamed(context, '/termsOfUse');
            }
          } else {
            TopAlert.showAlert(context, data.message, true);
          }
        } else {
          TopAlert.showAlert(context, data.message, true);
        }
      } else if (data is CommonApiReponse) {
        if (data.message == 'Check your internet connection.') {
          pushNamedIfNotCurrent(context, '/noInternet');
        } else {
          if (data.show_msg == 1) {
            TopAlert.showAlert(context, data.message, false);
          }
          Navigator.of(context).pop(true);
        }
      } else if (data is CustomError) {
        if (data.errorMessage == 'Check your internet connection.') {
          pushNamedIfNotCurrent(context, '/noInternet');
        } else {
          TopAlert.showAlert(context, data.errorMessage, true);
        }
      } else if (data is Exception) {
        TopAlert.showAlert(context,
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

  @override
  void dispose() {
    apiController.close();
    super.dispose();
  }

  void _onCreateChannel() {
    if (topicSelected == null) {
      TopAlert.showAlert(
          context, "Please select one topic for the channel.", true);
    } else if (radioValue1 == -1) {
      TopAlert.showAlert(
          context, "Please select privacy of your channel.", true);
    } else {
      if (widget.data.id == null) {
        Map<String, dynamic> request = Map();
        request.putIfAbsent("title", () => widget.data.title);
        request.putIfAbsent("topic_id", () => topicSelected.id);
        request.putIfAbsent("description", () => widget.data.desc);
        request.putIfAbsent("img", () => widget.data.img);
        request.putIfAbsent("type", () => radioValue1);
        _bloc.createChannel(context, request);
      } else {
        Map<String, dynamic> request = Map();
        request.putIfAbsent("title", () => widget.data.title);
        request.putIfAbsent("topic_id", () => topicSelected.id);
        request.putIfAbsent("description", () => widget.data.desc);
        request.putIfAbsent("img", () => widget.data.img);
        request.putIfAbsent("type", () => radioValue1);
        _bloc.updateChannel(context, request, widget.data.id);
      }
    }
  }
}
