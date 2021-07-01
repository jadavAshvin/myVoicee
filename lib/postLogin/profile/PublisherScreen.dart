import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:fm_fit/fm_fit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_voicee/constants/app_colors.dart';
import 'package:my_voicee/constants/app_constants.dart';
import 'package:my_voicee/constants/app_images_path.dart';
import 'package:my_voicee/customWidget/Alert/top_alert.dart';
import 'package:my_voicee/customWidget/SocialMediaCustomButton.dart';
import 'package:my_voicee/customWidget/appLoader/custom_progress_loader.dart';
import 'package:my_voicee/customWidget/super_tooltip.dart';
import 'package:my_voicee/models/GetAllPostsResponse.dart';
import 'package:my_voicee/models/UserResponse.dart';
import 'package:my_voicee/models/commonResponse/CommonpiResponse.dart';
import 'package:my_voicee/models/errorResponse/customeError.dart';
import 'package:my_voicee/models/errorResponse/error_reponse.dart';
import 'package:my_voicee/postLogin/profile/AddAudioBioScreen.dart';
import 'package:my_voicee/postLogin/profile/EnterMobileScreen.dart';
import 'package:my_voicee/postLogin/profile/drawerItems/channel/CreateChannel.dart';
import 'package:my_voicee/postLogin/profile/profileBloc/ProfileBloc.dart';
import 'package:my_voicee/utils/DialogUtils.dart';
import 'package:my_voicee/utils/Utility.dart';
import 'package:path_provider/path_provider.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

class PublisherScreen extends StatefulWidget {
  final data;

  PublisherScreen({this.data});

  @override
  _PublisherScreenState createState() => _PublisherScreenState();
}

class _PublisherScreenState extends State<PublisherScreen> {
  var _scaffoldKey = GlobalKey<ScaffoldState>();
  SuperTooltip tooltip;
  FmFit fit = FmFit(width: 750);
  UserData userData;
  ProfileBloc _bloc;
  StreamController apiResponseData;
  StreamController apiResponse;
  File userImageFile;
  var imagePath;
  bool isUpdate = false;
  GlobalKey _mobilePublisher = GlobalKey<_PublisherScreenState>();
  GlobalKey _profilePublisher = GlobalKey<_PublisherScreenState>();
  GlobalKey _bioPublisher = GlobalKey<_PublisherScreenState>();
  GlobalKey _createChannelKey = GlobalKey<_PublisherScreenState>();

  @override
  void initState() {
    super.initState();
    userData = widget.data;
    imagePath = userData.dp;
    apiResponseData = StreamController<List<AllPostResponse>>.broadcast();
    apiResponse = StreamController();
    _bloc = ProfileBloc(apiResponseData, apiResponse);
    if (isShowTut)
      SchedulerBinding.instance.addPostFrameCallback((_) => showTooltip());
    _subscribeToApiResponse();
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
            child: Column(
              children: [
                SizedBox(
                  height: fit.t(20.0),
                ),
                Image.asset(
                  becomea_pulisher_white,
                  color: userData.is_publisher
                      ? appColor
                      : Color.fromRGBO(143, 150, 171, 1),
                  scale: 0.6,
                ),
                SizedBox(
                  height: fit.t(10.0),
                ),
                //name
                Container(
                  padding: EdgeInsets.all(4.0),
                  child: Text(
                    userData.is_publisher
                        ? 'Successfully Verified'
                        : 'Verify Yourself',
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: fit.t(16.0),
                        fontWeight: FontWeight.w500,
                        color: Color.fromRGBO(0, 0, 0, 1)),
                  ),
                ),
                SizedBox(
                  height: fit.t(5.0),
                ),
                //bio
                Container(
                  child: Text(
                    userData.is_publisher
                        ? 'Now as a publisher you can "Go Live" or create\n"Campaign" to reach you audience'
                        : 'Below information are mandatory to become \na publisher',
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w400,
                        fontSize: fit.t(14.0),
                        color: Color.fromRGBO(130, 130, 130, 1)),
                  ),
                ),
                SizedBox(
                  height: fit.t(20.0),
                ),
                InkWell(
                  onTap: () async {
                    if (!userData.mobile_verified) {
                      var result = await pushNewScreen(context,
                          screen: EnterMobileScreen(), withNavBar: false);
                      if (result != null) {
                        if (result) {
                          _bloc.getUserProfile(context);
                        }
                      }
                    }
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          SizedBox(
                            width: 10.0,
                          ),
                          Image.asset(
                            ic_mobile_pb,
                            scale: 1.2,
                          ),
                          SizedBox(
                            width: fit.t(10.0),
                          ),
                          Text(
                            'Verify Mobile No.',
                            key: _mobilePublisher,
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontFamily: 'Roboto',
                                fontWeight: FontWeight.w400,
                                fontSize: fit.t(14.0),
                                color: Colors.blue[600]),
                          ),
                        ],
                      ),
                      Container(
                        margin: EdgeInsets.only(right: fit.t(10.0)),
                        child: Icon(
                          Icons.check,
                          color: userData.mobile_verified
                              ? Colors.green
                              : Color.fromRGBO(193, 193, 193, 1),
                        ),
                      ),
                    ],
                  ),
                ),
                Divider(),
                InkWell(
                  onTap: () {
                    if (userData.dp == null) {
                      _optionsDialogBox(context);
                    }
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          SizedBox(
                            width: 10.0,
                          ),
                          userData.dp == null
                              ? Image.asset(
                                  ic_profile_pb,
                                  width: fit.t(45.0),
                                  height: fit.t(45.0),
                                )
                              : Container(
                                  width: fit.t(45.0),
                                  height: fit.t(45.0),
                                  child: imagePath == null
                                      ? Container(
                                          width: fit.t(45.0),
                                          height: fit.t(45.0),
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
                                              width: fit.t(45.0),
                                              height: fit.t(45.0),
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
                                              width: fit.t(45.0),
                                              height: fit.t(45.0),
                                              decoration: BoxDecoration(
                                                  color: appColor,
                                                  shape: BoxShape.circle),
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        fit.t(60.0)),
                                                child: Image.file(
                                                  userImageFile,
                                                  fit: BoxFit.fill,
                                                  width: fit.t(45.0),
                                                  height: fit.t(45.0),
                                                ),
                                              ),
                                            ),
                                ),
                          SizedBox(
                            width: fit.t(10.0),
                          ),
                          Text(
                            'Add profile picture',
                            key: _profilePublisher,
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontFamily: 'Roboto',
                                fontWeight: FontWeight.w400,
                                fontSize: fit.t(14.0),
                                color: Colors.blue[600]),
                          ),
                        ],
                      ),
                      Container(
                        margin: EdgeInsets.only(right: fit.t(10.0)),
                        child: Icon(
                          Icons.check,
                          color: userData.dp != null
                              ? Colors.green
                              : Color.fromRGBO(193, 193, 193, 1),
                        ),
                      ),
                    ],
                  ),
                ),
                Divider(),
                InkWell(
                  onTap: () async {
                    if (userData?.audio?.isEmpty ?? true) {
                      var result = await pushNewScreen(context,
                          screen: AddAudioBioScreen(), withNavBar: false);
                      if (result != null) {
                        if (result) {
                          _bloc.getUserProfile(context);
                        }
                      }
                    }
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          SizedBox(
                            width: 10.0,
                          ),
                          Image.asset(
                            userData.audio.isNotEmpty ? ic_play : ic_audio_pb,
                            scale: userData.audio.isNotEmpty ? 1.8 : 1.2,
                          ),
                          SizedBox(
                            width: fit.t(10.0),
                          ),
                          Text(
                            'Add Audio Bio',
                            key: _bioPublisher,
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontFamily: 'Roboto',
                                fontWeight: FontWeight.w400,
                                fontSize: fit.t(14.0),
                                color: Colors.blue[600]),
                          ),
                        ],
                      ),
                      Container(
                        margin: EdgeInsets.only(right: fit.t(10.0)),
                        child: Icon(
                          Icons.check,
                          color: userData.audio.isNotEmpty
                              ? Colors.green
                              : Color.fromRGBO(193, 193, 193, 1),
                        ),
                      ),
                    ],
                  ),
                ),
                Divider(),
                isUpdate
                    ? SizedBox(
                        width: fit.t(10.0),
                      )
                    : Container(),
                isUpdate
                    ? Container(
                        key: _createChannelKey,
                        padding: EdgeInsets.all(6),
                        margin: EdgeInsets.only(
                            left: fit.t(30.0),
                            right: fit.t(30.0),
                            top: fit.t(30.0)),
                        child: SocialMediaCustomButton(
                            btnText: 'Create Channel',
                            buttonColor: colorAcceptBtn,
                            onPressed: _onCreateChannel,
                            size: fit.t(18.0),
                            splashColor: colorAcceptBtnSplash,
                            textColor: colorWhite),
                      )
                    : Container(),
                isUpdate ? Divider() : Container(),
                isUpdate
                    ? SizedBox(
                        width: fit.t(10.0),
                      )
                    : Container(),
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

  Widget _titleWidget() {
    return Container(
      child: Padding(
        padding: EdgeInsets.only(
            top: fit.t(8.0), left: fit.t(8.0), right: fit.t(8.0)),
        child: Container(
          child: Text(
            'Be a publisher',
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
      onTap: () => Navigator.of(context).pop(isUpdate),
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

  void _subscribeToApiResponse() {
    StreamSubscription subscription;
    subscription = apiResponse.stream.listen((data) {
      if (data is UserResponse) {
        userData = data.response;
        if (userData.is_publisher) {
          isUpdate = true;
        }
        if (mounted) setState(() {});
        Future.delayed(Duration(seconds: 1), showTooltipPublisher);
      } else if (data is CommonApiReponse) {
        if (data.response != null) {
          if (data.response is String) {
            if (data.response.toString().isNotEmpty) {
              imagePath = data.response;
            }
            if (mounted) setState(() {});
          }
        }
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

  _optionsDialogBox(context) {
    DialogUtils.showCustomDialog(context,
        fit: fit,
        okBtnText: "Camera",
        cancelBtnText: "Gallery",
        title: '',
        content: 'Please select camera or Gallery to capture image.',
        okBtnFunction: () {
      _captureImage(ImageSource.camera, context);
      Navigator.of(context).pop();
    }, cancelBtnFunction: () {
      _captureImage(ImageSource.gallery, context);
      Navigator.of(context).pop();
    });
  }

  _captureImage(ImageSource source, context) async {
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

  @override
  void dispose() {
    apiResponse.close();
    apiResponseData.close();
    super.dispose();
  }

  void _onCreateChannel() async {
    var result = await pushNewScreen(context,
        screen: CreateChannel(), withNavBar: false);
    if (result == null) {
      Navigator.of(context).pop(isUpdate);
    }
  }

  void showTooltip() {
    if (tooltip?.isOpen ?? false) {
      tooltip?.close();
    }
    // We create the tooltip on the first use
    tooltip = SuperTooltip(
      popupDirection: TooltipDirection.down,
      backgroundColor: Colors.amberAccent,
      myOffset: Offset(0, 0),
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
                "Verify your mobile number using OTP.",
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
                        showTooltipProfile();
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
    Future.delayed(Duration(milliseconds: 600), () {
      tooltip.show(_mobilePublisher.currentContext);
    });
  }

  void showTooltipProfile() {
    if (tooltip?.isOpen ?? false) {
      tooltip?.close();
    }
    // We create the tooltip on the first use
    tooltip = SuperTooltip(
      popupDirection: TooltipDirection.down,
      backgroundColor: Colors.amberAccent,
      myOffset: Offset(20, 10),
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
                "Add your profile picture.",
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
                        showTooltipBio();
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
    tooltip.show(_profilePublisher.currentContext);
  }

  void showTooltipBio() {
    if (tooltip?.isOpen ?? false) {
      tooltip?.close();
    }
    // We create the tooltip on the first use
    tooltip = SuperTooltip(
      popupDirection: TooltipDirection.down,
      backgroundColor: Colors.amberAccent,
      myOffset: Offset(20, 10),
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
                "Add your audio bio.",
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
    tooltip.show(_bioPublisher.currentContext);
  }

  void showTooltipPublisher() {
    if (tooltip?.isOpen ?? false) {
      tooltip?.close();
    }
    // We create the tooltip on the first use
    tooltip = SuperTooltip(
      popupDirection: TooltipDirection.down,
      backgroundColor: Colors.amberAccent,
      myOffset: Offset(40, 80),
      borderRadius: fit.t(24.0),
      borderWidth: fit.t(2.0),
      borderColor: Colors.black,
      dismissOnTapOutside: false,
      arrowLength: 0,
      arrowBaseWidth: 0,
      arrowTipDistance: 0,
      maxWidth: MediaQuery.of(context).size.width / 1.2,
      touchThroughAreaShape: ClipAreaShape.oval,
      hasShadow: true,
      content: Material(
        child: Container(
          color: Colors.amberAccent,
          child: Wrap(
            children: [
              Text(
                "Create a channel with your brand's/organization's name.",
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
    tooltip.show(_createChannelKey.currentContext);
  }
}
