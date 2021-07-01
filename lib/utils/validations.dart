import 'package:flutter/material.dart';

class Validations {
  String validateEmail(String value, context) {
    if (value.isEmpty) return 'Email id field can\'t be empty';
    final RegExp nameExp = new RegExp(
        r'^([A-Za-z0-9+_\-\.])+\@([A-Za-z0-9_\-\.])+\.([A-Za-z]{2,63})$');
    if (!nameExp.hasMatch(value)) return 'Email is not valid.';
    return null;
  }

  String validateFields(String value, context, [String whichName]) {
    if (value.isEmpty) {
      return "not_valid";
    }
    return null;
  }

  String validateName(String value, context, [String whichName]) {
    if (value.isEmpty)
      return whichName == "first_name"
          ? 'First name field can\'t be empty'
          : 'Last name field can\'t be empty';
    final RegExp nameExp = new RegExp(r'[A-Za-z0-9 ]');
    if (!nameExp.hasMatch(value))
      return whichName == "first_name"
          ? 'Invalid first name, it can\'t contain any number or special character(s)'
          : 'Invalid last name, it can\'t contain any number or special character(s)';
    return null;
  }

  String validateUserName(String value, context) {
    if (value.isEmpty) return 'Username is mandatory.';
    final RegExp nameExp = new RegExp(r'[a-z0-9]');
    if (!nameExp.hasMatch(value)) return 'Enter a valid username.';
    return null;
  }

  String validatePassword(String value, String s, context) {
    if (value.isEmpty) return 'Password is mandatory.';
    final RegExp nameExp =
        new RegExp(r'(?=.*[A-Z])(?=.*[a-z])(?=.*[0-9]).{5,12}$');
//    final RegExp nameExp = new RegExp(r'[A-Za-z0-9]');
    if (!nameExp.hasMatch(value))
      return s == 'new'
          ? 'New Password is not valid, Minimum six characters, one lowercase letter and one number is required for it.'
          : 'Minimum 6 characters and maximum 12 characters, one lowercase letter, one uppercase and one number is required for a password.';
    return null;
  }

  String validateLoginPassword(String value, String s, context) {
    if (value.isEmpty) return 'Password is mandatory.';
    final RegExp nameExp = new RegExp(r'[A-Za-z0-9]');
    if (!nameExp.hasMatch(value))
      return s == 'new'
          ? 'New Password is not valid, Minimum six characters, one lowercase letter and one number is required for it.'
          : 'New Password is not valid, Minimum six characters, one lowercase letter and one number is required for it.';
    return null;
  }

  String validatePhone(String value, context) {
    if (value.isEmpty) return 'Phone number is mandatory.';
    final RegExp nameExp = new RegExp(r'[0-9].{7,15}$');
    if (!nameExp.hasMatch(value)) {
      return 'Phone number is invalid.';
    }
    return null;
  }

  String validateDob(String trim, BuildContext context) {
    if (trim.isEmpty) return 'The date of birth must not be empty.';
    return null;
  }
}
