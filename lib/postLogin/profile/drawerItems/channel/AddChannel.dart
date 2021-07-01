import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:fm_fit/fm_fit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_voicee/constants/app_colors.dart';
import 'package:my_voicee/constants/app_images_path.dart';
import 'package:my_voicee/customWidget/Alert/top_alert.dart';
import 'package:my_voicee/customWidget/SocialMediaCustomButton.dart';
import 'package:my_voicee/customWidget/appLoader/custom_progress_loader.dart';
import 'package:my_voicee/models/ChannelDataList.dart';
import 'package:my_voicee/models/commonResponse/CommonpiResponse.dart';
import 'package:my_voicee/models/errorResponse/customeError.dart';
import 'package:my_voicee/models/errorResponse/error_reponse.dart';
import 'package:my_voicee/postLogin/profile/drawerItems/channel/ChannelTypeScreen.dart';
import 'package:my_voicee/postLogin/profile/drawerItems/channel/bloc/ChannelBloc.dart';
import 'package:my_voicee/utils/DialogUtils.dart';
import 'package:my_voicee/utils/Utility.dart';
import 'package:path_provider/path_provider.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

class AddChannel extends StatefulWidget {
  BuildContext oldContext;

  AddChannel({this.oldContext});

  @override
  _AddChannelState createState() => _AddChannelState();
}

class _AddChannelState extends State<AddChannel> {
  FmFit fit = FmFit(width: 750);
  var _inputController = TextEditingController();
  var _inputDesController = TextEditingController();
  ChannelBloc _bloc;
  StreamController apiController;
  File userImageFile;
  String imagePath;

  @override
  void initState() {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);
    apiController = StreamController();
    _bloc = ChannelBloc(apiController);
    _subscribeToApiResponse();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    fit = FmFit(width: MediaQuery.of(context).size.width);
    if (MediaQuery.of(context).size.width > 700) {
      fit.scale = 1.0 + MediaQuery.of(context).size.aspectRatio;
    } else {
      fit.scale = 1.0;
    }
    return Stack(
      children: [
        Container(
          height: double.maxFinite,
          width: MediaQuery.of(context).size.width,
          color: colorWhite,
          child: Wrap(
            alignment: WrapAlignment.center,
            children: [
              Center(
                child: Container(
                  height: fit.t(80.0),
                  width: fit.t(80.0),
                  margin: EdgeInsets.only(
                    top: fit.t(35.0),
                  ),
                  child: Stack(
                    children: <Widget>[
                      GestureDetector(
                        onTap: () => _optionsDialogBox(context),
                        child: imagePath == null
                            ? Container(
                                width: fit.t(80.0),
                                height: fit.t(80.0),
                                child: Image.asset(ic_user_place_holder),
                              )
                            : imagePath.contains('http')
                                ? Container(
                                    width: fit.t(80.0),
                                    height: fit.t(80.0),
                                    decoration: BoxDecoration(
                                      color: appColor,
                                      shape: BoxShape.circle,
                                      image: DecorationImage(
                                          fit: BoxFit.fill,
                                          image: NetworkImage(imagePath)),
                                    ),
                                  )
                                : Container(
                                    width: fit.t(80.0),
                                    height: fit.t(80.0),
                                    decoration: BoxDecoration(
                                        color: appColor,
                                        shape: BoxShape.circle),
                                    child: ClipRRect(
                                      borderRadius:
                                          BorderRadius.circular(fit.t(60.0)),
                                      child: Image.file(
                                        userImageFile,
                                        fit: BoxFit.fill,
                                        width: fit.t(80.0),
                                        height: fit.t(80.0),
                                      ),
                                    ),
                                  ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: GestureDetector(
                          onTap: () => _optionsDialogBox(context),
                          child: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                            ),
                            child: Image.asset(
                              ic_camera,
                              width: fit.t(30.0),
                              height: fit.t(30.0),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(
                    horizontal: fit.t(16.0), vertical: fit.t(16.0)),
                child: TextField(
                  keyboardType: TextInputType.text,
                  cursorColor: colorGrey,
                  controller: _inputController,
                  keyboardAppearance: Brightness.light,
                  style: TextStyle(
                    color: Color(0xFF262628),
                    fontFamily: "Roboto",
                    fontSize: fit.t(14.0),
                    fontWeight: FontWeight.normal,
                  ),
                  textInputAction: TextInputAction.next,
                  maxLines: 1,
                  textCapitalization: TextCapitalization.words,
                  decoration: InputDecoration(
                    hintText: '',
                    labelText: 'Channel name',
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 10.0),
                    hintStyle: TextStyle(
                      color: colorGrey2,
                      fontFamily: "Roboto",
                      fontSize: fit.t(14.0),
                      fontWeight: FontWeight.normal,
                    ),
                    labelStyle: TextStyle(
                      color: colorGrey2,
                      fontSize: fit.t(14.0),
                      fontWeight: FontWeight.normal,
                      fontFamily: "Roboto",
                    ),
                    alignLabelWithHint: true,
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(
                  horizontal: fit.t(16.0),
                ),
                child: TextField(
                  keyboardType: TextInputType.text,
                  cursorColor: colorGrey,
                  controller: _inputDesController,
                  keyboardAppearance: Brightness.light,
                  style: TextStyle(
                    color: Color(0xFF262628),
                    fontFamily: "Roboto",
                    fontSize: fit.t(14.0),
                    fontWeight: FontWeight.normal,
                  ),
                  textInputAction: TextInputAction.next,
                  maxLines: 5,
                  decoration: InputDecoration(
                    hintText: '',
                    labelText: 'Description',
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 10.0),
                    hintStyle: TextStyle(
                      color: colorGrey2,
                      fontSize: fit.t(14.0),
                      fontWeight: FontWeight.normal,
                      fontFamily: "Roboto",
                    ),
                    labelStyle: TextStyle(
                      color: colorGrey2,
                      fontFamily: "Roboto",
                      fontSize: fit.t(14.0),
                      fontWeight: FontWeight.normal,
                    ),
                    alignLabelWithHint: true,
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(
                    horizontal: fit.t(16.0), vertical: fit.t(30.0)),
                child: SocialMediaCustomButton(
                  btnText: 'Next',
                  buttonColor: colorAcceptBtn,
                  onPressed: _onContinue,
                  size: fit.t(16.0),
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
      Navigator.of(context).pop();
    }, cancelBtnFunction: () {
      _captureImage(ImageSource.gallery, context);
      Navigator.of(context).pop();
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
      _bloc.saveImage(context, this.imagePath);
      setState(() {});
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

  void _onContinue() async {
    if (imagePath == null) {
      TopAlert.showAlert(context, "Please select image for channel.", true);
    } else if (_inputController.text.trim().toString().isEmpty) {
      TopAlert.showAlert(context, "Please enter channel name.", true);
    } else if (_inputDesController.text.trim().toString().isEmpty) {
      TopAlert.showAlert(context, "Please enter channel description.", true);
    } else {
      Channels data = Channels(
          img: imagePath,
          desc: _inputDesController.text.toString(),
          title: _inputController.text.toString());

      var result = await pushNewScreen(context,
          screen: ChannelTypeScreen(data), withNavBar: false);
      if (result != null) {
        if (result) {
          Navigator.of(widget.oldContext).pop(true);
        }
      }
    }
  }

  void _subscribeToApiResponse() {
    StreamSubscription subscription;
    subscription = apiController.stream.listen((data) {
      if (data is ErrorResponse) {
        if (data.show_msg == 1) {
          if (data.authType != null) {
            if (data.authType == "login") {
              Navigator.pushReplacementNamed(context, '/waitingScreen');
            } else {
              Navigator.pushReplacementNamed(context, '/termsOfUse');
            }
          } else {
            TopAlert.showAlert(context, data.message, true);
          }
        } else {
          TopAlert.showAlert(context, data.message, true);
        }
      } else if (data is CommonApiReponse) {
        if (data.message == 'Check your internet connection.') {
          pushNamedIfNotCurrent(context, '/noInternet');
        } else {
          if (data.show_msg == 1) {
            TopAlert.showAlert(context, data.message, false);
          }
          if (data.response != null) {
            if (data.response is String) {
              if (data.response.toString().isNotEmpty) {
                imagePath = data.response;
              }
              if (mounted) setState(() {});
            }
          }
        }
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
  void dispose() {
    apiController.close();
    super.dispose();
  }
}
