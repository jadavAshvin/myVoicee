import 'dart:async';

import 'package:my_voicee/constants/app_constants.dart';
import 'package:my_voicee/models/ReActionResponse.dart';
import 'package:my_voicee/models/errorResponse/error_reponse.dart';
import 'package:my_voicee/network/api_callbacks.dart';
import 'package:my_voicee/postLogin/reactions/ReActionsBloc/ReActionsDataRepo.dart';
import 'package:rxdart/subjects.dart';

class ReActionsBloc implements ApiCallback {
  final StreamController apiController;
  final StreamController apiResponse;

  ReActionDataRepo _dataProvider;

  ReActionsBloc(this.apiController, this.apiResponse) {
    _dataProvider = ReActionDataRepo(this);
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
      case GET_ALL_REACTIONS:
        var errorResponse = ErrorResponse.fromJson(error);
        if (!apiController.isClosed) {
          apiResponse.add(errorResponse);
        }
        break;
      case ERROR_EXCEPTION_FLAG:
        showProgressLoader(false);
        if (!apiController.isClosed) {
          apiResponse.add(Exception());
        }
        break;
      case NO_INTERNET_FLAG:
        if (!apiController.isClosed) {
          apiResponse.add(error);
        }
        break;
    }
  }

  @override
  void onAPISuccess(Map<dynamic, dynamic> data, int flag) {
    showProgressLoader(false);
    if (flag == GET_ALL_REACTIONS) {
      var registerResponse = ReActionResponse.fromJson(data);
      if (registerResponse.response != null) {
        if (!apiController.isClosed) {
          apiResponse.add(registerResponse);
          apiController.add(registerResponse.response);
        }
      }
    }
  }

  void callApiGetReactions(context, id, type, page) {
    showProgressLoader(true);
    _dataProvider.callApiReActions(context, id, type, page);
  }
}
