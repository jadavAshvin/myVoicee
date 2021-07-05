import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:my_voicee/constants/app_constants.dart';
import 'package:my_voicee/models/errorResponse/customeError.dart';
import 'package:my_voicee/network/ApiUrls.dart';
import 'package:my_voicee/network/DioApiConfiguration.dart';
import 'package:my_voicee/network/api_callbacks.dart';
import 'package:my_voicee/utils/Utility.dart';

class ChannelDataRepo {
  final ApiCallback apiCallback;

  ChannelDataRepo(this.apiCallback);

  void onGetUserProfile(context, userId) {
    checkInternetConnection().then((onValue) {
      !onValue ? apiCallback.onAPIError(CustomError('Check your internet connection.'), NO_INTERNET_FLAG) : _onGetUserChannels(context, userId);
    });
  }

  _onGetUserChannels(context, userId) {
    var url = '$userChannel$userId';
    try {
      ApiDioConfiguration.getInstance()
          .apiClient
          .liveService
          .apiGetRequest(context, url, null, 'nonjson')
          .then((response) {
            Map map = (response.data);
            try {
              if (map['status']) {
                apiCallback.onAPISuccess(map, GET_PROFILE);
              } else {
                apiCallback.onAPIError(map, GET_PROFILE);
              }
            } catch (error) {
              apiCallback.onAPIError(error, ERROR_EXCEPTION_FLAG);
            }
          })
          .timeout(Duration(seconds: 100))
          .catchError((error) {
            try {
              apiCallback.onAPIError(error.response.data, GET_PROFILE);
            } catch (error) {
              apiCallback.onAPIError(error, ERROR_EXCEPTION_FLAG);
            }
          });
    } catch (error) {
      apiCallback.onAPIError(error, ERROR_EXCEPTION_FLAG);
    }
  }

  void apiUploadFile(BuildContext context, String filePath, int type) {
    checkInternetConnection().then((onValue) {
      !onValue ? apiCallback.onAPIError(CustomError('Check your internet connection.'), NO_INTERNET_FLAG) : _apiUploadFile(context, filePath, type);
    });
  }

  void _apiUploadFile(BuildContext context, String filePath, int type) async {
    var url = type == 0 ? "$uploadGeneral" : "$uploadAudio";
    FormData formData;
    if (type == 1) {
      formData = FormData.fromMap({"file": await MultipartFile.fromFile(filePath), "language": "en-IN"});
    } else {
      formData = FormData.fromMap({"file": await MultipartFile.fromFile(filePath)});
    }
    try {
      ApiDioConfiguration.getInstance()
          .apiClient
          .liveService
          .apiMultipartRequest(context, url, formData, 'post', 'json')
          .then((response) {
            Map map = (response.data);
            try {
              if (map['status']) {
                if (type == 1) {
                  apiCallback.onAPISuccess(map, UPLOAD_PROFILE_PIC);
                } else {
                  apiCallback.onAPISuccess(map, UPLOAD_PROFILE_PIC);
                }
              } else {
                apiCallback.onAPIError(map, UPLOAD_PROFILE_PIC);
              }
            } catch (error) {
              apiCallback.onAPIError(error, ERROR_EXCEPTION_FLAG);
            }
          })
          .timeout(Duration(seconds: 100))
          .catchError((error) {
            try {
              apiCallback.onAPIError(error.response.data, UPLOAD_PROFILE_PIC);
            } catch (error) {
              apiCallback.onAPIError(error, ERROR_EXCEPTION_FLAG);
            }
          });
    } catch (error) {
      apiCallback.onAPIError(error, ERROR_EXCEPTION_FLAG);
    }
  }

  void onSaveUpdateProfile(BuildContext context, Map<String, dynamic> map) {
    checkInternetConnection().then((onValue) {
      !onValue ? apiCallback.onAPIError(CustomError('Check your internet connection.'), NO_INTERNET_FLAG) : _onSaveUpdateProfile(context, map);
    });
  }

  void _onSaveUpdateProfile(BuildContext context, Map<String, dynamic> map) {
    var url = '$userProfileInfo';
    try {
      ApiDioConfiguration.getInstance()
          .apiClient
          .liveService
          .apiPutRequest(context, url, map, 'nonjson')
          .then((response) {
            Map map = (response.data);
            try {
              if (map['status']) {
                apiCallback.onAPISuccess(map, UPDATE_USER_DETAIL);
              } else {
                apiCallback.onAPIError(map, UPDATE_USER_DETAIL);
              }
            } catch (error) {
              apiCallback.onAPIError(error, ERROR_EXCEPTION_FLAG);
            }
          })
          .timeout(Duration(seconds: 100))
          .catchError((error) {
            try {
              apiCallback.onAPIError(error.response.data, UPDATE_USER_DETAIL);
            } catch (error) {
              apiCallback.onAPIError(error, ERROR_EXCEPTION_FLAG);
            }
          });
    } catch (error) {
      apiCallback.onAPIError(error, ERROR_EXCEPTION_FLAG);
    }
  }

  void callApiAllPost(BuildContext context, String userId, int page) {
    checkInternetConnection().then((onValue) {
      !onValue ? apiCallback.onAPIError(CustomError('Check your internet connection.'), NO_INTERNET_FLAG) : _onCallApiAllPost(context, userId, page);
    });
  }

  _onCallApiAllPost(BuildContext context, String userId, int page) {
    var url = '$allUserPosts?userId=$userId&page=$page&limit=10';
    try {
      ApiDioConfiguration.getInstance()
          .apiClient
          .liveService
          .apiGetRequest(context, url, null, 'nonjson')
          .then((response) {
            if (response != null) {
              Map map = (response.data);
              try {
                if (map['status']) {
                  apiCallback.onAPISuccess(map, GET_ALL_POSTS);
                } else {
                  apiCallback.onAPIError(map, GET_ALL_POSTS);
                }
              } catch (error) {
                apiCallback.onAPIError(error, ERROR_EXCEPTION_FLAG);
              }
            } else {
              apiCallback.onAPIError(null, ERROR_EXCEPTION_FLAG);
            }
          })
          .timeout(Duration(seconds: 100))
          .catchError((error) {
            try {
              apiCallback.onAPIError(error.response.data, GET_ALL_POSTS);
            } catch (error) {
              apiCallback.onAPIError(error, ERROR_EXCEPTION_FLAG);
            }
          });
    } catch (error) {
      apiCallback.onAPIError(error, ERROR_EXCEPTION_FLAG);
    }
  }

  void openUpVoteDownVote(BuildContext context, String id, String type) {
    checkInternetConnection().then((onValue) {
      !onValue
          ? apiCallback.onAPIError(CustomError('Check your internet connection.'), NO_INTERNET_FLAG)
          : _onCallApiUpVoteDownVote(context, id, type);
    });
  }

  _onCallApiUpVoteDownVote(BuildContext context, String id, String type) {
    var url = "";
    if (type == "1") {
      url = "$upVotePostsApi$id";
    } else {
      url = "$downVotePostsApi$id";
    }
    try {
      ApiDioConfiguration.getInstance()
          .apiClient
          .liveService
          .apiPutRequest(context, url, null, 'nonjson')
          .then((response) {
            Map map = (response.data);
            try {
              if (map['status']) {
                apiCallback.onAPISuccess(map, UP_DOWN_VOTE_POSTS);
              } else {
                apiCallback.onAPIError(map, UP_DOWN_VOTE_POSTS);
              }
            } catch (error) {
              apiCallback.onAPIError(error, ERROR_EXCEPTION_FLAG);
            }
          })
          .timeout(Duration(seconds: 100))
          .catchError((error) {
            try {
              apiCallback.onAPIError(error.response.data, UP_DOWN_VOTE_POSTS);
            } catch (error) {
              apiCallback.onAPIError(error, ERROR_EXCEPTION_FLAG);
            }
          });
    } catch (error) {
      apiCallback.onAPIError(error, ERROR_EXCEPTION_FLAG);
    }
  }

  void apiSharePost(BuildContext context, String id) {
    var url = "$sharePost$id";
    try {
      ApiDioConfiguration.getInstance()
          .apiClient
          .liveService
          .apiPutRequest(context, url, null, 'nonjson')
          .then((response) {})
          .timeout(Duration(seconds: 100))
          .catchError((error) {
        try {
          apiCallback.onAPIError(error.response.data, UP_DOWN_VOTE_POSTS);
        } catch (error) {
          apiCallback.onAPIError(error, ERROR_EXCEPTION_FLAG);
        }
      });
    } catch (error) {
      apiCallback.onAPIError(error, ERROR_EXCEPTION_FLAG);
    }
  }

  void apiGetOTP(BuildContext context, String number) {
    checkInternetConnection().then((onValue) {
      !onValue ? apiCallback.onAPIError(CustomError('Check your internet connection.'), NO_INTERNET_FLAG) : _apiGetOTP(context, number);
    });
  }

  void _apiGetOTP(BuildContext context, String number) {
    var url = '$sendOTP';
    Map<String, dynamic> requestData = Map();
    requestData.putIfAbsent("mobile", () => number);
    try {
      ApiDioConfiguration.getInstance()
          .apiClient
          .liveService
          .apiPostRequest(context, url, 'json', requestData)
          .then((response) {
            Map map = (response.data);
            try {
              if (map['status']) {
                apiCallback.onAPISuccess(map, GET_OTP_FLAG);
              } else {
                apiCallback.onAPIError(map, GET_OTP_FLAG);
              }
            } catch (error) {
              apiCallback.onAPIError(error, ERROR_EXCEPTION_FLAG);
            }
          })
          .timeout(Duration(seconds: 100))
          .catchError((error) {
            try {
              apiCallback.onAPIError(error.response.data, GET_OTP_FLAG);
            } catch (error) {
              apiCallback.onAPIError(error, ERROR_EXCEPTION_FLAG);
            }
          });
    } catch (error) {
      apiCallback.onAPIError(error, ERROR_EXCEPTION_FLAG);
    }
  }

  void apiVerifyOTP(BuildContext context, String number, String otp) {
    checkInternetConnection().then((onValue) {
      !onValue ? apiCallback.onAPIError(CustomError('Check your internet connection.'), NO_INTERNET_FLAG) : _apiVerifyOTP(context, number, otp);
    });
  }

  void _apiVerifyOTP(BuildContext context, String number, String Otp) {
    var url = '$verifyOTP';
    Map<String, dynamic> requestData = Map();
    requestData.putIfAbsent("mobile", () => number);
    requestData.putIfAbsent("otp", () => Otp);
    try {
      ApiDioConfiguration.getInstance()
          .apiClient
          .liveService
          .apiPostRequest(context, url, 'json', requestData)
          .then((response) {
            Map map = (response.data);
            try {
              if (map['status']) {
                apiCallback.onAPISuccess(map, VERIFY_OTP_FLAG);
              } else {
                apiCallback.onAPIError(map, VERIFY_OTP_FLAG);
              }
            } catch (error) {
              apiCallback.onAPIError(error, ERROR_EXCEPTION_FLAG);
            }
          })
          .timeout(Duration(seconds: 100))
          .catchError((error) {
            try {
              apiCallback.onAPIError(error.response.data, VERIFY_OTP_FLAG);
            } catch (error) {
              apiCallback.onAPIError(error, ERROR_EXCEPTION_FLAG);
            }
          });
    } catch (error) {
      apiCallback.onAPIError(error, ERROR_EXCEPTION_FLAG);
    }
  }

  void apicallApiResendOtp(BuildContext context, String phone) {
    checkInternetConnection().then((onValue) {
      !onValue ? apiCallback.onAPIError(CustomError('Check your internet connection.'), NO_INTERNET_FLAG) : _apiapicallApiResendOtp(context, phone);
    });
  }

  void _apiapicallApiResendOtp(BuildContext context, String phone) {
    var url = '$resendOTP';
    Map<String, dynamic> requestData = Map();
    requestData.putIfAbsent("mobile", () => phone);
    try {
      ApiDioConfiguration.getInstance()
          .apiClient
          .liveService
          .apiPostRequest(context, url, 'json', requestData)
          .then((response) {
            Map map = (response.data);
            try {
              if (map['status']) {
                apiCallback.onAPISuccess(map, GET_OTP_FLAG);
              } else {
                apiCallback.onAPIError(map, GET_OTP_FLAG);
              }
            } catch (error) {
              apiCallback.onAPIError(error, ERROR_EXCEPTION_FLAG);
            }
          })
          .timeout(Duration(seconds: 100))
          .catchError((error) {
            try {
              apiCallback.onAPIError(error.response.data, GET_OTP_FLAG);
            } catch (error) {
              apiCallback.onAPIError(error, ERROR_EXCEPTION_FLAG);
            }
          });
    } catch (error) {
      apiCallback.onAPIError(error, ERROR_EXCEPTION_FLAG);
    }
  }

  void apiGetFollowersList(BuildContext context) {
    checkInternetConnection().then((onValue) {
      !onValue ? apiCallback.onAPIError(CustomError('Check your internet connection.'), NO_INTERNET_FLAG) : _apiGetFollowersList(context);
    });
  }

  void _apiGetFollowersList(BuildContext context) {
    var url = '$userFollowers';
    try {
      ApiDioConfiguration.getInstance()
          .apiClient
          .liveService
          .apiGetRequest(context, url, null, 'nonjson')
          .then((response) {
            if (response != null) {
              Map map = (response.data);
              try {
                if (map['status']) {
                  apiCallback.onAPISuccess(map, GET_FOLLOWERS);
                } else {
                  apiCallback.onAPIError(map, GET_FOLLOWERS);
                }
              } catch (error) {
                apiCallback.onAPIError(error, ERROR_EXCEPTION_FLAG);
              }
            } else {
              apiCallback.onAPIError(null, ERROR_EXCEPTION_FLAG);
            }
          })
          .timeout(Duration(seconds: 100))
          .catchError((error) {
            try {
              apiCallback.onAPIError(error.response.data, GET_FOLLOWERS);
            } catch (error) {
              apiCallback.onAPIError(error, ERROR_EXCEPTION_FLAG);
            }
          });
    } catch (error) {
      apiCallback.onAPIError(error, ERROR_EXCEPTION_FLAG);
    }
  }

  void apiGetFollowingsList(BuildContext context) {
    checkInternetConnection().then((onValue) {
      !onValue ? apiCallback.onAPIError(CustomError('Check your internet connection.'), NO_INTERNET_FLAG) : _apiGetFollowingsList(context);
    });
  }

  void _apiGetFollowingsList(BuildContext context) {
    var url = '$userFollowings';
    try {
      ApiDioConfiguration.getInstance()
          .apiClient
          .liveService
          .apiGetRequest(context, url, null, 'nonjson')
          .then((response) {
            if (response != null) {
              Map map = (response.data);
              try {
                if (map['status']) {
                  apiCallback.onAPISuccess(map, GET_FOLLOWINGS);
                } else {
                  apiCallback.onAPIError(map, GET_FOLLOWINGS);
                }
              } catch (error) {
                apiCallback.onAPIError(error, ERROR_EXCEPTION_FLAG);
              }
            } else {
              apiCallback.onAPIError(null, ERROR_EXCEPTION_FLAG);
            }
          })
          .timeout(Duration(seconds: 100))
          .catchError((error) {
            try {
              apiCallback.onAPIError(error.response.data, GET_FOLLOWINGS);
            } catch (error) {
              apiCallback.onAPIError(error, ERROR_EXCEPTION_FLAG);
            }
          });
    } catch (error) {
      apiCallback.onAPIError(error, ERROR_EXCEPTION_FLAG);
    }
  }

  void apiUserFollow(BuildContext context, String id) {
    checkInternetConnection().then((onValue) {
      !onValue ? apiCallback.onAPIError(CustomError('Check your internet connection.'), NO_INTERNET_FLAG) : _apiUserFollow(context, id);
    });
  }

  void _apiUserFollow(BuildContext context, String id) {
    var url = '$userFollow/$id';
    Map<String, dynamic> requestData = Map();
    try {
      ApiDioConfiguration.getInstance()
          .apiClient
          .liveService
          .apiPostRequest(context, url, 'json', requestData)
          .then((response) {
            Map map = (response.data);
            try {
              if (map['status']) {
                apiCallback.onAPISuccess(map, USER_FOLLOW);
              } else {
                apiCallback.onAPIError(map, USER_FOLLOW);
              }
            } catch (error) {
              apiCallback.onAPIError(error, ERROR_EXCEPTION_FLAG);
            }
          })
          .timeout(Duration(seconds: 100))
          .catchError((error) {
            try {
              apiCallback.onAPIError(error.response.data, USER_FOLLOW);
            } catch (error) {
              apiCallback.onAPIError(error, ERROR_EXCEPTION_FLAG);
            }
          });
    } catch (error) {
      apiCallback.onAPIError(error, ERROR_EXCEPTION_FLAG);
    }
  }

  void calApiReportPost(BuildContext context, String id) {
    var url = "$reportPost$id";
    try {
      ApiDioConfiguration.getInstance()
          .apiClient
          .liveService
          .apiPutRequest(context, url, null, 'nonjson')
          .then((response) {
            Map map = (response.data);
            try {
              if (map['status']) {
                apiCallback.onAPISuccess(map, REPORT_POST);
              } else {
                apiCallback.onAPIError(map, REPORT_POST);
              }
            } catch (error) {
              apiCallback.onAPIError(error, ERROR_EXCEPTION_FLAG);
            }
          })
          .timeout(Duration(seconds: 100))
          .catchError((error) {
            try {
              apiCallback.onAPIError(error.response.data, REPORT_POST);
            } catch (error) {
              apiCallback.onAPIError(error, ERROR_EXCEPTION_FLAG);
            }
          });
    } catch (error) {
      apiCallback.onAPIError(error, ERROR_EXCEPTION_FLAG);
    }
  }

  void reportUser(BuildContext context, String title, String id) {
    checkInternetConnection().then((onValue) {
      !onValue ? apiCallback.onAPIError(CustomError('Check your internet connection.'), NO_INTERNET_FLAG) : _reportUser(context, title, id);
    });
  }

  _reportUser(BuildContext context, String title, String id) {
    var url = "$reportUsers/$id";
    Map<String, dynamic> request = Map();
    request.putIfAbsent("title", () => title);
    try {
      ApiDioConfiguration.getInstance()
          .apiClient
          .liveService
          .apiPostRequest(context, url, "json", request)
          .then((response) {
            Map map = (response.data);
            try {
              if (map['status']) {
                apiCallback.onAPISuccess(map, REPORT_USER);
              } else {
                apiCallback.onAPIError(map, REPORT_USER);
              }
            } catch (error) {
              apiCallback.onAPIError(error, ERROR_EXCEPTION_FLAG);
            }
          })
          .timeout(Duration(seconds: 100))
          .catchError((error) {
            try {
              apiCallback.onAPIError(error.response.data, REPORT_USER);
            } catch (error) {
              apiCallback.onAPIError(error, ERROR_EXCEPTION_FLAG);
            }
          });
    } catch (error) {
      apiCallback.onAPIError(error, ERROR_EXCEPTION_FLAG);
    }
  }
}
