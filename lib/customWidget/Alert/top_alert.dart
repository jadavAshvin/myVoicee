import 'package:flutter/material.dart';
import 'package:my_voicee/constants/app_colors.dart';
import 'package:my_voicee/customWidget/Alert/edge_alert.dart';

class TopAlert {
  static void showAlert(context, title, isAlert,
      [description, gravity, duration, icon, color]) {
    EdgeAlert.show(context,
        title: title,
        description: description,
        gravity: gravity == null ? EdgeAlert.TOP : gravity,
        backgroundColor: isAlert
            ? redColor
            : color != null
                ? Color(0XFFFF7F50)
                : greenColor,
        duration: duration == null ? EdgeAlert.LENGTH_VERY_LONG : duration,
        icon: icon == null && isAlert ? Icons.warning : Icons.done);
  }
}
