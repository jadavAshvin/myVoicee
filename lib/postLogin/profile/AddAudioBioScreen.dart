import 'dart:async';
import 'dart:io' as io;

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_audio_recorder/flutter_audio_recorder.dart';
import 'package:fm_fit/fm_fit.dart';
import 'package:my_voicee/constants/app_colors.dart';
import 'package:my_voicee/constants/app_images_path.dart';
import 'package:my_voicee/customWidget/Alert/top_alert.dart';
import 'package:my_voicee/customWidget/BottomSheetWaitRecord.dart';
import 'package:my_voicee/customWidget/SocialMediaCustomButton.dart';
import 'package:my_voicee/customWidget/appLoader/custom_progress_loader.dart';
import 'package:my_voicee/models/GetAllPostsResponse.dart';
import 'package:my_voicee/models/UserResponse.dart';
import 'package:my_voicee/models/commonResponse/CommonpiResponse.dart';
import 'package:my_voicee/models/errorResponse/customeError.dart';
import 'package:my_voicee/models/errorResponse/error_reponse.dart';
import 'package:my_voicee/postLogin/profile/profileBloc/ProfileBloc.dart';
import 'package:my_voicee/utils/Utility.dart';
import 'package:my_voicee/utils/date_formatter.dart';
import 'package:path_provider/path_provider.dart';

class AddAudioBioScreen extends StatefulWidget {
  @override
  _AddAudioBioScreenState createState() => _AddAudioBioScreenState();
}

class _AddAudioBioScreenState extends State<AddAudioBioScreen> {
  FmFit fit = FmFit(width: 750);
  var _scaffoldKey = GlobalKey<ScaffoldState>();
  var _screenFocusNode = FocusNode();
  AudioPlayer player = AudioPlayer();
  FlutterAudioRecorder _recorder;
  Recording _recording;
  bool isPaused = false;
  bool isRecorded = false;
  Timer _t;
  bool isRecordingStarted = false;
  bool isShowRecordingText = false;
  bool isFileUploaded = false;
  String audioUrl = "";
  String customPath = "";
  bool isPlaying = false;
  ProfileBloc _bloc;
  StreamController apiResponseData;
  StreamController apiResponse;

  @override
  void initState() {
    super.initState();
    apiResponseData = StreamController<List<AllPostResponse>>.broadcast();
    apiResponse = StreamController();
    _bloc = ProfileBloc(apiResponseData, apiResponse);
    _subscribeToApiResponse();
    Future.microtask(() {
      _onWaitToRecord();
      _prepare();
    });
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
          Container(
            color: colorWhite,
            margin: EdgeInsets.symmetric(horizontal: fit.t(16.0)),
            child: Column(
              children: [
                SizedBox(
                  height: fit.t(30.0),
                ),
                Text(
                  _recording?.duration == null
                      ? "00:00 / 01:00"
                      : '${toHoursMinutes(_recording?.duration)} / 01:00',
                  style: TextStyle(
                      color: colorBlack,
                      fontSize: fit.t(18.0),
                      fontFamily: "Roboto",
                      fontWeight: FontWeight.w400),
                ),
                isShowRecordingText
                    ? Container(child: _recodingText())
                    : Container(),
                SizedBox(
                  height: fit.t(30.0),
                ),
                Stack(
                  children: [
                    Container(
                      child: Image.asset(waves_empty),
                      margin: EdgeInsets.symmetric(vertical: fit.t(24.0)),
                    ),
                    Center(
                      child: Image.asset(
                        ic_player_mic,
                        width: fit.t(80.0),
                        height: fit.t(80.0),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: fit.t(30.0),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    InkWell(
                      onTap: () {
                        if (!isPaused) {
                          isShowRecordingText = false;
                          _recorder.pause();
                          isPaused = true;
                        } else {
                          isShowRecordingText = true;
                          _recorder.resume();
                          isPaused = false;
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
                ),
                SizedBox(
                  height: fit.t(30.0),
                ),
                Container(
                  width: MediaQuery.of(context).size.width / 1.3,
                  child: SocialMediaCustomButton(
                      btnText: 'Add Bio',
                      buttonColor: colorAcceptBtn,
                      onPressed: _onClickUpdateBio,
                      size: fit.t(16.0),
                      splashColor: colorAcceptBtnSplash,
                      textColor: colorWhite),
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
        ],
      ),
    );
  }

  void uploadRecorderFile() {
    _bloc.showProgressLoader(true);
    var _duration = Duration(milliseconds: 300);
    Timer(_duration, _uploadRecorderFile);
  }

  Widget _titleWidget() {
    return Container(
      child: Padding(
        padding: EdgeInsets.only(
            top: fit.t(8.0), left: fit.t(8.0), right: fit.t(8.0)),
        child: Container(
          child: Text(
            'Add Audio Bio',
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

  Widget _leadingWidget() {
    return InkWell(
      onTap: () => showDialogForConfirmation(),
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

  void _onClickUpdateBio() {
    if (audioUrl.isNotEmpty) {
      Map<String, dynamic> requestData = Map();
      requestData.putIfAbsent("audio", () => audioUrl);
      _bloc.saveUpdateProfile(context, requestData);
    } else {
      TopAlert.showAlert(context, "Please record you bio.", true);
    }
  }

  _onWaitToRecord() {
    showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30.0),
                topRight: Radius.circular(30.0))),
        isDismissible: false,
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

  void _onRecordStart() {
    Navigator.of(context).pop();
    FocusScope.of(context).requestFocus(_screenFocusNode);
    _opt();
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

  @override
  void dispose() {
    player.release();
    apiResponse?.close();
    _bloc.dispose();
    if (_recording.status == RecordingStatus.Recording) _stopRecording();
    super.dispose();
  }

  void showDialogForConfirmation() {
    // set up the buttons
    Widget cancelButton = FlatButton(
      child: Text("No"),
      onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
    );
    Widget continueButton = FlatButton(
      child: Text("Yes"),
      onPressed: () {
        Navigator.of(context, rootNavigator: true).pop();
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

  void _subscribeToApiResponse() {
    StreamSubscription subscription;
    subscription = apiResponse.stream.listen((data) {
      if (data is UserResponse) {
        Navigator.of(context).pop(true);
      } else if (data is CommonApiReponse) {
        audioUrl = data.response;
        if (mounted) setState(() {});
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

  void _uploadRecorderFile() {
    _bloc.callApiUploadFile(context, customPath, 1);
  }
}
