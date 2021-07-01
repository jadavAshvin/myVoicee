import 'dart:io';

import 'package:my_voicee/constants/app_constants.dart';
import 'package:my_voicee/utils/twitterLogin/twitter_callback.dart';
import 'package:twitter_login/schemes/auth_result.dart';
import 'package:twitter_login/twitter_login.dart';

class TwitterLoginKit {
  TwitterLogin twitterLogin = new TwitterLogin(
      apiKey: clientKeyTwitter,
      apiSecretKey: clientSecretTwitter,
      redirectURI: Platform.isIOS
          ? "twitterkit-c2ENUxCmNoYDhvY43fxaHuIH6://"
          : "twittersdk://");

  TwitterCallback twitterCallback;

  TwitterLoginKit(TwitterCallback twitterCallback) {
    this.twitterCallback = twitterCallback;
  }

  twitterLoginInit() async {
    final AuthResult result = await twitterLogin.login();

    switch (result.status) {
      case TwitterLoginStatus.loggedIn:
        twitterCallback.onTwitterLoginSuccess(result);
        break;
      case TwitterLoginStatus.cancelledByUser:
        twitterCallback.errors('Login process canceled by User.');
        break;
      case TwitterLoginStatus.error:
        twitterCallback.errors(result.errorMessage);
        break;
    }
  }
}
