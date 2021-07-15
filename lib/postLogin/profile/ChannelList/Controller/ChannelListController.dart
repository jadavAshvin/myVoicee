import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:my_voicee/network/ApiUrls.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_voicee/CallBacks/DashBaordListCallBack.dart';
import 'package:my_voicee/CallBacks/ShareCallBack.dart';
import 'package:my_voicee/models/UserChannelListModel.dart';
import 'package:get/get_connect/http/src/exceptions/exceptions.dart';
import 'dart:convert';
import 'package:my_voicee/models/channelListModel.dart';
import 'package:my_voicee/postLogin/master_screen/dashboard/Bloc/DasboardBloc.dart';

class ChannelListController extends GetxController with DashboardCallBack, ShareCallBack {
  // StreamController<bool> _progressLoaderController = BehaviorSubject<bool>();
  File userImageFile;
  String imagePath;
  BuildContext menuScreenContext;
  var scaffoldKey = GlobalKey<ScaffoldState>();
  AudioPlayer player = AudioPlayer();
  ChannelUser userDataBean;
  DashboardCallBack itemCallBacks;
  List<ChannelPost> allPosts = [];
  ShareCallBack _shareCallBack;
  ScrollController scrollController = ScrollController();
  var page = 0;
  var isLoading = true.obs;
  DashboardBloc _bloc;
  Duration _duration = Duration(milliseconds: 0);

  // Stream<bool> get progressLoaderStream => _progressLoaderController.stream;
  // @override
  // void dispose() {
  //   super.dispose();
  //   _progressLoaderController.close();
  // }

  // void showProgressLoader(bool show) {
  //   if (!_progressLoaderController.isClosed) {
  //     _progressLoaderController.sink.add(show);
  //   }
  // }

  void getUserProfile(context, userID) async {
    // showProgressLoader(true);
    isLoading(true);
    var user = await _onGetUserChanneldetail(context, userID);
    print("User $user");
    if (user != null) {
      userDataBean = user.response;
      imagePath = user.response.img;
    }
    var posts = await _onGetChannelPostList(context, userID);
    if (posts != null) {
      allPosts = posts.response;
    }
    print("UserDataBean $userDataBean");
    isLoading(false);
    // var posts = await _onGetChannelPostList(context, userID);
    // allPosts = posts;
    // showProgressLoader(false);
  }

  Future<UserChannelListModel> _onGetUserChanneldetail(BuildContext context, String id) async {
    var url = '$channelDetail$id';
    var response = await getRequest(url);
    var user = userChannelListModelFromJson(jsonEncode(response.body));

    print("User from api: $user");

    return user;
  }

  Future<ChannelListModel> _onGetChannelPostList(BuildContext context, String id) async {
    var url = '$channelPosts$id';
    var response = await getRequest(url);
    var user = channelListModelFromJson(jsonEncode(response.body));

    print("List From Api: $user");

    return user;
  }

  // Future<ChannelListModel> _onGetChannelPostList(BuildContext context, String id) async {
  //   var url = '$channelPosts$id';
  //   try {
  //     await getRequest(url)
  //         .then((response) {
  //           if (response != null) {
  //             if (response.statusCode == 200) {
  //               var user = channelListModelFromJson(jsonEncode(response.body));
  //               return user;
  //             } else {
  //               return null;
  //             }
  //           }
  //         })
  //         .timeout(Duration(seconds: 100))
  //         .catchError((error) {
  //           return null;
  //         });
  //   } catch (error) {
  //     return null;
  //   }
  // }

  Future<Response> getRequest(String url) async {
    GetHttpClient httpClient = GetHttpClient();
    Response response;
    try {
      response = await httpClient.get(Uri.encodeFull(baseUrl + url), headers: {});
      print("Request: ${response.request.url} ");
      print("Response: ${response.body}");
    } on GetHttpException catch (e) {
      print(e.message);
      throw (e.message);
    } finally {
      httpClient.close();
    }
    return response;
  }

  @override
  void FacebookShare(int pos) {
    // TODO: implement FacebookShare
  }

  @override
  void LinkedinShare(int pos) {
    // TODO: implement LinkedinShare
  }

  @override
  void TwitterShare(int pos) {
    // TODO: implement TwitterShare
  }

  @override
  void WhatsAppShare(int pos) {
    // TODO: implement WhatsAppShare
  }

  @override
  void onClickItem(int pos) {
    // TODO: implement onClickItem
  }

  @override
  void onClickMenu(int pos) {
    // TODO: implement onClickMenu
  }

  @override
  void onDownVoteClick(int pos) {
    // TODO: implement onDownVoteClick
  }

  @override
  void onForwardClick(int pos) {
    // TODO: implement onForwardClick
  }

  @override
  void onPauseClick(int pos) {
    // TODO: implement onPauseClick
  }

  @override
  void onPlayClick(int pos) {
    // TODO: implement onPlayClick
  }

  @override
  void onReplyClick(int pos) {
    // TODO: implement onReplyClick
  }

  @override
  void onReverseClick(int pos) {
    // TODO: implement onReverseClick
  }

  @override
  void onShareClick(int pos) {
    // TODO: implement onShareClick
  }

  @override
  void onUpVoteClick(int pos) {
    // TODO: implement onUpVoteClick
  }

  // @override
  // void onClickItem(int pos) {}

  // @override
  // void onDownVoteClick(int pos) {
  //   if (pos != -1) {
  //     FATracker tracker = FATracker();
  //     tracker.track(FAEvents(eventName: POST_DISLIKE_EVENT, attrs: null));
  //     _bloc.callApiUpVoteDownVote(menuScreenContext, allPosts[pos].id, pos, "2");
  //   }
  // }

  // @override
  // void onForwardClick(int pos) {
  //   player.pause();
  //   var duration = _duration + Duration(seconds: 15);
  //   player.seek(duration);
  //   player.resume();
  // }

  // @override
  // void onPlayClick(int pos) async {
  //   if (pos != -1) {
  //     // data.clear();
  //     for (var k = 0; k < allPosts.length; k++) {
  //       if (allPosts[k].duration != null) {
  //         if (k == pos) {
  //           allPosts[k].is_play = true;
  //         } else {
  //           if (allPosts[k].duration.inSeconds > 0) {
  //             allPosts[k].duration = Duration(milliseconds: 0);
  //           }
  //           allPosts[k].is_play = false;
  //         }
  //       }
  //     }
  //     int position = pos;
  //     _bloc.showProgressLoader(true);
  //     int result;
  //     if (allPosts[pos].duration.inSeconds > 0) {
  //       _duration = allPosts[pos].duration;
  //       result = await player.play(allPosts[pos].audio, isLocal: false, stayAwake: true, respectSilence: false);
  //       if (result == 1) {
  //         player.pause();
  //         player.seek(_duration);
  //         player.resume();
  //       }
  //     } else {
  //       _duration = Duration(milliseconds: 0);
  //       await player.pause();
  //       await player.stop();
  //       await player.release();
  //       result = await player.play(allPosts[pos].audio, isLocal: false, stayAwake: true, respectSilence: false);
  //     }

  //     if (result == 1) {
  //       player.onAudioPositionChanged.listen((event) {
  //         _duration = event;
  //       });
  //       player.onPlayerCompletion.listen((events) {
  //         allPosts[position].is_play = false;
  //         _duration = Duration(milliseconds: 0);
  //         allPosts[position].duration = _duration;
  //       });
  //       _bloc.showProgressLoader(false);
  //     } else {
  //       _bloc.showProgressLoader(false);
  //     }
  //   }
  // }

  // @override
  // void onPauseClick(int pos) async {
  //   if (pos != -1) {
  //     allPosts[pos].is_play = false;
  //     allPosts[pos].duration = _duration;
  //     if (player != null) await player.pause();
  //   }
  // }

  // @override
  // void onReverseClick(int pos) {
  //   if (_duration.inSeconds > 0) {
  //     player.pause();
  //     var duration = _duration - Duration(seconds: 15);
  //     player.seek(duration);
  //     player.resume();
  //   }
  // }

  // @override
  // void onReplyClick(int pos) async {
  //   // // var result = await Navigator.push(
  //   // //   menuScreenContext,
  //   // //   MaterialPageRoute(builder: (context) => ReplyPageList(data: allPosts[pos])),
  //   // // );
  //   // if (result != null) {
  //   //   if (result) {
  //   //     if (mounted) Get.forceAppUpdate();
  //   //   }
  //   // }
  // }

  // @override
  // void onShareClick(int pos) {
  //   allPosts[pos].isShared = true;
  //   showModalBottomSheet(
  //       context: menuScreenContext,
  //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(30.0), topRight: Radius.circular(30.0))),
  //       builder: (BuildContext bc) {
  //         return Container(
  //           color: Colors.transparent,
  //           height: MediaQuery.of(menuScreenContext).size.height / 2.7,
  //           child: Container(
  //             color: Colors.transparent,
  //             child: BottomSheetShare(callBack: _shareCallBack, pos: pos),
  //           ),
  //         );
  //       });
  // }

  // @override
  // void onUpVoteClick(int pos) {
  //   if (pos != -1) {
  //     FATracker tracker = FATracker();
  //     tracker.track(FAEvents(eventName: POST_LIKE_EVENT, attrs: null));
  //     _bloc.callApiUpVoteDownVote(menuScreenContext, allPosts[pos].id, pos, "1");
  //   }
  // }

  // @override
  // void onClickMenu(int pos) {
  //   // showDialog(
  //   //   context: menuScreenContext,
  //   //   builder: (context) {
  //   //     return AlertDialog(
  //   //       titleTextStyle: TextStyle(fontFamily: "Roboto", fontSize: fit.t(14.5), color: Colors.black, fontWeight: FontWeight.normal),
  //   //       title: GestureDetector(
  //   //         onTap: () => onClickStats(pos),
  //   //         child: Text(
  //   //           "View Stats",
  //   //           textAlign: TextAlign.start,
  //   //         ),
  //   //       ),
  //   //       content: GestureDetector(
  //   //         onTap: () => onClickReport(pos),
  //   //         child: Text(
  //   //           "Report Post",
  //   //           style: TextStyle(fontFamily: "Roboto", fontSize: fit.t(14.0), color: Colors.black, fontWeight: FontWeight.normal),
  //   //           textAlign: TextAlign.start,
  //   //         ),
  //   //       ),
  //   //     );
  //   //   },
  //   // );
  // }

  // @override
  // void FacebookShare(pos) async {
  //   allPosts[pos].isShared = true;
  //   allPosts[pos].nShares += 1;
  //   if (mounted) Get.forceAppUpdate();
  //   SocialShare.shareOptions("${allPosts[pos].text}\n\n${allPosts[pos].audio}").then((data) {});
  //   _bloc.callApiSharePost(menuScreenContext, allPosts[pos].id);
  // }

  // @override
  // void LinkedinShare(pos) async {
  //   allPosts[pos].isShared = true;
  //   allPosts[pos].nShares += 1;
  //   if (mounted) Get.forceAppUpdate();
  //   SocialShare.shareOptions("${allPosts[pos].text}\n\n${allPosts[pos].audio}").then((data) {});
  //   _bloc.callApiSharePost(menuScreenContext, allPosts[pos].id);
  // }

  // @override
  // void TwitterShare(pos) async {
  //   allPosts[pos].isShared = true;
  //   allPosts[pos].nShares += 1;
  //   if (mounted) Get.forceAppUpdate();
  //   SocialShare.shareTwitter("${allPosts[pos].text}",
  //           hashtags: ["voicee", "audio", "text", "replies"], url: "${allPosts[pos].audio}", trailingText: "")
  //       .then((data) {});
  //   _bloc.callApiSharePost(menuScreenContext, allPosts[pos].id);
  // }

  // @override
  // void WhatsAppShare(pos) async {
  //   allPosts[pos].isShared = true;
  //   allPosts[pos].nShares += 1;
  //   if (mounted) Get.forceAppUpdate();
  //   _bloc.showProgressLoader(true);
  //   var request = await HttpClient().getUrl(Uri.parse(allPosts[pos].audio));
  //   var response = await request.close();
  //   Uint8List bytes = await consolidateHttpClientResponseBytes(response);
  //   Share.file('${allPosts[pos].text}', 'voicee_${allPosts[pos].id}.wav', bytes, 'audio/wav').then((value) {
  //     _bloc.showProgressLoader(false);
  //   });
  //   _bloc.callApiSharePost(menuScreenContext, allPosts[pos].id);
  // }
}
