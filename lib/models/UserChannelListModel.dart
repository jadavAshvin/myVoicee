// To parse this JSON data, do
//
//     final userChannelListModel = userChannelListModelFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

UserChannelListModel userChannelListModelFromJson(String str) => UserChannelListModel.fromJson(json.decode(str));

String userChannelListModelToJson(UserChannelListModel data) => json.encode(data.toJson());

class UserChannelListModel {
  UserChannelListModel({
    @required this.status,
    @required this.showMsg,
    @required this.message,
    @required this.response,
  });

  bool status;
  int showMsg;
  String message;
  List<Response> response;

  factory UserChannelListModel.fromJson(Map<String, dynamic> json) => UserChannelListModel(
        status: json["status"],
        showMsg: json["show_msg"],
        message: json["message"],
        response: List<Response>.from(json["response"].map((x) => Response.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "show_msg": showMsg,
        "message": message,
        "response": List<dynamic>.from(response.map((x) => x.toJson())),
      };
}

class Response {
  Response({
    @required this.id,
    @required this.hashTag,
    @required this.isCampaign,
    @required this.campaignDesc,
    @required this.campaignImg,
    @required this.nLikes,
    @required this.nShares,
    @required this.nDislikes,
    @required this.nComments,
    @required this.isDeleted,
    @required this.isActive,
    @required this.channelId,
    @required this.topicId,
    @required this.text,
    @required this.audio,
    @required this.language,
    @required this.audioDuration,
    @required this.userId,
    @required this.createdAt,
    @required this.channel,
    @required this.userLiked,
    @required this.userShared,
    @required this.userComment,
    @required this.userDislike,
    @required this.user,
    @required this.isLiked,
    @required this.isShared,
    @required this.isCommented,
    @required this.isDisliked,
  });

  String id;
  String hashTag;
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
  String userId;
  DateTime createdAt;
  List<Channel> channel;
  List<String> userLiked;
  List<dynamic> userShared;
  List<dynamic> userComment;
  List<dynamic> userDislike;
  User user;
  bool isLiked;
  bool isShared;
  bool isCommented;
  bool isDisliked;

  factory Response.fromJson(Map<String, dynamic> json) => Response(
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
        createdAt: DateTime.parse(json["created_at"]),
        channel: List<Channel>.from(json["channel"].map((x) => Channel.fromJson(x))),
        userLiked: List<String>.from(json["user_liked"].map((x) => x)),
        userShared: List<dynamic>.from(json["user_shared"].map((x) => x)),
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
    @required this.id,
    @required this.img,
    @required this.isDeleted,
    @required this.title,
    @required this.topicId,
    @required this.description,
    @required this.type,
    @required this.userId,
    @required this.createdAt,
    @required this.v,
  });

  String id;
  String img;
  bool isDeleted;
  String title;
  String topicId;
  String description;
  int type;
  String userId;
  DateTime createdAt;
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
        createdAt: DateTime.parse(json["created_at"]),
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
    @required this.name,
    @required this.username,
    @required this.dp,
    @required this.bio,
    @required this.id,
    @required this.isPublisher,
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
