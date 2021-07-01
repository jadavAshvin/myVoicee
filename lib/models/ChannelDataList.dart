class ChannelDataList {
  bool _status;
  String _message;
  int _showMsg;
  List<Channels> _response;

  bool get status => _status;

  String get message => _message;

  int get showMsg => _showMsg;

  List<Channels> get response => _response;

  ChannelDataList(
      {bool status, String message, int showMsg, List<Channels> response}) {
    _status = status;
    _message = message;
    _showMsg = showMsg;
    _response = response;
  }

  ChannelDataList.fromJson(dynamic json) {
    _status = json["status"];
    _message = json["message"];
    _showMsg = json["show_msg"];
    if (json["response"] != null) {
      _response = [];
      json["response"].forEach((v) {
        _response.add(Channels.fromJson(v));
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

class Channels {
  String _id;
  String _img;
  bool _isDeleted;
  String _title;
  String _desc;
  String _topicId;
  String _userId;
  int _type;
  String _createdAt;
  int _v;
  Topic _topic;

  String get id => _id;

  String get img => _img;

  int get type => _type;

  bool get isDeleted => _isDeleted;

  String get title => _title;

  String get desc => _desc;

  String get topicId => _topicId;

  String get userId => _userId;

  String get createdAt => _createdAt;

  int get v => _v;

  Topic get topic => _topic;

  Channels(
      {String id,
      String img,
      bool isDeleted,
      int type,
      String title,
      String topicId,
      String userId,
      String desc,
      String createdAt,
      int v,
      Topic topic}) {
    _id = id;
    _img = img;
    _isDeleted = isDeleted;
    _type = type;
    _title = title;
    _desc = desc;
    _topicId = topicId;
    _userId = userId;
    _createdAt = createdAt;
    _v = v;
    _topic = topic;
  }

  Channels.fromJson(dynamic json) {
    _id = json["_id"];
    _img = json["img"];
    _desc = json["description"];
    _type = json["type"];
    _isDeleted = json["is_deleted"];
    _title = json["title"];
    _topicId = json["topic_id"];
    _userId = json["user_id"];
    _createdAt = json["created_at"];
    _v = json["__v"];
    _topic = json["topic"] != null ? Topic.fromJson(json["topic"]) : null;
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["_id"] = _id;
    map["img"] = _img;
    map["type"] = _type;
    map["is_deleted"] = _isDeleted;
    map["title"] = _title;
    map["description"] = _desc;
    map["topic_id"] = _topicId;
    map["user_id"] = _userId;
    map["created_at"] = _createdAt;
    map["__v"] = _v;
    if (_topic != null) {
      map["topic"] = _topic.toJson();
    }
    return map;
  }
}

class Topic {
  String _id;
  String _img;
  bool _isDeleted;
  String _title;
  String _createdAt;
  int _v;
  int _nPosts;
  String _updatedAt;

  String get id => _id;

  String get img => _img;

  bool get isDeleted => _isDeleted;

  String get title => _title;

  String get createdAt => _createdAt;

  int get v => _v;

  int get nPosts => _nPosts;

  String get updatedAt => _updatedAt;

  Topic(
      {String id,
      String img,
      bool isDeleted,
      String title,
      String createdAt,
      int v,
      int nPosts,
      String updatedAt}) {
    _id = id;
    _img = img;
    _isDeleted = isDeleted;
    _title = title;
    _createdAt = createdAt;
    _v = v;
    _nPosts = nPosts;
    _updatedAt = updatedAt;
  }

  Topic.fromJson(dynamic json) {
    _id = json["_id"];
    _img = json["img"];
    _isDeleted = json["is_deleted"];
    _title = json["title"];
    _createdAt = json["created_at"];
    _v = json["__v"];
    _nPosts = json["n_posts"];
    _updatedAt = json["updated_at"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["_id"] = _id;
    map["img"] = _img;
    map["is_deleted"] = _isDeleted;
    map["title"] = _title;
    map["created_at"] = _createdAt;
    map["__v"] = _v;
    map["n_posts"] = _nPosts;
    map["updated_at"] = _updatedAt;
    return map;
  }
}
