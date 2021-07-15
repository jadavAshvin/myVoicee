// To parse this JSON data, do
//
//     final channelListModel = channelListModelFromJson(jsonString);

import 'dart:convert';

ChannelListModel channelListModelFromJson(String str) => ChannelListModel.fromJson(json.decode(str));

String channelListModelToJson(ChannelListModel data) => json.encode(data.toJson());

class ChannelListModel {
  ChannelListModel({
    this.status,
    this.showMsg,
    this.message,
    this.response,
  });

  bool status;
  int showMsg;
  String message;
  List<ChannelPost> response;

  factory ChannelListModel.fromJson(Map<String, dynamic> json) => ChannelListModel(
        status: json["status"],
        showMsg: json["show_msg"],
        message: json["message"],
        response: List<ChannelPost>.from(json["response"].map((x) => ChannelPost.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "show_msg": showMsg,
        "message": message,
        "response": List<dynamic>.from(response.map((x) => x.toJson())),
      };
}

class ChannelPost {
  ChannelPost(
      {this.id,
      this.hashTag,
      this.isCampaign,
      this.campaignDesc,
      this.campaignImg,
      this.nLikes,
      this.nShares,
      this.nDislikes,
      this.nComments,
      this.isDeleted,
      this.isActive,
      this.channelId,
      this.topicId,
      this.text,
      this.audio,
      this.language,
      this.audioDuration,
      this.userId,
      this.createdAt,
      this.channel,
      this.userLiked,
      this.userShared,
      this.userComment,
      this.userDislike,
      this.user,
      this.isLiked,
      this.isShared,
      this.isCommented,
      this.isDisliked,
      this.is_play = false,
      this.duration});

  String id;
  String hashTag;
  Duration duration;
  bool isCampaign;
  String campaignDesc;
  String campaignImg;
  int nLikes;
  int nShares;
  int nDislikes;
  int nComments;
  bool isDeleted;
  bool isActive;
  List<String> channelId;
  List<String> topicId;
  String text;
  String audio;
  String language;
  int audioDuration;
  bool is_play;

  String userId;
  dynamic createdAt;
  List<Channel> channel;
  List<String> userLiked;
  List<String> userShared;
  List<dynamic> userComment;
  List<dynamic> userDislike;
  User user;
  bool isLiked;
  bool isShared;
  bool isCommented;
  bool isDisliked;

  factory ChannelPost.fromJson(Map<String, dynamic> json) => ChannelPost(
        id: json["_id"],
        hashTag: json["hash_tag"],
        isCampaign: json["is_campaign"],
        campaignDesc: json["campaign_desc"],
        campaignImg: json["campaign_img"],
        nLikes: json["n_likes"],
        nShares: json["n_shares"],
        nDislikes: json["n_dislikes"],
        nComments: json["n_comments"],
        isDeleted: json["is_deleted"],
        isActive: json["is_active"],
        channelId: List<String>.from(json["channel_id"].map((x) => x)),
        topicId: List<String>.from(json["topic_id"].map((x) => x)),
        text: json["text"],
        audio: json["audio"],
        language: json["language"],
        audioDuration: json["audio_duration"],
        userId: json["user_id"],
        createdAt: json["created_at"],
        channel: List<Channel>.from(json["channel"].map((x) => Channel.fromJson(x))),
        userLiked: List<String>.from(json["user_liked"].map((x) => x)),
        userShared: List<String>.from(json["user_shared"].map((x) => x)),
        userComment: List<dynamic>.from(json["user_comment"].map((x) => x)),
        userDislike: List<dynamic>.from(json["user_dislike"].map((x) => x)),
        user: User.fromJson(json["user"]),
        isLiked: json["is_liked"],
        isShared: json["is_shared"],
        isCommented: json["is_commented"],
        isDisliked: json["is_disliked"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "hash_tag": hashTag,
        "is_campaign": isCampaign,
        "campaign_desc": campaignDesc,
        "campaign_img": campaignImg,
        "n_likes": nLikes,
        "n_shares": nShares,
        "n_dislikes": nDislikes,
        "n_comments": nComments,
        "is_deleted": isDeleted,
        "is_active": isActive,
        "channel_id": List<dynamic>.from(channelId.map((x) => x)),
        "topic_id": List<dynamic>.from(topicId.map((x) => x)),
        "text": text,
        "audio": audio,
        "language": language,
        "audio_duration": audioDuration,
        "user_id": userId,
        "created_at": createdAt.toIso8601String(),
        "channel": List<dynamic>.from(channel.map((x) => x.toJson())),
        "user_liked": List<dynamic>.from(userLiked.map((x) => x)),
        "user_shared": List<dynamic>.from(userShared.map((x) => x)),
        "user_comment": List<dynamic>.from(userComment.map((x) => x)),
        "user_dislike": List<dynamic>.from(userDislike.map((x) => x)),
        "user": user.toJson(),
        "is_liked": isLiked,
        "is_shared": isShared,
        "is_commented": isCommented,
        "is_disliked": isDisliked,
      };
}

class Channel {
  Channel({
    this.id,
    this.img,
    this.isDeleted,
    this.title,
    this.topicId,
    this.description,
    this.type,
    this.userId,
    this.createdAt,
    this.v,
  });

  String id;
  String img;
  bool isDeleted;
  String title;
  String topicId;
  String description;
  int type;
  String userId;
  dynamic createdAt;
  int v;

  factory Channel.fromJson(Map<String, dynamic> json) => Channel(
        id: json["_id"],
        img: json["img"],
        isDeleted: json["is_deleted"],
        title: json["title"],
        topicId: json["topic_id"],
        description: json["description"],
        type: json["type"],
        userId: json["user_id"],
        createdAt: json["created_at"],
        v: json["__v"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "img": img,
        "is_deleted": isDeleted,
        "title": title,
        "topic_id": topicId,
        "description": description,
        "type": type,
        "user_id": userId,
        "created_at": createdAt.toIso8601String(),
        "__v": v,
      };
}

class User {
  User({
    this.name,
    this.username,
    this.dp,
    this.bio,
    this.id,
    this.isPublisher,
  });

  String name;
  String username;
  String dp;
  String bio;
  String id;
  bool isPublisher;

  factory User.fromJson(Map<String, dynamic> json) => User(
        name: json["name"],
        username: json["username"],
        dp: json["dp"],
        bio: json["bio"],
        id: json["_id"],
        isPublisher: json["is_publisher"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "username": username,
        "dp": dp,
        "bio": bio,
        "_id": id,
        "is_publisher": isPublisher,
      };
}
