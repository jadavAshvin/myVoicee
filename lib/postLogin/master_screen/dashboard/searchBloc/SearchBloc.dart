import 'dart:async';

import 'package:flutter/material.dart';
import 'package:my_voicee/constants/app_constants.dart';
import 'package:my_voicee/models/SearchResponse.dart';
import 'package:my_voicee/models/errorResponse/error_reponse.dart';
import 'package:my_voicee/network/api_callbacks.dart';
import 'package:my_voicee/postLogin/master_screen/dashboard/searchBloc/SearchDataRepo.dart';
import 'package:rxdart/rxdart.dart';

class SearchBloc extends ApiCallback {
  final StreamController apiController;
  SearchDataRepo _dataProvider;

  SearchBloc(this.apiController) {
    _dataProvider = SearchDataRepo(this);
  }

  StreamController<bool> _progressLoaderController = BehaviorSubject<bool>();

  Stream<bool> get progressLoaderStream => _progressLoaderController.stream;

  void dispose() {
    _progressLoaderController.close();
  }

  void showProgressLoader(bool show) {
    if (!_progressLoaderController.isClosed) {
      _progressLoaderController.sink.add(show);
    }
  }

  @override
  void onAPIError(error, int flag) {
    showProgressLoader(false);
    switch (flag) {
      case SEARCH_RESULT:
        var errorResponse = ErrorResponse.fromJson(error);
        if (!apiController.isClosed) {
          apiController.add(errorResponse);
        }
        break;
      case ERROR_EXCEPTION_FLAG:
        showProgressLoader(false);
        if (!apiController.isClosed) {
          apiController.add(Exception());
        }
        break;
      case NO_INTERNET_FLAG:
        if (!apiController.isClosed) {
          apiController.add(error);
        }
        break;
    }
  }

  @override
  void onAPISuccess(Map<dynamic, dynamic> data, int flag) {
    showProgressLoader(false);
    if (flag == SEARCH_RESULT) {
      var registerResponse = SearchResponse.fromJson(data);
      if (registerResponse.response != null) {
        if (!apiController.isClosed) {
          apiController.add(registerResponse.response);
        }
      }
    }
  }

  void getSearchItem(BuildContext context, String search) {
    showProgressLoader(true);
    _dataProvider.onGetSearchResult(context, search);
  }
}
