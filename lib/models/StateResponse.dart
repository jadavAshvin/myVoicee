class StateResponse {
  String message;
  List<States> response;
  int show_msg;
  bool status;

  StateResponse({this.message, this.response, this.show_msg, this.status});

  factory StateResponse.fromJson(Map<String, dynamic> json) {
    return StateResponse(
      message: json['message'],
      response: json['response'] != null
          ? (json['response'] as List).map((i) => States.fromJson(i)).toList()
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
      data['response'] = this.response.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class States {
  String id;
  String country_id;
  String created_at;
  bool is_deleted;
  String name;

  States(
      {this.id, this.country_id, this.created_at, this.is_deleted, this.name});

  factory States.fromJson(Map<String, dynamic> json) {
    return States(
      id: json['_id'],
      country_id: json['country_id'],
      created_at: json['created_at'],
      is_deleted: json['is_deleted'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.id;
    data['country_id'] = this.country_id;
    data['created_at'] = this.created_at;
    data['is_deleted'] = this.is_deleted;
    data['name'] = this.name;
    return data;
  }
}
