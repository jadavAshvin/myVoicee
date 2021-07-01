class GetAllPostResponse {
  String message;
  List<AllPostResponse> response;
  int show_msg;
  bool status;

  GetAllPostResponse({this.message, this.response, this.show_msg, this.status});

  factory GetAllPostResponse.fromJson(Map<String, dynamic> json) {
    return GetAllPostResponse(
      message: json['message'],
      response: json['response'] != null
          ? (json['response'] as List)
              .map((i) => AllPostResponse.fromJson(i))
              .toList()
          : null,
      show_msg: json['show_msg'],
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    data['show_msg'] = this.show_msg;
    data['status'] = this.status;
    if (this.response != null) {
      data['response'] = this.response.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class AllPostResponse {
  String id;
  String audio;
  Duration duration;
  String created_at;
  bool is_active;
  bool is_play;
  bool is_commented;
  bool is_deleted;
  bool is_disliked;
  bool is_liked;
  bool is_shared;
  String language;
  String hash_tag;
  bool is_campaign;
  String campaign_desc;
  String campaign_img;
  int n_comments;
  int n_dislikes;
  int n_likes;
  int n_shares;
  String text;
  dynamic audio_duration;
  User user;
  String user_id;
  List<Channel> channel;

  AllPostResponse(
      {this.id,
      this.audio_duration,
      this.duration,
      this.audio,
      this.channel,
      this.created_at,
      this.campaign_img,
      this.is_campaign,
      this.campaign_desc,
      this.hash_tag,
      this.is_active,
      this.is_play,
      this.is_commented,
      this.is_deleted,
      this.is_disliked,
      this.is_liked,
      this.is_shared,
      this.language,
      this.n_comments,
      this.n_dislikes,
      this.n_likes,
      this.n_shares,
      this.text,
      this.user,
      this.user_id});

  factory AllPostResponse.fromJson(Map<String, dynamic> json) {
    return AllPostResponse(
      id: json['_id'],
      audio: json['audio'],
      channel: json['channel'] != null
          ? (json['channel'] as List).map((i) => Channel.fromJson(i)).toList()
          : null,
      campaign_desc: json['campaign_desc'],
      created_at: json['created_at'],
      is_campaign: json['is_campaign'],
      campaign_img: json['campaign_img'],
      is_active: json['is_active'],
      audio_duration: json['audio_duration'],
      hash_tag: json['hash_tag'],
      is_commented: json['is_commented'],
      is_deleted: json['is_deleted'],
      is_disliked: json['is_disliked'],
      is_liked: json['is_liked'],
      is_shared: json['is_shared'],
      language: json['language'] != null ? json['language'] : "",
      n_comments: json['n_comments'],
      n_dislikes: json['n_dislikes'],
      n_likes: json['n_likes'],
      n_shares: json['n_shares'],
      text: json['text'],
      user: json['user'] != null ? User.fromJson(json['user']) : null,
      user_id: json['user_id'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.id;
    data['audio'] = this.audio;
    data['created_at'] = this.created_at;
    data['is_active'] = this.is_active;
    data['hash_tag'] = this.hash_tag;
    data['is_campaign'] = this.is_campaign;
    data['campaign_desc'] = this.campaign_desc;
    data['campaign_img'] = this.campaign_img;
    data['is_commented'] = this.is_commented;
    data['is_deleted'] = this.is_deleted;
    data['audio_duration'] = this.audio_duration;
    data['is_disliked'] = this.is_disliked;
    data['is_liked'] = this.is_liked;
    data['is_shared'] = this.is_shared;
    data['language'] = this.language;
    data['n_comments'] = this.n_comments;
    data['n_dislikes'] = this.n_dislikes;
    data['n_likes'] = this.n_likes;
    data['n_shares'] = this.n_shares;
    data['text'] = this.text;
    data['user_id'] = this.user_id;
    if (this.user != null) {
      data['user'] = this.user.toJson();
    }
    if (this.channel != null) {
      data['response'] = this.channel.map((v) => v.toJson()).toList();
    }
    return data;
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

class Channel {
  String _id;
  String _img;
  bool _isDeleted;
  String _title;
  String _topicId;
  String _userId;
  String _createdAt;
  int _v;
  String _updatedAt;
  String _description;
  String _link;
  int _type;

  String get id => _id;

  String get img => _img;

  bool get isDeleted => _isDeleted;

  String get title => _title;

  String get topicId => _topicId;

  String get userId => _userId;

  String get createdAt => _createdAt;

  int get v => _v;

  String get updatedAt => _updatedAt;

  String get description => _description;

  String get link => _link;

  int get type => _type;

  Channel(
      {String id,
      String img,
      bool isDeleted,
      String title,
      String topicId,
      String userId,
      String createdAt,
      int v,
      String updatedAt,
      String description,
      String link,
      int type}) {
    _id = id;
    _img = img;
    _isDeleted = isDeleted;
    _title = title;
    _topicId = topicId;
    _userId = userId;
    _createdAt = createdAt;
    _v = v;
    _updatedAt = updatedAt;
    _description = description;
    _link = link;
    _type = type;
  }

  Channel.fromJson(dynamic json) {
    _id = json["_id"];
    _img = json["img"];
    _isDeleted = json["is_deleted"];
    _title = json["title"];
    _topicId = json["topic_id"];
    _userId = json["user_id"];
    _createdAt = json["created_at"];
    _v = json["__v"];
    _updatedAt = json["updated_at"];
    _description = json["description"];
    _link = json["link"];
    _type = json["type"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["_id"] = _id;
    map["img"] = _img;
    map["is_deleted"] = _isDeleted;
    map["title"] = _title;
    map["topic_id"] = _topicId;
    map["user_id"] = _userId;
    map["created_at"] = _createdAt;
    map["__v"] = _v;
    map["updated_at"] = _updatedAt;
    map["description"] = _description;
    map["link"] = _link;
    map["type"] = _type;
    return map;
  }
}
