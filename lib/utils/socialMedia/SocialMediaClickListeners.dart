import 'package:my_voicee/utils/socialMedia/SocialUserModel.dart';

abstract class SocilaMediaClickListeners {
  void onTwitterClick();

  void onFBClick();

  void onGoogleClick();

  void onAppleClick();

  void userData(SocialUserModel userDataModel);
}
