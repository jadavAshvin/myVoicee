import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_voicee/constants/app_colors.dart';

class CustomInputField extends StatelessWidget {
  final String icon;
  final IconButton suffixIcon;
  final Icon prefix;
  final String hintText;
  final TextInputType textInputType;
  final Color iconColor;
  final bool obscureText;
  final TextStyle textStyle, hintStyle;
  final TextInputAction inputAction;
  final bool enabled;
  final maxlength;
  final onChanged;
  final controller;
  final inputFormatters;
  final capital;
  final suffixIconStyle;
  final focusNode;
  final imgHeight;
  final imgWidth;
  final lines;
  final Function onSubmitted;

  CustomInputField(
      {this.icon,
      this.hintText,
      this.textInputType,
      this.imgHeight,
      this.imgWidth,
      this.prefix,
      this.maxlength,
      this.onSubmitted,
      this.onChanged,
      this.iconColor,
      this.lines,
      this.obscureText,
      this.capital,
      @required this.inputFormatters,
      this.controller,
      this.suffixIconStyle,
      this.enabled = true,
      this.suffixIcon = null,
      this.inputAction = TextInputAction.done,
      this.textStyle,
      this.focusNode,
      this.hintStyle});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: obscureText,
      controller: controller,
      focusNode: focusNode,
      maxLines: lines == null ? 1 : lines,
      enabled: enabled,
      style: textStyle,
      keyboardType: textInputType,
      cursorColor: colorBlack,
      textInputAction: inputAction,
      textCapitalization: capital == null ? TextCapitalization.none : capital,
      onFieldSubmitted: onSubmitted,
      maxLength: maxlength,
      inputFormatters: inputFormatters,
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: hintStyle,
        border: InputBorder.none,
        icon: icon != null
            ? Image.asset(
                icon,
                color: iconColor,
                height: imgHeight,
                width: imgWidth,
              )
            : null,
        prefixIcon: prefix != null ? prefix : null,
        suffixIcon: suffixIcon != null ? suffixIcon : null,
        suffixStyle: suffixIconStyle,
      ),
    );
  }
}
