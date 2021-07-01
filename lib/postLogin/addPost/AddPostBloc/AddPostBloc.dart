import 'dart:async';

import 'package:flutter/material.dart';
import 'package:my_voicee/constants/app_constants.dart';
import 'package:my_voicee/models/AddCommentReponse.dart';
import 'package:my_voicee/models/AddPostResponse.dart';
import 'package:my_voicee/models/AllTopicsModel.dart';
import 'package:my_voicee/models/ChannelDataList.dart';
import 'package:my_voicee/models/GetAllPostsResponse.dart';
import 'package:my_voicee/models/commonResponse/CommonpiResponse.dart';
import 'package:my_voicee/models/errorResponse/error_reponse.dart';
import 'package:my_voicee/network/api_callbacks.dart';
import 'package:my_voicee/postLogin/addPost/AddPostBloc/AddPostDataRepo.dart';
import 'package:rxdart/rxdart.dart';

class AddPostBloc extends ApiCallback {
  final StreamController apiController;
  AddPostDataRepo _dataProvider;

  AddPostBloc(this.apiController) {
    _dataProvider = AddPostDataRepo(this);
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
      case UPLOAD_FILE:
        var errorResponse = ErrorResponse.fromJson(error);
        if (!apiController.isClosed) {
          apiController.add(errorResponse);
        }
        break;
      case ADD_POST:
        var errorResponse = ErrorResponse.fromJson(error);
        if (!apiController.isClosed) {
          apiController.add(errorResponse);
        }
        break;
      case GET_A_POST:
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
      case TOPICS_FLAG:
        var errorResponse = ErrorResponse.fromJson(error);
        if (!apiController.isClosed) {
          apiController.add(errorResponse);
        }
        break;
      case ADD_COMMENT:
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
    if (flag == TOPICS_FLAG) {
      var topicsResponse = AllTopicsModel.fromJson(data);
      if (topicsResponse.response != null) {
        if (!apiController.isClosed) {
          apiController.add(topicsResponse);
        }
      }
    } else if (flag == UPLOAD_FILE) {
      var registerResponse = CommonApiReponse.fromJson(data);
      if (!apiController.isClosed) {
        apiController.add(registerResponse);
      }
    } else if (flag == ADD_POST) {
      var registerResponse = AddPostResponse.fromJson(data);
      if (!apiController.isClosed) {
        apiController.add(registerResponse);
      }
    } else if (flag == GET_A_POST) {
      var registerResponse = GetAllPostResponse.fromJson(data);
      if (!apiController.isClosed) {
        apiController.add(registerResponse);
      }
    } else if (flag == ADD_COMMENT) {
      var registerResponse = AddComment.fromJson(data);
      if (!apiController.isClosed) {
        apiController.add(registerResponse);
      }
    } else if (flag == GET_CHANNELS_FLAG) {
      var topicsResponse = ChannelDataList.fromJson(data);
      if (topicsResponse.response != null) {
        if (!apiController.isClosed) {
          apiController.add(topicsResponse);
        }
      }
    }
  }

  void callApiUploadFile(BuildContext context, String filePath, int type) {
    showProgressLoader(true);
    _dataProvider.apiUploadFile(context, filePath, type);
  }

  void callApiSavePost(BuildContext context, Map<String, dynamic> requestData) {
    showProgressLoader(true);
    _dataProvider.apiSavePost(context, requestData);
  }

  void getPost(BuildContext context, String id) {
    showProgressLoader(true);
    _dataProvider.apiGetSingle(context, id);
  }

  void callApiReplyPost(BuildContext context, String trim, String audioUrl,
      String id, String duration) {
    showProgressLoader(true);
    _dataProvider.apiReplyPost(context, trim, audioUrl, id, duration);
  }

  void getAllTopics(BuildContext context) {
    _dataProvider.onGetAllTopics(context);
  }

  void getChannelsList(BuildContext context) {
    _dataProvider.apiGetChannelsList(context);
  }
}
