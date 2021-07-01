import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fm_fit/fm_fit.dart';
import 'package:my_voicee/constants/app_colors.dart';
import 'package:my_voicee/customWidget/Alert/top_alert.dart';
import 'package:my_voicee/customWidget/appLoader/custom_progress_loader.dart';
import 'package:my_voicee/models/AllTopicsModel.dart';
import 'package:my_voicee/models/commonResponse/CommonpiResponse.dart';
import 'package:my_voicee/models/errorResponse/customeError.dart';
import 'package:my_voicee/models/errorResponse/error_reponse.dart';
import 'package:my_voicee/postLogin/Topics/topicbloc/TopicsBloc.dart';
import 'package:my_voicee/utils/Utility.dart';

class TopicsScreen extends StatefulWidget {
  final BuildContext menuScreenContext;
  final Function(int index) controller;

  const TopicsScreen({Key key, this.menuScreenContext, this.controller})
      : super(key: key);

  @override
  _TopicsScreenState createState() => _TopicsScreenState();
}

class _TopicsScreenState extends State<TopicsScreen>
    with AutomaticKeepAliveClientMixin<TopicsScreen> {
  @override
  bool get wantKeepAlive => false;

  var _scaffoldKey = GlobalKey<ScaffoldState>();
  var refreshKey = GlobalKey<RefreshIndicatorState>();
  FmFit fit = FmFit(width: 750);
  List<Topics> _choices;
  List<Topics> _filters;
  TopicsBloc _bloc;
  StreamController apiResponseController;

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);
    apiResponseController = StreamController();
    _bloc = TopicsBloc(apiResponseController);
    _subscribeToApiResponse();
    _bloc.getAllTopics(context);
    _choices = <Topics>[];
    _filters = <Topics>[];
    _choices.add(Topics());
  }

  Future<Null> refreshList() async {
    refreshKey.currentState?.show(atTop: false);
    await Future.delayed(Duration(seconds: 1));
    _bloc.getAllTopics(context);
    return null;
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
      backgroundColor: colorWhite,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(fit.t(50.0)),
        child: AppBar(
          backgroundColor: colorWhite,
          elevation: 0,
          centerTitle: true,
          title: _titleWidget(),
        ),
      ),
      body: Stack(
        children: [
          Container(
            color: colorWhite,
            margin: EdgeInsets.only(
              bottom: fit.t(10.0),
            ),
            child: RefreshIndicator(
              key: refreshKey,
              onRefresh: refreshList,
              child: CustomScrollView(
                slivers: [
                  SliverList(
                    delegate: SliverChildListDelegate(
                      topicsPosition.toList(),
                    ),
                  ),
                  SliverList(
                    delegate: SliverChildListDelegate(
                      unselectedTopicsPosition.toList(),
                    ),
                  )
                ],
              ),
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
      if (topics.isChoosed == null) {
        yield topics.id == null
            ? ListTile(
                title: Text(
                  "Topics you are following",
                  style: TextStyle(
                      fontFamily: "Roboto",
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                      fontSize: fit.t(16.0)),
                ),
              )
            : Text("");
      } else {
        if (topics.isChoosed) {
          yield Column(
            children: [
              Center(
                child: ListTile(
                  dense: true,
                  leading: RichText(
                    text: TextSpan(
                      text: topics.title,
                      style: TextStyle(
                          fontFamily: "Roboto",
                          color: Colors.black,
                          fontWeight: FontWeight.w400,
                          fontSize: fit.t(12.0)),
                      children: <TextSpan>[
                        TextSpan(
                          text: ' ${topics.n_posts}+ Posts',
                          style: TextStyle(
                            fontFamily: "Roboto",
                            color: Colors.black38,
                            fontSize: fit.t(12.0),
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                  trailing: Icon(
                    Icons.close,
                    color: Colors.black38,
                    size: fit.t(20.0),
                  ),
                  onTap: () {
                    if (_filters.length > 3) {
                      setState(() {
                        List<String> data = List();
                        data.add(topics.id);
                        _bloc.submitSelectedTopicsRemove(context, data);
                      });
                    } else {
                      TopAlert.showAlert(
                          widget.menuScreenContext,
                          "Minimum three topics are mandatory to select.",
                          true);
                    }
                  },
                ),
              ),
              Divider(
                color: Color.fromRGBO(243, 243, 243, 1),
              )
            ],
          );
        }
      }
    }
  }

  Iterable<Widget> get unselectedTopicsPosition sync* {
    for (Topics topics in _choices) {
      if (topics.isChoosed == null) {
        yield topics.id == null
            ? ListTile(
                title: Text(
                  "More Topics",
                  style: TextStyle(
                      fontFamily: "Roboto",
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                      fontSize: fit.t(16.0)),
                ),
              )
            : Text("");
      } else {
        if (!topics.isChoosed) {
          yield Column(
            children: [
              Center(
                child: ListTile(
                  dense: true,
                  leading: RichText(
                    text: TextSpan(
                      text: topics.title,
                      style: TextStyle(
                          fontFamily: "Roboto",
                          color: Colors.black,
                          fontWeight: FontWeight.w400,
                          fontSize: fit.t(12.0)),
                      children: <TextSpan>[
                        TextSpan(
                          text: ' ${topics.n_posts}+ Posts',
                          style: TextStyle(
                            fontFamily: "Roboto",
                            color: Colors.black38,
                            fontSize: fit.t(12.0),
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                  trailing: Icon(
                    Icons.add,
                    color: Colors.black38,
                    size: fit.t(20.0),
                  ),
                  onTap: () {
                    setState(() {
                      List<String> data = List();
                      data.add(topics.id);
                      _bloc.submitSelectedTopics(context, data);
                    });
                  },
                ),
              ),
              Divider(
                color: Color.fromRGBO(243, 243, 243, 1),
              )
            ],
          );
        }
      }
    }
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

  //listen to api response
  void _subscribeToApiResponse() {
    StreamSubscription subscription;
    subscription = apiResponseController.stream.listen((data) {
      if (data is AllTopicsModel) {
        _choices.clear();
        _filters.clear();
        _choices = data.response;
        for (Topics topic in _choices) {
          if (topic.id != null) {
            if (topic.isChoosed) {
              _filters.add(topic);
            }
          }
        }
        _choices.insert(0, Topics());
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
        _bloc.getAllTopics(context);
        if (data.message == 'Check your internet connection.') {
          pushNamedIfNotCurrent(context, '/noInternet');
        } else {
          TopAlert.showAlert(
              _scaffoldKey.currentState.context, data.message, false);
        }
      } else if (data is CustomError) {
        if (data.errorMessage == 'Check your internet connection.') {
          pushNamedIfNotCurrent(context, '/noInternet');
        } else {
          TopAlert.showAlert(
              _scaffoldKey.currentState.context, data.errorMessage, true);
        }
      } else {
        if (data is Exception) {
          TopAlert.showAlert(_scaffoldKey.currentState.context,
              'Oops, Something went wrong please try again later.', true);
        }
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
}
