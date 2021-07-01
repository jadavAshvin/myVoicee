import 'package:flutter/material.dart';
import 'package:my_voicee/constants/app_constants.dart';
import 'package:my_voicee/constants/app_images_path.dart';
import 'package:my_voicee/customWidget/gradient_app_bar.dart';

class AppbarCustom extends StatelessWidget with PreferredSizeWidget {
  final String titleTxt;
  final Function() actionPerformed;
  final bool actionBtnVisibility;

  AppbarCustom({this.titleTxt, this.actionPerformed, this.actionBtnVisibility});

  @override
  Widget build(BuildContext context) {
    return GradientAppBar(
        elevation: 0.0,
        leading: Material(
          shadowColor: Colors.transparent,
          color: Colors.transparent,
          child: Padding(
            padding: const EdgeInsets.only(top: 4.0, bottom: 4.0),
            child: IconButton(
              icon: Image.asset(
                ic_back_white,
                height: 50.0,
                width: 50.0,
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
        ),
        title: Text(
          titleTxt,
          style: TextStyle(fontFamily: robotoRegular, color: Colors.white),
        ),
        actions: <Widget>[
          actionBtnVisibility
              ? Padding(
                  padding: const EdgeInsets.all(6.0),
                  child: InkWell(
                    onTap: actionPerformed,
                    child: Icon(
                      Icons.check,
                      color: Colors.white,
                    ),
                  ),
                )
              : Container(),
        ],
        centerTitle: true,
        gradient: gradientApp);
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
