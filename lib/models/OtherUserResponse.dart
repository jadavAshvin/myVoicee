class OtherUserResponse {
  bool _status;
  String _message;
  ProfileResponse _response;

  bool get status => _status;

  String get message => _message;

  ProfileResponse get response => _response;

  OtherUserResponse({bool status, String message, ProfileResponse response}) {
    _status = status;
    _message = message;
    _response = response;
  }

  OtherUserResponse.fromJson(dynamic json) {
    _status = json["status"];
    _message = json["message"];
    _response = json["response"] != null
        ? ProfileResponse.fromJson(json["response"])
        : null;
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["status"] = _status;
    map["message"] = _message;
    if (_response != null) {
      map["response"] = _response.toJson();
    }
    return map;
  }
}

class ProfileResponse {
  String _id;
  String _username;
  String _dp;
  String _name;
  String _email;
  String _bio;
  bool _following;
  bool is_publisher;

  set following(bool value) {
    _following = value;
  }

  String get id => _id;

  String get username => _username;

  bool get following => _following;

  String get dp => _dp;

  String get name => _name;

  String get email => _email;

  String get bio => _bio;

  ProfileResponse(
      {String id,
      String username,
      bool following,
      bool is_publisher,
      String dp,
      String name,
      String email,
      String bio}) {
    _id = id;
    _username = username;
    _dp = dp;
    _following = following;
    _name = name;
    _email = email;
    _bio = bio;
  }

  ProfileResponse.fromJson(dynamic json) {
    _id = json["_id"];
    _username = json["username"];
    _following = json["is_following"];
    is_publisher = json["is_publisher"];
    _dp = json["dp"];
    _name = json["name"];
    _email = json["email"];
    _bio = json["bio"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["_id"] = _id;
    map["username"] = _username;
    map["is_publisher"] = is_publisher;
    map["is_following"] = _following;
    map["dp"] = _dp;
    map["name"] = _name;
    map["email"] = _email;
    map["bio"] = _bio;
    return map;
  }
}
