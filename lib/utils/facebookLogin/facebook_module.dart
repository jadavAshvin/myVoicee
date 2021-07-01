import 'dart:convert';

import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:http/http.dart' as http;
import 'package:my_voicee/constants/app_constants.dart';
import 'package:my_voicee/utils/Utility.dart';
import 'package:my_voicee/utils/facebookLogin/facebook_callbacks.dart';

class Facebook {
  FacebookCallback facebookCallback;

  Facebook(FacebookCallback facebookCallback) {
    this.facebookCallback = facebookCallback;
  }

  facebookLogin() async {
    var facebookLog = FacebookLogin();
    var facebookLoginResult =
        await facebookLog.logIn(['public_profile', 'email']);
    switch (facebookLoginResult.status) {
      case FacebookLoginStatus.error:
        facebookCallback.onFBLoginError(facebookLoginResult.errorMessage);
        await facebookLog.logOut();
        break;
      case FacebookLoginStatus.cancelledByUser:
        facebookCallback.onFBLoginError('Login process canceled by User.');
        await facebookLog.logOut();
        break;
      case FacebookLoginStatus.loggedIn:
        writeStringDataLocally(
            key: fbStringToken, value: facebookLoginResult.accessToken.token);
        var graphResponse = await http.get(
            'https://graph.facebook.com/v2.12/me?fields=name,first_name,last_name,email&access_token=${facebookLoginResult.accessToken.token}');
        Map profile = json.decode(graphResponse.body);
        profile.putIfAbsent(
            'access_token', () => facebookLoginResult.accessToken.token);
        facebookCallback.facebookSuccess(profile);
        await facebookLog.logOut();
        break;
    }
  }
}

logoutFacebook() async {
  return await FacebookLogin().logOut();
}
