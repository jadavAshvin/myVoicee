import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:my_voicee/constants/app_constants.dart';
import 'package:my_voicee/models/errorResponse/customeError.dart';
import 'package:my_voicee/network/ApiUrls.dart';
import 'package:my_voicee/network/DioApiConfiguration.dart';
import 'package:my_voicee/network/api_callbacks.dart';
import 'package:my_voicee/utils/Utility.dart';

class AddPostDataRepo {
  final ApiCallback apiCallback;

  AddPostDataRepo(this.apiCallback);

  void apiSavePost(BuildContext context, Map<String, dynamic> requestData) {
    checkInternetConnection().then((onValue) {
      !onValue
          ? apiCallback.onAPIError(
              CustomError('Check your internet connection.'), NO_INTERNET_FLAG)
          : _apiSavePost(context, requestData);
    });
  }

  void _apiSavePost(BuildContext context, Map<String, dynamic> requestData) {
    try {
      ApiDioConfiguration.getInstance()
          .apiClient
          .liveService
          .apiPostRequest(context, '$savePost', 'json', requestData)
          .then((response) {
            Map map = (response.data);
            try {
              if (map['status']) {
                apiCallback.onAPISuccess(map, ADD_POST);
              } else {
                apiCallback.onAPIError(map, ADD_POST);
              }
            } catch (error) {
              apiCallback.onAPIError(error, ERROR_EXCEPTION_FLAG);
            }
          })
          .timeout(Duration(seconds: 100))
          .catchError((error) {
            try {
              apiCallback.onAPIError(error.response.data, ADD_POST);
            } catch (error) {
              apiCallback.onAPIError(error, ERROR_EXCEPTION_FLAG);
            }
          });
    } catch (error) {
      apiCallback.onAPIError(error, ERROR_EXCEPTION_FLAG);
    }
  }

  void apiGetSingle(BuildContext context, String id) {
    var url = "$savePost/$id";
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
                  apiCallback.onAPISuccess(map, GET_A_POST);
                } else {
                  apiCallback.onAPIError(map, GET_A_POST);
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
              apiCallback.onAPIError(error.response.data, GET_A_POST);
            } catch (error) {
              apiCallback.onAPIError(error, ERROR_EXCEPTION_FLAG);
            }
          });
    } catch (error) {
      apiCallback.onAPIError(error, ERROR_EXCEPTION_FLAG);
    }
  }

  void apiReplyPost(BuildContext context, String trim, String audioUrl,
      String id, String duration) {
    checkInternetConnection().then((onValue) {
      !onValue
          ? apiCallback.onAPIError(
              CustomError('Check your internet connection.'), NO_INTERNET_FLAG)
          : _apiReplyPost(context, trim, audioUrl, id, duration);
    });
  }

  _apiReplyPost(BuildContext context, String trim, String audioUrl, String id,
      String duration) {
    Map<String, dynamic> map = Map();
    map.putIfAbsent('comment', () => trim);
    map.putIfAbsent('comment_url', () => audioUrl);
    map.putIfAbsent('audio_duration', () => duration);
    try {
      ApiDioConfiguration.getInstance()
          .apiClient
          .liveService
          .apiPostRequest(context, '$replyPost/$id', 'json', map)
          .then((response) {
            Map map = (response.data);
            try {
              if (map['status']) {
                apiCallback.onAPISuccess(map, ADD_COMMENT);
              } else {
                apiCallback.onAPIError(map, ADD_COMMENT);
              }
            } catch (error) {
              apiCallback.onAPIError(error, ERROR_EXCEPTION_FLAG);
            }
          })
          .timeout(Duration(seconds: 100))
          .catchError((error) {
            try {
              apiCallback.onAPIError(error.response.data, ADD_COMMENT);
            } catch (error) {
              apiCallback.onAPIError(error, ERROR_EXCEPTION_FLAG);
            }
          });
    } catch (error) {
      apiCallback.onAPIError(error, ERROR_EXCEPTION_FLAG);
    }
  }

  void apiGetChannelsList(BuildContext context) {
    checkInternetConnection().then((onValue) {
      !onValue
          ? apiCallback.onAPIError(
              CustomError('Check your internet connection.'), NO_INTERNET_FLAG)
          : _apiGetChannelsList(context);
    });
  }

  void _apiGetChannelsList(BuildContext context) {
    var url = '$channelList?my_channel=true';
    Map<String, dynamic> data = Map();
    try {
      ApiDioConfiguration.getInstance()
          .apiClient
          .liveService
          .apiGetRequest(context, url, data, 'json')
          .then((response) {
            Map map = (response.data);
            try {
              if (map['status']) {
                apiCallback.onAPISuccess(map, GET_CHANNELS_FLAG);
              } else {
                apiCallback.onAPIError(map, GET_CHANNELS_FLAG);
              }
            } catch (error) {
              apiCallback.onAPIError(error, ERROR_EXCEPTION_FLAG);
            }
          })
          .timeout(Duration(seconds: 100))
          .catchError((error) {
            try {
              apiCallback.onAPIError(error.response.data, GET_CHANNELS_FLAG);
            } catch (error) {
              apiCallback.onAPIError(error, ERROR_EXCEPTION_FLAG);
            }
          });
    } catch (error) {
      apiCallback.onAPIError(error, ERROR_EXCEPTION_FLAG);
    }
  }

  void onGetAllTopics(context) {
    checkInternetConnection().then((onValue) {
      !onValue
          ? apiCallback.onAPIError(
              CustomError('Check your internet connection.'), NO_INTERNET_FLAG)
          : _onGetAllTopics(context);
    });
  }

  void _onGetAllTopics(BuildContext context) {
    var url = '$topics';
    Map<String, dynamic> data = Map();
    try {
      ApiDioConfiguration.getInstance()
          .apiClient
          .liveService
          .apiGetRequest(context, url, data, 'json')
          .then((response) {
            Map map = (response.data);
            try {
              if (map['status']) {
                apiCallback.onAPISuccess(map, TOPICS_FLAG);
              } else {
                apiCallback.onAPIError(map, TOPICS_FLAG);
              }
            } catch (error) {
              apiCallback.onAPIError(error, ERROR_EXCEPTION_FLAG);
            }
          })
          .timeout(Duration(seconds: 100))
          .catchError((error) {
            try {
              apiCallback.onAPIError(error.response.data, TOPICS_FLAG);
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
      !onValue
          ? apiCallback.onAPIError(
              CustomError('Check your internet connection.'), NO_INTERNET_FLAG)
          : _apiUploadFile(context, filePath, type);
    });
  }

  void _apiUploadFile(BuildContext context, String filePath, int type) async {
    var url = type == 0 ? "$uploadGeneral" : "$uploadAudio";
    FormData formData;
    if (type == 1) {
      formData = FormData.fromMap({
        "file": await MultipartFile.fromFile(filePath),
        "language": "en-IN"
      });
    } else {
      formData =
          FormData.fromMap({"file": await MultipartFile.fromFile(filePath)});
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
                map.putIfAbsent("nav_type", () => type);
                apiCallback.onAPISuccess(map, UPLOAD_FILE);
              } else {
                apiCallback.onAPIError(map, UPLOAD_FILE);
              }
            } catch (error) {
              apiCallback.onAPIError(error, ERROR_EXCEPTION_FLAG);
            }
          })
          .timeout(Duration(seconds: 100))
          .catchError((error) {
            try {
              apiCallback.onAPIError(error.response.data, UPLOAD_FILE);
            } catch (error) {
              apiCallback.onAPIError(error, ERROR_EXCEPTION_FLAG);
            }
          });
    } catch (error) {
      apiCallback.onAPIError(error, ERROR_EXCEPTION_FLAG);
    }
  }
}
