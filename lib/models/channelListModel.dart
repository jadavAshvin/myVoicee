// To parse this JSON data, do
//
//     final channelListModel = channelListModelFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

ChannelListModel channelListModelFromJson(String str) => ChannelListModel.fromJson(json.decode(str));

String channelListModelToJson(ChannelListModel data) => json.encode(data.toJson());

class ChannelListModel {
  ChannelListModel({
    @required this.status,
    @required this.message,
    @required this.showMsg,
    @required this.response,
  });

  bool status;
  String message;
  int showMsg;
  Response response;

  factory ChannelListModel.fromJson(Map<String, dynamic> json) => ChannelListModel(
        status: json["status"],
        message: json["message"],
        showMsg: json["show_msg"],
        response: Response.fromJson(json["response"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "show_msg": showMsg,
        "response": response.toJson(),
      };
}

class Response {
  Response({
    @required this.img,
    @required this.isDeleted,
    @required this.id,
    @required this.title,
    @required this.topicId,
    @required this.description,
    @required this.type,
    @required this.userId,
    @required this.createdAt,
    @required this.v,
    @required this.topic,
    @required this.user,
    @required this.responseId,
  });

  String img;
  bool isDeleted;
  String id;
  String title;
  String topicId;
  String description;
  int type;
  String userId;
  DateTime createdAt;
  int v;
  Topic topic;
  User user;
  String responseId;

  factory Response.fromJson(Map<String, dynamic> json) => Response(
        img: json["img"],
        isDeleted: json["is_deleted"],
        id: json["_id"],
        title: json["title"],
        topicId: json["topic_id"],
        description: json["description"],
        type: json["type"],
        userId: json["user_id"],
        createdAt: DateTime.parse(json["created_at"]),
        v: json["__v"],
        topic: Topic.fromJson(json["topic"]),
        user: User.fromJson(json["user"]),
        responseId: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "img": img,
        "is_deleted": isDeleted,
        "_id": id,
        "title": title,
        "topic_id": topicId,
        "description": description,
        "type": type,
        "user_id": userId,
        "created_at": createdAt.toIso8601String(),
        "__v": v,
        "topic": topic.toJson(),
        "user": user.toJson(),
        "id": responseId,
      };
}

class Topic {
  Topic({
    @required this.img,
    @required this.isDeleted,
    @required this.nPosts,
    @required this.id,
    @required this.title,
    @required this.createdAt,
    @required this.v,
  });

  String img;
  bool isDeleted;
  int nPosts;
  String id;
  String title;
  DateTime createdAt;
  int v;

  factory Topic.fromJson(Map<String, dynamic> json) => Topic(
        img: json["img"],
        isDeleted: json["is_deleted"],
        nPosts: json["n_posts"],
        id: json["_id"],
        title: json["title"],
        createdAt: DateTime.parse(json["created_at"]),
        v: json["__v"],
      );

  Map<String, dynamic> toJson() => {
        "img": img,
        "is_deleted": isDeleted,
        "n_posts": nPosts,
        "_id": id,
        "title": title,
        "created_at": createdAt.toIso8601String(),
        "__v": v,
      };
}

class User {
  User({
    @required this.username,
    @required this.audio,
    @required this.mobileVerified,
    @required this.isPublisher,
    @required this.dp,
    @required this.postLiked,
    @required this.postDisliked,
    @required this.postShared,
    @required this.topics,
    @required this.isWorking,
    @required this.isAdmin,
    @required this.fbId,
    @required this.gmailId,
    @required this.appleId,
    @required this.twId,
    @required this.nPosts,
    @required this.isBlocked,
    @required this.isApproved,
    @required this.id,
    @required this.name,
    @required this.mobile,
    @required this.email,
    @required this.createdAt,
    @required this.v,
    @required this.bio,
    @required this.concentration,
    @required this.degreeType,
    @required this.employment,
    @required this.graduationYear,
    @required this.location,
    @required this.schoolUniversity,
    @required this.startYear,
    @required this.updatedAt,
    @required this.countryId,
    @required this.districtId,
    @required this.stateId,
    @required this.tempMobile,
    @required this.userId,
  });

  String username;
  String audio;
  bool mobileVerified;
  bool isPublisher;
  String dp;
  List<dynamic> postLiked;
  List<dynamic> postDisliked;
  List<dynamic> postShared;
  List<String> topics;
  bool isWorking;
  bool isAdmin;
  String fbId;
  String gmailId;
  String appleId;
  String twId;
  int nPosts;
  bool isBlocked;
  bool isApproved;
  String id;
  String name;
  int mobile;
  String email;
  DateTime createdAt;
  int v;
  String bio;
  String concentration;
  String degreeType;
  String employment;
  DateTime graduationYear;
  String location;
  String schoolUniversity;
  DateTime startYear;
  DateTime updatedAt;
  String countryId;
  String districtId;
  String stateId;
  int tempMobile;
  String userId;

  factory User.fromJson(Map<String, dynamic> json) => User(
        username: json["username"],
        audio: json["audio"],
        mobileVerified: json["mobile_verified"],
        isPublisher: json["is_publisher"],
        dp: json["dp"],
        postLiked: List<dynamic>.from(json["post_liked"].map((x) => x)),
        postDisliked: List<dynamic>.from(json["post_disliked"].map((x) => x)),
        postShared: List<dynamic>.from(json["post_shared"].map((x) => x)),
        topics: List<String>.from(json["topics"].map((x) => x)),
        isWorking: json["is_working"],
        isAdmin: json["is_admin"],
        fbId: json["fb_id"],
        gmailId: json["gmail_id"],
        appleId: json["apple_id"],
        twId: json["tw_id"],
        nPosts: json["n_posts"],
        isBlocked: json["is_blocked"],
        isApproved: json["is_approved"],
        id: json["_id"],
        name: json["name"],
        mobile: json["mobile"],
        email: json["email"],
        createdAt: DateTime.parse(json["created_at"]),
        v: json["__v"],
        bio: json["bio"],
        concentration: json["concentration"],
        degreeType: json["degree_type"],
        employment: json["employment"],
        graduationYear: DateTime.parse(json["graduation_year"]),
        location: json["location"],
        schoolUniversity: json["school_university"],
        startYear: DateTime.parse(json["start_year"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        countryId: json["country_id"],
        districtId: json["district_id"],
        stateId: json["state_id"],
        tempMobile: json["temp_mobile"],
        userId: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "username": username,
        "audio": audio,
        "mobile_verified": mobileVerified,
        "is_publisher": isPublisher,
        "dp": dp,
        "post_liked": List<dynamic>.from(postLiked.map((x) => x)),
        "post_disliked": List<dynamic>.from(postDisliked.map((x) => x)),
        "post_shared": List<dynamic>.from(postShared.map((x) => x)),
        "topics": List<dynamic>.from(topics.map((x) => x)),
        "is_working": isWorking,
        "is_admin": isAdmin,
        "fb_id": fbId,
        "gmail_id": gmailId,
        "apple_id": appleId,
        "tw_id": twId,
        "n_posts": nPosts,
        "is_blocked": isBlocked,
        "is_approved": isApproved,
        "_id": id,
        "name": name,
        "mobile": mobile,
        "email": email,
        "created_at": createdAt.toIso8601String(),
        "__v": v,
        "bio": bio,
        "concentration": concentration,
        "degree_type": degreeType,
        "employment": employment,
        "graduation_year": graduationYear.toIso8601String(),
        "location": location,
        "school_university": schoolUniversity,
        "start_year": startYear.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "country_id": countryId,
        "district_id": districtId,
        "state_id": stateId,
        "temp_mobile": tempMobile,
        "id": userId,
      };
}
