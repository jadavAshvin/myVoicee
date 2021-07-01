import 'dart:async';

import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fm_fit/fm_fit.dart';
import 'package:my_voicee/constants/app_colors.dart';
import 'package:my_voicee/constants/app_images_path.dart';
import 'package:my_voicee/customWidget/Alert/top_alert.dart';
import 'package:my_voicee/customWidget/SocialMediaCustomButton.dart';
import 'package:my_voicee/customWidget/appLoader/custom_progress_loader.dart';
import 'package:my_voicee/models/GetAllPostsResponse.dart';
import 'package:my_voicee/models/UserResponse.dart';
import 'package:my_voicee/models/commonResponse/CommonpiResponse.dart';
import 'package:my_voicee/models/errorResponse/customeError.dart';
import 'package:my_voicee/models/errorResponse/error_reponse.dart';
import 'package:my_voicee/postLogin/profile/VerifyOTPScreen.dart';
import 'package:my_voicee/postLogin/profile/profileBloc/ProfileBloc.dart';
import 'package:my_voicee/utils/Utility.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

class EnterMobileScreen extends StatefulWidget {
  @override
  _EnterMobileScreenState createState() => _EnterMobileScreenState();
}

class _EnterMobileScreenState extends State<EnterMobileScreen> {
  var _scaffoldKey = GlobalKey<ScaffoldState>();
  var screenFocusNode = FocusNode();
  FmFit fit = FmFit(width: 750);
  Locale _myLocale;
  String dialCode = "In +91";
  var _inputController = TextEditingController();
  var _codeinputController = TextEditingController();
  ProfileBloc _bloc;
  StreamController apiResponseData;
  StreamController apiResponse;

  UserData userData;

  @override
  void initState() {
    _codeinputController.text = dialCode;
    apiResponseData = StreamController<List<AllPostResponse>>.broadcast();
    apiResponse = StreamController();
    _bloc = ProfileBloc(apiResponseData, apiResponse);
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
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            color: colorWhite,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: fit.t(30.0),
                ),
                //name
                Container(
                  padding: EdgeInsets.only(left: fit.t(24.0)),
                  child: Text(
                    'Enter Mobile Number',
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: fit.t(18.0),
                        fontWeight: FontWeight.w500,
                        color: Color.fromRGBO(0, 0, 0, 1)),
                  ),
                ),
                SizedBox(
                  height: fit.t(10.0),
                ),
                _phoneInputField("")
              ],
            ),
          ),
          Positioned(
            bottom: fit.t(20.0),
            left: fit.t(50.0),
            right: fit.t(50.0),
            child: SocialMediaCustomButton(
              btnText: 'Continue',
              buttonColor: colorAcceptBtn,
              onPressed: _onContinue,
              size: fit.t(16.0),
              splashColor: colorAcceptBtnSplash,
              textColor: colorWhite,
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
            'Verify Mobile No.',
            style: TextStyle(
              fontFamily: 'Roboto',
              fontSize: fit.t(18.0),
              fontWeight: FontWeight.w400,
              color: Colors.black,
            ),
          ),
        ),
      ),
    );
  }

  Widget _phoneInputField(String error) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          InkWell(
            onTap: () {
              showCountryPicker(
                context: context,
                showPhoneCode: true,
                onSelect: (Country country) {
                  dialCode = "${country.countryCode} +${country.phoneCode}";
                  _codeinputController.text = dialCode;
                  setState(() {});
                },
              );
            },
            child: Container(
              width: MediaQuery.of(context).size.width / 4.0,
              margin: EdgeInsets.only(top: fit.t(5.0)),
              child: Column(
                children: [
                  Row(
                    children: [
                      Text(
                        "  ${_codeinputController.text}",
                        style: TextStyle(
                          color: Color(0xFF262628),
                          fontSize: fit.t(14.0),
                          fontFamily: "Roboto",
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      SizedBox(width: fit.t(5.0)),
                      Icon(
                        Icons.keyboard_arrow_down,
                        color: appColor,
                      )
                    ],
                  ),
                  Divider(
                    thickness: 2.0,
                    color: colorGrey2,
                  )
                ],
              ),
            ),
          ),
          SizedBox(
            width: fit.t(10.0),
          ),
          Container(
            width: MediaQuery.of(context).size.width / 1.5,
            child: TextField(
              keyboardType: TextInputType.phone,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly
              ],
              cursorColor: colorGrey,
              controller: _inputController,
              keyboardAppearance: Brightness.light,
              style: TextStyle(
                color: Color(0xFF262628),
                fontSize: fit.t(14.0),
                fontFamily: "Roboto",
                fontWeight: FontWeight.w400,
              ),
              maxLength: 10,
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(
                hintText: '',
                labelText: 'Phone number',
                contentPadding: const EdgeInsets.symmetric(horizontal: 10.0),
                hintStyle: TextStyle(
                  color: Color(0xFF262628),
                  fontSize: fit.t(14.0),
                  fontFamily: "Roboto",
                  fontWeight: FontWeight.w400,
                ),
                labelStyle: TextStyle(
                  color: Color(0xFF262628),
                  fontSize: fit.t(14.0),
                  fontFamily: "Roboto",
                  fontWeight: FontWeight.w400,
                ),
                alignLabelWithHint: true,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _leadingWidget() {
    return InkWell(
      onTap: () => Navigator.of(context).pop(),
      child: Container(
        margin: EdgeInsets.only(left: fit.t(16.0)),
        child: Image.asset(
          ic_left_back,
          scale: 1.2,
        ),
      ),
    );
  }

  void _onContinue() async {
    FocusScope.of(context).requestFocus(screenFocusNode);
    if (_inputController.text.toString().isEmpty) {
      TopAlert.showAlert(_scaffoldKey.currentState.context,
          "Please enter your phone number.", true);
    } else if (_inputController.text.toString().length < 10) {
      TopAlert.showAlert(_scaffoldKey.currentState.context,
          "Please enter valid phone number.", true);
    } else {
      _bloc.callApiGetOTP(context, _inputController.text.toString());
    }
  }

  void _subscribeToApiResponse() {
    StreamSubscription subscription;
    subscription = apiResponse.stream.listen((data) async {
      if (data is UserResponse) {
        userData = data.response;
        if (mounted) setState(() {});
      } else if (data is CommonApiReponse) {
        TopAlert.showAlert(
            _scaffoldKey.currentState.context, data.message, false);
        if (data.show_msg == 6) {
          var result = await pushNewScreenWithRouteSettings(context,
              screen: VerifyOTPScreen(),
              withNavBar: false,
              settings: RouteSettings(
                  arguments: "${_inputController.text.toString()}"));
          if (result != null) {
            if (result) {
              Navigator.of(context).pop(true);
            }
          }
        }
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
}
