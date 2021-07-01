import 'dart:async';

import 'package:flutter/material.dart';
import 'package:my_voicee/constants/app_constants.dart';
import 'package:my_voicee/models/AllTopicsModel.dart';
import 'package:my_voicee/models/CountryResponse.dart';
import 'package:my_voicee/models/DistrictAcPc.dart';
import 'package:my_voicee/models/GetAllPostsResponse.dart';
import 'package:my_voicee/models/NotificationModel.dart';
import 'package:my_voicee/models/OtherUserResponse.dart';
import 'package:my_voicee/models/ReplyPostListModel.dart';
import 'package:my_voicee/models/StateResponse.dart';
import 'package:my_voicee/models/UpDownVoteResponse.dart';
import 'package:my_voicee/models/commonResponse/CommonpiResponse.dart';
import 'package:my_voicee/models/errorResponse/error_reponse.dart';
import 'package:my_voicee/network/api_callbacks.dart';
import 'package:my_voicee/postLogin/master_screen/dashboard/Bloc/DashboardDataRepo.dart';
import 'package:rxdart/rxdart.dart';

class DashboardBloc extends ApiCallback {
  final StreamController apiController;
  final StreamController apiResponseData;
  DashboardDataRepo _dataProvider;

  DashboardBloc(this.apiController, this.apiResponseData) {
    _dataProvider = DashboardDataRepo(this);
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
      case GET_ALL_POSTS:
        var errorResponse = ErrorResponse.fromJson(error);
        if (!apiController.isClosed) {
          apiController.add(errorResponse);
        }
        break;
      case GET_USER_COMMENTS:
        var errorResponse = ErrorResponse.fromJson(error);
        if (!apiController.isClosed) {
          apiController.add(errorResponse);
        }
        break;
      case GET_COUNTRIES:
        var errorResponse = ErrorResponse.fromJson(error);
        if (!apiController.isClosed) {
          apiController.add(errorResponse);
        }
        break;
      case UP_DOWN_VOTE_POSTS:
        var errorResponse = ErrorResponse.fromJson(error);
        if (!apiController.isClosed) {
          apiController.add(errorResponse);
        }
        break;
      case REPORT_POST:
        var errorResponse = ErrorResponse.fromJson(error);
        if (!apiController.isClosed) {
          apiController.add(errorResponse);
        }
        break;
      case GET_DISTRICT_AC_PC:
        var errorResponse = ErrorResponse.fromJson(error);
        if (!apiController.isClosed) {
          apiController.add(errorResponse);
        }
        break;
      case GET_STATES:
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
      case SAVE_TOPICS_FLAG:
        var errorResponse = ErrorResponse.fromJson(error);
        if (!apiController.isClosed) {
          apiController.add(errorResponse);
        }
        break;
      case NOTIFICATIONS_FLAG:
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
    if (flag == GET_COUNTRIES) {
      var registerResponse = CountryResponse.fromJson(data);
      if (registerResponse.response != null) {
        if (!apiController.isClosed) {
          apiController.add(registerResponse);
        }
      }
    } else if (flag == GET_ALL_POSTS) {
      var registerResponse = GetAllPostResponse.fromJson(data);
      if (registerResponse.response != null) {
        if (!apiController.isClosed) {
          apiController.add(registerResponse);
          apiResponseData.add(registerResponse.response);
        }
      }
    } else if (flag == GET_USER_COMMENTS) {
      var registerResponse = ReplyPostListModel.fromJson(data);
      if (registerResponse.response != null) {
        if (!apiController.isClosed) {
          apiController.add(registerResponse);
          apiResponseData.add(registerResponse.response);
        }
      }
    } else if (flag == GET_STATES) {
      var registerResponse = StateResponse.fromJson(data);
      if (registerResponse.response != null) {
        if (!apiController.isClosed) {
          apiController.add(registerResponse);
        }
      }
    } else if (flag == UP_DOWN_VOTE_POSTS) {
      var registerResponse = UpDownVoteResponse.fromJson(data);
      if (!apiController.isClosed) {
        apiController.add(registerResponse);
      }
    } else if (flag == UP_DOWN_VOTE_COMMENTS) {
      var registerResponse = UpDownVoteResponse.fromJson(data);
      if (!apiController.isClosed) {
        apiController.add(registerResponse);
      }
    } else if (flag == GET_DISTRICT_AC_PC) {
      var registerResponse = DistrictAcPc.fromJson(data);
      if (registerResponse.response != null) {
        if (!apiController.isClosed) {
          apiController.add(registerResponse);
        }
      }
    } else if (flag == REPORT_POST) {
      var registerResponse = CommonApiReponse.fromJson(data);
      if (registerResponse.response != null) {
        if (!apiController.isClosed) {
          apiController.add(registerResponse);
        }
      }
    } else if (flag == GET_OTHER_PROFILE) {
      var registerResponse = OtherUserResponse.fromJson(data);
      if (registerResponse.response != null) {
        if (!apiController.isClosed) {
          apiController.add(registerResponse);
        }
      }
    } else if (flag == TOPICS_FLAG) {
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
    } else if (flag == NOTIFICATIONS_FLAG) {
      var topicsResponse = NotificationModel.fromJson(data);
      if (topicsResponse.response != null) {
        if (!apiController.isClosed) {
          apiController.add(topicsResponse);
          apiResponseData.add(topicsResponse.response);
        }
      }
    }
  }

  callApiGetAllPosts(BuildContext context, int page, List<String> filterIds) {
    showProgressLoader(true);
    _dataProvider.callApiAllPost(context, page, filterIds);
  }

  void callApiUpVoteDownVote(
      BuildContext context, String id, int pos, String type) {
    showProgressLoader(true);
    _dataProvider.openUpVoteDownVote(context, id, pos, type);
  }

  void callApiSharePost(BuildContext context, String id) {
    _dataProvider.apiSharePost(context, id);
  }

  void updatedFirebaseToken(
      Map<String, dynamic> mapName, BuildContext context) {
    _dataProvider.UpdateFirebaseToken(mapName, context);
  }

  void callApiGetDistrict(BuildContext context, String id) {
    showProgressLoader(true);
    _dataProvider.onGetDistrictAcPc(context, id);
  }

  void callApiGetStates(BuildContext context, String id) {
    showProgressLoader(true);
    _dataProvider.onGetCountryStates(context, id);
  }

  void getAllCountries(BuildContext context) {
    showProgressLoader(true);
    _dataProvider.onGetCountries(context);
  }

  void callApiReportPost(BuildContext context, String id) {
    showProgressLoader(true);
    _dataProvider.calApiReportPost(context, id);
  }

  void callApiOtherUserProfile(BuildContext context, String id) {
    showProgressLoader(true);
    _dataProvider.calApiGetOtherProfile(context, id);
  }

  void callGetAllReplies(BuildContext context, String id, int page) {
    showProgressLoader(true);
    _dataProvider.callApiGetReplies(context, id, page);
  }

  void callApiUpVoteDownVoteReply(
      BuildContext context, String postId, String id, int pos, String type) {
    showProgressLoader(true);
    _dataProvider.openUpVoteDownVoteReply(context, postId, id, pos, type);
  }

  void callApiSharePostReply(BuildContext context, String id, String id2) {
    _dataProvider.apiSharePostReply(context, id, id2);
  }

  void getAllTopics(BuildContext context) {
    showProgressLoader(true);
    _dataProvider.onGetAllTopics(context);
  }

  void getAllNotifications(BuildContext context) {
    showProgressLoader(true);
    _dataProvider.getAllNotifications(context);
  }

  void submitSelectedTopics(BuildContext context, List<String> data) {
    _dataProvider.submitSelectedTopics(context, data);
  }

  void submitSelectedTopicsRemove(BuildContext context, List<String> value) {
    Map<String, dynamic> data = Map();
    data.putIfAbsent("topic", () => value[0]);
    _dataProvider.submitSelectedTopicsRemove(context, data);
  }
}
