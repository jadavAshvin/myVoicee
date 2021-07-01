class CountryResponse {
  String message;
  List<Countries> response;
  int show_msg;
  bool status;

  CountryResponse({this.message, this.response, this.show_msg, this.status});

  factory CountryResponse.fromJson(Map<String, dynamic> json) {
    return CountryResponse(
      message: json['message'],
      response: json['response'] != null
          ? (json['response'] as List)
              .map((i) => Countries.fromJson(i))
              .toList()
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

class Countries {
  String id;
  String created_at;
  bool is_deleted;
  bool is_ac_pc_avail;
  String name;

  Countries(
      {this.id,
      this.created_at,
      this.is_deleted,
      this.is_ac_pc_avail,
      this.name});

  factory Countries.fromJson(Map<String, dynamic> json) {
    return Countries(
      id: json['_id'],
      created_at: json['created_at'],
      is_ac_pc_avail: json['is_ac_pc_avail'],
      is_deleted: json['is_deleted'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.id;
    data['created_at'] = this.created_at;
    data['is_deleted'] = this.is_deleted;
    data['is_ac_pc_avail'] = this.is_ac_pc_avail;
    data['name'] = this.name;
    return data;
  }
}
