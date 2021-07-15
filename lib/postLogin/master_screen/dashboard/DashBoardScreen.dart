import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:audioplayers/audioplayers.dart';
import 'package:device_info/device_info.dart';
import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fm_fit/fm_fit.dart';
import 'package:geolocator/geolocator.dart';
import 'package:my_voicee/CallBacks/DashBaordListCallBack.dart';
import 'package:my_voicee/CallBacks/ShareCallBack.dart';
import 'package:my_voicee/analytics/FAEvent.dart';
import 'package:my_voicee/analytics/FAEventName.dart';
import 'package:my_voicee/analytics/FATracker.dart';
import 'package:my_voicee/constants/app_colors.dart';
import 'package:my_voicee/constants/app_constants.dart';
import 'package:my_voicee/constants/app_images_path.dart';
import 'package:my_voicee/customWidget/Alert/NoDataWidget.dart';
import 'package:my_voicee/customWidget/Alert/top_alert.dart';
import 'package:my_voicee/customWidget/BottomSheetShare.dart';
import 'package:my_voicee/customWidget/appLoader/custom_progress_loader.dart';
import 'package:my_voicee/models/AllTopicsModel.dart';
import 'package:my_voicee/models/GetAllPostsResponse.dart';
import 'package:my_voicee/models/OtherUserResponse.dart';
import 'package:my_voicee/models/UpDownVoteResponse.dart';
import 'package:my_voicee/models/UserResponse.dart';
import 'package:my_voicee/models/commonResponse/CommonpiResponse.dart';
import 'package:my_voicee/models/errorResponse/customeError.dart';
import 'package:my_voicee/models/errorResponse/error_reponse.dart';
import 'package:my_voicee/postLogin/master_screen/dashboard/Bloc/DasboardBloc.dart';
import 'package:my_voicee/postLogin/master_screen/dashboard/DashboardListItem.dart';
import 'package:my_voicee/postLogin/master_screen/dashboard/SearchUsers.dart';
import 'package:my_voicee/postLogin/postReply/ReplyList.dart';
import 'package:my_voicee/postLogin/profile/OtherProfileScreen.dart';
import 'package:my_voicee/postLogin/profile/ProfileScreen.dart';
import 'package:my_voicee/postLogin/reactions/ReActionsScreen.dart';
import 'package:my_voicee/utils/Utility.dart';
import 'package:my_voicee/utils/local_push_notification.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:social_share/social_share.dart';

Future<dynamic> myBackgroundMessageHandler(Map<String, dynamic> message) {
  if (message.containsKey('data')) {
    // Handle data message
    final dynamic data = message['data'];
  }

  if (message.containsKey('notification')) {
    // Handle notification message
    final dynamic notification = message['notification'];
  }
}

class DashBoardScreen extends StatefulWidget {
  final BuildContext menuScreenContext;
  final Function(int index) controller;
  final GlobalKey myKey;

  const DashBoardScreen({this.myKey, this.menuScreenContext, this.controller});

  @override
  _DashBoardScreenState createState() => _DashBoardScreenState();
}

class _DashBoardScreenState extends State<DashBoardScreen>
    with DashboardCallBack, ShareCallBack, WidgetsBindingObserver, AutomaticKeepAliveClientMixin<DashBoardScreen> {
  @override
  bool get wantKeepAlive => false;

  bool isShownTut = false;
  List<int> data = [];
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  LocalPushNotification localPushInstance = LocalPushNotification();
  List<String> _filterIds = List();
  AudioPlayer player = AudioPlayer();
  DashboardCallBack _itemCallBacks;
  ShareCallBack _shareCallBack;
  var _scaffoldKey = GlobalKey<ScaffoldState>();
  ScrollController _scrollController = ScrollController();
  FmFit fit = FmFit(width: 750);
  List<Topics> _choices;
  int page = 0;

  List<AllPostResponse> allPosts = List();
  UserData userDataBean;
  DashboardBloc _bloc;
  StreamController apiResponse;
  StreamController apiResponseData;
  bool isLoading = false;
  bool lastPage = false;
  var refreshKey = GlobalKey<RefreshIndicatorState>();
  Duration _duration = Duration(milliseconds: 0);

  Position _currentPosition;

  Future<Null> refreshList() async {
    refreshKey.currentState?.show(atTop: false);
    await Future.delayed(Duration(seconds: 1));
    page = 0;
    lastPage = false;
    _bloc.callApiGetAllPosts(widget.menuScreenContext, page, _filterIds);
    if (mounted) setState(() {});
    return null;
  }

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    _choices = <Topics>[];
    getStringDataLocally(key: userData).then((value) {
      userDataBean = UserData.fromJson(jsonDecode(value));
    });
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);
    getFirebaseToken();
    _itemCallBacks = this;
    _shareCallBack = this;
    apiResponse = StreamController();
    apiResponseData = StreamController<List<AllPostResponse>>.broadcast();
    _bloc = DashboardBloc(apiResponse, apiResponseData);
    _subscribeToApiResponse();
    _bloc.getAllTopics(widget.menuScreenContext);
    _scrollController.addListener(() {
      if (_scrollController.position.maxScrollExtent == _scrollController.position.pixels) {
        if (!isLoading) {
          isLoading = !isLoading;
          if (!lastPage) _bloc.callApiGetAllPosts(widget.menuScreenContext, page, _filterIds);
        }
      }
    });
    Geolocator.requestPermission();
    if (Platform.isAndroid) {
      _getCurrentLocation();
    }
    player.onPlayerStateChanged.listen((event) {
      if (event == AudioPlayerState.PLAYING) {
      } else if (event == AudioPlayerState.PAUSED) {
      } else if (event == AudioPlayerState.STOPPED) {
      } else if (event == AudioPlayerState.COMPLETED) {
        player.release();
      }
    });
    if (Platform.isIOS) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Future.delayed(Duration(seconds: 0), _getCurrentLocation());
        Future.delayed(Duration(seconds: 4), initPushNotification);
      });
    } else {
      initPushNotification();
    }
    super.initState();
  }

  void initPushNotification() {
    localPushInstance.initLocalPushNotification(widget.menuScreenContext);
    _firebaseMessaging.requestNotificationPermissions();
    _firebaseMessaging.autoInitEnabled();
    _firebaseMessaging.configure(
      onMessage: ((Map<dynamic, dynamic> data) {
        return localPushInstance.buildBackgroundNotification(data);
      }),
      onBackgroundMessage: Platform.isIOS ? null : myBackgroundMessageHandler,
      onResume: ((Map<dynamic, dynamic> data) {
        return localPushInstance.onTapNotification(data);
      }),
      onLaunch: ((Map<dynamic, dynamic> data) {
        return localPushInstance.onTapNotification(data);
      }),
    );
    localPushInstance.clearAll();
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
      backgroundColor: colorWhite,
      key: _scaffoldKey,
      resizeToAvoidBottomInset: false,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(fit.t(60.0)),
        child: AppBar(
          backgroundColor: colorWhite,
          elevation: 0,
          leading: _leadingWidget(),
          centerTitle: true,
          title: _titleWidget(),
          actions: <Widget>[trailingWidget()],
        ),
      ),
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            Container(
              color: colorWhite.withAlpha(1),
              margin: EdgeInsets.only(left: fit.t(20.0), right: fit.t(20.0)),
              height: fit.t(40.0),
              child: ListView.separated(
                physics: AlwaysScrollableScrollPhysics(),
                scrollDirection: Axis.horizontal,
                itemBuilder: (BuildContext context, int index) {
                  return _choices.length > 0
                      ? FilterChip(
                          backgroundColor: Color(0xFFf0f0f0),
                          checkmarkColor: Colors.white,
                          label: Text(
                            !selectedTopic.contains(_choices[index]) ? _choices[index].title + "   +" : _choices[index].title + "   x",
                          ),
                          showCheckmark: false,
                          selected: selectedTopic.contains(_choices[index]),
                          selectedColor: appColor.withOpacity(0.9),
                          labelPadding: EdgeInsets.all(3.0),
                          selectedShadowColor: colorWhite,
                          labelStyle: TextStyle(
                              color: !selectedTopic.contains(_choices[index]) ? Colors.black87 : colorWhite,
                              fontWeight: FontWeight.w400,
                              fontSize: fit.t(12.0),
                              fontFamily: "Roboto"),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(5),
                            ),
                          ),
                          onSelected: (bool selected) {
                            setState(
                              () {
                                if (selected) {
                                  if (!selectedTopic.contains(_choices[index])) selectedTopic.add(_choices[index]);
                                  _filterIds.clear();
                                  selectedTopic.forEach((element) {
                                    _filterIds.add(element.id);
                                  });
                                  page = 0;
                                  lastPage = false;
                                  _bloc.callApiGetAllPosts(widget.menuScreenContext, 0, _filterIds);
                                  if (mounted) setState(() {});
                                } else {
                                  if (selectedTopic.contains(_choices[index]))
                                    selectedTopic.removeWhere(
                                      (Topics name) {
                                        return name == _choices[index];
                                      },
                                    );
                                  _filterIds.clear();
                                  selectedTopic.forEach((element) {
                                    _filterIds.add(element.id);
                                  });
                                  page = 0;
                                  lastPage = false;
                                  _bloc.callApiGetAllPosts(widget.menuScreenContext, 0, _filterIds);
                                  if (mounted) setState(() {});
                                }
                              },
                            );
                          },
                        )
                      : Container();
                },
                itemCount: _choices.length,
                shrinkWrap: false,
                separatorBuilder: (BuildContext context, int index) {
                  return SizedBox(
                    width: fit.t(3.0),
                  );
                },
              ),
            ),
            Container(
              color: colorWhite,
              margin: EdgeInsets.only(
                top: fit.t(50.0),
                left: fit.t(12.0),
                right: fit.t(12.0),
                bottom: fit.t(10.0),
              ),
              child: _createListView(allPosts),
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

  Widget _leadingWidget() {
    return Container(
      margin: EdgeInsets.only(left: fit.t(16.0)),
      child: Container(
        child: Image.asset(
          ic_logo_small,
        ),
      ),
    );
  }

  Widget _titleWidget() {
    return InkWell(
      onTap: () => onClickSayIcon(),
      child: Padding(
        padding: EdgeInsets.only(
          top: fit.t(8.0),
          left: fit.t(8.0),
          right: fit.t(8.0),
        ),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                child: Image.asset(
                  ic_say_appbar,
                  width: fit.t(30.0),
                  height: fit.t(30.0),
                ),
              ),
              Container(
                child: Text(
                  "Post...",
                  style: TextStyle(color: colorBlack, fontFamily: 'Roboto', fontWeight: FontWeight.w400, fontSize: fit.t(18.0)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget trailingWidget() {
    return InkWell(
      onTap: () => _searchNavigate(),
      child: Container(
        margin: EdgeInsets.only(right: fit.t(16.0), top: fit.t(4.0)),
        child: Image.asset(
          ic_search,
          height: fit.t(35.0),
          width: fit.t(35.0),
        ),
      ),
    );
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    apiResponse?.close();
    apiResponseData?.close();
    player.release();
    _bloc.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    FATracker tracker = FATracker();
    if (state == AppLifecycleState.paused) {
      tracker.track(FAEvents(eventName: APP_CLOSED_EVENT, attrs: null));
    }
    if (state == AppLifecycleState.resumed) {
      tracker.track(FAEvents(eventName: APP_RESUMED_EVENT, attrs: null));
    }
  }

  void _subscribeToApiResponse() {
    StreamSubscription subscription;
    subscription = apiResponse.stream.listen((data) {
      if (data is AllTopicsModel) {
        _choices.clear();
        _choices = data.response;
        _filterIds.clear();
        if (selectedTopic.length == 0) {
          for (Topics topic in data.response) {
            if (topic.isChoosed) {
              if (!selectedTopic.contains(topic)) selectedTopic.add(topic);
            }
          }
          selectedTopic.forEach((element) {
            _filterIds.add(element.id);
          });
        } else {
          selectedTopic.forEach((element) {
            _filterIds.add(element.id);
          });
          selectedTopic.clear();
          for (Topics topic in data.response) {
            for (String id in _filterIds) {
              if (topic.id == id) {
                selectedTopic.add(topic);
              }
            }
          }
        }
        setState(() {
          page = 0;
          lastPage = false;
          _bloc.callApiGetAllPosts(widget.menuScreenContext, 0, _filterIds);
        });
      } else if (data is GetAllPostResponse) {
        if (data.response.length > 0) {
          if (page == 0) {
            allPosts.clear();
          }
          for (var i = 0; i < data.response.length; i++) {
            data.response[i].duration = Duration(seconds: 0);
            data.response[i].is_play = false;
            allPosts.add(data.response[i]);
          }
          if (page == 0) {
            allPosts.add(AllPostResponse());
          }
          isLoading = false;
          if (data.response.length == 10) {
            page += 1;
          }
          if (data.response.length < 10) {
            lastPage = true;
          }
          if (allPosts.length > 0) {
            if (allPosts.firstWhere((element) => element.id == null, orElse: null) != null) {
              allPosts.remove(allPosts.firstWhere((element) => element.id == null));
              allPosts.add(AllPostResponse());
            }
          }
        } else {
          lastPage = true;
          if (page == 0) {
            allPosts.clear();
          }
        }
        if (allPosts.length == 0) {
          allPosts.add(AllPostResponse());
        }

        if (mounted) setState(() {});
      } else if (data is UpDownVoteResponse) {
        if (data.from == "2") {
          //downvote
          if (data.is_action) {
            allPosts[data.pos].is_disliked = true;
            allPosts[data.pos].n_dislikes += 1;
            if (mounted) setState(() {});
          } else {
            allPosts[data.pos].is_disliked = false;
            allPosts[data.pos].n_dislikes -= 1;
            if (mounted) setState(() {});
          }
        } else {
          //upvote
          if (data.is_action) {
            allPosts[data.pos].is_liked = true;
            allPosts[data.pos].n_likes += 1;
            if (mounted) setState(() {});
          } else {
            allPosts[data.pos].is_liked = false;
            allPosts[data.pos].n_likes -= 1;
            if (mounted) setState(() {});
          }
        }
        TopAlert.showAlert(widget.menuScreenContext, data.message, false);
      } else if (data is OtherUserResponse) {
        pushNewScreen(widget.menuScreenContext, screen: OtherProfileScreen(profileData: data.response), withNavBar: false);
      } else if (data is CommonApiReponse) {
        TopAlert.showAlert(widget.menuScreenContext, data.message, false);
        _bloc.getAllTopics(widget.menuScreenContext);
      } else if (data is ErrorResponse) {
        TopAlert.showAlert(widget.menuScreenContext, data.message, true);
      } else if (data is CustomError) {
        if (data.errorMessage == 'Check your internet connection.') {
          pushNamedIfNotCurrent(widget.menuScreenContext, '/noInternet');
        } else {
          TopAlert.showAlert(_scaffoldKey.currentState.context, data.errorMessage, true);
        }
      } else if (data is Exception) {
        TopAlert.showAlert(_scaffoldKey.currentState.context, 'Oops, Something went wrong please try again later.', true);
      }
    }, onError: (error) {
      if (error is CustomError) {
        TopAlert.showAlert(widget.menuScreenContext, error.errorMessage, true);
      } else {
        TopAlert.showAlert(widget.menuScreenContext, error.toString(), true);
      }
    });
  }

  Widget _createListView(List<AllPostResponse> itemList) {
    return RefreshIndicator(
      key: refreshKey,
      onRefresh: refreshList,
      child: ListView.builder(
        physics: AlwaysScrollableScrollPhysics(),
        itemBuilder: (BuildContext context, int index) {
          return (index == 0 && itemList[index].id == null)
              ? NoDataWidget(
                  fit: fit,
                  txt: 'No Posts',
                )
              : itemList[index].id == null
                  ? NoDataWidget(
                      fit: fit,
                      txt: '',
                    )
                  : DashBoardListItem(
                      fit: fit,
                      pos: index,
                      parentKey: widget.myKey,
                      isShown: isShownTut,
                      player: player,
                      menuContext: widget.menuScreenContext,
                      isTutShown: _isShown,
                      data: itemList[index],
                      callBack: _itemCallBacks);
        },
        itemCount: itemList.length,
        shrinkWrap: false,
        controller: _scrollController,
      ),
    );
  }

  @override
  void onClickItem(int pos) {
    // if (pos != -1) {
    //   if (userDataBean?.id == allPosts[pos].user.id) {
    //     widget.controller(3);
    //   } else {
    //     _bloc.callApiOtherUserProfile(widget.menuScreenContext, allPosts[pos].user.id);
    //   }
    // }
  }

  @override
  void onDownVoteClick(int pos) {
    if (pos != -1) {
      FATracker tracker = FATracker();
      tracker.track(FAEvents(eventName: POST_DISLIKE_EVENT, attrs: null));
      _bloc.callApiUpVoteDownVote(widget.menuScreenContext, allPosts[pos].id, pos, "2");
    }
  }

  @override
  void onForwardClick(int pos) {
    player.pause();
    var duration = _duration + Duration(seconds: 15);
    player.seek(duration);
    player.resume();
  }

  @override
  void onPlayClick(int pos) async {
    if (pos != -1) {
      data.clear();
      for (var k = 0; k < allPosts.length; k++) {
        if (allPosts[k].duration != null) {
          if (k == pos) {
            allPosts[k].is_play = true;
          } else {
            if (allPosts[k].duration.inSeconds > 0) {
              allPosts[k].duration = Duration(milliseconds: 0);
            }
            allPosts[k].is_play = false;
          }
        }
      }
      if (mounted) setState(() {});
      int position = pos;
      _bloc.showProgressLoader(true);
      int result;
      if (allPosts[pos].duration.inSeconds > 0) {
        _duration = allPosts[pos].duration;
        result = await player.play(allPosts[pos].audio, isLocal: false, stayAwake: true, respectSilence: false);
        if (result == 1) {
          player.pause();
          player.seek(_duration);
          player.resume();
        }
      } else {
        _duration = Duration(milliseconds: 0);
        await player.pause();
        await player.stop();
        await player.release();
        result = await player.play(allPosts[pos].audio, isLocal: false, stayAwake: true, respectSilence: false);
      }

      if (result == 1) {
        player.onAudioPositionChanged.listen((event) {
          _duration = event;
        });
        player.onPlayerCompletion.listen((events) {
          if (mounted)
            setState(() {
              allPosts[position].is_play = false;
              _duration = Duration(milliseconds: 0);
              allPosts[position].duration = _duration;
            });
        });
        _bloc.showProgressLoader(false);
      } else {
        _bloc.showProgressLoader(false);
      }
    }
  }

  @override
  void onPauseClick(int pos) async {
    if (pos != -1) {
      allPosts[pos].is_play = false;
      allPosts[pos].duration = _duration;
      if (player != null) await player.pause();
    }
  }

  @override
  void onReverseClick(int pos) {
    if (_duration.inSeconds > 0) {
      player.pause();
      var duration = _duration - Duration(seconds: 15);
      player.seek(duration);
      player.resume();
    }
  }

  @override
  void onReplyClick(int pos) async {
    var result = await Navigator.push(
      widget.menuScreenContext,
      MaterialPageRoute(builder: (context) => ReplyPageList(data: allPosts[pos])),
    );
    if (result != null) {
      if (result) {
        if (mounted) setState(() {});
      }
    }
  }

  @override
  void onShareClick(int pos) {
    allPosts[pos].is_shared = true;
    showModalBottomSheet(
        context: widget.menuScreenContext,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(30.0), topRight: Radius.circular(30.0))),
        builder: (BuildContext bc) {
          return Container(
            color: Colors.transparent,
            height: MediaQuery.of(widget.menuScreenContext).size.height / 2.7,
            child: Container(
              color: Colors.transparent,
              child: BottomSheetShare(callBack: _shareCallBack, pos: pos),
            ),
          );
        });
  }

  @override
  void onUpVoteClick(int pos) {
    if (pos != -1) {
      FATracker tracker = FATracker();
      tracker.track(FAEvents(eventName: POST_LIKE_EVENT, attrs: null));
      _bloc.callApiUpVoteDownVote(widget.menuScreenContext, allPosts[pos].id, pos, "1");
    }
  }

  @override
  void onClickMenu(int pos) {
    showDialog(
      context: widget.menuScreenContext,
      builder: (context) {
        return AlertDialog(
          titleTextStyle: TextStyle(fontFamily: "Roboto", fontSize: fit.t(14.5), color: Colors.black, fontWeight: FontWeight.normal),
          title: GestureDetector(
            onTap: () => onClickStats(pos),
            child: Text(
              "View Stats",
              textAlign: TextAlign.start,
            ),
          ),
          content: GestureDetector(
            onTap: () => onClickReport(pos),
            child: Text(
              "Report Post",
              style: TextStyle(fontFamily: "Roboto", fontSize: fit.t(14.0), color: Colors.black, fontWeight: FontWeight.normal),
              textAlign: TextAlign.start,
            ),
          ),
        );
      },
    );
  }

  void onClickSayIcon() async {
    widget.controller(2);
  }

  void onClickProfile() async {
    await player.release();
    var result = await Navigator.push(
      widget.menuScreenContext,
      MaterialPageRoute(builder: (context) => ProfileScreen()),
    );
    if (result != null) {
      if (result) {
        page = 0;
        lastPage = false;
        _bloc.callApiGetAllPosts(widget.menuScreenContext, page, _filterIds);
        if (mounted) setState(() {});
      }
    }
  }

  @override
  void FacebookShare(pos) async {
    allPosts[pos].is_shared = true;
    allPosts[pos].n_shares += 1;
    if (mounted) setState(() {});
    SocialShare.shareOptions("${allPosts[pos].text}\n\n${allPosts[pos].audio}").then((data) {});
    _bloc.callApiSharePost(widget.menuScreenContext, allPosts[pos].id);
  }

  @override
  void LinkedinShare(pos) async {
    allPosts[pos].is_shared = true;
    allPosts[pos].n_shares += 1;
    if (mounted) setState(() {});
    SocialShare.shareOptions("${allPosts[pos].text}\n\n${allPosts[pos].audio}").then((data) {});
    _bloc.callApiSharePost(widget.menuScreenContext, allPosts[pos].id);
  }

  @override
  void TwitterShare(pos) async {
    allPosts[pos].is_shared = true;
    allPosts[pos].n_shares += 1;
    if (mounted) setState(() {});
    SocialShare.shareTwitter("${allPosts[pos].text}",
            hashtags: ["voicee", "audio", "text", "replies"], url: "${allPosts[pos].audio}", trailingText: "")
        .then((data) {});
    _bloc.callApiSharePost(widget.menuScreenContext, allPosts[pos].id);
  }

  @override
  void WhatsAppShare(pos) async {
    allPosts[pos].is_shared = true;
    allPosts[pos].n_shares += 1;
    if (mounted) setState(() {});
    _bloc.showProgressLoader(true);
    var request = await HttpClient().getUrl(Uri.parse(allPosts[pos].audio));
    var response = await request.close();
    Uint8List bytes = await consolidateHttpClientResponseBytes(response);
    Share.file('${allPosts[pos].text}', 'voicee_${allPosts[pos].id}.wav', bytes, 'audio/wav').then((value) {
      _bloc.showProgressLoader(false);
    });
    _bloc.callApiSharePost(widget.menuScreenContext, allPosts[pos].id);
  }

  void getFirebaseToken() {
    getStringDataLocally(key: fcmToken).then((onToken) {
      if (onToken != null) {
        if (onToken.isNotEmpty) {
          if (mounted) {
            _getId().then((value) {
              if (value != null) {
                if (value.isNotEmpty) {
                  Map<String, dynamic> mapName = Map();
                  mapName.putIfAbsent("token", () => onToken);
                  mapName.putIfAbsent("platform", () => Platform.isAndroid ? "ANDROID" : "IOS");
                  mapName.putIfAbsent("device_id", () => value);
                  _bloc.updatedFirebaseToken(mapName, widget.menuScreenContext);
                }
              }
            });
          }
        }
      }
    });
  }

  Future<String> _getId() async {
    var deviceInfo = DeviceInfoPlugin();
    if (Platform.isIOS) {
      IosDeviceInfo iosDeviceInfo = await deviceInfo.iosInfo;
      return iosDeviceInfo.identifierForVendor; // unique ID on iOS
    } else {
      AndroidDeviceInfo androidDeviceInfo = await deviceInfo.androidInfo;
      return androidDeviceInfo.androidId; // unique ID on Android
    }
  }

  void onClickReport(int pos) {
    Navigator.of(widget.menuScreenContext).pop();
    _bloc.callApiReportPost(widget.menuScreenContext, allPosts[pos].id);
  }

  void onClickStats(int pos) {
    FATracker tracker = FATracker();
    tracker.track(FAEvents(eventName: VIEW_STATS_EVENT, attrs: null));
    Navigator.of(widget.menuScreenContext).pop();
    Navigator.push(
      widget.menuScreenContext,
      MaterialPageRoute(builder: (context) => ReActionsScreen(data: allPosts[pos])),
    );
  }

  _getCurrentLocation() {
    _getCurrentLocations().then((position) {
      setState(() {
        if (position != null) {
          _currentPosition = position;
          writeStringDataLocally(key: latitude, value: _currentPosition.latitude.toString());
          writeStringDataLocally(key: longitude, value: _currentPosition.longitude.toString());
        }
      });
    }, onError: (map) {
      _bloc.showProgressLoader(false);
      // TopAlert.showAlert(widget.menuScreenContext,
      //     "You must activate your geolocation.", true);
    }).catchError((e) {
      _bloc.showProgressLoader(false);
      // TopAlert.showAlert(widget.menuScreenContext,
      //     "You must activate your geolocation.", true);
    });
  }

  Future<Position> _getCurrentLocations() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location permissions are permanently denied, we cannot request permissions.');
    }

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse && permission != LocationPermission.always) {
        return Future.error('Location permissions are denied (actual value: $permission).');
      }
    }

    return await Geolocator.getCurrentPosition();
  }

  void _searchNavigate() async {
    var result = await Navigator.push(widget.menuScreenContext, MaterialPageRoute(builder: (context) => SearchUsers()));
    if (result != null) {
      if (result) {
        widget.controller(3);
      }
    }
  }

  _isShown(bool shown) {
    setState(() {
      isShownTut = shown;
    });
  }
}
