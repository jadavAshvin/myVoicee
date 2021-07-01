class AddPostResponse {
  String message;
  Response response;
  int show_msg;
  bool status;

  AddPostResponse({this.message, this.response, this.show_msg, this.status});

  factory AddPostResponse.fromJson(Map<String, dynamic> json) {
    return AddPostResponse(
      message: json['message'],
      response:
          json['response'] != null ? Response.fromJson(json['response']) : null,
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
      data['response'] = this.response.toJson();
    }
    return data;
  }
}

class Response {
  String ids;
  String ac_id;
  String audio;
  String country_id;
  String created_at;
  String district_id;
  String id;
  bool is_active;
  bool is_deleted;
  int n_comments;
  int n_dislikes;
  int n_likes;
  int n_shares;
  String pc_id;
  String state_id;
  String text;
  String user_id;

  Response(
      {this.ids,
      this.ac_id,
      this.audio,
      this.country_id,
      this.created_at,
      this.district_id,
      this.id,
      this.is_active,
      this.is_deleted,
      this.n_comments,
      this.n_dislikes,
      this.n_likes,
      this.n_shares,
      this.pc_id,
      this.state_id,
      this.text,
      this.user_id});

  factory Response.fromJson(Map<String, dynamic> json) {
    return Response(
      ids: json['_id'],
      ac_id: json['ac_id'],
      audio: json['audio'],
      country_id: json['country_id'],
      created_at: json['created_at'],
      district_id: json['district_id'],
      id: json['id'],
      is_active: json['is_active'],
      is_deleted: json['is_deleted'],
      n_comments: json['n_comments'],
      n_dislikes: json['n_dislikes'],
      n_likes: json['n_likes'],
      n_shares: json['n_shares'],
      pc_id: json['pc_id'],
      state_id: json['state_id'],
      text: json['text'],
      user_id: json['user_id'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.ids;
    data['ac_id'] = this.ac_id;
    data['audio'] = this.audio;
    data['country_id'] = this.country_id;
    data['created_at'] = this.created_at;
    data['district_id'] = this.district_id;
    data['id'] = this.id;
    data['is_active'] = this.is_active;
    data['is_deleted'] = this.is_deleted;
    data['n_comments'] = this.n_comments;
    data['n_dislikes'] = this.n_dislikes;
    data['n_likes'] = this.n_likes;
    data['n_shares'] = this.n_shares;
    data['pc_id'] = this.pc_id;
    data['state_id'] = this.state_id;
    data['text'] = this.text;
    data['user_id'] = this.user_id;
    return data;
  }
}
