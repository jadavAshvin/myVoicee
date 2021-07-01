class FollowersModel {
  bool _status;
  String _message;
  int _showMsg;
  List<FollowersData> _response;

  bool get status => _status;

  String get message => _message;

  int get showMsg => _showMsg;

  List<FollowersData> get response => _response;

  FollowersModel(
      {bool status,
      String message,
      int showMsg,
      List<FollowersData> response}) {
    _status = status;
    _message = message;
    _showMsg = showMsg;
    _response = response;
  }

  FollowersModel.fromJson(dynamic json) {
    _status = json["status"];
    _message = json["message"];
    _showMsg = json["show_msg"];
    if (json["response"] != null) {
      _response = [];
      json["response"].forEach((v) {
        _response.add(FollowersData.fromJson(v));
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

class FollowersData {
  String _id;
  bool _isDeleted;
  String _userId;
  String _followerId;
  String _createdAt;
  int _v;
  Followers _followers;

  String get id => _id;

  bool get isDeleted => _isDeleted;

  String get userId => _userId;

  String get followerId => _followerId;

  String get createdAt => _createdAt;

  int get v => _v;

  Followers get followers => _followers;

  FollowersData(
      {String id,
      bool isDeleted,
      String userId,
      String followerId,
      String createdAt,
      int v,
      Followers followers}) {
    _id = id;
    _isDeleted = isDeleted;
    _userId = userId;
    _followerId = followerId;
    _createdAt = createdAt;
    _v = v;
    _followers = followers;
  }

  FollowersData.fromJson(dynamic json) {
    _id = json["_id"];
    _isDeleted = json["is_deleted"];
    _userId = json["user_id"];
    _followerId = json["follower_id"];
    _createdAt = json["created_at"];
    _v = json["__v"];
    _followers = json["followers"] != null
        ? Followers.fromJson(json["followers"])
        : null;
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["_id"] = _id;
    map["is_deleted"] = _isDeleted;
    map["user_id"] = _userId;
    map["follower_id"] = _followerId;
    map["created_at"] = _createdAt;
    map["__v"] = _v;
    if (_followers != null) {
      map["followers"] = _followers.toJson();
    }
    return map;
  }
}

class Followers {
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

  Followers(
      {String id, String username, String dp, String name, String email}) {
    _id = id;
    _username = username;
    _dp = dp;
    _name = name;
    _email = email;
  }

  Followers.fromJson(dynamic json) {
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
