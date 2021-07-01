import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:my_voicee/utils/Utility.dart';

class CurrencyInputFormatter extends TextInputFormatter {
//  TextEditingValue formatEditUpdate(
//      TextEditingValue oldValue, TextEditingValue newValue) {
//    if (newValue.selection.baseOffset == 0) {
//      print(true);
//      return newValue;
//    }
//
//    double value = double.parse(newValue.text);
//
//    final formatter = NumberFormat.currency(
//        locale: 'fr', customPattern: '\u20ac ###########');
//
//    String newText = formatter.format(value);
//
//    return newValue.copyWith(
//        text: newText,
//        selection: TextSelection.collapsed(offset: newText.length));
//  }

  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.length == 0) {
      return newValue.copyWith(text: '');
    } else if (newValue.text.compareTo(oldValue.text) != 0) {
      int selectionIndexFromTheRight =
          newValue.text.length - newValue.selection.end;
      final f = new NumberFormat('^\d+(\\.\d+)?\$');
      double num = round(
          double.parse(newValue.text.replaceAll(f.symbols.GROUP_SEP, '')), 2);
      final newString = '\u20ac ' + f.format(num);
      return new TextEditingValue(
        text: newString,
        selection: TextSelection.collapsed(
            offset: newString.length - selectionIndexFromTheRight),
      );
    } else {
      return newValue;
    }
  }
}
