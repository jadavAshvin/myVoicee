import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fm_fit/fm_fit.dart';
import 'package:my_voicee/constants/app_colors.dart';

class ProcessDialog {
  static ProcessDialog _instance = new ProcessDialog.internal();
  static bool _isLoading = false;

  ProcessDialog.internal();

  factory ProcessDialog() => _instance;
  static BuildContext _context;

  static void closeLoadingDialog(_context) {
    if (_isLoading) {
      Navigator.of(_context).pop();
      _isLoading = false;
    }
  }

  static void showLoadingDialog(BuildContext context) async {
    _context = context;
    if (!_isLoading) {
      _isLoading = true;
      await showDialog(
          context: _context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return Theme(
              data: Theme.of(context)
                  .copyWith(dialogBackgroundColor: Colors.transparent),
              child: AlertDialog(
                elevation: 0.0,
                backgroundColor: Colors.transparent,
                content: Center(
                  child: SpinKitFadingCube(
                    color: appColor,
                    size: fit.t(60.0),
                  ),
                ),
              ),
            );
          });
    }
  }
}
