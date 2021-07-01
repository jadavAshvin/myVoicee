import 'dart:async';

import 'package:flutter/src/widgets/framework.dart';
import 'package:my_voicee/constants/app_constants.dart';
import 'package:my_voicee/models/AllTopicsModel.dart';
import 'package:my_voicee/models/ChannelDataList.dart';
import 'package:my_voicee/models/commonResponse/CommonpiResponse.dart';
import 'package:my_voicee/models/errorResponse/error_reponse.dart';
import 'package:my_voicee/network/api_callbacks.dart';
import 'package:my_voicee/postLogin/profile/drawerItems/channel/bloc/ChannelDataRepository.dart';
import 'package:rxdart/rxdart.dart';

class ChannelBloc with ApiCallback {
  final StreamController apiController;
  final StreamController apiController2;
  ChannelDataRepository _dataProvider;

  ChannelBloc(this.apiController, [this.apiController2]) {
    _dataProvider = ChannelDataRepository(this);
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
  void onAPISuccess(Map data, int flag) {
    showProgressLoader(false);
    if (flag == TOPICS_FLAG) {
      var topicsResponse = AllTopicsModel.fromJson(data);
      if (topicsResponse.response != null) {
        if (!apiController.isClosed) {
          apiController.add(topicsResponse);
        }
      }
    } else if (flag == SAVE_TOPICS_FLAG) {
      var topicsResponse = CommonApiReponse.fromJson(data);
      if (topicsResponse.response != null) {
        if (!apiController.isClosed) {
          apiController.add(topicsResponse);
        }
      }
    } else if (flag == CREATE_CHANNELS_FLAG) {
      var topicsResponse = CommonApiReponse.fromJson(data);
      if (topicsResponse.response != null) {
        if (!apiController.isClosed) {
          apiController.add(topicsResponse);
        }
      }
    } else if (flag == UPLOAD_PROFILE_PIC) {
      var topicsResponse = CommonApiReponse.fromJson(data);
      if (topicsResponse.response != null) {
        if (!apiController.isClosed) {
          apiController.add(topicsResponse);
        }
      }
    } else if (flag == GET_CHANNELS_FLAG) {
      var topicsResponse = ChannelDataList.fromJson(data);
      if (topicsResponse.response != null) {
        if (!apiController2.isClosed) {
          apiController2.add(topicsResponse.response);
        }
      }
    }
  }

  @override
  void onAPIError(error, int flag) {
    showProgressLoader(false);
    switch (flag) {
      case TOPICS_FLAG:
        var errorResponse = ErrorResponse.fromJson(error);
        if (!apiController.isClosed) {
          apiController.add(errorResponse);
        }
        break;
      case SAVE_TOPICS_FLAG:
        var errorResponse = ErrorResponse.fromJson(error);
        if (!apiController.isClosed) {
          apiController.add(errorResponse);
        }
        break;
      case UPLOAD_PROFILE_PIC:
        var errorResponse = ErrorResponse.fromJson(error);
        if (!apiController.isClosed) {
          apiController.add(errorResponse);
        }
        break;
      case CREATE_CHANNELS_FLAG:
        var errorResponse = ErrorResponse.fromJson(error);
        if (!apiController.isClosed) {
          apiController.add(errorResponse);
        }
        break;
      case GET_CHANNELS_FLAG:
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

  void getAllTopics(BuildContext context) {
    showProgressLoader(true);
    _dataProvider.onGetAllTopics(context);
  }

  void submitSelectedTopics(BuildContext context, List<String> data) {
    showProgressLoader(true);
    _dataProvider.submitSelectedTopics(context, data);
  }

  void submitSelectedTopicsRemove(BuildContext context, List<String> value) {
    showProgressLoader(true);
    Map<String, dynamic> data = Map();
    data.putIfAbsent("topic", () => value[0]);
    _dataProvider.submitSelectedTopicsRemove(context, data);
  }

  void getChannelsList(BuildContext context) {
    showProgressLoader(true);
    _dataProvider.apiGetChannelsList(context);
  }

  void saveImage(BuildContext context, String request) {
    showProgressLoader(true);
    _dataProvider.apiUploadFile(context, request, 0);
  }

  void createChannel(BuildContext context, Map<String, dynamic> request) {
    showProgressLoader(true);
    _dataProvider.apicreateChannel(context, request);
  }

  void updateChannel(
      BuildContext context, Map<String, dynamic> request, String id) {
    showProgressLoader(true);
    _dataProvider.apiUpdateChannel(context, request, id);
  }
}
