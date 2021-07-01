class AllTopicsModel {
  bool _status;
  int _showMsg;
  String _message;
  List<Topics> _response;

  bool get status => _status;

  int get showMsg => _showMsg;

  String get message => _message;

  List<Topics> get response => _response;

  AllTopicsModel(
      {bool status, int showMsg, String message, List<Topics> response}) {
    _status = status;
    _showMsg = showMsg;
    _message = message;
    _response = response;
  }

  AllTopicsModel.fromJson(dynamic json) {
    _status = json["status"];
    _showMsg = json["show_msg"];
    _message = json["message"];
    if (json["response"] != null) {
      _response = [];
      json["response"].forEach((v) {
        _response.add(Topics.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["status"] = _status;
    map["show_msg"] = _showMsg;
    map["message"] = _message;
    if (_response != null) {
      map["response"] = _response.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

class Topics {
  String _id;
  String _img;
  bool _isDeleted;
  String _title;
  String _createdAt;
  int _v;
  int _n_posts;
  bool _isChoosed;

  String get id => _id;

  String get img => _img;

  bool get isDeleted => _isDeleted;

  String get title => _title;

  int get n_posts => _n_posts;

  String get createdAt => _createdAt;

  int get v => _v;

  bool get isChoosed => _isChoosed;

  set isChoosed(bool value) {
    _isChoosed = value;
  }

  Topics(
      {String id,
      String img,
      bool isDeleted,
      int n_posts,
      String title,
      String createdAt,
      int v,
      bool isChoosed}) {
    _id = id;
    _n_posts = n_posts;
    _img = img;
    _isDeleted = isDeleted;
    _title = title;
    _createdAt = createdAt;
    _v = v;
    _isChoosed = isChoosed;
  }

  Topics.fromJson(dynamic json) {
    _id = json["_id"];
    _img = json["img"];
    _n_posts = json["n_posts"];
    _isDeleted = json["is_deleted"];
    _title = json["title"];
    _createdAt = json["created_at"];
    _v = json["__v"];
    _isChoosed = json["is_choosed"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["_id"] = _id;
    map["img"] = _img;
    map["is_deleted"] = _isDeleted;
    map["n_posts"] = _n_posts;
    map["title"] = _title;
    map["created_at"] = _createdAt;
    map["__v"] = _v;
    map["is_choosed"] = _isChoosed;
    return map;
  }
}
