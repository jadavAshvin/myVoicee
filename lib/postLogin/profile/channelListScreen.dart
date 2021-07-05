import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:audioplayers/audioplayers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fm_fit/fm_fit.dart';
import 'package:my_voicee/models/channelListModel.dart';
import 'package:my_voicee/postLogin/profile/drawerItems/channel/bloc/ChannelBloc.dart';
import 'package:my_voicee/postLogin/profile/profileBloc/ChannelListBloc.dart';
import 'package:social_share/social_share.dart';
import 'package:my_voicee/CallBacks/DashBaordListCallBack.dart';
import 'package:my_voicee/CallBacks/ShareCallBack.dart';
import 'package:my_voicee/analytics/FAEvent.dart';
import 'package:my_voicee/analytics/FAEventName.dart';
import 'package:my_voicee/analytics/FATracker.dart';
import 'package:my_voicee/constants/app_colors.dart';
import 'package:my_voicee/constants/app_images_path.dart';
import 'package:my_voicee/customWidget/Alert/NoDataWidget.dart';
import 'package:my_voicee/customWidget/Alert/top_alert.dart';
import 'package:my_voicee/customWidget/BottomSheetShare.dart';
import 'package:my_voicee/customWidget/appLoader/custom_progress_loader.dart';
import 'package:my_voicee/customWidget/imageViewer/ImageViewer.dart';
import 'package:my_voicee/models/FollowResponse.dart';
import 'package:my_voicee/models/GetAllPostsResponse.dart';
import 'package:my_voicee/models/OtherUserResponse.dart';
import 'package:my_voicee/models/commonResponse/CommonpiResponse.dart';
import 'package:my_voicee/models/errorResponse/customeError.dart';
import 'package:my_voicee/models/errorResponse/error_reponse.dart';
import 'package:my_voicee/postLogin/master_screen/dashboard/DashboardListItem.dart';
import 'package:my_voicee/postLogin/postReply/PostReplyPage.dart';
import 'package:my_voicee/postLogin/postReply/ReplyList.dart';
import 'package:my_voicee/postLogin/profile/profileBloc/ProfileBloc.dart';
import 'package:my_voicee/postLogin/reactions/ReActionsScreen.dart';
import 'package:my_voicee/utils/Utility.dart';

class ChannelListScreen extends StatefulWidget {
  final String userIdChannel;

  ChannelListScreen({this.userIdChannel});

  @override
  _ChannelListScreenState createState() => _ChannelListScreenState();
}

class _ChannelListScreenState extends State<ChannelListScreen> with DashboardCallBack, ShareCallBack {
  var _scaffoldKey = GlobalKey<ScaffoldState>();
  AudioPlayer player = AudioPlayer();
  FmFit fit = FmFit(width: 750);
  File userImageFile;
  String imagePath;
  ChannelListModel userDataBean;
  ChannelListBloc _bloc;
  StreamController apiResponseData;
  StreamController apiResponse;
  List<AllPostResponse> allPosts = List();
  ScrollController _scrollController = ScrollController();
  var page = 0;
  bool isLoading = false;
  bool lastPage = false;
  DashboardCallBack _itemCallBacks;
  ShareCallBack _shareCallBack;
  var valuePop = false;
  Duration _duration = Duration(milliseconds: 0);

  @override
  void initState() {
    _itemCallBacks = this;
    _shareCallBack = this;
    apiResponseData = StreamController<List<AllPostResponse>>.broadcast();
    apiResponse = StreamController();
    _bloc = ChannelListBloc(apiResponseData, apiResponse);
    _subscribeToApiResponse();
    _bloc.getUserProfile(context, widget.userIdChannel);

    imagePath = userDataBean.response.user.dp;
    // _scrollController.addListener(() {
    //   if (_scrollController.position.maxScrollExtent == _scrollController.position.pixels) {
    //     if (!isLoading) {
    //       isLoading = !isLoading;
    //       if (!lastPage) _bloc.callApiGetAllPosts(context, userDataBean.response.user.id, page);
    //     }
    //   }
    // });
    page = 0;
    _bloc.callApiGetAllPosts(context, userDataBean.response.user.id, page);
    player.onPlayerStateChanged.listen((event) {
      if (event == AudioPlayerState.PLAYING) {
      } else if (event == AudioPlayerState.PAUSED) {
      } else if (event == AudioPlayerState.STOPPED) {
      } else if (event == AudioPlayerState.COMPLETED) {
        player.release();
      }
    });
    FATracker tracker = FATracker();
    tracker.track(FAEvents(eventName: VIEW_PUBLIC_PROFILE, attrs: null));
    super.initState();
  }

  @override
  void dispose() {
    apiResponseData.close();
    apiResponse.close();
    player.release();
    _bloc.dispose();
    super.dispose();
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
      backgroundColor: colorWhite,
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: colorWhite,
        elevation: 0,
        leading: _leadingWidget(),
        centerTitle: true,
        title: _titleWidget(),
        actions: <Widget>[trailingWidget()],
      ),
      body: Stack(children: <Widget>[
        Container(
          margin: EdgeInsets.only(top: fit.t(8.0), left: fit.t(8.0), right: fit.t(4.0)),
          child: Stack(
            children: [
              Positioned(
                right: fit.t(0.0),
                top: fit.t(0.0),
                child: Container(
                  height: fit.t(30.0),
                  width: fit.t(60.0),
                  child: InkWell(
                    onTap: () => onClickReportUser(),
                    child: Icon(
                      Icons.block_flipped,
                      color: Colors.red,
                      size: fit.t(24.0),
                    ),
                  ),
                ),
              ),
              Wrap(
                children: <Widget>[
                  Column(
                    children: [
                      Container(
                        height: fit.t(60.0),
                        width: fit.t(60.0),
                        margin: EdgeInsets.only(
                          left: fit.t(60.0),
                          right: fit.t(60.0),
                        ),
                        child: Stack(
                          children: <Widget>[
                            GestureDetector(
                              onTap: () => onImageClick(),
                              child: CachedNetworkImage(
                                imageUrl: '$imagePath',
                                imageBuilder: (context, imageProvider) => ClipRRect(
                                  borderRadius: BorderRadius.all(Radius.circular(80.0)),
                                  child: Container(
                                    height: fit.t(60.0),
                                    width: fit.t(60.0),
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image: imageProvider,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),
                                placeholder: (context, image) => Image.asset(
                                  ic_profile,
                                  height: fit.t(60.0),
                                  width: fit.t(60.0),
                                  fit: BoxFit.cover,
                                ),
                                errorWidget: (context, url, error) => Image.asset(
                                  ic_profile,
                                  height: fit.t(60.0),
                                  width: fit.t(60.0),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 5.0,
                      ),
                      userDataBean.response.user.isPublisher ?? false
                          ? Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  padding: EdgeInsets.all(4.0),
                                  child: Text(
                                    '${userDataBean.response.user.name ?? ""}',
                                    textAlign: TextAlign.center,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        fontFamily: 'Roboto', fontSize: fit.t(20.0), fontWeight: FontWeight.bold, color: Color.fromRGBO(0, 0, 0, 1)),
                                  ),
                                ),
                                Image.asset(
                                  badge,
                                  scale: 2.5,
                                )
                              ],
                            )
                          : Container(
                              padding: EdgeInsets.all(4.0),
                              child: Text(
                                '${userDataBean.response.user.name ?? ""}',
                                textAlign: TextAlign.center,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontFamily: 'Roboto', fontSize: fit.t(18.0), fontWeight: FontWeight.bold, color: Color.fromRGBO(0, 0, 0, 1)),
                              ),
                            ),
                      SizedBox(
                        height: 5.0,
                      ),
                      //bio
                      Container(
                        child: Text(
                          '${userDataBean.response.user.bio ?? ""}',
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontFamily: 'Roboto', fontWeight: FontWeight.w400, fontSize: fit.t(16.0), color: Color.fromRGBO(119, 113, 113, 1)),
                        ),
                      ),
                      SizedBox(
                        height: 5.0,
                      ),
                      // Container(
                      //   height: fit.t(30.0),
                      //   child: RaisedButton(
                      //     color: colorAcceptBtn,
                      //     textColor: colorWhite,
                      //     onPressed: () => onClickFollow(),
                      //     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
                      //     child: Text(
                      //       userDataBean.response.user.f ?? false ? 'UnFollow' : 'Follow',
                      //       textAlign: TextAlign.center,
                      //       style: TextStyle(
                      //         fontWeight: FontWeight.w500,
                      //         color: colorWhite,
                      //         letterSpacing: 0.18,
                      //         fontFamily: "Roboto",
                      //         fontSize: fit.t(14.0),
                      //       ),
                      //     ),
                      //     splashColor: colorAcceptBtnSplash,
                      //   ),
                      // ),
                      SizedBox(
                        height: fit.t(10.0),
                      ),
                      //divider
                      Divider(
                        height: fit.t(2.0),
                        endIndent: fit.t(15.0),
                        indent: fit.t(15.0),
                      ),
                      //column
                    ],
                  ),
                  SizedBox(
                    height: fit.t(10.0),
                  ),
                  Container(height: MediaQuery.of(context).size.height, child: _createListView(allPosts)),
                ],
              ),
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
      ]),
    );
  }

  Widget _createListView(List<AllPostResponse> itemList) {
    return ListView.builder(
      physics: BouncingScrollPhysics(),
      itemBuilder: (BuildContext context, int index) {
        return (index == 0 && itemList[index].id == null)
            ? NoDataWidget(
                fit: fit,
                txt: 'No Posts',
              )
            : itemList[index].id == null
                ? NoDataWidget(
                    fit: fit,
                    txt: '\n\n\n\n\n\n\n\n\n\n\n',
                  )
                : DashBoardListItem(
                    fit: fit, pos: index, isTutShown: _isShown, isShown: true, from: "profile", data: itemList[index], callBack: _itemCallBacks);
      },
      itemCount: itemList.length,
      shrinkWrap: false,
      controller: _scrollController,
    );
  }

  _isShown(bool shown) {}

  Widget _titleWidget() {
    return Container(
      child: Padding(
        padding: EdgeInsets.only(top: fit.t(8.0), left: fit.t(8.0), right: fit.t(8.0)),
        child: Container(
          child: Text(
            'Profile',
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
    return Container(
      margin: EdgeInsets.only(left: fit.t(16.0)),
      child: Container(
        child: Image.asset(
          ic_logo_small,
        ),
      ),
    );
  }

  Widget trailingWidget() {
    return InkWell(
      onTap: () => Navigator.of(context).pop(),
      child: Container(
        margin: EdgeInsets.only(right: fit.t(16.0), top: fit.t(4.0)),
        child: Image.asset(
          ic_back_img,
          height: fit.t(40.0),
          width: fit.t(40.0),
        ),
      ),
    );
  }

  onImageClick() {
    if (imagePath != null) {
      if (imagePath.toString().contains('https://')) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => PhotoViewer(imagePath, fit)),
        );
      }
    }
  }

  void _subscribeToApiResponse() {
    // StreamSubscription subscription;
    // subscription = apiResponse.stream.listen((data) {
    //   if (data is GetAllPostResponse) {
    //     if (data.response.length > 0) {
    //       if (page == 0) {
    //         allPosts.clear();
    //       }
    //       for (var i = 0; i < data.response.length; i++) {
    //         data.response[i].duration = Duration(seconds: 0);
    //         data.response[i].is_play = false;
    //         allPosts.add(data.response[i]);
    //       }
    //       if (page == 0) {
    //         allPosts.add(AllPostResponse());
    //       }
    //       isLoading = false;
    //       if (data.response.length == 10) {
    //         page += 1;
    //       }
    //       if (data.response.length < 10) {
    //         lastPage = true;
    //       }
    //       if (allPosts.length > 0) {
    //         if (allPosts.firstWhere((element) => element.id == null, orElse: null) != null) {
    //           allPosts.remove(allPosts.firstWhere((element) => element.id == null));
    //           allPosts.add(AllPostResponse());
    //         }
    //       }
    //     }
    //     if (allPosts.length == 0) {
    //       allPosts.add(AllPostResponse());
    //     }
    //     if (mounted) setState(() {});
    //   } else if (data is CommonApiReponse) {
    //     if (data.message == "Thank you for reporting the user. Our team will look at this account soon.") {
    //     } else {
    //       if (data.response != null) {
    //         if (data.response is String) {
    //           if (data.response.toString().isNotEmpty) {
    //             imagePath = data.response;
    //             page = 0;
    //           }
    //           if (mounted) setState(() {});
    //         }
    //       }
    //     }
    //     TopAlert.showAlert(context, data.message, false);
    //   } else if (data is FollowResponse) {
    //     if (userDataBean.following) {
    //       userDataBean.following = false;
    //     } else {
    //       userDataBean.following = true;
    //     }
    //     if (data.showMsg == 1) TopAlert.showAlert(context, data.message, false);
    //     if (mounted) setState(() {});
    //   } else if (data is ErrorResponse) {
    //     TopAlert.showAlert(context, data.message, true);
    //   } else if (data is CustomError) {
    //     if (data.errorMessage == 'Check your internet connection.') {
    //       pushNamedIfNotCurrent(context, '/noInternet');
    //     } else {
    //       TopAlert.showAlert(_scaffoldKey.currentState.context, data.errorMessage, true);
    //     }
    //   } else if (data is Exception) {
    //     TopAlert.showAlert(_scaffoldKey.currentState.context, 'Oops, Something went wrong please try again later.', true);
    //   }
    // }, onError: (error) {
    //   if (error is CustomError) {
    //     TopAlert.showAlert(context, error.errorMessage, true);
    //   } else {
    //     TopAlert.showAlert(context, error.toString(), true);
    //   }
    // });
  }

  @override
  void FacebookShare(pos) async {
    allPosts[pos].is_shared = true;
    allPosts[pos].n_shares += 1;
    if (mounted) setState(() {});
    SocialShare.shareOptions("${allPosts[pos].text}\n\n${allPosts[pos].audio}").then((data) {});
    _bloc.callApiSharePost(context, allPosts[pos].id);
  }

  @override
  void LinkedinShare(pos) async {
    allPosts[pos].is_shared = true;
    allPosts[pos].n_shares += 1;
    if (mounted) setState(() {});
    SocialShare.shareOptions("${allPosts[pos].text}\n${allPosts[pos].audio}").then((data) {});
    _bloc.callApiSharePost(context, allPosts[pos].id);
  }

  @override
  void TwitterShare(pos) async {
    allPosts[pos].is_shared = true;
    allPosts[pos].n_shares += 1;
    if (mounted) setState(() {});
    SocialShare.shareTwitter("${allPosts[pos].text}",
            hashtags: ["voicee", "audio", "text", "replies"], url: "${allPosts[pos].audio}", trailingText: "")
        .then((data) {});
    _bloc.callApiSharePost(context, allPosts[pos].id);
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
    _bloc.callApiSharePost(context, allPosts[pos].id);
  }

  @override
  void onClickItem(int pos) {
    if (pos != -1)
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => PostReplyPage(data: allPosts[pos].id)),
      );
  }

  @override
  void onClickMenu(int pos) {
    showDialog(
      context: context,
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

  void onClickReport(int pos) {
    Navigator.of(context).pop();
    _bloc.callApiReportPost(context, allPosts[pos].id);
  }

  void onClickStats(int pos) {
    FATracker tracker = FATracker();
    tracker.track(FAEvents(eventName: VIEW_STATS_EVENT, attrs: null));
    Navigator.of(context).pop();
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ReActionsScreen(data: allPosts[pos])),
    );
  }

  @override
  void onDownVoteClick(int pos) {
    if (pos != -1) {
      allPosts[pos].is_disliked = true;
      allPosts[pos].n_dislikes += 1;
      if (mounted) setState(() {});
      _bloc.callApiUpVoteDownVote(context, allPosts[pos].id, "2");
    }
  }

  @override
  void onReplyClick(int pos) async {
    if (pos != -1) {
      var result = await Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ReplyPageList(data: allPosts[pos])),
      );
      if (result != null) {
        if (result) {
          allPosts[pos].is_commented = true;
          allPosts[pos].n_comments += 1;
          if (mounted) setState(() {});
        }
      }
    }
  }

  @override
  void onShareClick(int pos) {
    allPosts[pos].is_shared = true;
    showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(30.0), topRight: Radius.circular(30.0))),
        builder: (BuildContext bc) {
          return Container(
            color: Colors.transparent,
            height: MediaQuery.of(context).size.height / 2.7,
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
      allPosts[pos].is_liked = true;
      allPosts[pos].n_likes += 1;
      if (mounted) setState(() {});
      _bloc.callApiUpVoteDownVote(context, allPosts[pos].id, "1");
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

  // void onClickFollow() {
  //   _bloc.userFollow(context, userDataBean.id);
  // }

  void onClickReportUser() {
    showDialogReportUser(context, title: "Why are you reporting this account?", content: "", onReportClick: (item) {
      Navigator.of(context).pop();
      _bloc.callApiReportUser(context, item.title, userDataBean.response.userId);
    });
  }
}
