import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:my_voicee/constants/app_constants.dart';
import 'package:my_voicee/models/FollowResponse.dart';
import 'package:my_voicee/models/FollowersModel.dart';
import 'package:my_voicee/models/FollowingsModel.dart';
import 'package:my_voicee/models/GetAllPostsResponse.dart';
import 'package:my_voicee/models/UserResponse.dart';
import 'package:my_voicee/models/commonResponse/CommonpiResponse.dart';
import 'package:my_voicee/models/errorResponse/error_reponse.dart';
import 'package:my_voicee/network/api_callbacks.dart';
import 'package:my_voicee/postLogin/profile/profileBloc/ProfileDataRepo.dart';
import 'package:my_voicee/utils/Utility.dart';
import 'package:rxdart/subjects.dart';

class ProfileBloc implements ApiCallback {
  final StreamController apiResponse;
  final StreamController apiResponseData;

  ProfileDataRepo _dataProvider;

  ProfileBloc(this.apiResponseData, this.apiResponse) {
    _dataProvider = ProfileDataRepo(this);
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
        if (!apiResponse.isClosed) {
          apiResponse.add(errorResponse);
        }
        break;
      case UP_DOWN_VOTE_POSTS:
        var errorResponse = ErrorResponse.fromJson(error);
        if (!apiResponse.isClosed) {
          apiResponse.add(errorResponse);
        }
        break;
      case REPORT_USER:
        var errorResponse = ErrorResponse.fromJson(error);
        if (!apiResponse.isClosed) {
          apiResponse.add(errorResponse);
        }
        break;
      case UPLOAD_PROFILE_PIC:
        var errorResponse = ErrorResponse.fromJson(error);
        if (!apiResponse.isClosed) {
          apiResponse.add(errorResponse);
        }
        break;
      case GET_PROFILE:
        var errorResponse = ErrorResponse.fromJson(error);
        if (!apiResponse.isClosed) {
          apiResponse.add(errorResponse);
        }
        break;
      case GET_FOLLOWINGS:
        var errorResponse = ErrorResponse.fromJson(error);
        if (!apiResponse.isClosed) {
          apiResponse.add(errorResponse);
        }
        break;
      case GET_FOLLOWERS:
        var errorResponse = ErrorResponse.fromJson(error);
        if (!apiResponse.isClosed) {
          apiResponse.add(errorResponse);
        }
        break;
      case UPDATE_USER_DETAIL:
        var errorResponse = ErrorResponse.fromJson(error);
        if (!apiResponse.isClosed) {
          apiResponse.add(errorResponse);
        }
        break;
      case GET_OTP_FLAG:
        var errorResponse = ErrorResponse.fromJson(error);
        if (!apiResponse.isClosed) {
          apiResponse.add(errorResponse);
        }
        break;
      case USER_FOLLOW:
        var errorResponse = ErrorResponse.fromJson(error);
        if (!apiResponse.isClosed) {
          apiResponse.add(errorResponse);
        }
        break;
      case REPORT_POST:
        var errorResponse = ErrorResponse.fromJson(error);
        if (!apiResponse.isClosed) {
          apiResponse.add(errorResponse);
        }
        break;
      case VERIFY_OTP_FLAG:
        var errorResponse = ErrorResponse.fromJson(error);
        if (!apiResponse.isClosed) {
          apiResponse.add(errorResponse);
        }
        break;
      case ERROR_EXCEPTION_FLAG:
        showProgressLoader(false);
        if (!apiResponse.isClosed) {
          apiResponse.add(Exception());
        }
        break;
      case NO_INTERNET_FLAG:
        if (!apiResponse.isClosed) {
          apiResponse.add(error);
        }
        break;
    }
  }

  @override
  void onAPISuccess(Map<dynamic, dynamic> data, int flag) {
    showProgressLoader(false);
    if (flag == GET_ALL_POSTS) {
      var registerResponse = GetAllPostResponse.fromJson(data);
      if (registerResponse.response != null) {
        if (!apiResponse.isClosed) {
          apiResponse.add(registerResponse);
          apiResponseData.add(registerResponse.response);
        }
      }
    } else if (flag == REPORT_POST) {
      var registerResponse = CommonApiReponse.fromJson(data);
      if (registerResponse.response != null) {
        if (!apiResponse.isClosed) {
          apiResponse.add(registerResponse);
        }
      }
    } else if (flag == UP_DOWN_VOTE_POSTS) {
      var registerResponse = CommonApiReponse.fromJson(data);
      if (!apiResponse.isClosed) {
        apiResponse.add(registerResponse);
      }
    } else if (flag == REPORT_USER) {
      var registerResponse = CommonApiReponse.fromJson(data);
      registerResponse.message =
          "Thank you for reporting the user. Our team will look at this account soon.";
      if (!apiResponse.isClosed) {
        apiResponse.add(registerResponse);
      }
    } else if (flag == UPLOAD_PROFILE_PIC) {
      var registerResponse = CommonApiReponse.fromJson(data);
      if (registerResponse.response != null) {
        if (!apiResponse.isClosed) {
          apiResponse.add(registerResponse);
        }
      }
    } else if (flag == GET_OTP_FLAG) {
      var registerResponse = CommonApiReponse.fromJson(data);
      registerResponse.show_msg = 6;
      if (registerResponse.response != null) {
        if (!apiResponse.isClosed) {
          apiResponse.add(registerResponse);
        }
      }
    } else if (flag == VERIFY_OTP_FLAG) {
      var registerResponse = CommonApiReponse.fromJson(data);
      registerResponse.show_msg = 7;
      if (registerResponse.response != null) {
        if (!apiResponse.isClosed) {
          apiResponse.add(registerResponse);
        }
      }
    } else if (flag == GET_FOLLOWINGS) {
      var registerResponse = FollowingsModel.fromJson(data);
      if (registerResponse.response != null) {
        if (!apiResponse.isClosed) {
          apiResponse.add(registerResponse.response);
        }
      }
    } else if (flag == GET_FOLLOWERS) {
      var registerResponse = FollowersModel.fromJson(data);
      if (registerResponse.response != null) {
        if (!apiResponse.isClosed) {
          apiResponse.add(registerResponse.response);
        }
      }
    } else if (flag == GET_PROFILE) {
      var registerResponse = UserResponse.fromJson(data);
      if (registerResponse.response != null) {
        writeStringDataLocally(
            key: userData, value: jsonEncode(registerResponse.response));
        if (!apiResponse.isClosed) {
          apiResponse.add(registerResponse);
        }
      }
    } else if (flag == UPDATE_USER_DETAIL) {
      var registerResponse = UserResponse.fromJson(data);
      if (registerResponse.response != null) {
        writeStringDataLocally(
            key: userData, value: jsonEncode(registerResponse.response));
        if (!apiResponse.isClosed) {
          apiResponse.add(registerResponse);
        }
      }
    } else if (flag == USER_FOLLOW) {
      var registerResponse = FollowResponse.fromJson(data);
      if (!apiResponse.isClosed) {
        apiResponse.add(registerResponse);
      }
    }
  }

  void getUserProfile(BuildContext context) {
    showProgressLoader(true);
    _dataProvider.onGetUserProfile(context);
  }

  void callApiGetAllPosts(BuildContext context, String userId, int page) {
    showProgressLoader(true);
    _dataProvider.callApiAllPost(context, userId, page);
  }

  void callApiUpVoteDownVote(BuildContext context, String id, String type) {
    showProgressLoader(true);
    _dataProvider.openUpVoteDownVote(context, id, type);
  }

  void saveUpdateProfile(BuildContext context, Map<String, dynamic> map) {
    showProgressLoader(true);
    _dataProvider.onSaveUpdateProfile(context, map);
  }

  void callApiUploadFile(BuildContext context, String filePath, int type) {
    showProgressLoader(true);
    _dataProvider.apiUploadFile(context, filePath, type);
  }

  void callApiSharePost(BuildContext context, String id) {
    _dataProvider.apiSharePost(context, id);
  }

  void callApiGetOTP(BuildContext context, String string) {
    showProgressLoader(true);
    _dataProvider.apiGetOTP(context, string);
  }

  void callApiVerifyOtp(BuildContext context, String phone, String otpCode) {
    showProgressLoader(true);
    _dataProvider.apiVerifyOTP(context, phone, otpCode);
  }

  void callApiResendOtp(BuildContext context, String phone) {
    showProgressLoader(true);
    _dataProvider.apicallApiResendOtp(context, phone);
  }

  void getFollowersList(BuildContext context) {
    showProgressLoader(true);
    _dataProvider.apiGetFollowersList(context);
  }

  void getFollowingsList(BuildContext context) {
    showProgressLoader(true);
    _dataProvider.apiGetFollowingsList(context);
  }

  void userFollow(BuildContext context, String id) {
    showProgressLoader(true);
    _dataProvider.apiUserFollow(context, id);
  }

  void callApiReportPost(BuildContext context, String id) {
    showProgressLoader(true);
    _dataProvider.calApiReportPost(context, id);
  }

  void callApiReportUser(BuildContext context, String title, String id) {
    showProgressLoader(true);
    _dataProvider.reportUser(context, title, id);
  }
}
