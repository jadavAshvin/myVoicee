class UserResponse {
  String authType;
  String message;
  UserData response;
  int show_msg;
  bool status;

  UserResponse(
      {this.authType, this.message, this.response, this.show_msg, this.status});

  factory UserResponse.fromJson(Map<String, dynamic> json) {
    return UserResponse(
      authType: json['auth_type'],
      message: json['message'],
      response: json['response'] != null
          ? json['response'] is Map<String, dynamic>
              ? UserData.fromJson(json['response'])
              : UserData.fromJson(json['response'][0])
          : null,
      show_msg: json['show_msg'],
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['auth_type'] = this.authType;
    data['message'] = this.message;
    data['show_msg'] = this.show_msg;
    data['status'] = this.status;
    if (this.response != null) {
      data['response'] = this.response.toJson();
    }
    return data;
  }
}

class UserData {
  String id;
  String ac_id;
  String apple_id;
  String countryid;
  String districtid;
  String concentration;
  String employment;
  String dp;
  String audio;
  String email;
  String bio;
  String fb_id;
  String gmail_id;
  bool is_admin;
  int is_approved;
  bool is_blocked;
  int mobile;
  String name;
  String school_university;
  String pc_id;
  String graduation_year;
  String degree_type;
  String stateid;
  dynamic followers;
  dynamic followings;
  String tw_id;
  String updated_at;
  String username;
  String end_year;
  String start_year;
  String location;
  bool is_working;
  bool is_publisher;
  bool mobile_verified;

  UserData(
      {this.id,
      this.ac_id,
      this.mobile_verified,
      this.is_publisher,
      this.apple_id,
      this.followings,
      this.followers,
      this.location,
      this.school_university,
      this.audio,
      this.countryid,
      this.districtid,
      this.is_working,
      this.end_year,
      this.concentration,
      this.graduation_year,
      this.employment,
      this.dp,
      this.bio,
      this.email,
      this.degree_type,
      this.fb_id,
      this.start_year,
      this.gmail_id,
      this.is_admin,
      this.is_approved,
      this.is_blocked,
      this.mobile,
      this.name,
      this.pc_id,
      this.stateid,
      this.tw_id,
      this.updated_at,
      this.username});

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      id: json['_id'],
      ac_id: json['ac_id'],
      is_publisher: json['is_publisher'],
      followers: json['followers'],
      followings: json['followings'],
      audio: json['audio'],
      mobile_verified: json['mobile_verified'],
      school_university: json['school_university'],
      start_year: json['start_year'],
      location: json['location'],
      apple_id: json['apple_id'],
      is_working: json['is_working'],
      concentration: json['concentration'],
      employment: json['employment'],
      bio: json['bio'],
      end_year: json['end_year'],
      graduation_year: json['graduation_year'],
      degree_type: json['degree_type'],
      countryid: json['country_id'],
      districtid: json['district_id'],
      dp: json['dp'],
      email: json['email'],
      fb_id: json['fb_id'],
      gmail_id: json['gmail_id'],
      is_admin: json['is_admin'],
      is_approved: json['is_approved'] is bool
          ? json['is_approved']
              ? 1
              : 0
          : json['is_approved'],
      is_blocked: json['is_blocked'],
      mobile: json['mobile'],
      name: json['name'],
      pc_id: json['pc_id'],
      stateid: json['state_id'],
      tw_id: json['tw_id'],
      updated_at: json['updated_at'],
      username: json['username'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.id;
    data['end_year'] = this.end_year;
    data['followings'] = this.followings;
    data['followers'] = this.followers;
    data['ac_id'] = this.ac_id;
    data['location'] = this.location;
    data['start_year'] = this.start_year;
    data['apple_id'] = this.apple_id;
    data['degree_type'] = this.degree_type;
    data['mobile_verified'] = this.mobile_verified;
    data['is_publisher'] = this.is_publisher;
    data['audio'] = this.audio;
    data['country_id'] = this.countryid;
    data['employment'] = this.employment;
    data['is_working'] = this.is_working;
    data['district_id'] = this.districtid;
    data['dp'] = this.dp;
    data['graduation_year'] = this.graduation_year;
    data['concentration'] = this.concentration;
    data['email'] = this.email;
    data['fb_id'] = this.fb_id;
    data['bio'] = this.bio;
    data['gmail_id'] = this.gmail_id;
    data['is_admin'] = this.is_admin;
    data['is_approved'] = this.is_approved;
    data['is_blocked'] = this.is_blocked;
    data['mobile'] = this.mobile;
    data['name'] = this.name;
    data['pc_id'] = this.pc_id;
    data['state_id'] = this.stateid;
    data['tw_id'] = this.tw_id;
    data['updated_at'] = this.updated_at;
    data['username'] = this.username;
    return data;
  }
}
