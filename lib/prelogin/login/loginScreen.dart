import 'dart:async';
import 'dart:io';

import 'package:apple_sign_in/apple_sign_in.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fm_fit/fm_fit.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:my_voicee/constants/app_colors.dart';
import 'package:my_voicee/constants/app_constants.dart';
import 'package:my_voicee/constants/app_images_path.dart';
import 'package:my_voicee/customWidget/Alert/top_alert.dart';
import 'package:my_voicee/customWidget/SocialWidgets.dart';
import 'package:my_voicee/customWidget/appLoader/custom_progress_loader.dart';
import 'package:my_voicee/models/DistrictAcPc.dart';
import 'package:my_voicee/models/LoginResponse.dart';
import 'package:my_voicee/models/UserResponse.dart';
import 'package:my_voicee/models/errorResponse/customeError.dart';
import 'package:my_voicee/models/errorResponse/error_reponse.dart';
import 'package:my_voicee/network/DioApiConfiguration.dart';
import 'package:my_voicee/prelogin/TermsOfUseNew.dart';
import 'package:my_voicee/prelogin/WebViewTermsPrivacy.dart';
import 'package:my_voicee/prelogin/login/loginbloc/LoginValidationBloc.dart';
import 'package:my_voicee/utils/Utility.dart';
import 'package:my_voicee/utils/facebookLogin/facebook_callbacks.dart';
import 'package:my_voicee/utils/facebookLogin/facebook_module.dart';
import 'package:my_voicee/utils/googleLogin/google_login_module.dart';
import 'package:my_voicee/utils/socialMedia/SocialMediaClickListeners.dart';
import 'package:my_voicee/utils/socialMedia/SocialUserModel.dart';
import 'package:my_voicee/utils/twitterLogin/twitter_callback.dart';
import 'package:my_voicee/utils/twitterLogin/twitter_login_module.dart';
import 'package:twitter_login/schemes/auth_result.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with
        TwitterCallback,
        TickerProviderStateMixin,
        SocilaMediaClickListeners,
        FacebookCallback {
  // var _screenFocusNode = FocusNode();
  GoogleSignInAccount _currentUser;
  var _scaffoldKey = GlobalKey<ScaffoldState>();
  LoginValidationBloc validation;
  StreamController apiResponseController;
  FmFit fit = FmFit(width: 750);

  Map facebookMap;

  bool valuefirst = false;

  @override
  void initState() {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);
    apiResponseController = StreamController();
    validation = LoginValidationBloc(apiResponseController);
    _subscribeToApiResponse();
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
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      body: Stack(
        children: <Widget>[
          LayoutBuilder(
            builder:
                (BuildContext context, BoxConstraints viewportConstraints) {
              return SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: viewportConstraints.maxHeight,
                  ),
                  child: Center(
                    child: Container(
                      margin: EdgeInsets.only(left: 24.0, right: 24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          _widgetAppLogo(),
                          SizedBox(
                            height: MediaQuery.of(context).size.height / 6.0,
                          ),
                          SocialWidget(this, valuefirst),
                          _termsOfUseWidget()
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
          StreamBuilder<Object>(
            stream: validation.progressLoaderStream,
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

  //App Logo widget
  Widget _widgetAppLogo() {
    return Center(
      child: Container(
        padding: EdgeInsets.only(top: fit.t(60.0)),
        child: Image.asset(
          logo_blue,
          width: MediaQuery.of(context).size.width,
          height: fit.t(200.0),
        ),
      ),
    );
  }

  //listen to api response
  void _subscribeToApiResponse() {
    StreamSubscription subscription;
    subscription = apiResponseController.stream.listen((data) {
      if (data is LoginResponse) {
        ApiDioConfiguration.createNullConfiguration(
            ConfigConfig('${data.response}', true));
        apiGetProfile(data.authType);
      } else if (data is UserResponse) {
        if (data.response.is_approved == 1) {
          if (data.authType == "login") {
            validation.callApiGetCountries(context);
          } else {
            Navigator.pushReplacementNamed(context, '/termsOfUse');
          }
        } else {
          Navigator.pushNamedAndRemoveUntil(
              context, '/waitingScreen', ModalRoute.withName('/'));
        }
      } else if (data is DistrictAcPc) {
        Navigator.pushNamedAndRemoveUntil(
            context, '/masterDashboard', ModalRoute.withName('/'));
      } else if (data is ErrorResponse) {
        if (data.show_msg == 1) {
          if (data.authType != null) {
            if (data.authType == "login") {
              Navigator.pushReplacementNamed(context, '/waitingScreen');
            } else {
              Navigator.pushReplacementNamed(context, '/termsOfUse');
            }
          } else {
            TopAlert.showAlert(
                _scaffoldKey.currentState.context, data.message, true);
          }
        } else {
          TopAlert.showAlert(
              _scaffoldKey.currentState.context, data.message, true);
        }
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

  @override
  void dispose() {
    validation?.dispose();
    apiResponseController?.close();
    super.dispose();
  }

  @override
  void onAppleClick() async {
    if (valuefirst) {
      validation.showProgressLoader(true);
      if (await AppleSignIn.isAvailable()) {
        final AuthorizationResult result = await AppleSignIn.performRequests([
          AppleIdRequest(requestedScopes: [
            Scope.email,
            Scope.fullName,
          ])
        ]);

        switch (result.status) {
          case AuthorizationStatus.authorized:
            validation.showProgressLoader(false);
            Map<String, dynamic> map = Map();
            map.putIfAbsent("email", () => result.credential.email);
            map.putIfAbsent("apple_id", () => result.credential.user);
            map.putIfAbsent("name", () => result.credential.fullName.givenName);
            validation.submitLogin(map, context, isApple);
            break;
          case AuthorizationStatus.error:
            validation.showProgressLoader(false);
            // print("Sign in failed: ${result.error.localizedDescription}");
            break;
          case AuthorizationStatus.cancelled:
            validation.showProgressLoader(false);
            // print('User cancelled');
            break;
        }
      } else {
        print('Apple SignIn is not available for your device');
      }
    } else {
      TopAlert.showAlert(
          context,
          "Please accept terms of use and privacy policy by clicking on checkbox.",
          true);
    }
  }

  @override
  void onFBClick() {
    if (valuefirst) {
      _handleFacebookLogin();
    } else {
      TopAlert.showAlert(
          context,
          "Please accept terms of use and privacy policy by clicking on checkbox.",
          true);
    }
  }

  void _handleFacebookLogin() {
    Facebook instance = Facebook(this);
    instance.facebookLogin();
  }

  @override
  void facebookSuccess(Map data) {
    validation.showProgressLoader(false);
    Map<String, dynamic> bundle = Map();
    bundle.putIfAbsent("access_token", () => data['access_token']);
    validation.submitLogin(
        bundle, _scaffoldKey.currentState.context, isFacebook);
  }

  @override
  void onFBLoginError(String error) {
    print(error);
    validation.showProgressLoader(false);
    TopAlert.showAlert(context, error, true);
  }

  @override
  void onGoogleClick() {
    if (valuefirst) {
      _handleGoogleLogin();
    } else {
      TopAlert.showAlert(
          context,
          "Please accept terms of use and privacy policy by clicking on checkbox.",
          true);
    }
  }

  void _handleGoogleLogin() async {
    var googleLoginInstance = GoogleLogin();
    googleLoginInstance.handleSignIn();
    googleLoginInstance.googleSignIn.onCurrentUserChanged
        .listen((GoogleSignInAccount account) {
      setState(() {
        _currentUser = account;
        if (_currentUser != null) {
          Map<String, dynamic> bundle = Map();
          account.authentication.then((value) {
            bundle.putIfAbsent("access_token", () => value.idToken);
            validation.submitLogin(
                bundle, _scaffoldKey.currentState.context, isGoogle);
          });
          validation.showProgressLoader(false);
        }
      });
    });
    bool isSignedIn = await googleLoginInstance.googleSignIn.isSignedIn();
    if (isSignedIn) await googleLoginInstance.googleSignIn.signOut();
  }

  @override
  void onTwitterClick() {
    if (valuefirst) {
      _handleTwitterLogin();
    } else {
      TopAlert.showAlert(
          context,
          "Please accept terms of use and privacy policy by clicking on checkbox.",
          true);
    }
  }

  void _handleTwitterLogin() {
    TwitterLoginKit twitterLoginKit = TwitterLoginKit(this);
    twitterLoginKit.twitterLoginInit();
    validation.showProgressLoader(true);
  }

  @override
  void onTwitterLoginSuccess(AuthResult data) {
    Map<String, dynamic> bundle = Map();
    bundle.putIfAbsent("access_token", () => data.authToken);
    bundle.putIfAbsent("secret", () => data.authTokenSecret);
    validation.showProgressLoader(false);
    validation.submitLogin(
        bundle, _scaffoldKey.currentState.context, isTWitter);
  }

  @override
  void errors(String error) {
    validation.showProgressLoader(false);
    TopAlert.showAlert(context, error, true);
  }

  @override
  void userData(SocialUserModel userDataModel) {}

  void apiGetProfile(String authType) {
    validation.getUserProfile(_scaffoldKey.currentState.context, authType);
  }

  Widget _termsOfUseWidget() {
    return Container(
      margin: EdgeInsets.only(
          bottom: Platform.isAndroid ? fit.t(10.0) : fit.t(50.0)),
      child: Align(
        alignment: Alignment.lerp(Alignment.center, Alignment.center, 0.2),
        child: Container(
          margin: EdgeInsets.only(top: fit.t(20.0)),
          child: Row(
            children: [
              Checkbox(
                checkColor: Colors.white,
                activeColor: appColor,
                value: this.valuefirst,
                onChanged: (bool value) {
                  setState(() {
                    this.valuefirst = value;
                  });
                },
              ),
              RichText(
                softWrap: true,
                textAlign: TextAlign.center,
                text: TextSpan(
                  text: "I agree to the ",
                  style: TextStyle(
                      fontFamily: "Roboto",
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                      decoration: TextDecoration.none,
                      fontSize: fit.t(14.0)),
                  children: <TextSpan>[
                    TextSpan(
                      text: 'Terms of use',
                      style: TextStyle(
                          fontFamily: "Roboto",
                          color: appColor,
                          decoration: TextDecoration.underline,
                          fontWeight: FontWeight.w500,
                          fontSize: fit.t(14.0)),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          //privacy policy
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => TermsOfUseOther()));
                        },
                    ),
                    TextSpan(
                        text: ' | ',
                        style: TextStyle(
                            fontFamily: "Roboto",
                            color: colorBlack,
                            decoration: TextDecoration.none,
                            fontSize: fit.t(14.0))),
                    TextSpan(
                      text: 'Privacy policy',
                      style: TextStyle(
                          fontFamily: "Roboto",
                          color: appColor,
                          decoration: TextDecoration.underline,
                          fontWeight: FontWeight.w500,
                          fontSize: fit.t(14.0)),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          //privacy policy
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => WebViewTermsPrivacy(
                                      url:
                                          'https://voicee.co/privacy_policy.html',
                                      title: "Privacy policy")));
                        },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
