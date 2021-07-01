/// status : true
/// message : "Login Successful"
/// response : "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJtb2JpbGUiOjg4ODg4ODg4ODg4ODAxLCJpYXQiOjE1OTY1NTU2MjN9.TXpJi7NFEuCZcC2nLcpru3tvD53dgccJr_811agdHJk"
/// auth_type : "login"

class LoginResponse {
  bool _status;
  String _message;
  String _response;
  String _authType;

  bool get status => _status;

  String get message => _message;

  String get response => _response;

  String get authType => _authType;

  LoginResponse(
      {bool status, String message, String response, String authType}) {
    _status = status;
    _message = message;
    _response = response;
    _authType = authType;
  }

  LoginResponse.fromJson(dynamic json) {
    _status = json["status"];
    _message = json["message"];
    _response = json["response"];
    _authType = json["auth_type"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["status"] = _status;
    map["message"] = _message;
    map["response"] = _response;
    map["auth_type"] = _authType;
    return map;
  }
}
