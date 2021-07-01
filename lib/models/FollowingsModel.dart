class FollowingsModel {
  bool _status;
  String _message;
  int _showMsg;
  List<Following> _response;

  bool get status => _status;

  String get message => _message;

  int get showMsg => _showMsg;

  List<Following> get response => _response;

  FollowingsModel(
      {bool status, String message, int showMsg, List<Following> response}) {
    _status = status;
    _message = message;
    _showMsg = showMsg;
    _response = response;
  }

  FollowingsModel.fromJson(dynamic json) {
    _status = json["status"];
    _message = json["message"];
    _showMsg = json["show_msg"];
    if (json["response"] != null) {
      _response = [];
      json["response"].forEach((v) {
        _response.add(Following.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["status"] = _status;
    map["message"] = _message;
    map["show_msg"] = _showMsg;
    if (_response != null) {
      map["response"] = _response.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

class Following {
  String _id;
  bool _isDeleted;
  String _userId;
  String _followerId;
  String _createdAt;
  int _v;
  User _user;

  String get id => _id;

  bool get isDeleted => _isDeleted;

  String get userId => _userId;

  String get followerId => _followerId;

  String get createdAt => _createdAt;

  int get v => _v;

  User get user => _user;

  Following(
      {String id,
      bool isDeleted,
      String userId,
      String followerId,
      String createdAt,
      int v,
      User user}) {
    _id = id;
    _isDeleted = isDeleted;
    _userId = userId;
    _followerId = followerId;
    _createdAt = createdAt;
    _v = v;
    _user = user;
  }

  Following.fromJson(dynamic json) {
    _id = json["_id"];
    _isDeleted = json["is_deleted"];
    _userId = json["user_id"];
    _followerId = json["follower_id"];
    _createdAt = json["created_at"];
    _v = json["__v"];
    _user = json["user"] != null ? User.fromJson(json["user"]) : null;
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["_id"] = _id;
    map["is_deleted"] = _isDeleted;
    map["user_id"] = _userId;
    map["follower_id"] = _followerId;
    map["created_at"] = _createdAt;
    map["__v"] = _v;
    if (_user != null) {
      map["user"] = _user.toJson();
    }
    return map;
  }
}

class User {
  String _id;
  String _username;
  String _dp;
  String _name;
  String _email;

  String get id => _id;

  String get username => _username;

  String get dp => _dp;

  String get name => _name;

  String get email => _email;

  User({String id, String username, String dp, String name, String email}) {
    _id = id;
    _username = username;
    _dp = dp;
    _name = name;
    _email = email;
  }

  User.fromJson(dynamic json) {
    _id = json["_id"];
    _username = json["username"];
    _dp = json["dp"];
    _name = json["name"];
    _email = json["email"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["_id"] = _id;
    map["username"] = _username;
    map["dp"] = _dp;
    map["name"] = _name;
    map["email"] = _email;
    return map;
  }
}
