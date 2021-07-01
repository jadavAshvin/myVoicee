class UpDownVoteResponse {
  String message;
  int show_msg;
  bool status;
  dynamic is_action;
  dynamic response;
  String from;
  int pos;

  UpDownVoteResponse(
      {this.message,
      this.show_msg,
      this.is_action,
      this.pos,
      this.from,
      this.response,
      this.status});

  factory UpDownVoteResponse.fromJson(Map<String, dynamic> json) {
    return UpDownVoteResponse(
      message: json['message'],
      pos: json['pos'],
      show_msg: json['show_msg'],
      is_action: json['is_action'],
      status: json['status'],
      response: json['response'],
      from: json['from'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    data['pos'] = this.pos;
    data['is_action'] = this.is_action;
    data['show_msg'] = this.show_msg;
    data['status'] = this.status;
    data['response'] = this.response;
    data['from'] = this.from;
    return data;
  }
}
