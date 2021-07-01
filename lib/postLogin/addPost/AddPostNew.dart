import 'dart:async';
import 'dart:convert';
import 'dart:io' as io;
import 'dart:io';
import 'dart:ui';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_audio_recorder/flutter_audio_recorder.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:fm_fit/fm_fit.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:my_voicee/analytics/FAEvent.dart';
import 'package:my_voicee/analytics/FAEventName.dart';
import 'package:my_voicee/analytics/FATracker.dart';
import 'package:my_voicee/constants/app_colors.dart';
import 'package:my_voicee/constants/app_constants.dart';
import 'package:my_voicee/constants/app_images_path.dart';
import 'package:my_voicee/customWidget/Alert/top_alert.dart';
import 'package:my_voicee/customWidget/SocialMediaCustomButton.dart';
import 'package:my_voicee/customWidget/appLoader/custom_progress_loader.dart';
import 'package:my_voicee/customWidget/circular_progress_widget/CircleProgress.dart';
import 'package:my_voicee/customWidget/super_tooltip.dart';
import 'package:my_voicee/models/AddPostResponse.dart';
import 'package:my_voicee/models/AllTopicsModel.dart';
import 'package:my_voicee/models/ChannelDataList.dart';
import 'package:my_voicee/models/UserResponse.dart';
import 'package:my_voicee/models/commonResponse/CommonpiResponse.dart';
import 'package:my_voicee/models/errorResponse/customeError.dart';
import 'package:my_voicee/models/errorResponse/error_reponse.dart';
import 'package:my_voicee/postLogin/addPost/AddPostBloc/AddPostBloc.dart';
import 'package:my_voicee/postLogin/addPost/styles.dart';
import 'package:my_voicee/utils/Utility.dart';
import 'package:my_voicee/utils/date_formatter.dart';

class AddPostNew extends StatefulWidget {
  final BuildContext menuScreenContext;
  final Function() controller;

  const AddPostNew({Key key, this.menuScreenContext, this.controller}) : super(key: key);

  @override
  _AddPostNewState createState() => _AddPostNewState();
}

class _AddPostNewState extends State<AddPostNew> with TickerProviderStateMixin {
  final Geolocator geoLocator = Geolocator();

  SuperTooltip tooltip;
  GlobalKey _cancelPostRecording = GlobalKey<_AddPostNewState>();
  GlobalKey _pausePost = GlobalKey<_AddPostNewState>();
  GlobalKey _finishPost = GlobalKey<_AddPostNewState>();
  GlobalKey _addTitlePost = GlobalKey<_AddPostNewState>();
  GlobalKey _addTagPost = GlobalKey<_AddPostNewState>();
  GlobalKey _chooseTopicPost = GlobalKey<_AddPostNewState>();
  GlobalKey _uploadPost = GlobalKey<_AddPostNewState>();
  GlobalKey _channelPost = GlobalKey<_AddPostNewState>();
  GlobalKey _asCampaignPost = GlobalKey<_AddPostNewState>();

  String _actionText = "Cancel";
  var _titleInputController = TextEditingController();
  var _hashInputController = TextEditingController();
  var _selectTopicInputController = TextEditingController();
  var _selectChannelInputController = TextEditingController();
  var _descInputController = TextEditingController();

  AudioPlayer player = AudioPlayer();

  var _screenFocusNode = FocusNode();
  var _titleFocusNode = FocusNode();
  var _hashTagFocusNode = FocusNode();
  var _topicFocusNode = FocusNode();
  var _channelFocusNode = FocusNode();
  var _descFocusNode = FocusNode();

  List<Topics> _choices = List();
  List<Channels> _allChannels = List();
  List<Channels> _selectedChannels = List();
  List<Topics> _filters = List();
  FlutterAudioRecorder _recorder;
  Recording _recording;
  Position _currentPosition;
  bool isPaused = false;
  bool isRecorded = false;
  Timer _t;
  bool isRecordingStarted = false;
  bool isShowRecordingText = false;
  bool isFileUploaded = false;
  var _scaffoldKey = GlobalKey<ScaffoldState>();
  FmFit fit = FmFit(width: 750);
  UserData userDataBean;
  bool isPlaying = false;
  String customPath = "";
  AddPostBloc _bloc;
  StreamController _apiResponse;
  String audioUrl = "";

  AnimationController controller;
  Animation<double> animation;
  double animationValue;

  AnimationController _descController;
  Animation<double> _descAnimation;
  double _descAnimationValue;

  var isSwitched = false;
  var isCampaign = false;

  File userImageFile;
  String imagePath;
  ScrollController _scrollController = new ScrollController();

  @override
  void initState() {
    getStringDataLocally(key: userData).then((value) {
      userDataBean = UserData.fromJson(jsonDecode(value));
      if (mounted)
        setState(() {
          if (userDataBean.is_publisher) {
            _bloc.getChannelsList(context);
          } else {
            _bloc.getAllTopics(context);
          }
        });
    });
    if (!isShowTut) {
      Future.microtask(() async {
        await _prepare();
        _onRecordStart();
      });
    } else {
      SchedulerBinding.instance.addPostFrameCallback((_) => showTooltip());
    }
    _apiResponse = StreamController();
    _bloc = AddPostBloc(_apiResponse);
    _subscribeToApiResponse();
    if (_descInputController.text.toString().trim().length > 0) {
      _descAnimationValue = _calculateEndAnimation(0, 300);
    } else {
      _descAnimationValue = 0;
    }
    if (_titleInputController.text.toString().trim().length > 0) {
      animationValue = _calculateEndAnimation(0, 140);
    } else {
      animationValue = 0;
    }
    controller = AnimationController(vsync: this, duration: Duration(milliseconds: 0));
    animation = Tween<double>(begin: 0, end: animationValue).animate(controller)..addListener(() {});
    _descController = AnimationController(vsync: this, duration: Duration(milliseconds: 0));
    _descAnimation = Tween<double>(begin: 0, end: _descAnimationValue).animate(_descController)..addListener(() {});

    _getCurrentLocation();
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
    return WillPopScope(
      onWillPop: () async {
        if (_recording != null) {
          if (_recording.status == RecordingStatus.Recording) {
            _recorder?.pause();
            _recorder?.stop();
          } else if (_recording.status == RecordingStatus.Paused) {
            _recorder?.stop();
          } else {
            _stopRecording();
          }
        }
        widget.controller();
        Navigator.of(context).pop(true);
        return false;
      },
      child: Scaffold(
        backgroundColor: colorWhite,
        key: _scaffoldKey,
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
        body: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            FocusScope.of(context).requestFocus(_screenFocusNode);
          },
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: fit.t(16.0)),
            child: Stack(
              children: [
                Container(
                  padding: EdgeInsets.only(bottom: fit.t(10.0)),
                  child: ListView(
                    controller: _scrollController,
                    children: <Widget>[
                      SizedBox(
                        height: fit.t(20.0),
                      ),
                      !isRecordingStarted
                          ? _recordingStarted()
                          : !isFileUploaded
                              ? _recordingStarted()
                              : _playRecordingWidget(),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: fit.t(20.0),
                          ),
                          Text(
                            "Add Title",
                            key: _addTitlePost,
                            style: TextStyle(color: colorBlack, fontSize: fit.t(16.0), fontFamily: 'Roboto', fontWeight: FontWeight.w500),
                          ),
                          SizedBox(
                            height: fit.t(10.0),
                          ),
                          Stack(
                            children: [
                              Container(
                                padding: EdgeInsets.only(right: fit.t(16.0)),
                                width: MediaQuery.of(context).size.width,
                                child: TextField(
                                  keyboardType: TextInputType.text,
                                  cursorColor: colorGrey,
                                  controller: _titleInputController,
                                  inputFormatters: [LengthLimitingTextInputFormatter(140)],
                                  keyboardAppearance: Brightness.light,
                                  style: TextStyle(
                                    color: Color(0xFF262628),
                                    fontFamily: "Roboto",
                                    fontSize: fit.t(12.0),
                                    fontWeight: FontWeight.w400,
                                  ),
                                  maxLines: 3,
                                  onChanged: (text) {
                                    if (text.toString().isNotEmpty) {
                                      animationValue = _calculateEndAnimation(double.parse(text.toString().length.toString()), 140);
                                    }
                                    if (mounted) setState(() {});
                                  },
                                  minLines: 2,
                                  textInputAction: TextInputAction.next,
                                  autocorrect: false,
                                  maxLengthEnforced: true,
                                  focusNode: _titleFocusNode,
                                  decoration: InputDecoration(
                                    floatingLabelBehavior: FloatingLabelBehavior.never,
                                    hintText: 'Tap here to start typing...',
                                    labelText: 'Tap here to start typing...',
                                    enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(Radius.circular(0.0)), borderSide: BorderSide(color: Colors.transparent)),
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(Radius.circular(0.0)), borderSide: BorderSide(color: Colors.transparent)),
                                    focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(Radius.circular(0.0)), borderSide: BorderSide(color: Colors.transparent)),
                                    contentPadding: EdgeInsets.symmetric(horizontal: fit.t(10.0)),
                                    hintStyle: TextStyle(
                                      color: colorGrey2,
                                      fontSize: fit.t(12.0),
                                      fontWeight: FontWeight.w400,
                                    ),
                                    labelStyle: TextStyle(
                                      color: colorGrey2,
                                      fontSize: fit.t(12.0),
                                      fontWeight: FontWeight.w400,
                                    ),
                                    alignLabelWithHint: true,
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: fit.t(0.0),
                                right: fit.t(0.0),
                                child: Container(
                                  height: fit.t(40.0),
                                  width: fit.t(40.0),
                                  child: AnimatedBuilder(
                                      animation: controller,
                                      builder: (context, child) {
                                        return CustomPaint(
                                          foregroundPainter: CircleProgress(
                                              animationValue, appColor, animation.value == 0.0 ? Color(0x20464649) : Color(0x64464649)),
                                          child: Container(
                                            height: fit.t(20.0),
                                            width: fit.t(20.0),
                                          ),
                                        );
                                      }),
                                ),
                              ),
                            ],
                          ),
                          Container(
                            height: fit.t(1.0),
                            color: Color(0xFFf0f0f0),
                          ),
                          SizedBox(
                            height: fit.t(20.0),
                          ),
                          Text(
                            "Add Hashtags",
                            key: _addTagPost,
                            style: TextStyle(color: colorBlack, fontSize: fit.t(14.0), fontFamily: 'Roboto', fontWeight: FontWeight.w500),
                          ),
                          SizedBox(
                            height: fit.t(10.0),
                          ),
                          Container(
                            padding: EdgeInsets.only(right: fit.t(16.0)),
                            width: MediaQuery.of(context).size.width,
                            child: TextField(
                              keyboardType: TextInputType.text,
                              cursorColor: colorGrey,
                              controller: _hashInputController,
                              keyboardAppearance: Brightness.light,
                              style: TextStyle(
                                color: Color(0xFF262628),
                                fontFamily: "Roboto",
                                fontSize: fit.t(12.0),
                                fontWeight: FontWeight.w400,
                              ),
                              onChanged: (text) {},
                              textInputAction: TextInputAction.next,
                              autocorrect: false,
                              focusNode: _hashTagFocusNode,
                              decoration: InputDecoration(
                                floatingLabelBehavior: FloatingLabelBehavior.never,
                                hintText: 'Tap here to start typing...',
                                labelText: 'Tap here to start typing...',
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(0.0)), borderSide: BorderSide(color: Colors.transparent)),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(0.0)), borderSide: BorderSide(color: Colors.transparent)),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(0.0)), borderSide: BorderSide(color: Colors.transparent)),
                                contentPadding: EdgeInsets.symmetric(horizontal: fit.t(10.0)),
                                hintStyle: TextStyle(
                                  color: colorGrey2,
                                  fontSize: fit.t(12.0),
                                  fontWeight: FontWeight.w400,
                                ),
                                labelStyle: TextStyle(
                                  color: colorGrey2,
                                  fontSize: fit.t(12.0),
                                  fontWeight: FontWeight.w400,
                                ),
                                alignLabelWithHint: true,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: fit.t(20.0),
                          ),
                          Container(
                            height: fit.t(2.0),
                            color: Color(0xFFf0f0f0),
                          ),
                          SizedBox(
                            height: fit.t(20.0),
                          ),
                          userDataBean?.is_publisher ?? false
                              ? Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      "Select channel",
                                      key: _channelPost,
                                      style: TextStyle(color: colorBlack, fontSize: fit.t(16.0), fontFamily: 'Roboto', fontWeight: FontWeight.w500),
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                        color: borderBackgroundColor,
                                        border: Border.all(
                                          color: borderBackgroundColor,
                                          width: 1,
                                        ),
                                        borderRadius: BorderRadius.circular(5.0),
                                      ),
                                      margin: EdgeInsets.only(top: fit.t(20.0)),
                                      child: TypeAheadField(
                                        textFieldConfiguration: TextFieldConfiguration(
                                          keyboardType: TextInputType.text,
                                          cursorColor: colorGrey,
                                          controller: _selectChannelInputController,
                                          keyboardAppearance: Brightness.light,
                                          style: Styles.inputHintStyle,
                                          textInputAction: TextInputAction.next,
                                          focusNode: _channelFocusNode,
                                          onEditingComplete: () => FocusScope.of(context).requestFocus(_screenFocusNode),
                                          decoration: InputDecoration(
                                            suffixIcon: Icon(
                                              Icons.search,
                                              color: appColor,
                                            ),
                                            contentPadding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
                                            hintStyle: TextStyle(
                                              color: Color(0xFF262628),
                                              fontSize: fit.t(14.0),
                                              fontWeight: FontWeight.w400,
                                            ),
                                            labelStyle: TextStyle(
                                              color: Color(0xFF262628),
                                              fontSize: fit.t(14.0),
                                              fontWeight: FontWeight.w400,
                                            ),
                                            alignLabelWithHint: true,
                                            fillColor: borderBackgroundColor,
                                            floatingLabelBehavior: FloatingLabelBehavior.never,
                                            hintText: 'Search...',
                                            labelText: 'Search...',
                                            enabledBorder: OutlineInputBorder(
                                                borderRadius: BorderRadius.all(Radius.circular(0.0)),
                                                borderSide: BorderSide(color: borderBackgroundColor)),
                                            border: OutlineInputBorder(
                                                borderRadius: BorderRadius.all(Radius.circular(0.0)),
                                                borderSide: BorderSide(color: borderBackgroundColor)),
                                            focusedBorder: OutlineInputBorder(
                                                borderRadius: BorderRadius.all(Radius.circular(0.0)),
                                                borderSide: BorderSide(color: borderBackgroundColor)),
                                          ),
                                        ),
                                        onSuggestionSelected: (suggestion) {
                                          for (var i = 0; i < _allChannels.length; i++) {
                                            if (_allChannels[i] != null) if (_allChannels[i].title.toLowerCase().contains(suggestion.toLowerCase())) {
                                              if (!_selectedChannels.contains(_allChannels[i])) _selectedChannels.add(_allChannels[i]);
                                            }
                                          }
                                        },
                                        transitionBuilder: (context, suggestionsBox, controller) {
                                          return suggestionsBox;
                                        },
                                        suggestionsCallback: (pattern) {
                                          List<String> data = List<String>();
                                          for (var i = 0; i < _allChannels.length; i++) {
                                            if (_allChannels[i] != null) if (_allChannels[i].title.toLowerCase().contains(pattern.toLowerCase())) {
                                              data.add(_allChannels[i].title);
                                            }
                                          }
                                          return data;
                                        },
                                        itemBuilder: (BuildContext context, suggestion) {
                                          return ListTile(
                                            title: Text(
                                              suggestion,
                                              textAlign: TextAlign.start,
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                    _selectedChannels.length > 0
                                        ? Wrap(
                                            children: channelSelectedList.toList(),
                                          )
                                        : Container(),
                                  ],
                                )
                              : Container(),
                          userDataBean?.is_publisher ?? false
                              ? SizedBox(
                                  height: fit.t(10.0),
                                )
                              : Container(),
                          userDataBean?.is_publisher ?? false
                              ? Container()
                              : Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      "Choose topics",
                                      key: _chooseTopicPost,
                                      style: TextStyle(color: colorBlack, fontSize: fit.t(16.0), fontFamily: 'Roboto', fontWeight: FontWeight.w500),
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                        color: borderBackgroundColor,
                                        border: Border.all(
                                          color: borderBackgroundColor,
                                          width: 1,
                                        ),
                                        borderRadius: BorderRadius.circular(5.0),
                                      ),
                                      margin: EdgeInsets.only(top: fit.t(20.0)),
                                      child: TypeAheadField(
                                        textFieldConfiguration: TextFieldConfiguration(
                                          keyboardType: TextInputType.text,
                                          cursorColor: colorGrey,
                                          controller: _selectTopicInputController,
                                          keyboardAppearance: Brightness.light,
                                          style: Styles.inputHintStyle,
                                          textInputAction: TextInputAction.next,
                                          focusNode: _topicFocusNode,
                                          onEditingComplete: () => FocusScope.of(context).requestFocus(_screenFocusNode),
                                          decoration: InputDecoration(
                                            suffixIcon: Icon(
                                              Icons.search,
                                              color: appColor,
                                            ),
                                            contentPadding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
                                            hintStyle: TextStyle(
                                              color: Color(0xFF262628),
                                              fontSize: fit.t(14.0),
                                              fontWeight: FontWeight.w400,
                                            ),
                                            labelStyle: TextStyle(
                                              color: Color(0xFF262628),
                                              fontSize: fit.t(14.0),
                                              fontWeight: FontWeight.w400,
                                            ),
                                            alignLabelWithHint: true,
                                            fillColor: borderBackgroundColor,
                                            floatingLabelBehavior: FloatingLabelBehavior.never,
                                            hintText: 'Add topic',
                                            labelText: 'Add topic',
                                            enabledBorder: OutlineInputBorder(
                                                borderRadius: BorderRadius.all(Radius.circular(0.0)),
                                                borderSide: BorderSide(color: borderBackgroundColor)),
                                            border: OutlineInputBorder(
                                                borderRadius: BorderRadius.all(Radius.circular(0.0)),
                                                borderSide: BorderSide(color: borderBackgroundColor)),
                                            focusedBorder: OutlineInputBorder(
                                                borderRadius: BorderRadius.all(Radius.circular(0.0)),
                                                borderSide: BorderSide(color: borderBackgroundColor)),
                                          ),
                                        ),
                                        onSuggestionSelected: (suggestion) {
                                          for (var i = 0; i < _choices.length; i++) {
                                            if (_choices[i] != null) if (_choices[i].title.toLowerCase().contains(suggestion.toLowerCase())) {
                                              if (!_filters.contains(_choices[i])) _filters.add(_choices[i]);
                                            }
                                          }
                                        },
                                        transitionBuilder: (context, suggestionsBox, controller) {
                                          return suggestionsBox;
                                        },
                                        suggestionsCallback: (pattern) {
                                          List<String> data = List<String>();
                                          for (var i = 0; i < _choices.length; i++) {
                                            if (_choices[i] != null) if (_choices[i].title.toLowerCase().contains(pattern.toLowerCase())) {
                                              data.add(_choices[i].title);
                                            }
                                          }
                                          return data;
                                        },
                                        itemBuilder: (BuildContext context, suggestion) {
                                          return ListTile(
                                            title: Text(
                                              suggestion,
                                              textAlign: TextAlign.start,
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                    _filters.length > 0
                                        ? Wrap(
                                            children: topicsPosition.toList(),
                                          )
                                        : Container(),
                                  ],
                                ),
                          userDataBean?.is_publisher ?? false
                              ? Container()
                              : SizedBox(
                                  height: fit.t(10.0),
                                ),
                          userDataBean?.is_publisher ?? false
                              ? Container(
                                  height: fit.t(2.0),
                                  color: Color(0xFFf0f0f0),
                                )
                              : Container(),
                          userDataBean?.is_publisher ?? false
                              ? SizedBox(
                                  height: fit.t(10.0),
                                )
                              : Container(),
                          userDataBean?.is_publisher ?? true
                              ? Row(
                                  children: [
                                    CupertinoSwitch(
                                      value: isSwitched,
                                      onChanged: (value) {
                                        setState(() {
                                          isSwitched = value;
                                          if (value) {
                                            isCampaign = true;
                                          } else {
                                            isCampaign = false;
                                          }
                                        });
                                      },
                                      trackColor: Color(0xFFF4F4F4),
                                      activeColor: Colors.green,
                                    ),
                                    Text(
                                      "Share it as campaign",
                                      key: _asCampaignPost,
                                      style: TextStyle(
                                        color: colorBlack.withOpacity(0.7),
                                        fontSize: fit.t(14.0),
                                        fontWeight: FontWeight.w400,
                                        fontFamily: 'Roboto',
                                      ),
                                    )
                                  ],
                                )
                              : Container(),
                          userDataBean?.is_publisher ?? false
                              ? SizedBox(
                                  height: fit.t(10.0),
                                )
                              : Container(),
                          userDataBean?.is_publisher ?? false
                              ? Container(
                                  height: fit.t(2.0),
                                  color: Color(0xFFf0f0f0),
                                )
                              : Container(),
                          userDataBean?.is_publisher ?? false
                              ? SizedBox(
                                  height: fit.t(10.0),
                                )
                              : Container(),
                          isCampaign
                              ? Stack(
                                  fit: StackFit.passthrough,
                                  children: [
                                    Container(
                                      padding: EdgeInsets.only(right: fit.t(16.0)),
                                      width: MediaQuery.of(context).size.width,
                                      child: TextField(
                                        keyboardType: TextInputType.text,
                                        cursorColor: colorGrey,
                                        controller: _descInputController,
                                        inputFormatters: [LengthLimitingTextInputFormatter(300)],
                                        keyboardAppearance: Brightness.light,
                                        style: TextStyle(
                                          color: Color(0xFF262628),
                                          fontFamily: "Roboto",
                                          fontSize: fit.t(12.0),
                                          fontWeight: FontWeight.w400,
                                        ),
                                        maxLines: 10,
                                        onChanged: (text) {
                                          if (text.toString().isNotEmpty) {
                                            _descAnimationValue = _calculateEndAnimation(double.parse(text.toString().length.toString()), 300);
                                          }
                                          if (mounted) setState(() {});
                                        },
                                        minLines: 7,
                                        textInputAction: TextInputAction.next,
                                        autocorrect: false,
                                        maxLengthEnforced: true,
                                        focusNode: _descFocusNode,
                                        decoration: InputDecoration(
                                          floatingLabelBehavior: FloatingLabelBehavior.never,
                                          hintText: 'Tap here to start typing...',
                                          labelText: 'Tap here to start typing...',
                                          enabledBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.all(Radius.circular(0.0)),
                                              borderSide: BorderSide(color: Colors.transparent)),
                                          border: OutlineInputBorder(
                                              borderRadius: BorderRadius.all(Radius.circular(0.0)),
                                              borderSide: BorderSide(color: Colors.transparent)),
                                          focusedBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.all(Radius.circular(0.0)),
                                              borderSide: BorderSide(color: Colors.transparent)),
                                          contentPadding: EdgeInsets.symmetric(horizontal: fit.t(10.0)),
                                          hintStyle: TextStyle(
                                            color: colorGrey2,
                                            fontSize: fit.t(12.0),
                                            fontWeight: FontWeight.w400,
                                          ),
                                          labelStyle: TextStyle(
                                            color: colorGrey2,
                                            fontSize: fit.t(12.0),
                                            fontWeight: FontWeight.w400,
                                          ),
                                          alignLabelWithHint: true,
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      bottom: fit.t(0.0),
                                      right: fit.t(0.0),
                                      child: Container(
                                        height: fit.t(40.0),
                                        width: fit.t(40.0),
                                        child: AnimatedBuilder(
                                            animation: _descController,
                                            builder: (context, child) {
                                              return CustomPaint(
                                                foregroundPainter: CircleProgress(_descAnimationValue, appColor,
                                                    _descAnimation.value == 0.0 ? Color(0x20464649) : Color(0x64464649)),
                                                child: Container(
                                                  height: fit.t(20.0),
                                                  width: fit.t(20.0),
                                                ),
                                              );
                                            }),
                                      ),
                                    ),
                                    Positioned(
                                      bottom: fit.t(14.0),
                                      right: fit.t(40.0),
                                      child: Center(
                                        child: Text(
                                          '${_descInputController.text.toString().trim().length} /300 ch',
                                          style: TextStyle(color: Colors.grey, fontFamily: "Roboto", fontSize: 16.0),
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              : Container(),
                          isCampaign ?? false
                              ? SizedBox(
                                  height: fit.t(10.0),
                                )
                              : Container(),
                          isCampaign ?? false
                              ? Container(
                                  height: fit.t(1.0),
                                  color: Color(0xFFf0f0f0),
                                )
                              : Container(),
                          userImageFile != null
                              ? SizedBox(
                                  height: fit.t(10.0),
                                )
                              : Container(),
                          userImageFile != null
                              ? Stack(
                                  children: [
                                    Container(
                                      width: MediaQuery.of(context).size.width,
                                      decoration: BoxDecoration(color: colorWhite, border: Border.all()),
                                      child: ClipRRect(
                                        child: Image.file(
                                          userImageFile,
                                          fit: BoxFit.fitWidth,
                                          width: MediaQuery.of(context).size.width,
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      right: fit.t(20.0),
                                      top: fit.t(20.0),
                                      child: InkWell(
                                        onTap: () {
                                          setState(
                                            () {
                                              imagePath = null;
                                              userImageFile = null;
                                            },
                                          );
                                        },
                                        child: Icon(
                                          Icons.close,
                                          color: appColor,
                                        ),
                                      ),
                                    )
                                  ],
                                )
                              : Container(),
                          isCampaign ?? false
                              ? SizedBox(
                                  height: fit.t(10.0),
                                )
                              : Container(),
                          isCampaign ?? false
                              ? InkWell(
                                  onTap: () {
                                    _captureImage(ImageSource.gallery, context);
                                  },
                                  child: Container(
                                    padding: EdgeInsets.only(right: fit.t(16.0)),
                                    width: MediaQuery.of(context).size.width,
                                    child: Row(
                                      children: [
                                        Icon(Icons.image, color: colorGrey2),
                                        SizedBox(
                                          width: fit.t(10.0),
                                        ),
                                        Text(
                                          'Add Image',
                                          style: TextStyle(
                                            color: Colors.grey,
                                            fontFamily: "Roboto",
                                            fontSize: fit.t(12.0),
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              : Container(),
                          isCampaign ?? false
                              ? SizedBox(
                                  height: fit.t(10.0),
                                )
                              : Container(),
                          isCampaign ?? false
                              ? Container(
                                  height: fit.t(1.0),
                                  color: Color(0xFFf0f0f0),
                                )
                              : Container()
                        ],
                      ),
                      Container(
                        key: _uploadPost,
                        margin: EdgeInsets.only(left: fit.t(50.0), right: fit.t(50.0), top: fit.t(30.0)),
                        child: SocialMediaCustomButton(
                          btnText: 'Post',
                          buttonColor: colorAcceptBtn,
                          onPressed: isValidPost,
                          size: 18.0,
                          splashColor: colorAcceptBtnSplash,
                          textColor: colorWhite,
                        ),
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
          ),
        ),
      ),
    );
  }

  Future _prepare() async {
    if (mounted) {
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
    customPath = appDocDirectory.path + customPath + DateTime.now().millisecondsSinceEpoch.toString() + ".wav";

    _recorder = FlutterAudioRecorder(customPath, audioFormat: AudioFormat.WAV, sampleRate: 16000);
    await _recorder.initialized;
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
    _t.cancel();
    var result = await _recorder.stop();
    if (mounted)
      setState(() {
        _recording = result;
      });
  }

  void _onRecordStart() {
    FocusScope.of(context).requestFocus(_screenFocusNode);
    if (mounted) _opt();
  }

  void _subscribeToApiResponse() {
    _apiResponse.stream.listen((data) {
      if (data is AllTopicsModel) {
        _choices.clear();
        _choices = data.response;
        if (mounted) setState(() {});
      } else if (data is ChannelDataList) {
        _allChannels.clear();
        _allChannels = data.response;
        if (mounted) setState(() {});
      } else if (data is CommonApiReponse) {
        if (data.type == 1) {
          audioUrl = data.response;
          isFileUploaded = true;
          _actionText = "Record Again";
        } else {
          imagePath = data.response;
        }
        if (data.show_msg == 1)
          TopAlert.showAlert(
              context,
              data.message != null
                  ? data.message.isNotEmpty
                      ? "${data.message}"
                      : "Audio file uploaded successfully."
                  : "Audio file uploaded successfully.",
              false);
        if (mounted) setState(() {});
      } else if (data is AddPostResponse) {
        TopAlert.showAlert(
            context,
            data.message != null
                ? data.message.isNotEmpty
                    ? "${data.message}"
                    : "Post added successfully."
                : "Post added successfully.",
            false);
        if (_recording.status == RecordingStatus.Recording) {
          _recorder?.pause();
          _recorder?.stop();
        } else if (_recording.status == RecordingStatus.Paused) {
          _recorder?.stop();
        } else {
          _stopRecording();
        }
        widget.controller();
        Navigator.of(context).pop(true);
      } else if (data is ErrorResponse) {
        TopAlert.showAlert(_scaffoldKey.currentState.context, data.message, true);
      } else if (data is CustomError) {
        if (data.errorMessage == 'Check your internet connection.') {
          pushNamedIfNotCurrent(context, '/noInternet');
        } else {
          TopAlert.showAlert(_scaffoldKey.currentState.context, data.errorMessage, true);
        }
      } else if (data is Exception) {
        TopAlert.showAlert(_scaffoldKey.currentState.context, 'Oops, Something went wrong please try again later.', true);
      }
    }, onError: (error) {
      if (error is CustomError) {
        TopAlert.showAlert(_scaffoldKey.currentState.context, error.errorMessage, true);
      } else {
        TopAlert.showAlert(_scaffoldKey.currentState.context, error.toString(), true);
      }
    });
  }

  Widget _titleWidget() {
    return Container(
      child: Padding(
        padding: EdgeInsets.only(top: fit.t(8.0), left: fit.t(8.0), right: fit.t(8.0)),
        child: Container(
          child: Text(
            'Post',
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
    return RotatedBox(
      quarterTurns: 2,
      child: InkWell(
        onTap: () {
          if (_recording != null) {
            if (_recording.status == RecordingStatus.Recording) {
              _recorder?.pause();
              _recorder?.stop();
            } else if (_recording.status == RecordingStatus.Paused) {
              _recorder?.stop();
            } else {
              _stopRecording();
            }
          }
          widget.controller();
          Navigator.of(context).pop(true);
        },
        child: Container(
          height: fit.t(30.0),
          width: fit.t(30.0),
          margin: EdgeInsets.only(right: fit.t(16.0), top: fit.t(4.0)),
          child: Image.asset(
            ic_back_img,
            height: fit.t(30.0),
            width: fit.t(30.0),
            scale: 2.0,
          ),
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
          '',
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

  Widget trailingWidget() {
    return GestureDetector(
      onTap: () async {
        audioUrl = "";
        if (_actionText.contains("Cancel")) {
          _actionText = "Record Again";
          isShowRecordingText = false;
          isRecordingStarted = false;
          isPaused = true;
          await _stopRecording();
        } else {
          _actionText = "Cancel";
          isFileUploaded = false;
          isShowRecordingText = true;
          isRecordingStarted = true;
          isPaused = false;
          await _prepare();
          _onRecordStart();
        }
      },
      child: Center(
        child: Container(
          margin: EdgeInsets.only(right: fit.t(16.0), top: fit.t(4.0)),
          padding: EdgeInsets.all(6.0),
          decoration: BoxDecoration(
            border: Border.all(
              color: appColor,
            ),
            color: appColor,
            borderRadius: BorderRadius.all(
              Radius.circular(4.0),
            ),
          ),
          child: Text(
            "$_actionText",
            key: _cancelPostRecording,
            style: TextStyle(backgroundColor: appColor, color: colorWhite),
          ),
        ),
      ),
    );
  }

  void uploadRecorderFile() {
    _bloc.showProgressLoader(true);
    var _duration = Duration(milliseconds: 500);
    Timer(_duration, _uploadRecorderFile);
  }

  double _calculateEndAnimation(double data, int all) {
    try {
      if (data == 0) {
        return 0;
      } else {
        return (data / all) * 100;
      }
    } catch (e) {
      return 0;
    }
  }

  void _getCurrentLocation() {
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
      // TopAlert.showAlert(context,
      //     "You must activate your geolocation.", true);
    }).catchError((e) {
      _bloc.showProgressLoader(false);
      // TopAlert.showAlert(context,
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
      return Future.error('Location permissions are permantly denied, we cannot request permissions.');
    }

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse && permission != LocationPermission.always) {
        return Future.error('Location permissions are denied (actual value: $permission).');
      }
    }

    return await Geolocator.getCurrentPosition();
  }

  Widget _recordingStarted() {
    return Wrap(
      alignment: WrapAlignment.center,
      children: [
        Padding(
          padding: EdgeInsets.only(top: fit.t(4.0)),
          child: Text(
            _recording?.duration == null ? "00:00 / 01:00" : '${toHoursMinutes(_recording?.duration)} / 01:00',
            style: TextStyle(color: colorBlack, fontSize: fit.t(12.0), fontFamily: "Roboto", fontWeight: FontWeight.w400),
          ),
        ),
        isShowRecordingText ? _recodingText() : Container(),
        Container(
          height: fit.t(10.0),
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
        Container(
          height: fit.t(10.0),
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
                key: _pausePost,
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
                if (_recording.status == RecordingStatus.Recording) {
                  _recorder?.pause();
                  _recorder?.stop();
                } else if (_recording.status == RecordingStatus.Paused) {
                  _recorder?.stop();
                }
                uploadRecorderFile();
              },
              child: Image.asset(
                ic_send_recording,
                key: _finishPost,
                height: fit.t(45.0),
                scale: 1,
              ),
            ),
          ],
        ),
        Container(
          height: fit.t(20.0),
        ),
        Container(
          height: fit.t(2.0),
          color: Color(0xFFf0f0f0),
        ),
      ],
    );
  }

  Widget _playRecordingWidget() {
    return Wrap(
      alignment: WrapAlignment.center,
      children: [
        Text(
          _recording?.duration == null ? "00:00" : '${toHoursMinutes(_recording?.duration)}',
          style: TextStyle(color: colorBlack, fontSize: fit.t(12.0), fontFamily: "Roboto", fontWeight: FontWeight.w400),
        ),
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            InkWell(
              onTap: () => isPlaying ? _stopPlaying() : _play(),
              child: Image.asset(
                isPlaying ? ic_stop_recording : ic_play_big,
                height: isPlaying ? fit.t(40.0) : fit.t(70.0),
                scale: 1,
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width / 1.4,
              child: Image.asset(waves_full),
              margin: EdgeInsets.symmetric(vertical: fit.t(24.0)),
            ),
            Container(
              width: fit.t(10.0),
            ),
          ],
        ),
        Container(
          height: fit.t(20.0),
        ),
        Container(
          height: fit.t(2.0),
          color: Color(0xFFf0f0f0),
        ),
      ],
    );
  }

  void _play() {
    isPlaying = true;
    player.play(_recording.path, isLocal: true);
    player.onPlayerCompletion.listen((events) {
      isPlaying = false;
    });
  }

  Iterable<Widget> get topicsPosition sync* {
    for (Topics topics in _filters) {
      yield Padding(
        padding: const EdgeInsets.all(4.0),
        child: FilterChip(
          backgroundColor: Color(0xFFf0f0f0),
          checkmarkColor: Colors.white,
          label: Text(
            "${topics.title}  x",
          ),
          showCheckmark: false,
          selected: _filters.contains(topics),
          selectedColor: appColor.withOpacity(0.9),
          labelPadding: const EdgeInsets.all(3.0),
          selectedShadowColor: colorWhite,
          labelStyle: TextStyle(
              color: !_filters.contains(topics) ? Colors.black87 : colorWhite,
              fontWeight: FontWeight.w400,
              fontSize: fit.t(14.0),
              fontFamily: "Roboto"),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(5),
            ),
          ),
          onSelected: (bool selected) {
            setState(
              () {
                _filters.removeWhere((Topics name) {
                  return name == topics;
                });
              },
            );
          },
        ),
      );
    }
  }

  Iterable<Widget> get channelSelectedList sync* {
    for (Channels topics in _selectedChannels) {
      yield Padding(
        padding: const EdgeInsets.all(4.0),
        child: FilterChip(
          backgroundColor: Color(0xFFf0f0f0),
          checkmarkColor: Colors.white,
          label: Text(
            "${topics.title}  x",
          ),
          showCheckmark: false,
          selected: _selectedChannels.contains(topics),
          selectedColor: appColor.withOpacity(0.9),
          labelPadding: const EdgeInsets.all(3.0),
          selectedShadowColor: colorWhite,
          labelStyle: TextStyle(
              color: !_selectedChannels.contains(topics) ? Colors.black87 : colorWhite,
              fontSize: fit.t(14.0),
              fontFamily: "Roboto",
              fontWeight: FontWeight.w400),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(5),
            ),
          ),
          onSelected: (bool selected) {
            setState(
              () {
                _selectedChannels.removeWhere((Channels name) {
                  return name == topics;
                });
              },
            );
          },
        ),
      );
    }
  }

  void isValidPost() {
    if (userDataBean?.is_publisher ?? false) {
      if (audioUrl.isNotEmpty) {
        if (_titleInputController.text.toString().trim().length > 0) {
          if (isCampaign) {
            if (_descInputController.text.toString().trim().length > 0) {
              if (userImageFile != null) {
                FATracker tracker = FATracker();
                tracker.track(FAEvents(eventName: ADD_POST_EVENT, attrs: null));
                List<double> list = List();
                list.add(_currentPosition.latitude);
                list.add(_currentPosition.longitude);
                Map<String, dynamic> map = Map();
                map.putIfAbsent('text', () => _titleInputController.text.toString().trim());
                map.putIfAbsent('audio', () => audioUrl);
                map.putIfAbsent("language", () => "en-IN");
                map.putIfAbsent('audio_duration', () => _recording.duration.inSeconds.toString());
                map.putIfAbsent('is_campaign', () => true);
                if (_selectedChannels.length > 0) {
                  map.putIfAbsent('channel_id', () => _selectedChannels[0].id);
                  map.putIfAbsent('topic_id', () => _selectedChannels[0].topic.id);
                }
                map.putIfAbsent('campaign_img', () => imagePath);
                map.putIfAbsent('campaign_desc', () => _descInputController.text.toString().trim());
                map.putIfAbsent('lat_lng', () => list);
                map.putIfAbsent('hash_tag', () => _hashInputController.text.toString().trim());
                _bloc.callApiSavePost(context, map);
              } else {
                TopAlert.showAlert(context, 'Please select image for your campaign.', true);
              }
            } else {
              TopAlert.showAlert(context, 'Please enter description of campaign.', true);
            }
          } else {
            FATracker tracker = FATracker();
            tracker.track(FAEvents(eventName: ADD_POST_EVENT, attrs: null));
            List<double> list = List();
            list.add(_currentPosition.latitude);
            list.add(_currentPosition.longitude);
            Map<String, dynamic> map = Map();
            map.putIfAbsent('text', () => _titleInputController.text.toString().trim());
            map.putIfAbsent('audio', () => audioUrl);
            map.putIfAbsent("language", () => "en-IN");
            map.putIfAbsent('audio_duration', () => _recording.duration.inSeconds.toString());
            map.putIfAbsent('is_campaign', () => false);
            if (_selectedChannels.length > 0) {
              map.putIfAbsent('channel_id', () => _selectedChannels[0].id);
              map.putIfAbsent('topic_id', () => _selectedChannels[0].topic.id);
            }
            map.putIfAbsent('lat_lng', () => list);
            map.putIfAbsent('hash_tag', () => _hashInputController.text.toString().trim());
            _bloc.callApiSavePost(context, map);
          }
        } else {
          TopAlert.showAlert(context, 'Please add title of post.', true);
        }
      } else {
        TopAlert.showAlert(context, 'Please record your post.', true);
      }
    } else {
      if (audioUrl.isNotEmpty) {
        if (_titleInputController.text.toString().trim().length > 0) {
          if (_filters.length > 0) {
            FATracker tracker = FATracker();
            tracker.track(FAEvents(eventName: ADD_POST_EVENT, attrs: null));
            List<double> list = List();
            list.add(_currentPosition.latitude);
            list.add(_currentPosition.longitude);
            Map<String, dynamic> map = Map();
            map.putIfAbsent('text', () => _titleInputController.text.toString().trim());
            map.putIfAbsent('audio', () => audioUrl);
            map.putIfAbsent("language", () => "en-IN");
            map.putIfAbsent('audio_duration', () => _recording.duration.inSeconds.toString());
            map.putIfAbsent('is_campaign', () => false);
            map.putIfAbsent('topic_id', () => _filters[0].id);
            map.putIfAbsent('lat_lng', () => list);
            map.putIfAbsent('hash_tag', () => _hashInputController.text.toString().trim());
            _bloc.callApiSavePost(context, map);
          } else {
            TopAlert.showAlert(context, 'Please select at least one topic for your posts.', true);
          }
        } else {
          TopAlert.showAlert(context, 'Please add title of post.', true);
        }
      } else {
        TopAlert.showAlert(context, 'Please record your post.', true);
      }
    }
  }

  void _captureImage(ImageSource source, context) async {
    File _imageFile = await ImagePicker.pickImage(source: source);
    if (_imageFile != null) {
      String name = new DateTime.now().millisecondsSinceEpoch.toString();
      Directory dir = await getApplicationDocumentsDirectory();
      var ext = _imageFile.path.toString().substring(_imageFile.path.length - 3, _imageFile.path.length);
      if (ext == 'jpg') {
        ext = 'jpeg';
      }
      var targetPath = dir.absolute.path + "/$name.$ext";
      var imgFile = await _compressFileCaptured(_imageFile, targetPath, ext);

      this.userImageFile = imgFile;
      this.imagePath = _imageFile.path;
      if (mounted) setState(() {});
      _bloc.callApiUploadFile(context, _imageFile.path, 0);
    }
  }

  Future<File> _compressFileCaptured(File file, String targetPath, String ext) async {
    var result = await FlutterImageCompress.compressAndGetFile(file.absolute.path, targetPath,
        quality: 100, rotate: 0, format: ext == 'png' ? CompressFormat.png : CompressFormat.jpeg);
    return result;
  }

  @override
  void dispose() {
    player?.release();
    _stopRecording();
    _apiResponse?.close();
    _recorder = null;
    _recording = null;
    _bloc?.dispose();
    super.dispose();
  }

  void _uploadRecorderFile() {
    _bloc.callApiUploadFile(context, customPath, 1);
  }

  _stopPlaying() {
    isPlaying = false;
    player.stop();
  }

  showTooltip() {
    if (tooltip?.isOpen ?? false) {
      tooltip?.close();
    }
    // We create the tooltip on the first use
    tooltip = SuperTooltip(
      popupDirection: TooltipDirection.down,
      backgroundColor: Colors.amberAccent,
      myOffset: Offset(20, 20),
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
                "Recording start automatically on this screen, you can cancel and go back anytime.",
                softWrap: true,
                style: TextStyle(fontWeight: FontWeight.bold, fontFamily: "Roboto"),
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
                      onTap: () async {
                        tooltip.close();
                        await _prepare();
                        _onRecordStart();
                        isShowTut = false;
                      },
                      child: Text(
                        " Skip all ",
                        style: TextStyle(fontWeight: FontWeight.bold, fontFamily: "Roboto"),
                      )),
                  Text(
                    "|",
                    style: TextStyle(fontWeight: FontWeight.bold, fontFamily: "Roboto"),
                  ),
                  InkWell(
                      onTap: () {
                        tooltip?.close();
                        showTooltipPause();
                      },
                      child: Text(
                        " Next ",
                        style: TextStyle(fontWeight: FontWeight.bold, fontFamily: "Roboto"),
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
    tooltip.show(_cancelPostRecording.currentContext);
  }

  void showTooltipPause() {
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
                "You can pause the recording using this icon.",
                softWrap: true,
                style: TextStyle(fontWeight: FontWeight.bold, fontFamily: "Roboto"),
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
                      onTap: () async {
                        tooltip.close();
                        await _prepare();
                        _onRecordStart();
                        isShowTut = false;
                      },
                      child: Text(
                        " Skip all ",
                        style: TextStyle(fontWeight: FontWeight.bold, fontFamily: "Roboto"),
                      )),
                  Text(
                    "|",
                    style: TextStyle(fontWeight: FontWeight.bold, fontFamily: "Roboto"),
                  ),
                  InkWell(
                      onTap: () {
                        tooltip?.close();
                        showTooltipFinish();
                      },
                      child: Text(
                        " Next ",
                        style: TextStyle(fontWeight: FontWeight.bold, fontFamily: "Roboto"),
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
    tooltip.show(_pausePost.currentContext);
  }

  void showTooltipFinish() {
    Scrollable.ensureVisible(_finishPost.currentContext);
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
                userDataBean?.is_publisher ?? false
                    ? "Click this icon once you finish saying,and it'll save the voice."
                    : "Once you finish, click on is icon to save recording.",
                softWrap: true,
                style: TextStyle(fontWeight: FontWeight.bold, fontFamily: "Roboto"),
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
                      onTap: () async {
                        tooltip.close();
                        await _prepare();
                        _onRecordStart();
                        isShowTut = false;
                      },
                      child: Text(
                        " Skip all ",
                        style: TextStyle(fontWeight: FontWeight.bold, fontFamily: "Roboto"),
                      )),
                  Text(
                    "|",
                    style: TextStyle(fontWeight: FontWeight.bold, fontFamily: "Roboto"),
                  ),
                  InkWell(
                      onTap: () {
                        tooltip?.close();
                        showTooltipTitle();
                      },
                      child: Text(
                        " Next ",
                        style: TextStyle(fontWeight: FontWeight.bold, fontFamily: "Roboto"),
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
    tooltip.show(_finishPost.currentContext);
  }

  void showTooltipTitle() {
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
                userDataBean?.is_publisher ?? false ? "Add the relevant title to the post." : "Add a title to your post.",
                softWrap: true,
                style: TextStyle(fontWeight: FontWeight.bold, fontFamily: "Roboto"),
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
                      onTap: () async {
                        tooltip.close();
                        await _prepare();
                        _onRecordStart();
                        isShowTut = false;
                      },
                      child: Text(
                        " Skip all ",
                        style: TextStyle(fontWeight: FontWeight.bold, fontFamily: "Roboto"),
                      )),
                  Text(
                    "|",
                    style: TextStyle(fontWeight: FontWeight.bold, fontFamily: "Roboto"),
                  ),
                  InkWell(
                      onTap: () {
                        tooltip?.close();
                        showTooltipHashTag();
                      },
                      child: Text(
                        " Next ",
                        style: TextStyle(fontWeight: FontWeight.bold, fontFamily: "Roboto"),
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
    tooltip.show(_addTitlePost.currentContext);
  }

  void showTooltipHashTag() {
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
                userDataBean?.is_publisher ?? false ? "Add some relevant hastags." : "Add couple of hastags (optional).",
                softWrap: true,
                style: TextStyle(fontWeight: FontWeight.bold, fontFamily: "Roboto"),
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
                      onTap: () async {
                        tooltip.close();
                        await _prepare();
                        _onRecordStart();
                        isShowTut = false;
                      },
                      child: Text(
                        " Skip all ",
                        style: TextStyle(fontWeight: FontWeight.bold, fontFamily: "Roboto"),
                      )),
                  Text(
                    "|",
                    style: TextStyle(fontWeight: FontWeight.bold, fontFamily: "Roboto"),
                  ),
                  InkWell(
                      onTap: () {
                        tooltip?.close();
                        userDataBean?.is_publisher ?? false ? showTooltipChannel() : showTopicsTooltip();
                      },
                      child: Text(
                        " Next ",
                        style: TextStyle(fontWeight: FontWeight.bold, fontFamily: "Roboto"),
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
    tooltip.show(_addTagPost.currentContext);
  }

  void showTooltipChannel() {
    _scrollController.animateTo(MediaQuery.of(context).size.height, duration: Duration(microseconds: 200), curve: Curves.easeIn);
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
                "Select one of your channel from which you want to post.",
                softWrap: true,
                style: TextStyle(fontWeight: FontWeight.bold, fontFamily: "Roboto"),
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
                      onTap: () async {
                        tooltip.close();
                        await _prepare();
                        _onRecordStart();
                        isShowTut = false;
                      },
                      child: Text(
                        " Skip all ",
                        style: TextStyle(fontWeight: FontWeight.bold, fontFamily: "Roboto"),
                      )),
                  Text(
                    "|",
                    style: TextStyle(fontWeight: FontWeight.bold, fontFamily: "Roboto"),
                  ),
                  InkWell(
                      onTap: () {
                        tooltip?.close();
                        showTooltipCampaign();
                      },
                      child: Text(
                        " Next ",
                        style: TextStyle(fontWeight: FontWeight.bold, fontFamily: "Roboto"),
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
    tooltip.show(_channelPost.currentContext);
  }

  void showTooltipCampaign() {
    _scrollController.animateTo(MediaQuery.of(context).size.height, duration: Duration(microseconds: 200), curve: Curves.easeIn);
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
                "Want to start a campaign? Start here...",
                softWrap: true,
                style: TextStyle(fontWeight: FontWeight.bold, fontFamily: "Roboto"),
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
                      onTap: () async {
                        tooltip.close();
                        await _prepare();
                        _onRecordStart();
                        isShowTut = false;
                      },
                      child: Text(
                        " Skip all ",
                        style: TextStyle(fontWeight: FontWeight.bold, fontFamily: "Roboto"),
                      )),
                  Text(
                    "|",
                    style: TextStyle(fontWeight: FontWeight.bold, fontFamily: "Roboto"),
                  ),
                  InkWell(
                      onTap: () {
                        tooltip?.close();
                        showTooltipSavePost();
                      },
                      child: Text(
                        " Next ",
                        style: TextStyle(fontWeight: FontWeight.bold, fontFamily: "Roboto"),
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
    tooltip.show(_asCampaignPost.currentContext);
  }

  void showTooltipSavePost() {
    _scrollController.animateTo(MediaQuery.of(context).size.height, duration: Duration(microseconds: 200), curve: Curves.easeIn);
    if (tooltip?.isOpen ?? false) {
      tooltip?.close();
    }
    // We create the tooltip on the first use
    tooltip = SuperTooltip(
      popupDirection: TooltipDirection.up,
      backgroundColor: Colors.amberAccent,
      myOffset: Offset(20, 80),
      borderRadius: fit.t(24.0),
      borderWidth: fit.t(2.0),
      borderColor: Colors.black,
      dismissOnTapOutside: true,
      arrowLength: 0,
      left: 20,
      maxWidth: MediaQuery.of(context).size.width / 1.2,
      touchThroughAreaShape: ClipAreaShape.oval,
      hasShadow: true,
      content: Material(
        child: Container(
          color: Colors.amberAccent,
          child: Wrap(
            children: [
              Text(
                "Click on 'Post' to publish.",
                softWrap: true,
                style: TextStyle(fontWeight: FontWeight.bold, fontFamily: "Roboto"),
              ),
              Container(
                height: fit.t(2.0),
              ),
              // (userDataBean?.is_publisher ?? false) ?
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  InkWell(
                      onTap: () async {
                        tooltip?.close();
                        await _prepare();
                        _onRecordStart();
                        isShowTut = false;
                      },
                      child: Text(
                        " Finish ",
                        style: TextStyle(fontWeight: FontWeight.bold, fontFamily: "Roboto"),
                      )),
                  SizedBox(
                    width: fit.t(10.0),
                  )
                ],
              )
              // : Row(
              //     mainAxisSize: MainAxisSize.max,
              //     mainAxisAlignment: MainAxisAlignment.end,
              //     crossAxisAlignment: CrossAxisAlignment.end,
              //     children: [
              //       InkWell(
              //           onTap: () async {
              //             tooltip.close();
              //             await _prepare();
              //             _onRecordStart();
              //             isShowTut = false;
              //           },
              //           child: Text(
              //             " Skip all ",
              //             style: TextStyle(
              //                 fontWeight: FontWeight.bold,
              //                 fontFamily: "Roboto"),
              //           )),
              //       Text(
              //         "|",
              //         style: TextStyle(
              //             fontWeight: FontWeight.bold,
              //             fontFamily: "Roboto"),
              //       ),
              //       InkWell(
              //           onTap: () async {
              //             tooltip?.close();
              //             await _prepare();
              //             _onRecordStart();
              //           },
              //           child: Text(
              //             " Next ",
              //             style: TextStyle(
              //                 fontWeight: FontWeight.bold,
              //                 fontFamily: "Roboto"),
              //           )),
              //       SizedBox(
              //         width: fit.t(10.0),
              //       )
              // ],
              // )
            ],
          ),
        ),
      ),
    );
    tooltip.show(_uploadPost.currentContext);
  }

  void showTopicsTooltip() {
    _scrollController.animateTo(MediaQuery.of(context).size.height, duration: Duration(microseconds: 200), curve: Curves.easeIn);
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
                "select a relevant topic from the list.",
                softWrap: true,
                style: TextStyle(fontWeight: FontWeight.bold, fontFamily: "Roboto"),
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
                      onTap: () async {
                        tooltip.close();
                        await _prepare();
                        _onRecordStart();
                        isShowTut = false;
                      },
                      child: Text(
                        " Skip all ",
                        style: TextStyle(fontWeight: FontWeight.bold, fontFamily: "Roboto"),
                      )),
                  Text(
                    "|",
                    style: TextStyle(fontWeight: FontWeight.bold, fontFamily: "Roboto"),
                  ),
                  InkWell(
                      onTap: () {
                        tooltip?.close();
                        showTooltipSavePost();
                      },
                      child: Text(
                        " Next ",
                        style: TextStyle(fontWeight: FontWeight.bold, fontFamily: "Roboto"),
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
    tooltip.show(_chooseTopicPost.currentContext);
  }
}
