class CommonApiReponse {
  String message;
  int show_msg;
  bool status;
  dynamic response;
  int type;
  String audio_text;

  CommonApiReponse(
      {this.message,
      this.show_msg,
      this.type,
      this.audio_text,
      this.response,
      this.status});

  factory CommonApiReponse.fromJson(Map<String, dynamic> json) {
    return CommonApiReponse(
      message: json['message'],
      show_msg: json['show_msg'],
      type: json['nav_type'],
      status: json['status'],
      response: json['response'],
      audio_text: json['audio_text'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    data['nav_type'] = this.type;
    data['show_msg'] = this.show_msg;
    data['status'] = this.status;
    data['response'] = this.response;
    data['audio_text'] = this.audio_text;
    return data;
  }
}
