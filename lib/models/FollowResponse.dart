class FollowResponse {
  bool _status;
  String _message;
  int _showMsg;
  Response _response;

  bool get status => _status;

  String get message => _message;

  int get showMsg => _showMsg;

  Response get response => _response;

  FollowResponse(
      {bool status, String message, int showMsg, Response response}) {
    _status = status;
    _message = message;
    _showMsg = showMsg;
    _response = response;
  }

  FollowResponse.fromJson(dynamic json) {
    _status = json["status"];
    _message = json["message"];
    _showMsg = json["show_msg"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["status"] = _status;
    map["message"] = _message;
    map["show_msg"] = _showMsg;
    if (_response != null) {
      map["response"] = _response.toJson();
    }
    return map;
  }
}

class Response {
  bool _isDeleted;
  String _id;
  String _userId;
  String _followerId;
  String _createdAt;
  int _v;

  bool get isDeleted => _isDeleted;

  String get id => _id;

  String get userId => _userId;

  String get followerId => _followerId;

  String get createdAt => _createdAt;

  int get v => _v;

  Response(
      {bool isDeleted,
      String id,
      String userId,
      String followerId,
      String createdAt,
      int v}) {
    _isDeleted = isDeleted;
    _userId = userId;
    _followerId = followerId;
    _createdAt = createdAt;
    _v = v;
    _id = id;
  }

  Response.fromJson(dynamic json) {
    _isDeleted = json["is_deleted"];
    _id = json["_id"];
    _userId = json["user_id"];
    _followerId = json["follower_id"];
    _createdAt = json["created_at"];
    _v = json["__v"];
    _id = json["id"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["is_deleted"] = _isDeleted;
    map["_id"] = _id;
    map["user_id"] = _userId;
    map["follower_id"] = _followerId;
    map["created_at"] = _createdAt;
    map["__v"] = _v;
    map["id"] = _id;
    return map;
  }
}
