// To parse this JSON data, do
//
//     final userChannelListModel = userChannelListModelFromJson(jsonString);

import 'dart:convert';

UserChannelListModel userChannelListModelFromJson(String str) => UserChannelListModel.fromJson(json.decode(str));

String userChannelListModelToJson(UserChannelListModel data) => json.encode(data.toJson());

class UserChannelListModel {
  UserChannelListModel({
    this.status,
    this.message,
    this.showMsg,
    this.response,
  });

  bool status;
  String message;
  int showMsg;
  ChannelUser response;

  factory UserChannelListModel.fromJson(Map<String, dynamic> json) => UserChannelListModel(
        status: json["status"],
        message: json["message"],
        showMsg: json["show_msg"],
        response: ChannelUser.fromJson(json["response"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "show_msg": showMsg,
        "response": response.toJson(),
      };
}

class ChannelUser {
  ChannelUser({
    this.img,
    this.isDeleted,
    this.id,
    this.title,
    this.topicId,
    this.description,
    this.type,
    this.userId,
    this.createdAt,
    this.v,
    this.topic,
    this.user,
    this.responseId,
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

  factory ChannelUser.fromJson(Map<String, dynamic> json) => ChannelUser(
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
    this.img,
    this.isDeleted,
    this.nPosts,
    this.id,
    this.title,
    this.createdAt,
    this.v,
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
    this.username,
    this.audio,
    this.mobileVerified,
    this.isPublisher,
    this.dp,
    this.postLiked,
    this.postDisliked,
    this.postShared,
    this.topics,
    this.isWorking,
    this.isAdmin,
    this.fbId,
    this.gmailId,
    this.appleId,
    this.twId,
    this.nPosts,
    this.isBlocked,
    this.isApproved,
    this.id,
    this.name,
    this.mobile,
    this.email,
    this.createdAt,
    this.v,
    this.bio,
    this.concentration,
    this.degreeType,
    this.employment,
    this.graduationYear,
    this.location,
    this.schoolUniversity,
    this.startYear,
    this.updatedAt,
    this.countryId,
    this.districtId,
    this.stateId,
    this.tempMobile,
    this.userId,
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
  dynamic createdAt;
  int v;
  String bio;
  String concentration;
  String degreeType;
  String employment;
  dynamic graduationYear;
  String location;
  String schoolUniversity;
  dynamic startYear;
  dynamic updatedAt;
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
        createdAt: json["created_at"],
        v: json["__v"],
        bio: json["bio"],
        concentration: json["concentration"],
        degreeType: json["degree_type"],
        employment: json["employment"],
        graduationYear: json["graduation_year"],
        location: json["location"],
        schoolUniversity: json["school_university"],
        startYear: json["start_year"],
        updatedAt: json["updated_at"],
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
