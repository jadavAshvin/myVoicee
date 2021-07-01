class ErrorResponse {
  String message;
  String authType;
  int show_msg;
  dynamic status;

  ErrorResponse({this.message, this.authType, this.show_msg, this.status});

  factory ErrorResponse.fromJson(Map<String, dynamic> json) {
    return ErrorResponse(
      message: json['message'],
      authType: json['auth_type'],
      show_msg: json['show_msg'],
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    data['auth_type'] = this.authType;
    data['show_msg'] = this.show_msg;
    data['status'] = this.status;
    return data;
  }
}
