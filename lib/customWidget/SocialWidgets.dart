import 'dart:io';

import 'package:flutter/material.dart';
import 'package:my_voicee/constants/app_colors.dart';
import 'package:my_voicee/constants/app_images_path.dart';
import 'package:my_voicee/customWidget/SocialMediaCustomButton.dart';
import 'package:my_voicee/utils/socialMedia/SocialMediaClickListeners.dart';

class SocialWidget extends StatelessWidget {
  final SocilaMediaClickListeners _socilaMediaClickListeners;
  final bool valuefirst;

  SocialWidget(this._socilaMediaClickListeners, this.valuefirst);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Platform.isIOS
            ? Padding(
                padding: EdgeInsets.all(6),
                child: SocialMediaCustomButton(
                  btnText: 'Sign in with Apple',
                  buttonColor: colorBlack,
                  enable: valuefirst,
                  size: 18.0,
                  image: apple,
                  textColor: colorWhite,
                  splashColor: hintColor,
                  onPressed: _socilaMediaClickListeners.onAppleClick,
                ),
              )
            : Container(),
        Padding(
          padding: EdgeInsets.all(6),
          child: SocialMediaCustomButton(
            btnText: 'Login with Facebook',
            buttonColor: colorFacebookBtn,
            size: 18.0,
            enable: valuefirst,
            image: ic_facebook,
            textColor: colorWhite,
            splashColor: colorFacebookBtnSplash,
            onPressed: _socilaMediaClickListeners.onFBClick,
          ),
        ),
        Padding(
          padding: EdgeInsets.all(6),
          child: SocialMediaCustomButton(
            btnText: 'Login with Twitter',
            buttonColor: colorTwitterBtn,
            enable: valuefirst,
            size: 18.0,
            image: ic_twitter,
            textColor: colorWhite,
            splashColor: colorTwitterBtnSplash,
            onPressed: _socilaMediaClickListeners.onTwitterClick,
          ),
        ),
        Padding(
          padding: EdgeInsets.all(6),
          child: SocialMediaCustomButton(
            btnText: 'Login with Google',
            buttonColor: colorGoogleBtn,
            enable: valuefirst,
            size: 18.0,
            image: google_plus,
            textColor: colorWhite,
            splashColor: colorGoogleBtnSplash,
            onPressed: _socilaMediaClickListeners.onGoogleClick,
          ),
        ),
      ],
    );
  }
}
