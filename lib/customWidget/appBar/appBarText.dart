import 'package:flutter/material.dart';
import 'package:my_voicee/constants/app_constants.dart';
import 'package:my_voicee/constants/app_images_path.dart';
import 'package:my_voicee/customWidget/gradient_app_bar.dart';

class AppbarTextCustom extends StatelessWidget with PreferredSizeWidget {
  final String titleTxt;
  final Function() actionPerformed;
  final Function() actionPerformedBack;
  final Function() popCallback;
  final bool actionBtnVisibility;

  AppbarTextCustom(
      {this.titleTxt,
      this.actionPerformed,
      this.actionPerformedBack,
      this.popCallback,
      this.actionBtnVisibility});

  @override
  Widget build(BuildContext context) {
    return GradientAppBar(
        elevation: 2.0,
        leading: Material(
          shadowColor: Colors.transparent,
          color: Colors.transparent,
          child: Padding(
            padding: const EdgeInsets.only(top: 4.0, bottom: 4.0),
            child: IconButton(
              icon: Image.asset(
                ic_back_black,
                height: 50.0,
                width: 50.0,
              ),
              onPressed: popCallback == null
                  ? () => Navigator.of(context).pop()
                  : popCallback,
            ),
          ),
        ),
        title: Text(
          titleTxt,
          style: TextStyle(fontFamily: robotoBold, color: Colors.black),
        ),
        actions: <Widget>[
          actionBtnVisibility
              ? Container(
                  margin: EdgeInsets.only(top: 15.0),
                  padding: const EdgeInsets.only(right: 6.0, bottom: 6.0),
                  child: InkWell(
                    onTap: actionPerformed,
                    child: Text(
                      'SAVE',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontFamily: robotoBlack,
                          fontSize: 18.0,
                          color: Colors.black),
                    ),
                  ),
                )
              : Container(),
        ],
        centerTitle: true,
        gradient: gradientAppWhite);
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
