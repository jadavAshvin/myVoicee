import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:audioplayers/audioplayers.dart';
import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fm_fit/fm_fit.dart';
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
import 'package:my_voicee/models/GetAllPostsResponse.dart';
import 'package:my_voicee/models/OtherUserResponse.dart';
import 'package:my_voicee/models/ReplyPostListModel.dart';
import 'package:my_voicee/models/UpDownVoteResponse.dart';
import 'package:my_voicee/models/commonResponse/CommonpiResponse.dart';
import 'package:my_voicee/models/errorResponse/customeError.dart';
import 'package:my_voicee/models/errorResponse/error_reponse.dart';
import 'package:my_voicee/postLogin/master_screen/dashboard/Bloc/DasboardBloc.dart';
import 'package:my_voicee/postLogin/master_screen/dashboard/DashboardListItem.dart';
import 'package:my_voicee/postLogin/postReply/PostReplyListItem.dart';
import 'package:my_voicee/postLogin/postReply/PostReplyPage.dart';
import 'package:my_voicee/postLogin/profile/OtherProfileScreen.dart';
import 'package:my_voicee/postLogin/reactions/ReActionsScreen.dart';
import 'package:my_voicee/utils/Utility.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:social_share/social_share.dart';

class ReplyPageList extends StatefulWidget {
  final AllPostResponse data;

  ReplyPageList({this.data});

  @override
  _ReplyPageListState createState() => _ReplyPageListState();
}

class _ReplyPageListState extends State<ReplyPageList>
    with DashboardCallBack, ShareCallBack {
  List<ResponseReplyModel> itemList = List();
  FmFit fit = FmFit(width: 750);
  GlobalKey _scaffoldKey = GlobalKey<ScaffoldState>();
  DashboardBloc _bloc;
  DashboardCallBack _itemCallBacks;
  ShareCallBack _shareCallBack;
  StreamController apiResponse;
  StreamController apiResponseData;
  ScrollController _scrollController = ScrollController();
  AudioPlayer player = AudioPlayer();
  Duration _duration = Duration(milliseconds: 0);
  bool isLoading = false;
  bool lastPage = false;
  int page = 0;

  @override
  void initState() {
    _itemCallBacks = this;
    _shareCallBack = this;
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);
    player.onPlayerStateChanged.listen((event) {
      if (event == AudioPlayerState.PLAYING) {
      } else if (event == AudioPlayerState.PAUSED) {
      } else if (event == AudioPlayerState.STOPPED) {
      } else if (event == AudioPlayerState.COMPLETED) {
        player.release();
      }
    });
    apiResponse = StreamController();
    apiResponseData = StreamController<List<ResponseReplyModel>>.broadcast();
    _bloc = DashboardBloc(apiResponse, apiResponseData);
    _subscribeToApiResponse();
    _bloc.callGetAllReplies(context, widget.data.id, page);
    _scrollController.addListener(() {
      if (_scrollController.position.maxScrollExtent ==
          _scrollController.position.pixels) {
        if (!isLoading) {
          isLoading = !isLoading;
          if (!lastPage) _bloc.callGetAllReplies(context, widget.data.id, page);
        }
      }
    });
    super.initState();
  }

  void _subscribeToApiResponse() {
    StreamSubscription subscription;
    subscription = apiResponse.stream.listen((data) {
      if (data is ReplyPostListModel) {
        if (data.response.length > 0) {
          if (page == 0) {
            itemList.clear();
          }
          for (var i = 0; i < data.response.length; i++) {
            data.response[i].duration = Duration(seconds: 0);
            data.response[i].is_play = false;
            itemList.add(data.response[i]);
          }
          if (page == 0) {
            itemList.add(ResponseReplyModel());
          }
          isLoading = false;
          if (data.response.length == 10) {
            page += 1;
          }
          if (data.response.length < 10) {
            lastPage = true;
          }
          if (itemList.length > 0) {
            if (itemList.firstWhere((element) => element.id == null,
                    orElse: null) !=
                null) {
              itemList
                  .remove(itemList.firstWhere((element) => element.id == null));
              itemList.insert(0, ResponseReplyModel());
              itemList.add(ResponseReplyModel());
            }
          }
        } else {
          lastPage = true;
          if (page == 0) {
            itemList.clear();
          }
        }
        if (itemList.length == 0) {
          itemList.add(ResponseReplyModel());
        }

        if (page == 0 && data.response.length == 0) {
          itemList.add(ResponseReplyModel());
        }
        if (mounted) setState(() {});
      } else if (data is UpDownVoteResponse) {
        if (data.from == "2") {
          if (data.pos != -2) {
            //downvote
            if (data.is_action) {
              itemList[data.pos].isDisliked = true;
              itemList[data.pos].nDislikes += 1;
            } else {
              itemList[data.pos].isDisliked = false;
              itemList[data.pos].nDislikes -= 1;
            }
          } else {
            //downvote
            if (data.is_action) {
              widget.data.is_disliked = true;
              widget.data.n_dislikes += 1;
            } else {
              widget.data.is_disliked = false;
              widget.data.n_dislikes -= 1;
            }
          }
          if (mounted) setState(() {});
        } else {
          if (data.pos != -2) {
            //upvote
            if (data.is_action) {
              itemList[data.pos].isLiked = true;
              itemList[data.pos].nLikes += 1;
            } else {
              itemList[data.pos].isLiked = false;
              itemList[data.pos].nLikes -= 1;
            }
          } else {
            //upvote
            if (data.is_action) {
              widget.data.is_liked = true;
              widget.data.n_likes += 1;
            } else {
              widget.data.is_liked = false;
              widget.data.n_likes -= 1;
            }
          }
          if (mounted) setState(() {});
        }
        TopAlert.showAlert(context, data.message, false);
      } else if (data is OtherUserResponse) {
        // Navigator.push(
        //     context,
        //     MaterialPageRoute(
        //         builder: (context) =>
        //             OtherProfileScreen(profileData: data.response)));
        pushNewScreen(context,
            screen: OtherProfileScreen(profileData: data.response),
            withNavBar: false);
      } else if (data is CommonApiReponse) {
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
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(fit.t(60.0)),
        child: AppBar(
          backgroundColor: Color.fromRGBO(243, 243, 243, 1),
          elevation: 0,
          leading: _leadingWidget(),
          centerTitle: true,
          title: _titleWidget(),
          actions: <Widget>[trailingWidget()],
        ),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              margin: EdgeInsets.only(
                  top: fit.t(10.0), left: fit.t(12.0), right: fit.t(12.0)),
              child: _createListView(),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: InkWell(
                onTap: () => onClickSayIcon(),
                child: Container(
                  height: fit.t(80.0),
                  color: Colors.white,
                  child: Image.asset(
                    "assets/images/share_shot.png",
                    height: fit.t(65.0),
                    fit: BoxFit.fitHeight,
                  ),
                  alignment: Alignment.center,
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
      ),
    );
  }

  Widget trailingWidget() {
    return InkWell(
      onTap: () {
        showDialogForConfirmation(context);
      },
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

  void showDialogForConfirmation(BuildContext context) {
    // set up the buttons
    Widget cancelButton = FlatButton(
      child: Text("No"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    Widget continueButton = FlatButton(
      child: Text("Yes"),
      onPressed: () {
        Navigator.of(context).pop();
        Navigator.of(context).pop(true);
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(""),
      content: Text("Are you sure want to exit?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
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
            'Reply',
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
    return Container(
      margin: EdgeInsets.only(left: fit.t(16.0)),
      child: Container(
        child: Image.asset(
          ic_logo_small,
        ),
      ),
    );
  }

  Widget dashboardItem() {
    return DashBoardListItem(
      fit: fit,
      pos: -2,
      from: -2,
      isTutShown: _isShown,
      isShown: true,
      data: widget.data,
      callBack: _itemCallBacks,
      player: player,
    );
  }

  _isShown(bool shown) {}

  @override
  void FacebookShare(pos) async {
    if (pos == -2) {
      widget.data.is_shared = true;
      widget.data.n_shares += 1;
      if (mounted) setState(() {});
      SocialShare.shareOptions("${widget.data.text}\n\n${widget.data.audio}")
          .then((data) {});
      _bloc.callApiSharePost(context, widget.data.id);
    } else {
      if (pos != -1) {
        itemList[pos].isShared = true;
        itemList[pos].nShares += 1;
        if (mounted) setState(() {});
        SocialShare.shareOptions(
                "${itemList[pos].comment}\n\n${itemList[pos].commentUrl}")
            .then((data) {});
        _bloc.callApiSharePostReply(context, widget.data.id, itemList[pos].id);
      }
    }
  }

  @override
  void LinkedinShare(pos) async {
    if (pos == -2) {
      widget.data.is_shared = true;
      widget.data.n_shares += 1;
      if (mounted) setState(() {});
      SocialShare.shareOptions("${widget.data.text}\n\n${widget.data.audio}")
          .then((data) {});
      _bloc.callApiSharePost(context, widget.data.id);
    } else {
      if (pos != -1) {
        itemList[pos].isShared = true;
        itemList[pos].nShares += 1;
        if (mounted) setState(() {});
        SocialShare.shareOptions(
                "${itemList[pos].comment}\n\n${itemList[pos].commentUrl}")
            .then((data) {});
        _bloc.callApiSharePostReply(context, widget.data.id, itemList[pos].id);
      }
    }
  }

  @override
  void TwitterShare(pos) async {
    if (pos == -2) {
      widget.data.is_shared = true;
      widget.data.n_shares += 1;
      if (mounted) setState(() {});
      SocialShare.shareTwitter("${widget.data.text}",
              hashtags: ["voicee", "audio", "text", "replies"],
              url: "${widget.data.audio}",
              trailingText: "")
          .then((data) {});
      _bloc.callApiSharePost(context, widget.data.id);
    } else {
      if (pos != -1) {
        itemList[pos].isShared = true;
        itemList[pos].nShares += 1;
        if (mounted) setState(() {});
        SocialShare.shareTwitter("${itemList[pos].comment}",
                hashtags: ["voicee", "audio", "text", "replies"],
                url: "${itemList[pos].commentUrl}",
                trailingText: "")
            .then((data) {});
        _bloc.callApiSharePostReply(context, widget.data.id, itemList[pos].id);
      }
    }
  }

  @override
  void WhatsAppShare(pos) async {
    if (pos == -2) {
      widget.data.is_shared = true;
      widget.data.n_shares += 1;
      if (mounted) setState(() {});
      _bloc.showProgressLoader(true);
      var request = await HttpClient().getUrl(Uri.parse(widget.data.audio));
      var response = await request.close();
      Uint8List bytes = await consolidateHttpClientResponseBytes(response);
      Share.file('${widget.data.text}', 'voicee_${widget.data.id}.wav', bytes,
              'audio/wav')
          .then((value) {
        _bloc.showProgressLoader(false);
      });
      _bloc.callApiSharePost(context, widget.data.id);
    } else {
      if (pos != -1) {
        itemList[pos].isShared = true;
        itemList[pos].nShares += 1;
        if (mounted) setState(() {});
        _bloc.showProgressLoader(true);
        var request =
            await HttpClient().getUrl(Uri.parse(itemList[pos].commentUrl));
        var response = await request.close();
        Uint8List bytes = await consolidateHttpClientResponseBytes(response);
        Share.file('${itemList[pos].comment}', 'voicee_${itemList[pos].id}.wav',
                bytes, 'audio/wav')
            .then((value) {
          _bloc.showProgressLoader(false);
        });
        _bloc.callApiSharePostReply(context, widget.data.id, itemList[pos].id);
      }
    }
  }

  @override
  void onClickItem(int pos) {
    if (pos == -2)
      _bloc.callApiOtherUserProfile(context, widget.data.user.id);
    else
      _bloc.callApiOtherUserProfile(context, itemList[pos].user.id);
  }

  @override
  void onDownVoteClick(int pos) {
    if (pos == -2) {
      FATracker tracker = FATracker();
      tracker.track(FAEvents(eventName: POST_DISLIKE_EVENT, attrs: null));
      _bloc.callApiUpVoteDownVote(context, widget.data.id, pos, "2");
    } else {
      if (pos != -1) {
        FATracker tracker = FATracker();
        tracker.track(FAEvents(eventName: POST_LIKE_EVENT, attrs: null));
        _bloc.callApiUpVoteDownVoteReply(
            context, widget.data.id, itemList[pos].id, pos, "2");
      }
    }
  }

  @override
  void onForwardClick(int pos) {
    if (pos == -2) {
      player.pause();
      var duration = _duration + Duration(seconds: 15);
      player.seek(duration);
      player.resume();
    } else {
      player.pause();
      var duration = _duration + Duration(seconds: 15);
      player.seek(duration);
      player.resume();
    }
  }

  @override
  void onPlayClick(int pos) async {
    if (pos == -2) {
      widget.data.is_play = true;
      if (mounted) setState(() {});
      int position = pos;
      _bloc.showProgressLoader(true);
      int result;
      if (widget.data.duration.inSeconds > 0) {
        _duration = widget.data.duration;
        result = await player.play(widget.data.audio,
            isLocal: false, stayAwake: true, respectSilence: false);
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
        result = await player.play(widget.data.audio,
            isLocal: false, stayAwake: true, respectSilence: false);
      }

      if (result == 1) {
        player.onAudioPositionChanged.listen((event) {
          _duration = event;
        });
        player.onPlayerCompletion.listen((events) {
          if (mounted)
            setState(() {
              widget.data.is_play = false;
              _duration = Duration(milliseconds: 0);
              widget.data.duration = _duration;
            });
        });
        _bloc.showProgressLoader(false);
      } else {
        _bloc.showProgressLoader(false);
      }
    } else {
      if (pos != -1) {
        for (var k = 0; k < itemList.length; k++) {
          if (itemList[k].duration != null) {
            if (k == pos) {
              itemList[k].is_play = true;
            } else {
              if (itemList[k].duration.inSeconds > 0) {
                itemList[k].duration = Duration(milliseconds: 0);
              }
              itemList[k].is_play = false;
            }
          }
        }
        widget.data.is_play = false;
        if (mounted) setState(() {});
        int position = pos;
        _bloc.showProgressLoader(true);
        int result;
        if (itemList[pos].duration.inSeconds > 0) {
          _duration = itemList[pos].duration;
          result = await player.play(itemList[pos].commentUrl,
              isLocal: false, stayAwake: true, respectSilence: false);
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
          result = await player.play(itemList[pos].commentUrl,
              isLocal: false, stayAwake: true, respectSilence: false);
        }

        if (result == 1) {
          player.onAudioPositionChanged.listen((event) {
            _duration = event;
          });
          player.onPlayerCompletion.listen((events) {
            if (mounted)
              setState(() {
                itemList[position].is_play = false;
                _duration = Duration(milliseconds: 0);
                itemList[position].duration = _duration;
              });
          });
          _bloc.showProgressLoader(false);
        } else {
          _bloc.showProgressLoader(false);
        }
      }
    }
  }

  @override
  void onPauseClick(int pos) async {
    if (pos == -2) {
      widget.data.is_play = false;
      widget.data.duration = _duration;
      if (player != null) await player.pause();
    } else {
      if (pos != -1) {
        itemList[pos].is_play = false;
        itemList[pos].duration = _duration;
        if (player != null) await player.pause();
      }
    }
  }

  @override
  void onReverseClick(int pos) {
    if (pos == -2) {
      if (_duration.inSeconds > 0) {
        player.pause();
        var duration = _duration - Duration(seconds: 15);
        player.seek(duration);
        player.resume();
      }
    } else {
      if (_duration.inSeconds > 0) {
        player.pause();
        var duration = _duration - Duration(seconds: 15);
        player.seek(duration);
        player.resume();
      }
    }
  }

  @override
  void onReplyClick(int pos) async {}

  @override
  void onShareClick(int pos) {
    if (pos == -2) {
      widget.data.is_shared = true;
      showModalBottomSheet(
          context: context,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30.0),
                  topRight: Radius.circular(30.0))),
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
    } else {
      if (pos != -1) {
        itemList[pos].isShared = true;
        showModalBottomSheet(
            context: context,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30.0),
                    topRight: Radius.circular(30.0))),
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
    }
  }

  @override
  void onUpVoteClick(int pos) {
    if (pos == -2) {
      FATracker tracker = FATracker();
      tracker.track(FAEvents(eventName: POST_LIKE_EVENT, attrs: null));
      _bloc.callApiUpVoteDownVote(context, widget.data.id, pos, "1");
    } else {
      if (pos != -1) {
        FATracker tracker = FATracker();
        tracker.track(FAEvents(eventName: POST_LIKE_EVENT, attrs: null));
        _bloc.callApiUpVoteDownVoteReply(
            context, widget.data.id, itemList[pos].id, pos, "1");
      }
    }
  }

  @override
  void onClickMenu(int pos) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          titleTextStyle: TextStyle(
              fontFamily: "Roboto",
              fontSize: fit.t(14.5),
              color: Colors.black,
              fontWeight: FontWeight.normal),
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
              style: TextStyle(
                  fontFamily: "Roboto",
                  fontSize: fit.t(14.0),
                  color: Colors.black,
                  fontWeight: FontWeight.normal),
              textAlign: TextAlign.start,
            ),
          ),
        );
      },
    );
  }

  void onClickReport(int pos) {
    if (pos == -2) {
      Navigator.of(context).pop();
      _bloc.callApiReportPost(context, widget.data.id);
    }
  }

  void onClickStats(int pos) {
    if (pos == -2) {
      FATracker tracker = FATracker();
      tracker.track(FAEvents(eventName: VIEW_STATS_EVENT, attrs: null));
      Navigator.of(context).pop();
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ReActionsScreen(data: widget.data)),
      );
    }
  }

  void onClickSayIcon() async {
    var result = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => PostReplyPage(data: widget.data.id)),
    );
    if (result != null) {
      if (result) {
        page = 0;
        lastPage = false;
        _bloc.callGetAllReplies(context, widget.data.id, page);
      }
    }
  }

  Widget _createListView() {
    return ListView.builder(
      physics: AlwaysScrollableScrollPhysics(),
      itemBuilder: (BuildContext context, int index) {
        return (index == 0)
            ? dashboardItem()
            : (index == 1 && itemList[index].id == null)
                ? NoDataWidget(
                    fit: fit,
                    txt: 'No Replies.',
                  )
                : itemList[index].id == null
                    ? NoDataWidget(
                        fit: fit,
                        txt: '\n',
                      )
                    : PostReplyListItem(
                        fit: fit,
                        pos: index,
                        player: player,
                        data: itemList[index],
                        callBack: _itemCallBacks);
      },
      itemCount: itemList.length,
      shrinkWrap: false,
      controller: _scrollController,
    );
  }
}
