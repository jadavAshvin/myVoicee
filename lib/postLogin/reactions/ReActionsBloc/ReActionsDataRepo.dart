import 'package:my_voicee/constants/app_constants.dart';
import 'package:my_voicee/models/errorResponse/customeError.dart';
import 'package:my_voicee/network/ApiUrls.dart';
import 'package:my_voicee/network/DioApiConfiguration.dart';
import 'package:my_voicee/network/api_callbacks.dart';
import 'package:my_voicee/utils/Utility.dart';

class ReActionDataRepo {
  final ApiCallback apiCallback;

  ReActionDataRepo(this.apiCallback);

  void callApiReActions(context, id, type, page) {
    checkInternetConnection().then((onValue) {
      !onValue
          ? apiCallback.onAPIError(
              CustomError('Check your internet connection.'), NO_INTERNET_FLAG)
          : _onCallApiReActions(context, id, type, page);
    });
  }

  _onCallApiReActions(context, id, type, page) {
    var url = "";
    if (type == 1) {
      url = "$getPostLikedBy$id?page=$page&limit=10";
    } else if (type == 2) {
      url = "$getPostCommentBy$id?page=$page&limit=10";
    } else if (type == 3) {
      url = "$getPostDisLikedBy$id?page=$page&limit=10";
    } else if (type == 4) {
      url = "$getPostSharedBy$id?page=$page&limit=10";
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
                  apiCallback.onAPISuccess(map, GET_ALL_REACTIONS);
                } else {
                  apiCallback.onAPIError(map, GET_ALL_REACTIONS);
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
              apiCallback.onAPIError(error.response.data, GET_ALL_REACTIONS);
            } catch (error) {
              apiCallback.onAPIError(error, ERROR_EXCEPTION_FLAG);
            }
          });
    } catch (error) {
      apiCallback.onAPIError(error, ERROR_EXCEPTION_FLAG);
    }
  }
}
