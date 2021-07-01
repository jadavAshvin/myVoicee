import 'dart:convert';

import 'package:flutter/src/widgets/framework.dart';
import 'package:my_voicee/constants/app_constants.dart';
import 'package:my_voicee/models/CountryResponse.dart';
import 'package:my_voicee/models/DistrictAcPc.dart';
import 'package:my_voicee/models/StateResponse.dart';
import 'package:my_voicee/models/errorResponse/customeError.dart';
import 'package:my_voicee/network/ApiUrls.dart';
import 'package:my_voicee/network/DioApiConfiguration.dart';
import 'package:my_voicee/network/api_callbacks.dart';
import 'package:my_voicee/utils/Utility.dart';

class LoginDataRepository {
  final ApiCallback apiCallback;

  LoginDataRepository(this.apiCallback);

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

  void onGetUserProfile(context, String authType) {
    checkInternetConnection().then((onValue) {
      !onValue
          ? apiCallback.onAPIError(
              CustomError('Check your internet connection.'), NO_INTERNET_FLAG)
          : _onGetUserProfile(context, authType);
    });
  }

  _onGetUserProfile(context, String authType) {
    var url = '$userProfile';
    try {
      ApiDioConfiguration.getInstance()
          .apiClient
          .liveService
          .apiGetRequest(context, url, null, 'nonjson')
          .then((response) {
            Map map = (response.data);
            map.putIfAbsent("auth_type", () => authType);
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
                writeStringDataLocally(
                    key: countryData, value: jsonEncode(map));
                var registerResponse = CountryResponse.fromJson(map);
                var countryId = registerResponse.response[0].id;
                var url = '$userState$countryId';
                try {
                  ApiDioConfiguration.getInstance()
                      .apiClient
                      .liveService
                      .apiGetRequest(context, url, null, 'nonjson')
                      .then((response) {
                        Map mapState = (response.data);
                        try {
                          if (mapState['status']) {
                            writeStringDataLocally(
                                key: stateData, value: jsonEncode(mapState));
                            var stateResponse =
                                StateResponse.fromJson(mapState);
                            var stateId = stateResponse.response[0].id;
                            var url = '$userDistrictAcPc$stateId';
                            try {
                              ApiDioConfiguration.getInstance()
                                  .apiClient
                                  .liveService
                                  .apiGetRequest(context, url, null, 'nonjson')
                                  .then((response) {
                                    Map map = (response.data);
                                    try {
                                      if (map['status']) {
                                        writeStringDataLocally(
                                            key: distictAcPcData,
                                            value: jsonEncode(map));
                                        var districtResponse =
                                            DistrictAcPc.fromJson(map);
                                        var districtId = districtResponse
                                            .response.districts[0].id;
                                        Map<String, dynamic> mapRequest = Map();
                                        mapRequest.putIfAbsent(
                                            'state_id', () => stateId);
                                        mapRequest.putIfAbsent(
                                            'country_id', () => countryId);
                                        mapRequest.putIfAbsent(
                                            'district_id', () => districtId);
                                        var url = '$userProfileInfo';
                                        try {
                                          ApiDioConfiguration.getInstance()
                                              .apiClient
                                              .liveService
                                              .apiPutRequest(context, url,
                                                  mapRequest, 'nonjson')
                                              .then((response) {
                                                Map map = (response.data);
                                                try {
                                                  if (map['status']) {
                                                    getStringDataLocally(
                                                            key:
                                                                distictAcPcData)
                                                        .then((value) {
                                                      if (value != null) {
                                                        var data = DistrictAcPc
                                                                .fromJson(
                                                                    jsonDecode(
                                                                        value))
                                                            .toJson();
                                                        apiCallback.onAPISuccess(
                                                            data,
                                                            GET_DISTRICT_AC_PC);
                                                      }
                                                    });
                                                  } else {
                                                    apiCallback.onAPIError(map,
                                                        UPDATE_USER_DETAIL);
                                                  }
                                                } catch (error) {
                                                  apiCallback.onAPIError(error,
                                                      ERROR_EXCEPTION_FLAG);
                                                }
                                              })
                                              .timeout(Duration(seconds: 100))
                                              .catchError((error) {
                                                try {
                                                  apiCallback.onAPIError(
                                                      error.response.data,
                                                      UPDATE_USER_DETAIL);
                                                } catch (error) {
                                                  apiCallback.onAPIError(error,
                                                      ERROR_EXCEPTION_FLAG);
                                                }
                                              });
                                        } catch (error) {
                                          apiCallback.onAPIError(
                                              error, ERROR_EXCEPTION_FLAG);
                                        }
                                      } else {
                                        apiCallback.onAPIError(
                                            map, GET_DISTRICT_AC_PC);
                                      }
                                    } catch (error) {
                                      apiCallback.onAPIError(
                                          error, ERROR_EXCEPTION_FLAG);
                                    }
                                  })
                                  .timeout(Duration(seconds: 100))
                                  .catchError((error) {
                                    try {
                                      apiCallback.onAPIError(
                                          error.response.data,
                                          GET_DISTRICT_AC_PC);
                                    } catch (error) {
                                      apiCallback.onAPIError(
                                          error, ERROR_EXCEPTION_FLAG);
                                    }
                                  });
                            } catch (error) {
                              apiCallback.onAPIError(
                                  error, ERROR_EXCEPTION_FLAG);
                            }
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
                          apiCallback.onAPIError(
                              error.response.data, GET_DISTRICT_AC_PC);
                        } catch (error) {
                          apiCallback.onAPIError(error, ERROR_EXCEPTION_FLAG);
                        }
                      });
                } catch (error) {
                  apiCallback.onAPIError(error, ERROR_EXCEPTION_FLAG);
                }
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
}
