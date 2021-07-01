import 'package:flutter/src/widgets/framework.dart';
import 'package:my_voicee/constants/app_constants.dart';
import 'package:my_voicee/models/errorResponse/customeError.dart';
import 'package:my_voicee/network/ApiUrls.dart';
import 'package:my_voicee/network/DioApiConfiguration.dart';
import 'package:my_voicee/network/api_callbacks.dart';
import 'package:my_voicee/utils/Utility.dart';

class TopicsDataRepository {
  final ApiCallback apiCallback;

  TopicsDataRepository(this.apiCallback);

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

  void submitSelectedTopics(BuildContext context, List<String> data) {
    checkInternetConnection().then((onValue) {
      !onValue
          ? apiCallback.onAPIError(
              CustomError('Check your internet connection.'), NO_INTERNET_FLAG)
          : _submitSelectedTopics(context, data);
    });
  }

  void _submitSelectedTopics(BuildContext context, List<String> data) {
    var url = '$saveTopics';
    Map<String, dynamic> requestMap = Map();
    requestMap.putIfAbsent("topics", () => data);
    try {
      ApiDioConfiguration.getInstance()
          .apiClient
          .liveService
          .apiPutRequest(context, url, requestMap, 'json')
          .then((response) {
            Map map = (response.data);
            try {
              if (map['status']) {
                apiCallback.onAPISuccess(map, SAVE_TOPICS_FLAG);
              } else {
                apiCallback.onAPIError(map, SAVE_TOPICS_FLAG);
              }
            } catch (error) {
              apiCallback.onAPIError(error, ERROR_EXCEPTION_FLAG);
            }
          })
          .timeout(Duration(seconds: 100))
          .catchError((error) {
            try {
              apiCallback.onAPIError(error.response.data, SAVE_TOPICS_FLAG);
            } catch (error) {
              apiCallback.onAPIError(error, ERROR_EXCEPTION_FLAG);
            }
          });
    } catch (error) {
      apiCallback.onAPIError(error, ERROR_EXCEPTION_FLAG);
    }
  }

  void submitSelectedTopicsRemove(
      BuildContext context, Map<String, dynamic> data) {
    checkInternetConnection().then((onValue) {
      !onValue
          ? apiCallback.onAPIError(
              CustomError('Check your internet connection.'), NO_INTERNET_FLAG)
          : _submitSelectedTopicsRemove(context, data);
    });
  }

  void _submitSelectedTopicsRemove(
      BuildContext context, Map<String, dynamic> requestMap) {
    var url = "$removeTopics";
    try {
      ApiDioConfiguration.getInstance()
          .apiClient
          .liveService
          .apiPutRequest(context, url, requestMap, 'json')
          .then((response) {
            Map map = (response.data);
            try {
              if (map['status']) {
                apiCallback.onAPISuccess(map, SAVE_TOPICS_FLAG);
              } else {
                apiCallback.onAPIError(map, SAVE_TOPICS_FLAG);
              }
            } catch (error) {
              apiCallback.onAPIError(error, ERROR_EXCEPTION_FLAG);
            }
          })
          .timeout(Duration(seconds: 100))
          .catchError((error) {
            try {
              apiCallback.onAPIError(error.response.data, SAVE_TOPICS_FLAG);
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
}
