class ErrorResponseFile {
  int errorCode;
  ErrorMessage errorMessage;

  ErrorResponseFile({this.errorCode, this.errorMessage});

  factory ErrorResponseFile.fromJson(Map<String, dynamic> json) {
    return ErrorResponseFile(
      errorCode: json['errorCode'],
      errorMessage: json['errorMessage'] != null
          ? ErrorMessage.fromJson(json['errorMessage'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['errorCode'] = this.errorCode;
    if (this.errorMessage != null) {
      data['errorMessage'] = this.errorMessage.toJson();
    }
    return data;
  }
}

class ErrorMessage {
  String file;

  ErrorMessage({this.file});

  factory ErrorMessage.fromJson(Map<String, dynamic> json) {
    return ErrorMessage(
      file: json['File'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['File'] = this.file;
    return data;
  }
}
