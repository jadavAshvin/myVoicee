class ReplyPostListModel {
  bool status;
  int showMsg;
  String message;
  List<ResponseReplyModel> response;

  ReplyPostListModel(
      {bool status,
      int showMsg,
      String message,
      List<ResponseReplyModel> response}) {
    this.status = status;
    this.showMsg = showMsg;
    this.message = message;
    this.response = response;
  }

  ReplyPostListModel.fromJson(dynamic json) {
    this.status = json["status"];
    this.showMsg = json["show_msg"];
    this.message = json["message"];
    if (json["response"] != null) {
      this.response = [];
      json["response"].forEach((v) {
        this.response.add(ResponseReplyModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["status"] = status;
    map["show_msg"] = showMsg;
    map["message"] = message;
    if (response != null) {
      map["response"] = response.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

class ResponseReplyModel {
  String id;
  bool isDeleted;
  bool is_play;
  String comment;
  String commentUrl;
  dynamic audioDuration;
  String postId;
  String userId;
  String createdAt;
  int nLikes;
  int nShares;
  String language;
  int nDislikes;
  User user;
  bool isLiked;
  bool isShared;
  bool isDisliked;
  Duration duration;

  ResponseReplyModel(
      {String id,
      bool isDeleted,
      bool is_play,
      String comment,
      String commentUrl,
      dynamic audioDuration,
      Duration duration,
      String postId,
      String userId,
      String createdAt,
      int nLikes,
      int nShares,
      String language,
      int nDislikes,
      List<String> userLiked,
      List<String> userShared,
      List<String> userDislike,
      User user,
      bool isLiked,
      bool isShared,
      bool isDisliked}) {
    this.id = id;
    this.is_play = is_play;
    this.duration = duration;
    this.isDeleted = isDeleted;
    this.comment = comment;
    this.commentUrl = commentUrl;
    this.audioDuration = audioDuration;
    this.postId = postId;
    this.userId = userId;
    this.createdAt = createdAt;
    this.nLikes = nLikes;
    this.nShares = nShares;
    this.language = language;
    this.nDislikes = nDislikes;
    this.user = user;
    this.isLiked = isLiked;
    this.isShared = isShared;
    this.isDisliked = isDisliked;
  }

  ResponseReplyModel.fromJson(dynamic json) {
    this.id = json["_id"];
    this.isDeleted = json["is_deleted"];
    this.comment = json["comment"];
    this.commentUrl = json["comment_url"];
    this.audioDuration = json["audio_duration"];
    this.postId = json["post_id"];
    this.userId = json["user_id"];
    this.createdAt = json["created_at"];
    this.nLikes = json["n_likes"];
    this.nShares = json["n_shares"];
    this.language = json["language"];
    this.nDislikes = json["n_dislikes"];
    this.user = json["user"] != null ? User.fromJson(json["user"]) : null;
    this.isLiked = json["is_liked"];
    this.isShared = json["is_shared"];
    this.isDisliked = json["is_disliked"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["_id"] = id;
    map["is_deleted"] = isDeleted;
    map["comment"] = comment;
    map["comment_url"] = commentUrl;
    map["audio_duration"] = audioDuration;
    map["post_id"] = postId;
    map["user_id"] = userId;
    map["created_at"] = createdAt;
    map["n_likes"] = nLikes;
    map["n_shares"] = nShares;
    map["language"] = language;
    map["n_dislikes"] = nDislikes;
    if (user != null) {
      map["user"] = user.toJson();
    }
    map["is_liked"] = isLiked;
    map["is_shared"] = isShared;
    map["is_disliked"] = isDisliked;
    return map;
  }
}

class User {
  String name;
  String username;
  String dp;
  String bio;
  String id;

  User({String name, String username, String dp, String bio, String id}) {
    this.name = name;
    this.username = username;
    this.dp = dp;
    this.bio = bio;
    this.id = id;
  }

  User.fromJson(dynamic json) {
    this.name = json["name"];
    this.username = json["username"];
    this.dp = json["dp"];
    this.bio = json["bio"];
    this.id = json["_id"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["name"] = name;
    map["username"] = username;
    map["dp"] = dp;
    map["bio"] = bio;
    map["_id"] = id;
    return map;
  }
}
