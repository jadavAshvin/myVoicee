import 'package:twitter_login/schemes/auth_result.dart';

class TwitterCallback {
  void errors(String options) => options;

  void onTwitterLoginSuccess(AuthResult data) => data;
}
