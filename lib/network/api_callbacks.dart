abstract class ApiCallback {
  void onAPIError(var error, int flag);

  void onAPISuccess(Map data, int flag);
}
