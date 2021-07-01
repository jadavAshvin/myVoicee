import 'package:flutter/src/widgets/framework.dart';
import 'package:my_voicee/constants/app_constants.dart';
import 'package:my_voicee/models/errorResponse/customeError.dart';
import 'package:my_voicee/network/ApiUrls.dart';
import 'package:my_voicee/network/DioApiConfiguration.dart';
import 'package:my_voicee/network/api_callbacks.dart';
import 'package:my_voicee/utils/Utility.dart';

class UpdateInfoDataRepository {
  final ApiCallback apiCallback;

  UpdateInfoDataRepository(this.apiCallback);

  void onUserLogin(Map data, context, int type) {
    checkInternetConnection().then((onValue) {
      !onValue
          ? apiCallback.onAPIError(
              CustomError('Check your internet connection.'), NO_INTERNET_FLAG)
          : _onLogin(data, context, type);
    });
  }

  void _onLogin(Map data, context, int type) async {
    var url = '';
    if (type == isFacebook) {
      url = '$loginFacebook';
    } else if (type == isGoogle) {
      url = '$loginGoogle';
    } else if (type == isTWitter) {
      url = '$loginTwitter';
    } else if (type == isApple) {
      url = '$loginApple';
    }
    try {
      ApiDioConfiguration.getInstance()
          .apiClient
          .liveService
          .apiPostRequest(context, url, 'json', data)
          .then((response) {
            Map map = (response.data);
            try {
              if (map['status']) {
                apiCallback.onAPISuccess(map, LOGIN_FLAG);
              } else {
                apiCallback.onAPIError(map, LOGIN_FLAG);
              }
            } catch (error) {
              apiCallback.onAPIError(error, ERROR_EXCEPTION_FLAG);
            }
          })
          .timeout(Duration(seconds: 100))
          .catchError((error) {
            try {
              apiCallback.onAPIError(error.response.data, LOGIN_FLAG);
            } catch (error) {
              apiCallback.onAPIError(error, ERROR_EXCEPTION_FLAG);
            }
          });
    } catch (error) {
      apiCallback.onAPIError(error, ERROR_EXCEPTION_FLAG);
    }
  }

  void onGetUserProfile(context) {
    checkInternetConnection().then((onValue) {
      !onValue
          ? apiCallback.onAPIError(
              CustomError('Check your internet connection.'), NO_INTERNET_FLAG)
          : _onGetUserProfile(context);
    });
  }

  _onGetUserProfile(context) {
    var url = '$userProfile';
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

  void onGetCountries(BuildContext context) {
    checkInternetConnection().then((onValue) {
      !onValue
          ? apiCallback.onAPIError(
              CustomError('Check your internet connection.'), NO_INTERNET_FLAG)
          : _onGetCountries(context);
    });
  }

  void onGetCountryStates(BuildContext context, String id) {
    checkInternetConnection().then((onValue) {
      !onValue
          ? apiCallback.onAPIError(
              CustomError('Check your internet connection.'), NO_INTERNET_FLAG)
          : _onGetCountriesState(context, id);
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

  void onSaveUpdateProfile(BuildContext context, Map<String, dynamic> map) {
    checkInternetConnection().then((onValue) {
      !onValue
          ? apiCallback.onAPIError(
              CustomError('Check your internet connection.'), NO_INTERNET_FLAG)
          : _onSaveUpdateProfile(context, map);
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
                commonProfile(context, UPDATE_USER_DETAIL);
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

  void commonProfile(BuildContext context, int type) {
    var url = '$userProfile';
    try {
      ApiDioConfiguration.getInstance()
          .apiClient
          .liveService
          .apiGetRequest(context, url, null, 'nonjson')
          .then((response) {
            Map map = (response.data);
            try {
              if (map['status']) {
                apiCallback.onAPISuccess(map, type);
              } else {
                apiCallback.onAPIError(map, type);
              }
            } catch (error) {
              apiCallback.onAPIError(error, ERROR_EXCEPTION_FLAG);
            }
          })
          .timeout(Duration(seconds: 100))
          .catchError((error) {
            try {
              apiCallback.onAPIError(error.response.data, type);
            } catch (error) {
              apiCallback.onAPIError(error, ERROR_EXCEPTION_FLAG);
            }
          });
    } catch (error) {
      apiCallback.onAPIError(error, ERROR_EXCEPTION_FLAG);
    }
  }

  void onGetOnlyAcPc(BuildContext context, String id) {
    checkInternetConnection().then((onValue) {
      !onValue
          ? apiCallback.onAPIError(
              CustomError('Check your internet connection.'), NO_INTERNET_FLAG)
          : _onGetOnlyAcPc(context, id);
    });
  }

  _onGetOnlyAcPc(BuildContext context, String id) {
    var url = '$userAcPc$id';
    try {
      ApiDioConfiguration.getInstance()
          .apiClient
          .liveService
          .apiGetRequest(context, url, null, 'nonjson')
          .then((response) {
            Map map = (response.data);
            try {
              if (map['status']) {
                apiCallback.onAPISuccess(map, GET_AC_PC);
              } else {
                apiCallback.onAPIError(map, GET_AC_PC);
              }
            } catch (error) {
              apiCallback.onAPIError(error, ERROR_EXCEPTION_FLAG);
            }
          })
          .timeout(Duration(seconds: 100))
          .catchError((error) {
            try {
              apiCallback.onAPIError(error.response.data, GET_AC_PC);
            } catch (error) {
              apiCallback.onAPIError(error, ERROR_EXCEPTION_FLAG);
            }
          });
    } catch (error) {
      apiCallback.onAPIError(error, ERROR_EXCEPTION_FLAG);
    }
  }
}
