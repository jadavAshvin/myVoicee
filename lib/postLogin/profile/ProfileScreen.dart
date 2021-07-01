import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:audioplayers/audioplayers.dart';
import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:fm_fit/fm_fit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_voicee/CallBacks/DashBaordListCallBack.dart';
import 'package:my_voicee/CallBacks/ShareCallBack.dart';
import 'package:my_voicee/constants/app_colors.dart';
import 'package:my_voicee/constants/app_constants.dart';
import 'package:my_voicee/constants/app_images_path.dart';
import 'package:my_voicee/customWidget/Alert/NoDataWidget.dart';
import 'package:my_voicee/customWidget/Alert/top_alert.dart';
import 'package:my_voicee/customWidget/BottomSheetShare.dart';
import 'package:my_voicee/customWidget/appLoader/custom_progress_loader.dart';
import 'package:my_voicee/customWidget/imageViewer/ImageViewer.dart';
import 'package:my_voicee/customWidget/super_tooltip.dart';
import 'package:my_voicee/models/GetAllPostsResponse.dart';
import 'package:my_voicee/models/UserResponse.dart';
import 'package:my_voicee/models/commonResponse/CommonpiResponse.dart';
import 'package:my_voicee/models/errorResponse/customeError.dart';
import 'package:my_voicee/models/errorResponse/error_reponse.dart';
import 'package:my_voicee/postLogin/master_screen/dashboard/DashboardListItem.dart';
import 'package:my_voicee/postLogin/postReply/ReplyList.dart';
import 'package:my_voicee/postLogin/profile/FollowersScreen.dart';
import 'package:my_voicee/postLogin/profile/FollowingsScreen.dart';
import 'package:my_voicee/postLogin/profile/PublisherScreen.dart';
import 'package:my_voicee/postLogin/profile/drawerItems/EditProfileScreen.dart';
import 'package:my_voicee/postLogin/profile/drawerItems/channel/CreateChannel.dart';
import 'package:my_voicee/postLogin/profile/profileBloc/ProfileBloc.dart';
import 'package:my_voicee/postLogin/reactions/ReActionsScreen.dart';
import 'package:my_voicee/utils/DialogUtils.dart';
import 'package:my_voicee/utils/Utility.dart';
import 'package:my_voicee/utils/date_formatter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:social_share/social_share.dart';

class ProfileScreen extends StatefulWidget {
  final BuildContext menuScreenContext;
  final Function(int index) controller;

  const ProfileScreen({Key key, this.menuScreenContext, this.controller})
      : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with
        DashboardCallBack,
        ShareCallBack,
        AutomaticKeepAliveClientMixin<ProfileScreen> {
  @override
  bool get wantKeepAlive => false;
  var _scaffoldKey = GlobalKey<ScaffoldState>();
  SuperTooltip tooltip;
  GlobalKey _becomePublisher = GlobalKey<_ProfileScreenState>();
  GlobalKey _detailPublisher = GlobalKey<_ProfileScreenState>();
  AudioPlayer player = AudioPlayer();
  FmFit fit = FmFit(width: 750);
  File userImageFile;
  String imagePath;
  UserData userDataBean;
  ProfileBloc _bloc;
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
  bool isPlaying = false;

  @override
  void initState() {
    _itemCallBacks = this;
    _shareCallBack = this;
    if (isShowTut)
      SchedulerBinding.instance.addPostFrameCallback((_) => showTooltip());
    apiResponseData = StreamController<List<AllPostResponse>>.broadcast();
    apiResponse = StreamController();
    _bloc = ProfileBloc(apiResponseData, apiResponse);
    _subscribeToApiResponse();
    _bloc.getUserProfile(context);
    getStringDataLocally(key: userData).then((value) {
      userDataBean = UserData.fromJson(jsonDecode(value));
      if (userDataBean.dp != null) {
        if (userDataBean.dp.isNotEmpty) {
          imagePath = userDataBean.dp;
          if (mounted) setState(() {});
        }
      }
    });
    _scrollController.addListener(() {
      if (_scrollController.position.maxScrollExtent ==
          _scrollController.position.pixels) {
        if (!isLoading) {
          isLoading = !isLoading;
          if (!lastPage)
            _bloc.callApiGetAllPosts(context, userDataBean.id, page);
        }
      }
    });
    player.onPlayerStateChanged.listen((event) {
      if (event == AudioPlayerState.PLAYING) {
      } else if (event == AudioPlayerState.PAUSED) {
      } else if (event == AudioPlayerState.STOPPED) {
      } else if (event == AudioPlayerState.COMPLETED) {
        player.release();
      }
    });
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
      // endDrawer: Drawer(child: _drawerChildren()),
      appBar: _appBarWidget(),
      body: Stack(children: <Widget>[
        Container(
          height: fit.t(MediaQuery.of(context).size.height),
          margin: EdgeInsets.only(
              top: fit.t(8.0), left: fit.t(8.0), right: fit.t(8.0)),
          child: Wrap(
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Wrap(
                    children: [
                      Stack(
                        children: [
                          Positioned(
                            key: _detailPublisher,
                            right: fit.t(15.0),
                            top: fit.t(0.0),
                            child: Container(
                              height: fit.t(30.0),
                              width: fit.t(60.0),
                              child: RaisedButton(
                                color: colorAcceptBtn,
                                textColor: colorWhite,
                                onPressed: () => onClickEditProfile(),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5.0)),
                                child: Text(
                                  'Edit',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: colorWhite,
                                    letterSpacing: 0.18,
                                    fontFamily: "Roboto",
                                    fontSize: fit.t(14.0),
                                  ),
                                ),
                                splashColor: colorAcceptBtnSplash,
                              ),
                            ),
                          ),
                          Wrap(
                            alignment: WrapAlignment.center,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              Column(
                                children: [
                                  Container(
                                    height: fit.t(60.0),
                                    width: fit.t(60.0),
                                    margin: EdgeInsets.only(
                                      top: fit.t(5.0),
                                    ),
                                    child: Stack(
                                      children: <Widget>[
                                        GestureDetector(
                                          onTap: () => onImageClick(),
                                          child: imagePath == null
                                              ? Container(
                                                  width: fit.t(60.0),
                                                  height: fit.t(60.0),
                                                  decoration: BoxDecoration(
                                                    color: appColor,
                                                    shape: BoxShape.circle,
                                                    image: DecorationImage(
                                                      fit: BoxFit.fill,
                                                      image: AssetImage(
                                                          ic_user_place_holder),
                                                    ),
                                                  ),
                                                )
                                              : imagePath.contains('http')
                                                  ? Container(
                                                      width: fit.t(60.0),
                                                      height: fit.t(60.0),
                                                      decoration: BoxDecoration(
                                                        color: appColor,
                                                        shape: BoxShape.circle,
                                                        image: DecorationImage(
                                                            fit: BoxFit.fill,
                                                            image: NetworkImage(
                                                                imagePath)),
                                                      ),
                                                    )
                                                  : Container(
                                                      width: fit.t(60.0),
                                                      height: fit.t(60.0),
                                                      decoration: BoxDecoration(
                                                          color: appColor,
                                                          shape:
                                                              BoxShape.circle),
                                                      child: ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(fit
                                                                    .t(60.0)),
                                                        child: Image.file(
                                                          userImageFile,
                                                          fit: BoxFit.fill,
                                                          width: fit.t(60.0),
                                                          height: fit.t(60.0),
                                                        ),
                                                      ),
                                                    ),
                                        ),
                                        Positioned(
                                          bottom: 0,
                                          right: 0,
                                          child: GestureDetector(
                                            onTap: () =>
                                                _optionsDialogBox(context),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                              ),
                                              child: Image.asset(
                                                ic_camera,
                                              ),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10.0,
                                  ),
                                  //name
                                  userDataBean?.is_publisher ?? false
                                      ? Row(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Container(
                                              padding: EdgeInsets.all(4.0),
                                              child: Text(
                                                '${userDataBean?.name ?? ""}',
                                                textAlign: TextAlign.center,
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                    fontFamily: 'Roboto',
                                                    fontSize: fit.t(20.0),
                                                    fontWeight: FontWeight.w500,
                                                    color: Color.fromRGBO(
                                                        0, 0, 0, 1)),
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
                                            '${userDataBean?.name ?? ""}',
                                            textAlign: TextAlign.center,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                                fontFamily: 'Roboto',
                                                fontSize: fit.t(20.0),
                                                fontWeight: FontWeight.w500,
                                                color:
                                                    Color.fromRGBO(0, 0, 0, 1)),
                                          ),
                                        ),
                                  //bio
                                  Container(
                                    child: Text(
                                      '${userDataBean?.bio ?? ""}',
                                      textAlign: TextAlign.center,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          fontFamily: 'Roboto',
                                          fontWeight: FontWeight.w400,
                                          fontSize: fit.t(14.0),
                                          color:
                                              Color.fromRGBO(119, 113, 113, 1)),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 15.0,
                                  ),
                                  (userDataBean?.is_publisher ?? false)
                                      ? _followerWidget()
                                      : _publisherButton(),
                                  SizedBox(
                                    height: 15.0,
                                  ),
                                  //column
                                  Column(
                                    children: <Widget>[
                                      Container(
                                        margin: EdgeInsets.only(
                                            left: fit.t(15.0),
                                            right: fit.t(15.0),
                                            bottom: fit.t(5.0)),
                                        child: Row(
                                          children: <Widget>[
                                            Image.asset(ic_work),
                                            SizedBox(
                                              width: 5.0,
                                            ),
                                            RichText(
                                              softWrap: true,
                                              textAlign: TextAlign.start,
                                              text: TextSpan(
                                                text:
                                                    "${userDataBean?.employment ?? ""}",
                                                style: TextStyle(
                                                    fontFamily: 'Roboto',
                                                    color: Color.fromRGBO(
                                                        119, 113, 113, 1),
                                                    fontSize: fit.t(12.0),
                                                    fontWeight:
                                                        FontWeight.normal),
                                                children: <TextSpan>[
                                                  TextSpan(
                                                    text:
                                                        " ${userDataBean?.start_year != null ? getDateTimeStamp2(userDataBean?.start_year) : ""} - ${userDataBean?.is_working != null ? userDataBean.is_working ? " Present" : userDataBean?.end_year != null ? getDateTimeStamp2(userDataBean?.end_year) : "" : userDataBean?.end_year != null ? getDateTimeStamp2(userDataBean?.end_year) : ""}",
                                                    style: TextStyle(
                                                        fontFamily: 'Roboto',
                                                        color: Color.fromRGBO(
                                                            178, 178, 178, 1),
                                                        fontSize: fit.t(12.0),
                                                        fontWeight:
                                                            FontWeight.normal),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(
                                            left: fit.t(15.0),
                                            right: fit.t(15.0),
                                            bottom: fit.t(5.0)),
                                        child: Row(
                                          children: <Widget>[
                                            Image.asset(ic_qualification),
                                            SizedBox(
                                              width: 5.0,
                                            ),
                                            Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  1.4,
                                              child: RichText(
                                                softWrap: true,
                                                textAlign: TextAlign.start,
                                                text: TextSpan(
                                                  text:
                                                      "${userDataBean?.degree_type ?? ""},  ${userDataBean?.school_university ?? ""}",
                                                  style: TextStyle(
                                                      fontFamily: 'Roboto',
                                                      color: Color.fromRGBO(
                                                          119, 113, 113, 1),
                                                      fontSize: fit.t(12.0),
                                                      fontWeight:
                                                          FontWeight.normal),
                                                  children: <TextSpan>[
                                                    TextSpan(
                                                      text:
                                                          " ${userDataBean?.graduation_year != null ? "\nGraduated ${userDataBean?.graduation_year != null ? getDateTimeStamp2(userDataBean?.graduation_year) : ""}" : ""}",
                                                      style: TextStyle(
                                                          fontFamily: 'Roboto',
                                                          color: Color.fromRGBO(
                                                              178, 178, 178, 1),
                                                          fontSize: fit.t(12.0),
                                                          fontWeight: FontWeight
                                                              .normal),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(
                                            left: fit.t(15.0),
                                            right: fit.t(15.0),
                                            bottom: fit.t(5.0)),
                                        child: Row(
                                          children: <Widget>[
                                            Image.asset(ic_work),
                                            SizedBox(
                                              width: 5.0,
                                            ),
                                            RichText(
                                              softWrap: true,
                                              textAlign: TextAlign.start,
                                              text: TextSpan(
                                                text:
                                                    "${userDataBean?.location ?? ""}",
                                                style: TextStyle(
                                                  fontFamily: 'Roboto',
                                                  color: Color.fromRGBO(
                                                      119, 113, 113, 1),
                                                  fontSize: fit.t(12.0),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: fit.t(10.0),
                              )
                            ],
                          )
                        ],
                      ),
                    ],
                  ),
                  Divider(
                    height: fit.t(2.0),
                    endIndent: fit.t(15.0),
                    indent: fit.t(15.0),
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height -
                        MediaQuery.of(context).size.height / 2,
                    child: _createListView(allPosts),
                  ),
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
                    txt: '\n',
                  )
                : DashBoardListItem(
                    fit: fit,
                    pos: index,
                    isTutShown: _isShown,
                    isShown: true,
                    from: "profile",
                    data: itemList[index],
                    callBack: _itemCallBacks);
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
        padding: EdgeInsets.only(
            top: fit.t(8.0), left: fit.t(8.0), right: fit.t(8.0)),
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
      onTap: () => Scaffold.of(context).openDrawer(),
      child: Container(
        decoration: BoxDecoration(shape: BoxShape.circle, color: appColor),
        height: fit.t(40.0),
        width: fit.t(40.0),
        margin: EdgeInsets.only(right: fit.t(16.0), top: fit.t(4.0)),
        child: Icon(
          Icons.home,
          size: fit.t(30.0),
          color: Colors.white,
        ),
      ),
    );
  }

  void _optionsDialogBox(context) {
    DialogUtils.showCustomDialog(context,
        fit: fit,
        okBtnText: "Camera",
        cancelBtnText: "Gallery",
        title: '',
        content: 'Please select camera or Gallery to capture image.',
        okBtnFunction: () {
      _captureImage(ImageSource.camera, context);
      Navigator.of(widget.menuScreenContext).pop();
    }, cancelBtnFunction: () {
      _captureImage(ImageSource.gallery, context);
      Navigator.of(widget.menuScreenContext).pop();
    });
  }

  void _captureImage(ImageSource source, context) async {
    File _imageFile = await ImagePicker.pickImage(source: source);
    if (_imageFile != null) {
      String name = new DateTime.now().millisecondsSinceEpoch.toString();
      Directory dir = await getApplicationDocumentsDirectory();
      var ext = _imageFile.path
          .toString()
          .substring(_imageFile.path.length - 3, _imageFile.path.length);
      if (ext == 'jpg') {
        ext = 'jpeg';
      }
      var targetPath = dir.absolute.path + "/$name.$ext";
      var imgFile = await _compressFileCaptured(_imageFile, targetPath, ext);

      this.userImageFile = imgFile;
      this.imagePath = _imageFile.path;
      _bloc.callApiUploadFile(context, _imageFile.path, 0);
    }
  }

  Future<File> _compressFileCaptured(
      File file, String targetPath, String ext) async {
    var result = await FlutterImageCompress.compressAndGetFile(
        file.absolute.path, targetPath,
        quality: 100,
        rotate: 0,
        format: ext == 'png' ? CompressFormat.png : CompressFormat.jpeg);
    return result;
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
    StreamSubscription subscription;
    subscription = apiResponse.stream.listen((data) {
      if (data is GetAllPostResponse) {
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
            if (allPosts.firstWhere((element) => element.id == null,
                    orElse: null) !=
                null) {
              allPosts
                  .remove(allPosts.firstWhere((element) => element.id == null));
              allPosts.add(AllPostResponse());
            }
          }
        }
        if (allPosts.length == 0) {
          allPosts.add(AllPostResponse());
        }
        if (mounted) setState(() {});
      } else if (data is UserResponse) {
        userDataBean = data.response;
        page = 0;
        _bloc.callApiGetAllPosts(context, userDataBean.id, page);
        if (mounted) setState(() {});
      } else if (data is CommonApiReponse) {
        if (data.response != null) {
          if (data.response is String) {
            if (data.response.toString().isNotEmpty) {
              imagePath = data.response;
              Map<String, dynamic> request = Map();
              request.putIfAbsent("dp", () => imagePath);
              _bloc.saveUpdateProfile(context, request);
              page = 0;
            }
            if (mounted) setState(() {});
          }
        }
        if (data.show_msg == 1)
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
  void FacebookShare(pos) async {
    allPosts[pos].is_shared = true;
    allPosts[pos].n_shares += 1;
    if (mounted) setState(() {});
    SocialShare.shareOptions("${allPosts[pos].text}\n\n${allPosts[pos].audio}")
        .then((data) {});
    _bloc.callApiSharePost(context, allPosts[pos].id);
  }

  @override
  void LinkedinShare(pos) async {
    allPosts[pos].is_shared = true;
    allPosts[pos].n_shares += 1;
    if (mounted) setState(() {});
    SocialShare.shareOptions("${allPosts[pos].text}\n${allPosts[pos].audio}")
        .then((data) {});
    _bloc.callApiSharePost(context, allPosts[pos].id);
  }

  @override
  void TwitterShare(pos) async {
    allPosts[pos].is_shared = true;
    allPosts[pos].n_shares += 1;
    if (mounted) setState(() {});
    SocialShare.shareTwitter("${allPosts[pos].text}",
            hashtags: ["voicee", "audio", "text", "replies"],
            url: "${allPosts[pos].audio}",
            trailingText: "")
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
    Share.file('${allPosts[pos].text}', 'voicee_${allPosts[pos].id}.wav', bytes,
            'audio/wav')
        .then((value) {
      _bloc.showProgressLoader(false);
    });
    _bloc.callApiSharePost(context, allPosts[pos].id);
  }

  @override
  void onClickItem(int pos) {
    // if (pos != -1)
    //   Navigator.push(
    //     context,
    //     MaterialPageRoute(
    //         builder: (context) => PostReplyPage(data: allPosts[pos].id)),
    //   );
  }

  @override
  void onClickMenu(int pos) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => ReActionsScreen(data: allPosts[pos])),
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
        MaterialPageRoute(
            builder: (context) => ReplyPageList(data: allPosts[pos])),
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
        result = await player.play(allPosts[pos].audio,
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
        result = await player.play(allPosts[pos].audio,
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

  void onClickEditProfile() async {
    final result = await pushNewScreen(context,
        screen: EditProfileScreen(data: userDataBean), withNavBar: false);
    if (result != null) {
      if (result) {
        _bloc.getUserProfile(context);
      }
    }
  }

  Widget _publisherButton() {
    return Container(
      margin: EdgeInsets.only(
        left: MediaQuery.of(context).size.width / 4,
        right: MediaQuery.of(context).size.width / 4,
        top: fit.t(10.0),
        bottom: fit.t(10.0),
      ),
      child: Center(
        child: RaisedButton(
          key: _becomePublisher,
          color: colorAcceptBtn,
          textColor: colorWhite,
          onPressed: () => _onBecomeAPublisher(),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
          child: Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  badge,
                  color: Colors.white,
                  width: fit.t(20.0),
                  height: fit.t(20.0),
                ),
                SizedBox(
                  width: fit.t(10.0),
                ),
                Text(
                  'Be a publisher',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    color: colorWhite,
                    letterSpacing: 0.18,
                    fontFamily: "Roboto",
                    fontSize: fit.t(14.0),
                  ),
                ),
              ],
            ),
          ),
          splashColor: colorAcceptBtnSplash,
        ),
      ),
    );
  }

  void _onBecomeAPublisher() {
    showDialogAcceptTerms(context, onClick: (bool item) {
      Navigator.of(context).pop();
      _clickOnAccept(item);
    });
  }

  Widget _drawerChildren() {
    return Stack(
      children: [
        ListView(
          children: [
            SizedBox(
              height: fit.t(20.0),
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  margin: EdgeInsets.only(left: fit.t(10.0)),
                  child: Text(
                    userDataBean?.name ?? "",
                    style: TextStyle(
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w600,
                        fontSize: fit.t(22.0),
                        color: colorBlack),
                  ),
                ),
                GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: Container(
                    child: Icon(Icons.close, color: appColor),
                    margin: EdgeInsets.only(right: fit.t(10.0)),
                  ),
                )
              ],
            ),
            SizedBox(
              height: fit.t(10.0),
            ),
            Divider(),
            userDataBean?.is_publisher ?? false
                ? GestureDetector(
                    onTap: () => _onClickCreateChannel(),
                    child: Container(
                      height: fit.t(40.0),
                      margin: EdgeInsets.only(left: fit.t(10.0)),
                      child: Row(
                        children: [
                          Image.asset(
                            channel,
                            width: fit.t(30.0),
                            height: fit.t(30.0),
                          ),
                          SizedBox(
                            width: fit.t(10.0),
                          ),
                          Text(
                            "Create/Edit Channel",
                            style: itemStyle(),
                          ),
                        ],
                      ),
                    ),
                  )
                : Container(),
            userDataBean?.is_publisher ?? false ? Divider() : Container(),
            GestureDetector(
              onTap: () => _onClickAccount(),
              child: Container(
                height: fit.t(40.0),
                margin: EdgeInsets.only(left: fit.t(10.0)),
                child: Row(
                  children: [
                    Image.asset(
                      account,
                      width: fit.t(30.0),
                      height: fit.t(30.0),
                    ),
                    SizedBox(
                      width: fit.t(10.0),
                    ),
                    Text(
                      "Account",
                      style: itemStyle(),
                    ),
                  ],
                ),
              ),
            ),
            Divider(),
            GestureDetector(
              onTap: () => _onClickDiscover(),
              child: Container(
                height: fit.t(40.0),
                margin: EdgeInsets.only(left: fit.t(10.0)),
                child: Row(
                  children: [
                    Image.asset(
                      discover_people,
                      width: fit.t(30.0),
                      height: fit.t(30.0),
                    ),
                    SizedBox(
                      width: fit.t(10.0),
                    ),
                    Text(
                      "Discover People",
                      style: itemStyle(),
                    ),
                  ],
                ),
              ),
            ),
            Divider(),
            GestureDetector(
              onTap: () => _onClickNotifications(),
              child: Container(
                height: fit.t(40.0),
                margin: EdgeInsets.only(left: fit.t(10.0)),
                child: Row(
                  children: [
                    Image.asset(
                      notifications_menu,
                      width: fit.t(30.0),
                      height: fit.t(30.0),
                    ),
                    SizedBox(
                      width: fit.t(10.0),
                    ),
                    Text(
                      "Notifications",
                      style: itemStyle(),
                    ),
                  ],
                ),
              ),
            ),
            Divider(),
            GestureDetector(
              onTap: () => _onClickPrivacy(),
              child: Container(
                height: fit.t(40.0),
                margin: EdgeInsets.only(left: fit.t(10.0)),
                child: Row(
                  children: [
                    Image.asset(
                      privacy,
                      width: fit.t(30.0),
                      height: fit.t(30.0),
                    ),
                    SizedBox(
                      width: fit.t(10.0),
                    ),
                    Text(
                      "Privacy",
                      style: itemStyle(),
                    ),
                  ],
                ),
              ),
            ),
            Divider(),
            GestureDetector(
              onTap: () => _onClickSecurity(),
              child: Container(
                height: fit.t(40.0),
                margin: EdgeInsets.only(left: fit.t(10.0)),
                child: Row(
                  children: [
                    Image.asset(
                      security,
                      width: fit.t(30.0),
                      height: fit.t(30.0),
                    ),
                    SizedBox(
                      width: fit.t(10.0),
                    ),
                    Text(
                      "Security",
                      style: itemStyle(),
                    ),
                  ],
                ),
              ),
            ),
            Divider(),
            GestureDetector(
              onTap: () => _onClickHelp(),
              child: Container(
                height: fit.t(40.0),
                margin: EdgeInsets.only(left: fit.t(10.0)),
                child: Row(
                  children: [
                    Image.asset(
                      help,
                      width: fit.t(30.0),
                      height: fit.t(30.0),
                    ),
                    SizedBox(
                      width: fit.t(10.0),
                    ),
                    Text(
                      "Help",
                      style: itemStyle(),
                    ),
                  ],
                ),
              ),
            ),
            Divider(),
            GestureDetector(
              onTap: () => _onClickDeactiviate(),
              child: Container(
                height: fit.t(40.0),
                margin: EdgeInsets.only(left: fit.t(10.0)),
                child: Row(
                  children: [
                    Image.asset(
                      delete_account,
                      width: fit.t(30.0),
                      height: fit.t(30.0),
                    ),
                    SizedBox(
                      width: fit.t(10.0),
                    ),
                    Text(
                      "Deactivate or Delete Account",
                      style: itemStyle(),
                    ),
                  ],
                ),
              ),
            ),
            Divider(),
          ],
        ),
        Positioned(
          bottom: fit.t(80.0),
          left: fit.t(10.0),
          child: GestureDetector(
            onTap: () => logoutDialog(),
            child: Container(
              height: fit.t(40.0),
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.only(left: fit.t(10.0)),
              child: Row(
                children: [
                  Image.asset(logout),
                  SizedBox(
                    width: fit.t(10.0),
                  ),
                  Text("Logout"),
                ],
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget _appBarWidget() {
    return AppBar(
      backgroundColor: colorWhite,
      elevation: 0,
      leading: _leadingWidget(),
      centerTitle: true,
      title: _titleWidget(),
      actions: <Widget>[
        (userDataBean?.is_publisher ?? false)
            ? Builder(
                builder: (context) => IconButton(
                  icon: Image.asset(
                    channel,
                    width: fit.t(35.0),
                    height: fit.t(35.0),
                  ),
                  onPressed: () => pushNewScreen(context,
                      screen: CreateChannel(), withNavBar: false),
                ),
              )
            : Container(),
      ],
    );
  }

  void logoutDialog() {
    Navigator.pop(context);
    DialogUtils.showCustomDialog(context,
        fit: fit,
        okBtnText: 'Yes',
        cancelBtnText: "No",
        title: '',
        content: "Are you sure you want to logout?",
        okBtnFunction: _onLogout);
  }

  void _onLogout() {
    clearDataLocally();
    Navigator.of(context, rootNavigator: true).pop();
    Navigator.pushNamedAndRemoveUntil(
        widget.menuScreenContext, '/login', ModalRoute.withName('/'));
  }

  _stopPlaying() {
    isPlaying = false;
    player.stop();
    if (mounted) setState(() {});
  }

  void _play() async {
    if (userDataBean?.audio != null) {
      if (userDataBean.audio.isNotEmpty) {
        isPlaying = true;
        if (mounted) setState(() {});
        await player.play(userDataBean?.audio,
            isLocal: false, stayAwake: true, respectSilence: false);
        player.onPlayerCompletion.listen((events) {
          isPlaying = false;
          if (mounted) setState(() {});
        });
      }
    }
  }

  Widget _followerWidget() {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.symmetric(horizontal: fit.t(10.0)),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              InkWell(
                onTap: () => isPlaying ? _stopPlaying() : _play(),
                child: Image.asset(
                  isPlaying ? ic_stop_recording : ic_play,
                  height: isPlaying ? fit.t(40.0) : fit.t(40.0),
                  scale: 1,
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width / 1.4,
                child: Image.asset(
                  waves_empty,
                ),
                margin: EdgeInsets.symmetric(horizontal: fit.t(10.0)),
              )
            ],
          ),
        ),
        SizedBox(
          height: fit.t(10.0),
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () => _onTapFollowers(),
              child: Column(
                children: [
                  Text(
                    '${userDataBean?.followers ?? 0}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: colorBlack,
                      letterSpacing: 0.18,
                      fontFamily: "Roboto",
                      fontSize: fit.t(18.0),
                    ),
                  ),
                  Text(
                    'Followers',
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      color: colorGrey2,
                      fontFamily: "Roboto",
                      fontSize: fit.t(16.0),
                    ),
                  )
                ],
              ),
            ),
            Container(
              height: fit.t(30.0),
              width: fit.t(1.0),
              color: colorGrey2,
              margin: EdgeInsets.only(
                left: fit.t(10.0),
                right: fit.t(10.0),
              ),
            ),
            GestureDetector(
              onTap: () => _onTapFollowing(),
              child: Column(
                children: [
                  Text(
                    '${userDataBean?.followings ?? 0}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: colorBlack,
                      letterSpacing: 0.18,
                      fontFamily: "Roboto",
                      fontSize: fit.t(18.0),
                    ),
                  ),
                  Text(
                    'Following',
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      color: colorGrey2,
                      fontFamily: "Roboto",
                      fontSize: fit.t(16.0),
                    ),
                  )
                ],
              ),
            ),
          ],
        )
      ],
    );
  }

  void _onTapFollowing() {
    if (userDataBean.followings > 0) {
      pushNewScreen(context, screen: FollowingsScreen(), withNavBar: false);
    }
  }

  void _onTapFollowers() {
    if (userDataBean.followers > 0) {
      pushNewScreen(context, screen: FollowersScreen(), withNavBar: false);
    }
  }

  TextStyle itemStyle() {
    return TextStyle(
      fontWeight: FontWeight.w400,
      fontFamily: "Roboto",
      fontSize: fit.t(14.0),
    );
  }

  void _onClickCreateChannel() {
    Navigator.of(context).pop();
    pushNewScreen(context, screen: CreateChannel(), withNavBar: false);
  }

  void _onClickAccount() {
    Navigator.of(context).pop();
  }

  void _onClickDiscover() {
    Navigator.of(context).pop();
  }

  void _onClickNotifications() {
    Navigator.of(context).pop();
  }

  void _onClickPrivacy() {
    Navigator.of(context).pop();
  }

  void _onClickSecurity() {
    Navigator.of(context).pop();
  }

  void _onClickHelp() {
    Navigator.of(context).pop();
  }

  void _onClickDeactiviate() {
    Navigator.of(context).pop();
  }

  void showTooltip() {
    if (tooltip?.isOpen ?? false) {
      tooltip?.close();
    }
    // We create the tooltip on the first use
    tooltip = SuperTooltip(
      popupDirection: TooltipDirection.down,
      backgroundColor: Colors.amberAccent,
      myOffset: Offset(20, 40),
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
                "Add as much detail you can",
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
                        tooltip.close();
                        isShowTut = false;
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
                        !(userDataBean?.is_publisher ?? false)
                            ? showToolTipBecomePublisher()
                            : null;
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
    tooltip.show(_detailPublisher.currentContext);
  }

  void showToolTipBecomePublisher() {
    if (tooltip?.isOpen ?? false) {
      tooltip?.close();
    }
    // We create the tooltip on the first use
    tooltip = SuperTooltip(
      popupDirection: TooltipDirection.down,
      backgroundColor: Colors.amberAccent,
      myOffset: Offset(20, 40),
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
                "Click on 'be a publisher' button.",
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
    tooltip.show(_becomePublisher.currentContext);
  }

  _clickOnAccept(bool item) async {
    var result = await pushNewScreen(context,
        screen: PublisherScreen(data: userDataBean), withNavBar: false);
    if (result != null) {
      if (result) {
        _bloc.getUserProfile(context);
      }
    }
  }
}
