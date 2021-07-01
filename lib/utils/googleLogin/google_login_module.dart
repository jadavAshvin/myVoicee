import 'package:google_sign_in/google_sign_in.dart';

class GoogleLogin {
  GoogleLogin();

  GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: <String>['email'],
  );

  GoogleSignInAccount _currentUser;

  GoogleSignIn get googleSignIn => _googleSignIn;

  Future<void> handleSignIn() async {
    try {
      await _googleSignIn.signIn();
    } catch (error) {
      print(error);
    }
  }

  Future<void> handleSignOut() async {
    _googleSignIn.disconnect();
  }
}
