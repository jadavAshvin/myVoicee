import 'dart:async';
import 'dart:io' as io;

import 'package:audioplayers/audioplayers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_audio_recorder/flutter_audio_recorder.dart';
import 'package:fm_fit/fm_fit.dart';
import 'package:geolocator/geolocator.dart';
import 'package:my_voicee/analytics/FAEvent.dart';
import 'package:my_voicee/analytics/FAEventName.dart';
import 'package:my_voicee/analytics/FATracker.dart';
import 'package:my_voicee/constants/app_colors.dart';
import 'package:my_voicee/constants/app_constants.dart';
import 'package:my_voicee/constants/app_images_path.dart';
import 'package:my_voicee/customWidget/Alert/top_alert.dart';
import 'package:my_voicee/customWidget/BottomSheetWaitRecord.dart';
import 'package:my_voicee/customWidget/SocialMediaCustomButton.dart';
import 'package:my_voicee/customWidget/Timeline.dart';
import 'package:my_voicee/customWidget/appLoader/custom_progress_loader.dart';
import 'package:my_voicee/models/AddCommentReponse.dart';
import 'package:my_voicee/models/AddPostResponse.dart';
import 'package:my_voicee/models/GetAllPostsResponse.dart';
import 'package:my_voicee/models/UserResponse.dart';
import 'package:my_voicee/models/commonResponse/CommonpiResponse.dart';
import 'package:my_voicee/models/errorResponse/customeError.dart';
import 'package:my_voicee/models/errorResponse/error_reponse.dart';
import 'package:my_voicee/postLogin/addPost/AddPostBloc/AddPostBloc.dart';
import 'package:my_voicee/postLogin/profile/ProfileScreen.dart';
import 'package:my_voicee/utils/Utility.dart';
import 'package:my_voicee/utils/date_formatter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shimmer/shimmer.dart';

class PostReplyPage extends StatefulWidget {
  final data;

  PostReplyPage({this.data});

  @override
  _PostReplyPageState createState() => _PostReplyPageState();
}

class _PostReplyPageState extends State<PostReplyPage>
    with TickerProviderStateMixin {
  List<AllPostResponse> allPosts = List();
  AudioPlayer player = AudioPlayer();
  var _screenFocusNode = FocusNode();
  var _textFocusNode = FocusNode();
  bool isPlay = false;
  bool isShowRecordingText = false;
  Duration _duration = Duration(milliseconds: 0);
  FlutterAudioRecorder _recorder;
  Recording _recording;
  Timer _t;
  bool isPaused = false;
  bool isRecordingStarted = false;
  bool isCalled = false;
  bool isFileUploaded = false;
  bool viewPost = false;
  var _scaffoldKey = GlobalKey<ScaffoldState>();
  FmFit fit = FmFit(width: 750);
  AnimationController controller;
  String userId;
  int page = 0;
  UserData userDataBean;
  Animation<double> animation;
  double animationValue;
  bool isPlaying = false;
  String customPath = "";
  AddPostBloc _bloc;
  StreamController _apiResponse;
  String audioUrl = "";
  Position _currentPosition;

  @override
  void initState() {
    _apiResponse = StreamController();
    _bloc = AddPostBloc(_apiResponse);
    _subscribeToApiResponse();
    Future.microtask(() {
      _prepare();
    });
    _bloc.getPost(context, widget.data);
    // if (_textController.text.toString().trim().length > 0) {
    //   animationValue = _calculateEndAnimation(0);
    // } else {
    //   animationValue = 0;
    // }
    _getCurrentLocation();
    controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 0));
    animation = Tween<double>(begin: 0, end: animationValue).animate(controller)
      ..addListener(() {});

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

  _getCurrentLocation() {
    _getCurrentLocations().then((position) {
      setState(() {
        if (position != null) {
          _currentPosition = position;
          writeStringDataLocally(
              key: latitude, value: _currentPosition.latitude.toString());
          writeStringDataLocally(
              key: longitude, value: _currentPosition.longitude.toString());
        }
      });
    }, onError: (map) {
      _bloc.showProgressLoader(false);
      // TopAlert.showAlert(context, "You must activate your geolocation.", true);
    }).catchError((e) {
      _bloc.showProgressLoader(false);
      // TopAlert.showAlert(context, "You must activate your geolocation.", true);
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
      return Future.error(
          'Location permissions are permantly denied, we cannot request permissions.');
    }

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse &&
          permission != LocationPermission.always) {
        return Future.error(
            'Location permissions are denied (actual value: $permission).');
      }
    }

    return await Geolocator.getCurrentPosition();
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
      backgroundColor: Color.fromRGBO(243, 243, 243, 1),
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
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          FocusScope.of(context).requestFocus(_screenFocusNode);
        },
        child: Stack(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(
                  top: fit.t(0.0), left: fit.t(16.0), right: fit.t(16.0)),
              child: Column(
                children: <Widget>[
                  !viewPost
                      ? isCalled
                          ? _widgetPostData()
                          : _shimmerContainer()
                      : _widgetViewPostData(),
                  SizedBox(height: fit.t(15.0)),
                  !isRecordingStarted
                      ? InkWell(
                          onTap: () => onClickSayIcon(),
                          child: Container(
                            height: fit.t(100.0),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.all(
                                Radius.circular(8.0),
                              ),
                            ),
                            child: Image.asset(
                              ic_say_now,
                              height: fit.t(40.0),
                              scale: 1,
                            ),
                            alignment: Alignment.center,
                          ),
                        )
                      : !isFileUploaded
                          ? _recordingStarted()
                          : _recordAgainWidget(),
                ],
              ),
            ),
            Positioned(
              bottom: 0,
              left: fit.t(16.0),
              right: fit.t(16.0),
              child: Container(
                margin: EdgeInsets.only(top: fit.t(16.0), bottom: fit.t(16.0)),
                child: SocialMediaCustomButton(
                  btnText: 'Reply',
                  buttonColor: colorAcceptBtn,
                  onPressed: _onClickPost,
                  size: 18.0,
                  splashColor: colorAcceptBtnSplash,
                  textColor: colorWhite,
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
        Navigator.of(context).pop(false);
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

  void onClickProfile() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ProfileScreen()),
    );
  }

  double _calculateEndAnimation(double data) {
    try {
      if (data == 0) {
        return 0;
      } else {
        return (data / int.parse("500")) * 100;
      }
    } catch (e) {
      return 0;
    }
  }

  @override
  void dispose() {
    super.dispose();
    player.release();
    _apiResponse?.close();
    _bloc.dispose();
    if (_recording.status == RecordingStatus.Recording) _stopRecording();
  }

  void _opt() async {
    switch (_recording.status) {
      case RecordingStatus.Initialized:
        {
          await _startRecording();
          break;
        }
      case RecordingStatus.Recording:
        {
          await _stopRecording();
          break;
        }
      case RecordingStatus.Stopped:
        {
          await _prepare();
          break;
        }

      default:
        break;
    }
  }

  Future _init() async {
    customPath = '/flutter_audio_files_';
    io.Directory appDocDirectory;
    if (io.Platform.isIOS) {
      appDocDirectory = await getApplicationDocumentsDirectory();
    } else {
      appDocDirectory = await getExternalStorageDirectory();
    }

    // can add extension like ".mp4" ".wav" ".m4a" ".aac"
    customPath = appDocDirectory.path +
        customPath +
        DateTime.now().millisecondsSinceEpoch.toString() +
        ".wav";

    _recorder = FlutterAudioRecorder(customPath,
        audioFormat: AudioFormat.WAV, sampleRate: 16000);
    await _recorder.initialized;
  }

  Future _prepare() async {
    var hasPermission = await FlutterAudioRecorder.hasPermissions;
    if (hasPermission) {
      await _init();
      var result = await _recorder.current();
      if (mounted)
        setState(() {
          _recording = result;
        });
    } else {
      if (mounted)
        setState(() {
          TopAlert.showAlert(context, "Permission Required.", true);
        });
    }
  }

  Future _startRecording() async {
    await _recorder.start();
    var current = await _recorder.current();
    if (mounted)
      setState(() {
        isRecordingStarted = true;
        isShowRecordingText = true;
        _recording = current;
        _recording.duration.inMinutes > 59 ?? _recorder.stop();
      });

    _t = Timer.periodic(Duration(seconds: 1), (Timer t) async {
      var current = await _recorder.current();
      if (mounted) {
        setState(() {
          _recording = current;
          _t = t;
        });
      } else {
        _t.cancel();
      }
    });
  }

  Future _stopRecording() async {
    var result = await _recorder.stop();
    _t.cancel();
    if (mounted)
      setState(() {
        _recording = result;
      });
  }

  void _play() {
    isPlaying = true;
    player.play(_recording.path, isLocal: true);
    player.onPlayerCompletion.listen((events) {
      isPlaying = false;
    });
  }

  void onClickSayIcon() {
    player.release();

    showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30.0),
                topRight: Radius.circular(30.0))),
        builder: (BuildContext bc) {
          return Container(
            color: Colors.transparent,
            height: MediaQuery.of(context).size.height / 2.1,
            child: Container(
              color: Colors.transparent,
              child: BottomSheetWaitRecord(callBack: _onRecordStart),
            ),
          );
        });
  }

  void _onClickPost() {
    if (audioUrl.isNotEmpty) {
      FATracker tracker = FATracker();
      tracker.track(FAEvents(eventName: POST_COMMENT_EVENT, attrs: null));
      _bloc.callApiReplyPost(context, "", audioUrl, widget.data,
          _recording.duration.inSeconds.toString());
      // if (_textController.text.toString().trim().length > 0) {
      //
      // } else {
      //   TopAlert.showAlert(context, 'Please write some on edit field.', true);
      // }
    } else {
      TopAlert.showAlert(context,
          'Please click on the microphone icon and start recording.', true);
    }
  }

  void _onRecordStart() {
    Navigator.of(context).pop();
    FocusScope.of(context).requestFocus(_screenFocusNode);
    _opt();
  }

  void uploadRecorderFile() {
    _bloc.callApiUploadFile(context, customPath, 1);
  }

  Widget _recordingStarted() {
    return Container(
      height: fit.t(100.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(
          Radius.circular(8.0),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          isShowRecordingText ? Container(child: _recodingText()) : Container(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              InkWell(
                onTap: () => !isPaused ? null : _play(),
                child: Image.asset(
                  !isPaused ? ic_player_mic : ic_play_big,
                  height: fit.t(70.0),
                  scale: 1,
                ),
              ),
              Text(
                '${toHoursMinutes(_recording?.duration)}',
                style: TextStyle(
                    color: colorBlack,
                    fontSize: 24.0,
                    fontFamily: "Roboto",
                    fontWeight: FontWeight.w500),
              ),
              Row(
                children: <Widget>[
                  InkWell(
                    onTap: () {
                      if (!isPaused) {
                        isShowRecordingText = false;
                        _recorder.pause();
                        _recorder.stop();
                        isPaused = true;
                      }
                    },
                    child: Image.asset(
                      !isPaused ? ic_pause_recording : ic_stop_recording,
                      height: fit.t(45.0),
                      scale: 1,
                    ),
                  ),
                  SizedBox(
                    width: 10.0,
                  ),
                  InkWell(
                    onTap: () {
                      isShowRecordingText = false;
                      if (!isPaused) {
                        _recorder?.pause();
                        _recorder?.stop();
                      }
                      uploadRecorderFile();
                    },
                    child: Image.asset(
                      ic_send_recording,
                      height: fit.t(45.0),
                      scale: 1,
                    ),
                  ),
                ],
              )
            ],
          ),
        ],
      ),
      alignment: Alignment.center,
    );
  }

  Widget _recordAgainWidget() {
    return Container(
      height: fit.t(140.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(
          Radius.circular(8.0),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              SizedBox(
                width: fit.t(20.0),
              ),
              InkWell(
                onTap: () => !isPlaying ? _play() : _pauseRecorder(),
                child: !isPlaying
                    ? Image.asset(
                        ic_play,
                        height: fit.t(40.0),
                        scale: 1,
                      )
                    : Image.asset(
                        ic_pause_recording,
                        height: fit.t(40.0),
                        scale: 1,
                      ),
              ),
              SizedBox(
                width: fit.t(10.0),
              ),
              Image.asset(
                waves_full,
                height: fit.t(40.0),
                width: MediaQuery.of(context).size.width / 1.5,
                scale: 1,
              ),
            ],
          ),
          SizedBox(
            height: fit.t(20.0),
          ),
          Row(
            children: <Widget>[
              SizedBox(
                width: fit.t(20.0),
              ),
              Container(
                height: fit.t(30.0),
                width: fit.t(120.0),
                child: RaisedButton(
                  color: colorAcceptBtn,
                  textColor: colorWhite,
                  onPressed: () async {
                    if (mounted) {
                      setState(() {
                        isFileUploaded = false;
                        isRecordingStarted = false;
                        isShowRecordingText = false;
                        isPaused = false;
                      });
                    }
                    _recorder?.stop();
                    await _prepare();
                  },
                  shape: new RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0)),
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'Record Again',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.w300,
                        fontFamily: "Roboto",
                        fontSize: 12.0,
                      ),
                    ),
                  ),
                  splashColor: colorAcceptBtnSplash,
                ),
              ),
              SizedBox(
                width: fit.t(10.0),
              ),
              Container(
                height: fit.t(30.0),
                width: fit.t(100.0),
                child: RaisedButton(
                  color: colorGrey2,
                  textColor: colorBlack,
                  onPressed: () => _onClickPost(),
                  shape: new RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0)),
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      ' Post   ',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontWeight: FontWeight.w300,
                          fontFamily: "Roboto",
                          fontSize: 12.0,
                          color: Colors.black.withOpacity(0.7)),
                    ),
                  ),
                  splashColor: Color.fromRGBO(119, 113, 113, 0.10),
                ),
              ),
            ],
          )
        ],
      ),
      alignment: Alignment.center,
    );
  }

  void _pauseRecorder() {
    player.pause();
    isPlaying = false;
  }

  void _subscribeToApiResponse() {
    _apiResponse.stream.listen((data) {
      if (data is CommonApiReponse) {
        audioUrl = data.response;
        isFileUploaded = true;
        viewPost = true;
        // _textController.text = data.audio_text;
        // animationValue = _calculateEndAnimation(double.parse(
        //     _textController.text.toString().trim().length.toString()));
        if (mounted) setState(() {});
      } else if (data is AddPostResponse) {
        Navigator.of(context).pop(true);
      } else if (data is AddComment) {
        Navigator.of(context).pop(true);
        TopAlert.showAlert(
            _scaffoldKey.currentState.context, data.message, false);
      } else if (data is GetAllPostResponse) {
        allPosts.clear();
        for (var i = 0; i < data.response.length; i++) {
          data.response[i].duration = Duration(seconds: 0);
          allPosts.add(data.response[i]);
        }
        if (mounted)
          setState(() {
            isCalled = true;
          });
      } else if (data is ErrorResponse) {
        TopAlert.showAlert(
            _scaffoldKey.currentState.context, data.message, true);
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

  Widget _widgetPostData() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(
          Radius.circular(8.0),
        ),
      ),
      child: Card(
        elevation: fit.t(0.0),
        child: Container(
          padding: EdgeInsets.only(bottom: fit.t(4.0)),
          decoration: ShapeDecoration(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)),
          ),
          child: Container(
            margin: EdgeInsets.only(
                top: fit.t(4.0),
                bottom: fit.t(4.0),
                left: fit.t(8.0),
                right: fit.t(8.0)),
            child: Timeline(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    allPosts[0]?.user?.dp == null ||
                            allPosts[0].user.dp.isEmpty ||
                            !allPosts[0].user.dp.contains("http")
                        ? Container(
                            width: fit.t(40.0),
                            height: fit.t(40.0),
                            decoration: BoxDecoration(
                              color: appColor,
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                fit: BoxFit.cover,
                                image: AssetImage(ic_place_holder),
                              ),
                            ),
                          )
                        : CachedNetworkImage(
                            imageUrl: '${allPosts[0].user.dp}',
                            imageBuilder: (context, imageProvider) => ClipRRect(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(80.0)),
                              child: Container(
                                height: fit.t(40.0),
                                width: fit.t(40.0),
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: imageProvider,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                            placeholder: (context, image) => Image.asset(
                              ic_place_holder,
                              height: fit.t(40.0),
                              width: fit.t(40.0),
                              fit: BoxFit.cover,
                            ),
                            errorWidget: (context, url, error) => Image.asset(
                              ic_place_holder,
                              height: fit.t(40.0),
                              width: fit.t(40.0),
                              fit: BoxFit.cover,
                            ),
                          ),
                    SizedBox(
                      width: fit.t(8.0),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width / 1.55,
                      child: Text(
                        '${allPosts[0].user.name}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontFamily: 'Roboto',
                            fontSize: fit.t(14.0),
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.18,
                            color: Color.fromRGBO(0, 0, 0, 1)),
                      ),
                    ),
                  ],
                ),
                Container(
                  margin: EdgeInsets.only(left: fit.t(45.0)),
                  child: Row(
                    children: <Widget>[
                      Flexible(
                        fit: FlexFit.tight,
                        child: Text(
                          '${allPosts[0].text}',
                          maxLines: 15,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontFamily: 'Roboto',
                              color: Color.fromRGBO(119, 113, 113, 1)),
                          textAlign: TextAlign.start,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: fit.t(45.0), top: fit.t(10.0)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      InkWell(
                        onTap: () => reverseAudio(),
                        child: Image.asset(
                          '$ic_reverse',
                          width: fit.t(30.0),
                          height: fit.t(30.0),
                        ),
                      ),
                      SizedBox(
                        width: 5.0,
                      ),
                      InkWell(
                        onTap: !isPlay
                            ? () {
                                isPlay = true;
                                onPlayClicked();
                                if (mounted) setState(() {});
                              }
                            : () {
                                isPlay = false;
                                onPauseClicked();
                                if (mounted) setState(() {});
                              },
                        child: Image.asset(
                          isPlay ? '$ic_pause_recording' : '$ic_play',
                          width: fit.t(40.0),
                          height: fit.t(40.0),
                        ),
                      ),
                      SizedBox(
                        width: 5.0,
                      ),
                      InkWell(
                        onTap: () => onForwardClick(),
                        child: Image.asset(
                          '$ic_forward',
                          width: fit.t(30.0),
                          height: fit.t(30.0),
                        ),
                      ),
                      SizedBox(
                        width: 5.0,
                      ),
                      Text(
                        '${allPosts[0].audio_duration ?? "0"}s',
                        style: TextStyle(
                            fontFamily: 'Roboto',
                            fontSize: fit.t(14.0),
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.18,
                            color: Color.fromRGBO(178, 178, 178, 1)),
                      )
                    ],
                  ),
                ),
                Row(
                  children: <Widget>[
                    userDataBean?.dp == null ||
                            !userDataBean?.dp.isEmpty ||
                            !userDataBean?.dp.contains("http")
                        ? Container(
                            width: fit.t(40.0),
                            height: fit.t(40.0),
                            decoration: BoxDecoration(
                              color: appColor,
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                fit: BoxFit.cover,
                                image: AssetImage(ic_place_holder),
                              ),
                            ),
                          )
                        : CachedNetworkImage(
                            imageUrl: '${userDataBean.dp}',
                            imageBuilder: (context, imageProvider) => ClipRRect(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(80.0)),
                              child: Container(
                                height: fit.t(40.0),
                                width: fit.t(40.0),
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: imageProvider,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                            placeholder: (context, image) => Image.asset(
                              ic_place_holder,
                              height: fit.t(40.0),
                              width: fit.t(40.0),
                              fit: BoxFit.cover,
                            ),
                            errorWidget: (context, url, error) => Image.asset(
                              ic_place_holder,
                              height: fit.t(40.0),
                              width: fit.t(40.0),
                              fit: BoxFit.cover,
                            ),
                          ),
                    SizedBox(
                      width: fit.t(8.0),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width / 1.55,
                      child: Text(
                        'Replying to @${allPosts[0].user.name}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontFamily: 'Roboto',
                            fontSize: fit.t(14.0),
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.18,
                            color: Color.fromRGBO(178, 178, 178, 1)),
                      ),
                    )
                  ],
                ),
              ],
              gutterSpacing: 0,
              indicatorColor: Color.fromRGBO(243, 243, 243, 1),
              indicatorSize: 0,
              lineGap: 0,
              lineColor: Color.fromRGBO(243, 243, 243, 1),
            ),
          ),
        ),
        shadowColor: Color.fromRGBO(243, 243, 243, 1),
        semanticContainer: true,
      ),
    );
  }

  void onForwardClick() {
    player.pause();
    var duration = _duration + Duration(seconds: 15);
    player.seek(duration);
    player.resume();
  }

  void onPlayClicked() async {
    _bloc.showProgressLoader(true);
    int result;
    if (allPosts[0].duration.inSeconds > 0) {
      _duration = allPosts[0].duration;
      result = await player.play(allPosts[0].audio,
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
      result = await player.play(allPosts[0].audio,
          isLocal: false, stayAwake: true, respectSilence: false);
    }

    if (result == 1) {
      player.onAudioPositionChanged.listen((event) {
        _duration = event;
      });
      player.onPlayerCompletion.listen((events) {
        if (mounted)
          setState(() {
            isPlay = false;
            _duration = Duration(milliseconds: 0);
            allPosts[0].duration = _duration;
          });
      });
      _bloc.showProgressLoader(false);
    } else {
      _bloc.showProgressLoader(false);
    }
  }

  void onPauseClicked() async {
    allPosts[0].duration = _duration;
    if (player != null) await player.pause();
  }

  void reverseAudio() {
    if (_duration.inSeconds > 0) {
      player.pause();
      var duration = _duration - Duration(seconds: 15);
      player.seek(duration);
      player.resume();
    }
  }

  Widget _widgetViewPostData() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(
          Radius.circular(8.0),
        ),
      ),
      child: Card(
        elevation: fit.t(0.0),
        child: Container(
          padding: EdgeInsets.only(bottom: fit.t(4.0)),
          decoration: ShapeDecoration(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)),
          ),
          child: Container(
            margin: EdgeInsets.only(
                top: fit.t(4.0),
                bottom: fit.t(4.0),
                left: fit.t(8.0),
                right: fit.t(8.0)),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    allPosts[0]?.user?.dp == null ||
                            allPosts[0]?.user?.dp.isEmpty ||
                            !allPosts[0].user.dp.contains("http")
                        ? Container(
                            width: fit.t(40.0),
                            height: fit.t(40.0),
                            decoration: BoxDecoration(
                              color: appColor,
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                fit: BoxFit.cover,
                                image: AssetImage(ic_place_holder),
                              ),
                            ),
                          )
                        : CachedNetworkImage(
                            imageUrl: '${allPosts[0].user.dp}',
                            imageBuilder: (context, imageProvider) => ClipRRect(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(80.0)),
                              child: Container(
                                height: fit.t(40.0),
                                width: fit.t(40.0),
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: imageProvider,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                            placeholder: (context, image) => Image.asset(
                              ic_place_holder,
                              height: fit.t(40.0),
                              width: fit.t(40.0),
                              fit: BoxFit.cover,
                            ),
                            errorWidget: (context, url, error) => Image.asset(
                              ic_place_holder,
                              height: fit.t(40.0),
                              width: fit.t(40.0),
                              fit: BoxFit.cover,
                            ),
                          ),
                    SizedBox(
                      width: fit.t(8.0),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width / 2.55,
                      child: Text(
                        'Replying to @${allPosts[0].user.name}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontFamily: 'Roboto',
                            fontSize: fit.t(12.0),
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.18,
                            color: Color.fromRGBO(178, 178, 178, 1)),
                      ),
                    )
                  ],
                ),
                Container(
                  height: fit.t(30.0),
                  width: fit.t(100.0),
                  child: RaisedButton(
                    color: colorAcceptBtn,
                    textColor: colorWhite,
                    onPressed: () {
                      setState(() {
                        viewPost = false;
                      });
                    },
                    shape: new RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0)),
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'View Post',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.w300,
                          fontFamily: "Roboto",
                          fontSize: 12.0,
                        ),
                      ),
                    ),
                    splashColor: colorAcceptBtnSplash,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _shimmerContainer() {
    return Container(
      height: fit.t(150.0),
      width: MediaQuery.of(context).size.width,
      child: Shimmer.fromColors(
        baseColor: Colors.grey[300],
        highlightColor: Colors.grey[100],
        enabled: true,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 48.0,
                  height: 48.0,
                  color: Colors.white,
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        width: double.infinity,
                        height: 8.0,
                        color: Colors.white,
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 2.0),
                      ),
                      Container(
                        width: double.infinity,
                        height: 8.0,
                        color: Colors.white,
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 2.0),
                      ),
                      Container(
                        width: 40.0,
                        height: 8.0,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
            ),
            Row(
              children: [
                Container(
                  width: 48.0,
                  height: 48.0,
                  color: Colors.white,
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        width: double.infinity,
                        height: 8.0,
                        color: Colors.white,
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 2.0),
                      ),
                      Container(
                        width: double.infinity,
                        height: 8.0,
                        color: Colors.white,
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 2.0),
                      ),
                      Container(
                        width: 40.0,
                        height: 8.0,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _recodingText() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(
          "assets/images/red_blink.gif",
          width: 20.0,
          height: 20.0,
        ),
        Text(
          'Recording now...',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: fit.t(14.0),
            color: appColor,
            fontFamily: 'Roboto',
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
