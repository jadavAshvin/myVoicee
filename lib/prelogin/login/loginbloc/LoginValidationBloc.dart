import 'dart:async';
import 'dart:convert';

import 'package:flutter/src/widgets/framework.dart';
import 'package:my_voicee/constants/app_constants.dart';
import 'package:my_voicee/models/DistrictAcPc.dart';
import 'package:my_voicee/models/LoginResponse.dart';
import 'package:my_voicee/models/UserResponse.dart';
import 'package:my_voicee/models/errorResponse/error_reponse.dart';
import 'package:my_voicee/network/api_callbacks.dart';
import 'package:my_voicee/prelogin/login/loginbloc/LoginDataRepository.dart';
import 'package:my_voicee/utils/Utility.dart';
import 'package:rxdart/rxdart.dart';

class LoginValidationBloc with ApiCallback {
  final StreamController apiController;
  LoginDataRepository _dataProvider;

  LoginValidationBloc(this.apiController) {
    _dataProvider = LoginDataRepository(this);
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

  submitLogin(Map map, context, int type) {
    showProgressLoader(true);
    _dataProvider.onUserLogin(map, context, type);
  }

  @override
  void onAPISuccess(Map data, int flag) {
    showProgressLoader(false);
    if (flag == LOGIN_FLAG) {
      var registerResponse = LoginResponse.fromJson(data);
      if (registerResponse.response != null) {
        writeStringDataLocally(key: cookie, value: registerResponse.response);
        if (!apiController.isClosed) {
          apiController.add(registerResponse);
        }
      }
    } else if (flag == GET_PROFILE) {
      var registerResponse = UserResponse.fromJson(data);
      if (registerResponse.response != null) {
        writeBoolDataLocally(key: session, value: true);
        writeStringDataLocally(
            key: userData, value: jsonEncode(registerResponse.response));
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
    }
  }

  @override
  void onAPIError(error, int flag) {
    showProgressLoader(false);
    switch (flag) {
      case LOGIN_FLAG:
        var errorResponse = ErrorResponse.fromJson(error);
        if (!apiController.isClosed) {
          apiController.add(errorResponse);
        }
        break;
      case GET_PROFILE:
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

  void getUserProfile(context, String authType) {
    showProgressLoader(true);
    _dataProvider.onGetUserProfile(context, authType);
  }

  void callApiGetCountries(BuildContext context) {
    showProgressLoader(true);
    _dataProvider.onGetCountries(context);
  }
}
