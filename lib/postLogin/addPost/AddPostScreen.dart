import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fm_fit/fm_fit.dart';
import 'package:my_voicee/constants/app_colors.dart';
import 'package:my_voicee/constants/app_constants.dart';
import 'package:my_voicee/constants/app_images_path.dart';
import 'package:my_voicee/customWidget/super_tooltip.dart';
import 'package:my_voicee/models/UserResponse.dart';
import 'package:my_voicee/postLogin/addPost/AddPostNew.dart';
import 'package:my_voicee/utils/Utility.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

class AddPostScreen extends StatefulWidget {
  final BuildContext menuScreenContext;
  final Function(int index) controller;

  const AddPostScreen({Key key, this.menuScreenContext, this.controller})
      : super(key: key);

  @override
  _AddPostScreenState createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen>
    with AutomaticKeepAliveClientMixin<AddPostScreen> {
  @override
  bool get wantKeepAlive => false;
  SuperTooltip tooltip;
  GlobalKey _scaffoldKey = GlobalKey<ScaffoldState>();
  GlobalKey _tutKey = GlobalKey<_AddPostScreenState>();
  FmFit fit = FmFit(width: 750);
  var timerValue = "3";
  Timer timer;
  bool isPublisher = false;

  @override
  void initState() {
    getStringDataLocally(key: userData).then((value) {
      var userDataBean = UserData.fromJson(jsonDecode(value));
      checkPermissions();
      if (mounted)
        setState(() {
          if (userDataBean.is_publisher) {
            isPublisher = true;
          } else {
            isPublisher = false;
          }
        });
    });

    super.initState();
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
      appBar: AppBar(
        backgroundColor: colorWhite,
        elevation: 0,
        centerTitle: true,
        title: _titleWidget(),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        color: colorWhite,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.only(top: fit.t(60.0)),
                child: Text(
                  'Record up to 1 mins',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: fit.t(16.0),
                      fontFamily: 'Roboto',
                      color: Colors.black,
                      fontWeight: FontWeight.w500),
                )),
            SizedBox(
              height: fit.t(10.0),
            ),
            Container(
                margin: EdgeInsets.only(
                    left: fit.t(30.0),
                    right: fit.t(30.0),
                    bottom: fit.t(30.0),
                    top: fit.t(10.0)),
                child: Center(
                    child: Stack(
                  children: <Widget>[
                    Image.asset(
                      ic_ripple_image,
                      width: MediaQuery.of(context).size.width / 2,
                      height: MediaQuery.of(context).size.height / 4,
                    ),
                    Positioned(
                      top: 0,
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Center(
                        child: Text(
                          '$timerValue',
                          style: TextStyle(
                              color: appColor,
                              fontSize: fit.t(48.0),
                              fontFamily: "Roboto",
                              fontWeight: FontWeight.w500),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                ))),
            Container(
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.only(bottom: fit.t(8.0)),
                child: Text(
                  'Are you ready?',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: fit.t(14.0),
                      fontFamily: 'Roboto',
                      color: Colors.black,
                      fontWeight: FontWeight.w500),
                )),
            SizedBox(
              height: fit.t(10.0),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.only(
                top: fit.t(0.0),
              ),
              child: Text(
                'Make sure you don\'t have any background noise.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color.fromRGBO(0, 0, 0, 0.4),
                  fontSize: fit.t(14.0),
                  fontFamily: "Roboto",
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 20.0),
              width: MediaQuery.of(context).size.width,
              height: fit.t(40.0),
              key: _tutKey,
            )
          ],
        ),
      ),
    );
  }

  Widget _titleWidget() {
    return Padding(
      padding: EdgeInsets.only(
        top: fit.t(8.0),
        left: fit.t(8.0),
        right: fit.t(8.0),
      ),
      child: Text(
        "Post",
        style: TextStyle(
            color: colorBlack,
            fontFamily: 'Roboto',
            fontWeight: FontWeight.w400,
            fontSize: fit.t(18.0)),
      ),
    );
  }

  void checkPermissions() async {
    Permission.microphone.request().isGranted.then((value) {
      Permission.storage.request().isGranted.then((value) {
        if (value) {
          _delay();
        }
      });
    });
  }

  void callNavigation() {
    if (isShowTut) {
      showTutorial();
    } else {
      timer = Timer.periodic(Duration(seconds: 1), (Timer t) async {
        timer = t;
        if (timer.tick == 1) {
          if (mounted) {
            setState(() {
              timerValue = "2";
            });
          } else {
            timer.cancel();
          }
        } else if (timer.tick == 2) {
          if (mounted) {
            setState(() {
              timerValue = "1";
            });
          } else {
            timer.cancel();
          }
        } else {
          timer.cancel();
          pushNewScreen(context,
              screen: AddPostNew(
                  menuScreenContext: widget.menuScreenContext,
                  controller: onBack),
              withNavBar: false);
        }
      });
    }
  }

  _delay() async {
    var _duration = Duration(seconds: 1);
    return Timer(_duration, callNavigation);
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  void onBack() {
    widget.controller(0);
  }

  void showTutorial() {
    if (tooltip?.isOpen ?? false) {
      tooltip?.close();
    }

    // We create the tooltip on the first use
    tooltip = SuperTooltip(
      popupDirection: TooltipDirection.down,
      backgroundColor: Colors.amberAccent,
      arrowLength: 0,
      arrowTipDistance: 0,
      arrowBaseWidth: 0,
      myOffset: Offset(40, 20),
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
                !isPublisher
                    ? "The counter will wait for 3 seconds before it start recording."
                    : "After you create a channel, you will be able to post from your brand or organization's name.",
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
                      onTap: () {
                        tooltip?.close();
                        isShowTut = false;
                        timer = Timer.periodic(Duration(seconds: 1),
                            (Timer t) async {
                          timer = t;
                          if (timer.tick == 1) {
                            if (mounted) {
                              setState(() {
                                timerValue = "2";
                              });
                            } else {
                              timer.cancel();
                            }
                          } else if (timer.tick == 2) {
                            if (mounted) {
                              setState(() {
                                timerValue = "1";
                              });
                            } else {
                              timer.cancel();
                            }
                          } else {
                            timer.cancel();
                            pushNewScreen(context,
                                screen: AddPostNew(
                                    menuScreenContext: widget.menuScreenContext,
                                    controller: onBack),
                                withNavBar: false);
                          }
                        });
                      },
                      child: Text(
                        " Skip all ",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontFamily: "Roboto"),
                      )),
                  Text(
                    "|",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, fontFamily: "Roboto"),
                  ),
                  InkWell(
                      onTap: () {
                        tooltip?.close();
                        timer = Timer.periodic(Duration(seconds: 1),
                            (Timer t) async {
                          timer = t;
                          if (timer.tick == 1) {
                            if (mounted) {
                              setState(() {
                                timerValue = "2";
                              });
                            } else {
                              timer.cancel();
                            }
                          } else if (timer.tick == 2) {
                            if (mounted) {
                              setState(() {
                                timerValue = "1";
                              });
                            } else {
                              timer.cancel();
                            }
                          } else {
                            timer.cancel();
                            pushNewScreen(context,
                                screen: AddPostNew(
                                    menuScreenContext: widget.menuScreenContext,
                                    controller: onBack),
                                withNavBar: false);
                          }
                        });
                      },
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
    tooltip.show(_tutKey.currentContext);
  }
}
