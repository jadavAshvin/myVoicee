import 'package:flutter/material.dart';
import 'package:fm_fit/fm_fit.dart';
import 'package:my_voicee/CallBacks/ShareCallBack.dart';
import 'package:my_voicee/constants/app_colors.dart';
import 'package:my_voicee/constants/app_images_path.dart';
import 'package:my_voicee/customWidget/SocialMediaCustomButton.dart';

class BottomSheetShare extends StatefulWidget {
  final ShareCallBack callBack;
  final pos;

  BottomSheetShare({this.callBack, this.pos});

  @override
  _BottomSheetShareState createState() => _BottomSheetShareState();
}

class _BottomSheetShareState extends State<BottomSheetShare> {
  var _scaffoldKey = GlobalKey<ScaffoldState>();
  FmFit fit = FmFit(width: 750);

  @override
  Widget build(BuildContext context) {
    fit = FmFit(width: MediaQuery.of(context).size.width);
    if (MediaQuery.of(context).size.width > 600) {
      fit.scale = 1.0 + MediaQuery.of(context).size.aspectRatio;
    } else {
      fit.scale = MediaQuery.of(context).size.aspectRatio;
    }
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: new BoxDecoration(
            color: Colors.white,
            borderRadius: new BorderRadius.only(
                topLeft: const Radius.circular(20.0),
                topRight: const Radius.circular(20.0))),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: fit.t(10.0),
            ),
            Container(
                padding: EdgeInsets.all(fit.t(4.0)),
                margin: EdgeInsets.only(left: fit.t(20.0), top: fit.t(30.0)),
                child: Text(
                  'Share Via',
                  style: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      letterSpacing: -0.18,
                      color: Color.fromRGBO(0, 0, 0, 1)),
                )),
            SizedBox(
              height: fit.t(20.0),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width / 2.3,
                  child: SocialMediaCustomButton(
                    btnText: 'Facebook',
                    buttonColor: colorFacebookBtn,
                    onPressed: () {
                      widget.callBack.FacebookShare(widget.pos);
                      Navigator.pop(context);
                    },
                    size: 15.0,
                    image: ic_fb_share,
                    splashColor: colorFacebookBtnSplash,
                    textColor: colorWhite,
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width / 2.3,
                  child: SocialMediaCustomButton(
                    btnText: 'Twitter',
                    buttonColor: colorTwitterBtn,
                    onPressed: () {
                      widget.callBack.TwitterShare(widget.pos);
                      Navigator.pop(context);
                    },
                    image: ic_twitter_share,
                    size: 15.0,
                    splashColor: colorTwitterBtnSplash,
                    textColor: colorWhite,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: fit.t(20.0),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width / 2.3,
                  child: SocialMediaCustomButton(
                    btnText: 'WhatsApp',
                    buttonColor: colowhatsAppButton,
                    onPressed: () {
                      widget.callBack.WhatsAppShare(widget.pos);
                      Navigator.pop(context);
                    },
                    size: 15.0,
                    image: ic_whats_app_share,
                    splashColor: colowhatsAppBtnSplash,
                    textColor: colorWhite,
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width / 2.3,
                  child: SocialMediaCustomButton(
                    btnText: 'Linkedin',
                    buttonColor: coloLinkedinButton,
                    onPressed: () {
                      widget.callBack.LinkedinShare(widget.pos);
                      Navigator.pop(context);
                    },
                    image: ic_linkedin_share,
                    size: 15.0,
                    splashColor: colorLinkedinBtnSplash,
                    textColor: colorWhite,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: fit.t(30.0),
            ),
          ],
        ),
      ),
    );
  }
}
