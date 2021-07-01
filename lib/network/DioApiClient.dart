import 'dart:io';

import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:my_voicee/network/ApiUrls.dart';

class DioApiClient {
  final Map<String, String> headers;
  final Map<String, String> query;

  DioApiClient._(this.headers, [this.query]);

  static createGuestClient(String nativeDeviceId, bool isLoggedIn) {
    Map<String, String> _headers;
    if (isLoggedIn) {
      _headers = {
        'x-access-token': '$nativeDeviceId',
      };
    } else {
      _headers = {};
    }
    return DioApiClient._(_headers);
  }

  Future<dynamic> get(url, String type,
      {Map<String, String> headers, Map<String, dynamic> query}) {
    var contentType = type == 'json'
        ? 'application/json'
        : 'application/x-www-form-urlencoded';
    this.headers.putIfAbsent('Content-Type', () => contentType);
    BaseOptions options = new BaseOptions(
      baseUrl: "$baseUrl",
      connectTimeout: 5000,
      receiveTimeout: 3000,
      contentType: type == 'json'
          ? 'application/json'
          : 'application/x-www-form-urlencoded',
      headers: headers ?? this.headers,
    );
    return _execute(
        (client) => client.get(url, queryParameters: query ?? this.query),
        type,
        options);
  }

  Future<dynamic> post(url, String type,
      {Map<String, String> headers, body, Map<String, String> queryParams}) {
    var contentType = type == 'json'
        ? 'application/json'
        : 'application/x-www-form-urlencoded';
    this.headers.putIfAbsent('Content-Type', () => contentType);
    BaseOptions options = new BaseOptions(
      baseUrl: "$baseUrl",
      connectTimeout: 5000,
      receiveTimeout: 3000,
      contentType: type == 'json'
          ? 'application/json'
          : 'application/x-www-form-urlencoded',
      headers: headers ?? this.headers,
    );
    return _execute(
        (client) => client.post(url, data: body, queryParameters: queryParams),
        type,
        options);
  }

  Future<dynamic> put(url, String type,
      {Map<String, String> headers, body, Map<String, String> queryParams}) {
    var contentType = type == 'json'
        ? 'application/json'
        : 'application/x-www-form-urlencoded';
    this.headers.putIfAbsent('Content-Type', () => contentType);
    BaseOptions options = new BaseOptions(
      baseUrl: "$baseUrl",
      connectTimeout: 5000,
      receiveTimeout: 3000,
      contentType: type == 'json'
          ? 'application/json'
          : 'application/x-www-form-urlencoded',
      headers: headers ?? this.headers,
    );
    Options optionsValue = Options();
    optionsValue.headers = headers ?? this.headers;

    return _execute(
        (client) => client.put(url,
            data: body, options: optionsValue, queryParameters: queryParams),
        type,
        options);
  }

  Future<dynamic> delete(String url, String type,
      [body, Map<String, String> queryParams]) {
    var contentType = type == 'json'
        ? 'application/json'
        : 'application/x-www-form-urlencoded';
    this.headers.putIfAbsent('Content-Type', () => contentType);
    BaseOptions options = new BaseOptions(
      baseUrl: "$baseUrl",
      connectTimeout: 5000,
      receiveTimeout: 3000,
      contentType: type == 'json'
          ? 'application/json'
          : 'application/x-www-form-urlencoded',
      headers: headers ?? this.headers,
    );
    return _execute(
        (client) =>
            client.delete(url, data: body, queryParameters: queryParams),
        type,
        options);
  }

  Future<dynamic> multipartPost(
      String url, FormData data, String type, String requestType) async {
    var contentType = type == 'json'
        ? 'application/json'
        : 'application/x-www-form-urlencoded';
    this.headers.putIfAbsent('Content-Type', () => contentType);
    BaseOptions options = new BaseOptions(
      baseUrl: "$baseUrl",
      connectTimeout: 30000,
      receiveTimeout: 30000,
      contentType: type == 'json'
          ? 'application/json'
          : 'application/x-www-form-urlencoded',
      headers: headers ?? this.headers,
    );
    Options optionsValue = Options();
    optionsValue.headers = headers ?? this.headers;

    if (requestType == 'post') {
      return _execute((client) => client.post(url, data: data), type, options);
    } else {
      return _execute(
          (client) => client.put(url,
              data: data, options: optionsValue, queryParameters: null),
          type,
          options);
    }
  }

  Future<dynamic> _execute<T>(
      Future<T> fn(Dio client), String type, BaseOptions options) async {
    final dio = Dio(options);
    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (HttpClient client) {
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
      return client;
    };
    dio.interceptors.add(LoggingInterceptor());
    try {
      return await fn(dio);
    } on DioError catch (e) {
      return e.response;
    } finally {
      dio.close();
    }
  }
}

class LoggingInterceptor extends Interceptor {
  int _maxCharactersPerLine = 300;

  @override
  Future onRequest(RequestOptions options) {
    print("--> ${options.method} ${options.path}");
    print("Content type: ${options.contentType}");
    print("<-- END HTTP");
    return super.onRequest(options);
  }

  @override
  Future onResponse(Response response) {
    print(
        "<-- ${response.statusCode} ${response.request.method} ${response.request.path}");
    String responseAsString = response.data.toString();
    if (responseAsString.length > _maxCharactersPerLine) {
      int iterations =
          (responseAsString.length / _maxCharactersPerLine).floor();
      for (int i = 0; i <= iterations; i++) {
        int endingIndex = i * _maxCharactersPerLine + _maxCharactersPerLine;
        if (endingIndex > responseAsString.length) {
          endingIndex = responseAsString.length;
        }
        print(
            responseAsString.substring(i * _maxCharactersPerLine, endingIndex));
      }
    } else {
      print(response.data);
    }
    print("<-- END HTTP");

    return super.onResponse(response);
  }

  @override
  Future onError(DioError err) {
    print("<-- Error -->");
    print(err.error);
    print(err.message);
    return super.onError(err);
  }
}
