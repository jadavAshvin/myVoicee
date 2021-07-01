class AddComment {
  String message;
  AddCommentResponse response;
  int show_msg;
  bool status;

  AddComment({this.message, this.response, this.show_msg, this.status});

  factory AddComment.fromJson(Map<String, dynamic> json) {
    return AddComment(
      message: json['message'],
      response: json['response'] != null
          ? AddCommentResponse.fromJson(json['response'])
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
      data['response'] = this.response.toJson();
    }
    return data;
  }
}

class AddCommentResponse {
  String ids;
  String comment;
  String created_at;
  String id;
  bool is_deleted;
  String post_id;
  String user_id;

  AddCommentResponse(
      {this.ids,
      this.comment,
      this.created_at,
      this.id,
      this.is_deleted,
      this.post_id,
      this.user_id});

  factory AddCommentResponse.fromJson(Map<String, dynamic> json) {
    return AddCommentResponse(
      id: json['_id'],
      comment: json['comment'],
      created_at: json['created_at'],
      ids: json['id'],
      is_deleted: json['is_deleted'],
      post_id: json['post_id'],
      user_id: json['user_id'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.ids;
    data['comment'] = this.comment;
    data['created_at'] = this.created_at;
    data['id'] = this.id;
    data['is_deleted'] = this.is_deleted;
    data['post_id'] = this.post_id;
    data['user_id'] = this.user_id;
    return data;
  }
}
