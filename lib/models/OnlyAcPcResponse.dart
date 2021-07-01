class OnlyAcPcResponse {
  String message;
  AllDistrictData response;
  int show_msg;
  bool status;

  OnlyAcPcResponse({this.message, this.response, this.show_msg, this.status});

  factory OnlyAcPcResponse.fromJson(Map<String, dynamic> json) {
    return OnlyAcPcResponse(
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
  List<Assembly> assemblies;
  List<Parliament> parliaments;

  AllDistrictData({this.assemblies, this.parliaments});

  factory AllDistrictData.fromJson(Map<String, dynamic> json) {
    return AllDistrictData(
      assemblies: json['assemblies'] != null
          ? (json['assemblies'] as List)
              .map((i) => Assembly.fromJson(i))
              .toList()
          : null,
      parliaments: json['parliaments'] != null
          ? (json['parliaments'] as List)
              .map((i) => Parliament.fromJson(i))
              .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.assemblies != null) {
      data['assemblies'] = this.assemblies.map((v) => v.toJson()).toList();
    }
    if (this.parliaments != null) {
      data['parliaments'] = this.parliaments.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Parliament {
  String id;
  String created_at;
  bool is_deleted;
  String name;
  String state_id;

  Parliament(
      {this.id, this.created_at, this.is_deleted, this.name, this.state_id});

  factory Parliament.fromJson(Map<String, dynamic> json) {
    return Parliament(
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

class Assembly {
  String id;
  String created_at;
  bool is_deleted;
  String name;
  String state_id;

  Assembly(
      {this.id, this.created_at, this.is_deleted, this.name, this.state_id});

  factory Assembly.fromJson(Map<String, dynamic> json) {
    return Assembly(
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
