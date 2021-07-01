import 'package:flutter/material.dart';
import 'package:my_voicee/constants/app_constants.dart';
import 'package:my_voicee/models/errorResponse/customeError.dart';
import 'package:my_voicee/network/ApiUrls.dart';
import 'package:my_voicee/network/DioApiConfiguration.dart';
import 'package:my_voicee/network/api_callbacks.dart';
import 'package:my_voicee/utils/Utility.dart';

class DashboardDataRepo {
  final ApiCallback apiCallback;

  DashboardDataRepo(this.apiCallback);

  void callApiAllPost(BuildContext context, int page, List<String> filterIds) {
    checkInternetConnection().then((onValue) {
      !onValue
          ? apiCallback.onAPIError(
              CustomError('Check your internet connection.'), NO_INTERNET_FLAG)
          : _onCallApiAllPost(context, page, filterIds);
    });
  }

  void _onCallApiAllPost(
      BuildContext context, int page, List<String> filterIds) {
    var url;
    if (filterIds.length > 0) {
      url =
          "$allUserPosts?page=$page&topic_id=${formatString(filterIds).trim()}&limit=10";
    } else {
      url = "$allUserPosts?page=$page&limit=10";
    }

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

  void openUpVoteDownVote(
      BuildContext context, String id, int pos, String type) {
    checkInternetConnection().then((onValue) {
      !onValue
          ? apiCallback.onAPIError(
              CustomError('Check your internet connection.'), NO_INTERNET_FLAG)
          : _onCallApiUpVoteDownVote(context, id, pos, type);
    });
  }

  void _onCallApiUpVoteDownVote(
      BuildContext context, String id, int pos, String type) {
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
                map.putIfAbsent("from", () => type);
                map.putIfAbsent("pos", () => pos);
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

  void UpdateFirebaseToken(Map<String, dynamic> mapName, BuildContext context) {
    var url = "$updateFcmToken";
    try {
      ApiDioConfiguration.getInstance()
          .apiClient
          .liveService
          .apiPutRequest(context, url, mapName, 'json')
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

  void onGetDistrictAcPc(BuildContext context, String id) {
    checkInternetConnection().then((onValue) {
      !onValue
          ? apiCallback.onAPIError(
              CustomError('Check your internet connection.'), NO_INTERNET_FLAG)
          : _onGetDistrictAcPc(context, id);
    });
  }

  _onGetDistrictAcPc(BuildContext context, String id) {
    var url = '$userDistrictAcPc$id';
    try {
      ApiDioConfiguration.getInstance()
          .apiClient
          .liveService
          .apiGetRequest(context, url, null, 'nonjson')
          .then((response) {
            Map map = (response.data);
            try {
              if (map['status']) {
                apiCallback.onAPISuccess(map, GET_DISTRICT_AC_PC);
              } else {
                apiCallback.onAPIError(map, GET_DISTRICT_AC_PC);
              }
            } catch (error) {
              apiCallback.onAPIError(error, ERROR_EXCEPTION_FLAG);
            }
          })
          .timeout(Duration(seconds: 100))
          .catchError((error) {
            try {
              apiCallback.onAPIError(error.response.data, GET_DISTRICT_AC_PC);
            } catch (error) {
              apiCallback.onAPIError(error, ERROR_EXCEPTION_FLAG);
            }
          });
    } catch (error) {
      apiCallback.onAPIError(error, ERROR_EXCEPTION_FLAG);
    }
  }

  void onGetCountryStates(BuildContext context, String id) {
    checkInternetConnection().then((onValue) {
      !onValue
          ? apiCallback.onAPIError(
              CustomError('Check your internet connection.'), NO_INTERNET_FLAG)
          : _onGetCountriesState(context, id);
    });
  }

  void _onGetCountriesState(BuildContext context, String id) {
    var url = '$userState$id';
    try {
      ApiDioConfiguration.getInstance()
          .apiClient
          .liveService
          .apiGetRequest(context, url, null, 'nonjson')
          .then((response) {
            Map map = (response.data);
            try {
              if (map['status']) {
                apiCallback.onAPISuccess(map, GET_STATES);
              } else {
                apiCallback.onAPIError(map, GET_STATES);
              }
            } catch (error) {
              apiCallback.onAPIError(error, ERROR_EXCEPTION_FLAG);
            }
          })
          .timeout(Duration(seconds: 100))
          .catchError((error) {
            try {
              apiCallback.onAPIError(error.response.data, GET_STATES);
            } catch (error) {
              apiCallback.onAPIError(error, ERROR_EXCEPTION_FLAG);
            }
          });
    } catch (error) {
      apiCallback.onAPIError(error, ERROR_EXCEPTION_FLAG);
    }
  }

  void onGetCountries(BuildContext context) {
    checkInternetConnection().then((onValue) {
      !onValue
          ? apiCallback.onAPIError(
              CustomError('Check your internet connection.'), NO_INTERNET_FLAG)
          : _onGetCountries(context);
    });
  }

  void _onGetCountries(BuildContext context) {
    var url = '$userCountry';
    try {
      ApiDioConfiguration.getInstance()
          .apiClient
          .liveService
          .apiGetRequest(context, url, null, 'nonjson')
          .then((response) {
            Map map = (response.data);
            try {
              if (map['status']) {
                apiCallback.onAPISuccess(map, GET_COUNTRIES);
              } else {
                apiCallback.onAPIError(map, GET_COUNTRIES);
              }
            } catch (error) {
              apiCallback.onAPIError(error, ERROR_EXCEPTION_FLAG);
            }
          })
          .timeout(Duration(seconds: 100))
          .catchError((error) {
            try {
              apiCallback.onAPIError(error.response.data, GET_COUNTRIES);
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

  void calApiGetOtherProfile(BuildContext context, String id) {
    checkInternetConnection().then((onValue) {
      !onValue
          ? apiCallback.onAPIError(
              CustomError('Check your internet connection.'), NO_INTERNET_FLAG)
          : _onGetUserProfile(context, id);
    });
  }

  _onGetUserProfile(context, id) {
    var url = '$publicProfile/$id';
    try {
      ApiDioConfiguration.getInstance()
          .apiClient
          .liveService
          .apiGetRequest(context, url, null, 'nonjson')
          .then((response) {
            Map map = (response.data);
            try {
              if (map['status']) {
                apiCallback.onAPISuccess(map, GET_OTHER_PROFILE);
              } else {
                apiCallback.onAPIError(map, GET_OTHER_PROFILE);
              }
            } catch (error) {
              apiCallback.onAPIError(error, ERROR_EXCEPTION_FLAG);
            }
          })
          .timeout(Duration(seconds: 100))
          .catchError((error) {
            try {
              apiCallback.onAPIError(error.response.data, GET_OTHER_PROFILE);
            } catch (error) {
              apiCallback.onAPIError(error, ERROR_EXCEPTION_FLAG);
            }
          });
    } catch (error) {
      apiCallback.onAPIError(error, ERROR_EXCEPTION_FLAG);
    }
  }

  void callApiGetReplies(BuildContext context, String id, int page) {
    var url = "$commentPosts/$id?page=$page&limit=10";

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
                  apiCallback.onAPISuccess(map, GET_USER_COMMENTS);
                } else {
                  apiCallback.onAPIError(map, GET_USER_COMMENTS);
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
              apiCallback.onAPIError(error.response.data, GET_USER_COMMENTS);
            } catch (error) {
              apiCallback.onAPIError(error, ERROR_EXCEPTION_FLAG);
            }
          });
    } catch (error) {
      apiCallback.onAPIError(error, ERROR_EXCEPTION_FLAG);
    }
  }

  void openUpVoteDownVoteReply(
      BuildContext context, String postId, String id, int pos, String type) {
    var url = "";
    if (type == "1") {
      url = "$replyPostUpVote$postId/$id";
    } else {
      url = "$replyPostDownVote$postId/$id";
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
                map.putIfAbsent("from", () => type);
                map.putIfAbsent("pos", () => pos);
                apiCallback.onAPISuccess(map, UP_DOWN_VOTE_COMMENTS);
              } else {
                apiCallback.onAPIError(map, UP_DOWN_VOTE_COMMENTS);
              }
            } catch (error) {
              apiCallback.onAPIError(error, ERROR_EXCEPTION_FLAG);
            }
          })
          .timeout(Duration(seconds: 100))
          .catchError((error) {
            try {
              apiCallback.onAPIError(
                  error.response.data, UP_DOWN_VOTE_COMMENTS);
            } catch (error) {
              apiCallback.onAPIError(error, ERROR_EXCEPTION_FLAG);
            }
          });
    } catch (error) {
      apiCallback.onAPIError(error, ERROR_EXCEPTION_FLAG);
    }
  }

  void apiSharePostReply(BuildContext context, String id, String id2) {
    var url = "$shareComment$id/$id2";
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

  void getAllNotifications(BuildContext context) {
    checkInternetConnection().then((onValue) {
      !onValue
          ? apiCallback.onAPIError(
              CustomError('Check your internet connection.'), NO_INTERNET_FLAG)
          : _getAllNotifications(context);
    });
  }

  void _getAllNotifications(BuildContext context) {
    var url = '$userNotifications';
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
                apiCallback.onAPISuccess(map, NOTIFICATIONS_FLAG);
              } else {
                apiCallback.onAPIError(map, NOTIFICATIONS_FLAG);
              }
            } catch (error) {
              apiCallback.onAPIError(error, ERROR_EXCEPTION_FLAG);
            }
          })
          .timeout(Duration(seconds: 100))
          .catchError((error) {
            try {
              apiCallback.onAPIError(error.response.data, NOTIFICATIONS_FLAG);
            } catch (error) {
              apiCallback.onAPIError(error, ERROR_EXCEPTION_FLAG);
            }
          });
    } catch (error) {
      apiCallback.onAPIError(error, ERROR_EXCEPTION_FLAG);
    }
  }
}
