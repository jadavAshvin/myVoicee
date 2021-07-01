import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:my_voicee/constants/app_constants.dart';
import 'package:my_voicee/models/CountryResponse.dart';
import 'package:my_voicee/models/DistrictAcPc.dart';
import 'package:my_voicee/models/OnlyAcPcResponse.dart';
import 'package:my_voicee/models/StateResponse.dart';
import 'package:my_voicee/models/UserResponse.dart';
import 'package:my_voicee/models/errorResponse/error_reponse.dart';
import 'package:my_voicee/network/api_callbacks.dart';
import 'package:my_voicee/prelogin/personalInfo/personalInfoBlock/UpdateInfoDataRepository.dart';
import 'package:my_voicee/utils/Utility.dart';
import 'package:rxdart/rxdart.dart';

class UpdateInfoBloc with ApiCallback {
  final StreamController apiController;
  UpdateInfoDataRepository _dataProvider;

  UpdateInfoBloc(this.apiController) {
    _dataProvider = UpdateInfoDataRepository(this);
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

  submitProfileInfo(Map map, context, int type) {
    showProgressLoader(true);
    _dataProvider.onUserLogin(map, context, type);
  }

  @override
  void onAPISuccess(Map data, int flag) {
    showProgressLoader(false);
    if (flag == GET_COUNTRIES) {
      var registerResponse = CountryResponse.fromJson(data);
      if (registerResponse.response != null) {
        if (!apiController.isClosed) {
          apiController.add(registerResponse);
        }
      }
    } else if (flag == GET_STATES) {
      var registerResponse = StateResponse.fromJson(data);
      if (registerResponse.response != null) {
        if (!apiController.isClosed) {
          apiController.add(registerResponse);
        }
      }
    } else if (flag == GET_DISTRICT_AC_PC) {
      var registerResponse = DistrictAcPc.fromJson(data);
      if (registerResponse.response != null) {
        if (!apiController.isClosed) {
          apiController.add(registerResponse);
        }
      }
    } else if (flag == GET_AC_PC) {
      var registerResponse = OnlyAcPcResponse.fromJson(data);
      if (registerResponse.response != null) {
        if (!apiController.isClosed) {
          apiController.add(registerResponse);
        }
      }
    } else if (flag == UPDATE_USER_DETAIL) {
      var registerResponse = UserResponse.fromJson(data);
      writeStringDataLocally(
          key: userData, value: jsonEncode(registerResponse.response));
      if (registerResponse.response != null) {
        if (!apiController.isClosed) {
          apiController.add(registerResponse);
        }
      }
    }
  }

  @override
  void onAPIError(error, int flag) {
    showProgressLoader(false);
    switch (flag) {
      case UPDATE_PROFILE:
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
      case GET_STATES:
        var errorResponse = ErrorResponse.fromJson(error);
        if (!apiController.isClosed) {
          apiController.add(errorResponse);
        }
        break;
      case UPDATE_USER_DETAIL:
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

      case GET_AC_PC:
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

  void getAllCountries(BuildContext context) {
    showProgressLoader(true);
    _dataProvider.onGetCountries(context);
  }

  void getAllStatesInCountry(BuildContext context, String id) {
    showProgressLoader(true);
    _dataProvider.onGetCountryStates(context, id);
  }

  void getAllDistrictAcPc(BuildContext context, String id) {
    showProgressLoader(true);
    _dataProvider.onGetDistrictAcPc(context, id);
  }

  void saveUpdateProfile(BuildContext context, Map<String, dynamic> map) {
    showProgressLoader(true);
    _dataProvider.onSaveUpdateProfile(context, map);
  }

  void getOnlyAcPC(BuildContext context, String id) {
    showProgressLoader(true);
    _dataProvider.onGetOnlyAcPc(context, id);
  }
}
