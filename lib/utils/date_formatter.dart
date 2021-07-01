import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

String dateFromLong(DateTime now, String format, BuildContext context) {
  var formatter;
  formatter = DateFormat(format);
  String formatted = formatter.format(now);
  return formatted;
}

String getDate(String date, String format) {
  return '${date.isEmpty ? ' --' : ' ' + '${DateFormat(format).format(DateTime.parse(date).toLocal())}'}';
}

DateTime getDateTimeStamp(String date, String format) {
  return date.isEmpty ? 0 : DateTime.parse(date);
}

String getDateTimeStamp2(String date) {
  return date.isEmpty
      ? 0
      : DateTime.parse(date.replaceAll("Z", '')).year.toString();
}

String toHoursMinutes(Duration duration) {
  String twoDigitMinutes = _toTwoDigits(duration.inSeconds.remainder(60));
  return "${_toTwoDigits(duration.inMinutes)}:$twoDigitMinutes";
}

String _toTwoDigits(int n) {
  if (n >= 10) return "$n";
  return "0$n";
}
