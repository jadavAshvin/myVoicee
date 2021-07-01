class ReActionResponse {
  String message;
  List<ReActionItemModel> response;
  int show_msg;
  bool status;

  ReActionResponse({this.message, this.response, this.show_msg, this.status});

  factory ReActionResponse.fromJson(Map<String, dynamic> json) {
    return ReActionResponse(
      message: json['message'],
      response: json['response'] != null
          ? (json['response'] as List)
              .map((i) => ReActionItemModel.fromJson(i))
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

class ReActionItemModel {
  String id;
  String comment;
  String created_at;
  Duration duration;
  bool is_deleted;
  String post_id;
  String comment_url;
  dynamic audio_duration;
  User user;
  String user_id;
  bool is_play;

  ReActionItemModel(
      {this.id,
      this.is_play,
      this.comment,
      this.duration,
      this.audio_duration,
      this.comment_url,
      this.created_at,
      this.is_deleted,
      this.post_id,
      this.user,
      this.user_id});

  factory ReActionItemModel.fromJson(Map<String, dynamic> json) {
    return ReActionItemModel(
      id: json['_id'],
      comment: json['comment'],
      comment_url: json['comment_url'],
      audio_duration: json['audio_duration'],
      created_at: json['created_at'],
      is_deleted: json['is_deleted'],
      post_id: json['post_id'],
      user: json['user'] != null ? User.fromJson(json['user']) : null,
      user_id: json['user_id'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.id;
    data['comment'] = this.comment;
    data['created_at'] = this.created_at;
    data['audio_duration'] = this.audio_duration;
    data['is_deleted'] = this.is_deleted;
    data['comment_url'] = this.comment_url;
    data['post_id'] = this.post_id;
    data['user_id'] = this.user_id;
    if (this.user != null) {
      data['user'] = this.user.toJson();
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

  User({this.id, this.bio, this.dp, this.name, this.username});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'],
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
    data['dp'] = this.dp;
    data['name'] = this.name;
    data['username'] = this.username;
    return data;
  }
}
