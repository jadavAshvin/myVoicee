import 'package:my_voicee/models/OtherUserResponse.dart';

class SearchResponse {
  bool _status;
  String _message;
  List<ProfileResponse> _response;

  bool get status => _status;

  String get message => _message;

  List<ProfileResponse> get response => _response;

  SearchResponse(
      {bool status, String message, List<ProfileResponse> response}) {
    _status = status;
    _message = message;
    _response = response;
  }

  SearchResponse.fromJson(dynamic json) {
    _status = json["status"];
    _message = json["message"];
    if (json["response"] != null) {
      _response = [];
      json["response"].forEach((v) {
        _response.add(ProfileResponse.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["status"] = _status;
    map["message"] = _message;
    if (_response != null) {
      map["response"] = _response.map((v) => v.toJson()).toList();
    }
    return map;
  }
}
