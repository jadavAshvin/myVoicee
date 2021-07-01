import 'package:flutter/material.dart';
import 'package:my_voicee/constants/app_constants.dart';
import 'package:my_voicee/models/errorResponse/customeError.dart';
import 'package:my_voicee/network/ApiUrls.dart';
import 'package:my_voicee/network/DioApiConfiguration.dart';
import 'package:my_voicee/network/api_callbacks.dart';
import 'package:my_voicee/utils/Utility.dart';

class SearchDataRepo {
  final ApiCallback apiCallback;

  SearchDataRepo(this.apiCallback);

  void onGetSearchResult(BuildContext context, String search) {
    checkInternetConnection().then((onValue) {
      !onValue
          ? apiCallback.onAPIError(
              CustomError('Check your internet connection.'), NO_INTERNET_FLAG)
          : _onGetSearchResult(context, search);
    });
  }

  void _onGetSearchResult(BuildContext context, String search) {
    var url = '$searchResults';
    Map<String, dynamic> requestData = Map();
    requestData.putIfAbsent("name", () => search);
    try {
      ApiDioConfiguration.getInstance()
          .apiClient
          .liveService
          .apiPostRequest(context, url, 'nonjson', requestData)
          .then((response) {
            Map map = (response.data);
            try {
              if (map['status']) {
                apiCallback.onAPISuccess(map, SEARCH_RESULT);
              } else {
                apiCallback.onAPIError(map, SEARCH_RESULT);
              }
            } catch (error) {
              apiCallback.onAPIError(error, ERROR_EXCEPTION_FLAG);
            }
          })
          .timeout(Duration(seconds: 100))
          .catchError((error) {
            try {
              apiCallback.onAPIError(error.response.data, SEARCH_RESULT);
            } catch (error) {
              apiCallback.onAPIError(error, ERROR_EXCEPTION_FLAG);
            }
          });
    } catch (error) {
      apiCallback.onAPIError(error, ERROR_EXCEPTION_FLAG);
    }
  }
}
