import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:audioplayers/audioplayers.dart';
import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fm_fit/fm_fit.dart';
import 'package:my_voicee/CallBacks/CommentCallBack.dart';
import 'package:my_voicee/CallBacks/ShareCallBack.dart';
import 'package:my_voicee/constants/app_colors.dart';
import 'package:my_voicee/customWidget/Alert/NoDataWidget.dart';
import 'package:my_voicee/customWidget/Alert/top_alert.dart';
import 'package:my_voicee/customWidget/BottomSheetShare.dart';
import 'package:my_voicee/customWidget/appLoader/custom_progress_loader.dart';
import 'package:my_voicee/models/ReActionResponse.dart';
import 'package:my_voicee/models/commonResponse/CommonpiResponse.dart';
import 'package:my_voicee/models/errorResponse/customeError.dart';
import 'package:my_voicee/models/errorResponse/error_reponse.dart';
import 'package:my_voicee/postLogin/reactions/ReActionsBloc/ReActionsBloc.dart';
import 'package:my_voicee/postLogin/reactions/comments/CommentListItem.dart';
import 'package:my_voicee/utils/Utility.dart';
import 'package:social_share/social_share.dart';

class CommentScreen extends StatefulWidget {
  final data;
  final id;

  CommentScreen({this.data, this.id});

  @override
  _CommentScreenState createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen>
    with CommentCallBack, ShareCallBack {
  Duration _duration = Duration(milliseconds: 0);
  AudioPlayer player = AudioPlayer();
  CommentCallBack _callBack;
  StreamController apiResponseData;
  StreamController apiResponse;
  ShareCallBack _shareCallBack;
  bool isLoading = false;
  bool lastPage = false;
  ReActionsBloc _bloc;
  FmFit fit = FmFit(width: 750);
  ScrollController _scrollController = ScrollController();
  var page = 0;
  List<ReActionItemModel> allPosts = List();

  @override
  void initState() {
    _callBack = this;
    _shareCallBack = this;
    apiResponseData = StreamController<List<ReActionItemModel>>.broadcast();
    apiResponse = StreamController();
    _bloc = ReActionsBloc(apiResponseData, apiResponse);
    _subscribeToApiResponse();
    _bloc.callApiGetReactions(context, widget.id, 2, page);

    _scrollController.addListener(() {
      if (_scrollController.position.maxScrollExtent ==
          _scrollController.position.pixels) {
        if (!isLoading) {
          isLoading = !isLoading;
          if (!lastPage) _bloc.callApiGetReactions(context, widget.id, 2, page);
        }
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    apiResponse.close();
    apiResponseData.close();
    player.release();
    _bloc.dispose();
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
    return Stack(
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(
              top: fit.t(10.0), left: fit.t(16.0), right: fit.t(16.0)),
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
    );
  }

  Widget _createListView(List<ReActionItemModel> itemList) {
    return ListView.builder(
      physics: AlwaysScrollableScrollPhysics(),
      itemBuilder: (BuildContext context, int index) {
        return index == 0 && itemList[index].id == null
            ? NoDataWidget(
                fit: fit,
                txt: 'No Reactions Found.',
              )
            : itemList[index].id == null
                ? NoDataWidget(
                    fit: fit,
                    txt: '',
                  )
                : CommentListItem(
                    fit: fit,
                    pos: index,
                    data: itemList[index],
                    onclickItem: _callBack,
                  );
      },
      itemCount: itemList.length,
      shrinkWrap: false,
      controller: _scrollController,
    );
  }

  void _subscribeToApiResponse() {
    StreamSubscription subscription;
    subscription = apiResponse.stream.listen((data) {
      if (data is ReActionResponse) {
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
            allPosts.add(ReActionItemModel());
          }
          isLoading = false;
          if (data.response.length == 10) {
            page += 1;
          }
          if (data.response.length < 10) {
            lastPage = true;
          }
          if (allPosts.length > 0) {
            if (allPosts.firstWhere((element) => element.id == null,
                    orElse: null) !=
                null) {
              allPosts
                  .remove(allPosts.firstWhere((element) => element.id == null));
              allPosts.add(ReActionItemModel());
            }
          }
        } else {
          lastPage = true;
          if (page == 0) {
            allPosts.clear();
          }
        }
        if (allPosts.length == 0) {
          allPosts.add(ReActionItemModel());
        }

        if (mounted) setState(() {});
      } else if (data is CommonApiReponse) {
        TopAlert.showAlert(context, data.message, false);
      } else if (data is ErrorResponse) {
        TopAlert.showAlert(context, data.message, true);
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
  void onClickShare(int pos) {
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
              child: BottomSheetShare(
                callBack: _shareCallBack,
                pos: pos,
              ),
            ),
          );
        });
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
        result = await player.play(allPosts[pos].comment_url,
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
        result = await player.play(allPosts[pos].comment_url,
            isLocal: false, stayAwake: true, respectSilence: false);
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
  void FacebookShare(pos) async {
    SocialShare.shareOptions(
            "${allPosts[pos].comment}\n\n${allPosts[pos].comment_url}")
        .then((data) {});
  }

  @override
  void LinkedinShare(pos) async {
    SocialShare.shareOptions(
            "${allPosts[pos].comment}\n${allPosts[pos].comment_url}")
        .then((data) {});
  }

  @override
  void TwitterShare(pos) async {
    SocialShare.shareTwitter("${allPosts[pos].comment}",
            hashtags: ["voicee", "audio", "text", "replies"],
            url: "${allPosts[pos].comment_url}",
            trailingText: "")
        .then((data) {});
  }

  @override
  void WhatsAppShare(pos) async {
//    SocialShare.shareWhatsapp(
//            "${allPosts[pos].comment}\n${allPosts[pos].comment_url}")
//        .then((data) {});
    _bloc.showProgressLoader(true);
    var request =
        await HttpClient().getUrl(Uri.parse(allPosts[pos].comment_url));
    var response = await request.close();
    Uint8List bytes = await consolidateHttpClientResponseBytes(response);
    Share.file('${allPosts[pos].comment}', 'voicee_${allPosts[pos].id}.wav',
            bytes, 'audio/wav')
        .then((value) {
      _bloc.showProgressLoader(false);
    });
  }
}
