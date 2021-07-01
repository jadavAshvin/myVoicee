class DistrictAcPc {
  String message;
  AllDistrictData response;
  int show_msg;
  bool status;

  DistrictAcPc({this.message, this.response, this.show_msg, this.status});

  factory DistrictAcPc.fromJson(Map<String, dynamic> json) {
    return DistrictAcPc(
      message: json['message'],
      response: json['response'] != null
          ? AllDistrictData.fromJson(json['response'])
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

class AllDistrictData {
  List<District> districts;

  AllDistrictData({this.districts});

  factory AllDistrictData.fromJson(Map<String, dynamic> json) {
    return AllDistrictData(
      districts: json['districts'] != null
          ? (json['districts'] as List)
              .map((i) => District.fromJson(i))
              .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.districts != null) {
      data['districts'] = this.districts.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class District {
  String id;
  String created_at;
  bool is_deleted;
  String name;
  String state_id;

  District(
      {this.id, this.created_at, this.is_deleted, this.name, this.state_id});

  factory District.fromJson(Map<String, dynamic> json) {
    return District(
      id: json['_id'],
      created_at: json['created_at'],
      is_deleted: json['is_deleted'],
      name: json['name'],
      state_id: json['state_id'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.id;
    data['created_at'] = this.created_at;
    data['is_deleted'] = this.is_deleted;
    data['name'] = this.name;
    data['state_id'] = this.state_id;
    return data;
  }
}
