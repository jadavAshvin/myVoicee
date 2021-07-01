import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_voicee/utils/date_formatter.dart';

DateTime selectedDate = DateTime.now();

Future<DateTime> selectDate(
    BuildContext context, String previousDate, String format) async {
  if (Platform.isIOS || Platform.isAndroid) {
    DateTime date;
    await showModalBottomSheet<void>(
        context: context,
        builder: (BuildContext context) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Align(
                alignment: Alignment.centerRight,
                child: FlatButton(
                  splashColor: Colors.transparent,
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Padding(
                    child: Text(
                      'DONE',
                      style: TextStyle(
                        fontSize: 15.0,
                      ),
                    ),
                    padding:
                        EdgeInsets.only(top: 10.0, right: 20, bottom: 10.0),
                  ),
                ),
              ),
              Container(
                height: 200,
                width: MediaQuery.of(context).size.width,
                child: CupertinoDatePicker(
                  onDateTimeChanged: (DateTime value) {
                    if (value != null && value != selectedDate) date = value;
                  },
                  initialDateTime: format == 'yyyy-MM-dd'
                      ? (previousDate != null && previousDate != ''
                          ? DateFormat(format).parse(previousDate)
                          : DateTime(DateTime.now().year - 18))
                      : (previousDate != null && previousDate != ''
                          ? DateFormat(format).parse(previousDate)
                          : DateTime(DateTime.now().year)),
                  mode: CupertinoDatePickerMode.date,
                  minimumYear: format == 'yyyy-MM-dd'
                      ? (DateTime.now().year - 90)
                      : DateTime.now().year - 90,
                  maximumYear: format == 'yyyy-MM-dd'
                      ? (DateTime.now().year - 18)
                      : (DateTime.now().year),
                ),
              ),
            ],
          );
        });
    return date;
  }
}

onBirthdaySelected(DateTime selectedDate, TextEditingController controller,
    String type, BuildContext context) {
  if (type == "normal") {
    controller.text = dateFromLong(selectedDate, "yyyy-MM-dd", context);
  } else {
    String data = DateFormat("MMM yyyy").format(selectedDate);
    controller.text = data;
  }
}
