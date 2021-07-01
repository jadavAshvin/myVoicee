import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:my_voicee/network/DioApiClient.dart';

class DioClient {
  final ApiService _liveService;

  DioClient._(this._liveService);

  factory DioClient.create(DioApiClient client) {
    final liveService = _ServiceImpl(client);
    return DioClient._(liveService);
  }

  ApiService get liveService => _liveService;
}

abstract class ApiService {
  Future<dynamic> apiPostRequest(BuildContext context, String url, String type,
      [Map<String, dynamic> request]);

  Future<dynamic> apiPutRequest(BuildContext context, String url,
      Map<String, dynamic> request, String type);

  Future<dynamic> apiGetRequest(BuildContext context, String url,
      Map<String, dynamic> mapName, String type);

  Future<dynamic> apiDeleteCustom(
      String url, String type, Map<String, dynamic> mapName);

  Future<dynamic> apiMultipartRequest(BuildContext context, String url,
      FormData data, String apiType, String type);
}

class _ServiceImpl implements ApiService {
  final DioApiClient client;

  _ServiceImpl(this.client);

  @override
  Future apiPostRequest(BuildContext context, String url, String type,
      [Map<String, dynamic> data]) async {
    final response = await client.post("$url", type, body: data);
    return response;
  }

  @override
  Future apiGetRequest(BuildContext context, String url,
      Map<String, dynamic> query, String type) async {
    final response = await client.get(url, type, query: query);
    return response;
  }

  @override
  Future apiPutRequest(BuildContext context, String url,
      Map<String, dynamic> request, String type) async {
    final response = await client.put("$url", type, body: request);
    return response;
  }

  @override
  Future apiDeleteCustom(
      String url, String type, Map<String, dynamic> mapName) async {
    final response = await client.delete("$url", type, mapName);
    return response;
  }

  @override
  Future apiMultipartRequest(BuildContext context, String url, FormData data,
      String apiType, String type) async {
    final response = await client.multipartPost(url, data, type, apiType);
    return response;
  }
}
