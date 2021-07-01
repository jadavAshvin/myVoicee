class NotificationModel {
  bool _status;
  String _message;
  List<Notifications> _response;

  bool get status => _status;

  String get message => _message;

  List<Notifications> get response => _response;

  NotificationModel(
      {bool status, String message, List<Notifications> response}) {
    _status = status;
    _message = message;
    _response = response;
  }

  NotificationModel.fromJson(dynamic json) {
    _status = json["status"];
    _message = json["message"];
    if (json["response"] != null) {
      _response = [];
      json["response"].forEach((v) {
        _response.add(Notifications.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["status"] = _status;
    map["message"] = _message;
    if (_response != null) {
      map["response"] = _response.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

class Notifications {
  String _id;
  String _title;
  String _body;
  String _type;
  String _page;
  Others _others;
  String _createdAt;
  int _v;
  User _user;

  String get id => _id;

  User get user => _user;

  String get title => _title;

  String get body => _body;

  String get type => _type;

  String get page => _page;

  Others get others => _others;

  String get createdAt => _createdAt;

  int get v => _v;

  Notifications(
      {String id,
      String title,
      String body,
      String type,
      String page,
      User users,
      Others others,
      String createdAt,
      int v}) {
    _id = id;
    _title = title;
    _body = body;
    _type = type;
    _page = page;
    _others = others;
    _user = users;
    _createdAt = createdAt;
    _v = v;
  }

  Notifications.fromJson(dynamic json) {
    _id = json["_id"];
    _title = json["title"];
    _body = json["body"];
    _type = json["type"];
    _page = json["page"];
    _others = json["others"] != null ? Others.fromJson(json["others"]) : null;
    _user = json['user'] != null ? User.fromJson(json['user']) : null;
    _createdAt = json["created_at"];
    _v = json["__v"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["_id"] = _id;
    map["title"] = _title;
    map["body"] = _body;
    map["type"] = _type;
    map["page"] = _page;
    if (_others != null) {
      map["others"] = _others.toJson();
    }
    if (_others != null) {
      map["user"] = _user.toJson();
    }
    map["created_at"] = _createdAt;
    map["__v"] = _v;
    return map;
  }
}

class Others {
  String _requestId;

  String get requestId => _requestId;

  Others({String requestId}) {
    _requestId = requestId;
  }

  Others.fromJson(dynamic json) {
    _requestId = json["request_id"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["request_id"] = _requestId;
    return map;
  }
}

class User {
  String id;
  String bio;
  String dp;
  String name;
  String username;
  bool is_publisher;

  User(
      {this.id,
      this.bio,
      this.dp,
      this.name,
      this.username,
      this.is_publisher});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'],
      is_publisher: json['is_publisher'],
      bio: json['bio'],
      dp: json['dp'],
      name: json['name'],
      username: json['username'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.id;
    data['bio'] = this.bio;
    data['is_publisher'] = this.is_publisher;
    data['dp'] = this.dp;
    data['name'] = this.name;
    data['username'] = this.username;
    return data;
  }
}
