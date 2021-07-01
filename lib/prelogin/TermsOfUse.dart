import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/style.dart';
import 'package:fm_fit/fm_fit.dart';
import 'package:my_voicee/constants/app_colors.dart';
import 'package:my_voicee/constants/app_constants.dart';
import 'package:my_voicee/constants/app_images_path.dart';
import 'package:my_voicee/customWidget/SocialMediaCustomButton.dart';
import 'package:my_voicee/models/UserResponse.dart';
import 'package:my_voicee/utils/Utility.dart';

const kUserAgent =
    'Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/62.0.3202.94 Mobile Safari/537.36';

class TermsOfUse extends StatefulWidget {
  @override
  _TermsOfUseState createState() => _TermsOfUseState();
}

class _TermsOfUseState extends State<TermsOfUse> {
  var _scaffoldKey = GlobalKey<ScaffoldState>();
  FmFit fit = FmFit(width: 750);
  UserData data;
  ScrollController _scrollController = ScrollController();
  bool isShowButton = false;
  var html = '<html><head><title>Voicee - Terms of Use</title></head><body>'
      '<p></p><h2>1. APPLICATION OF TERMS</h2><p></p>'
      '<p>1.1 These Terms apply to your use of the Service (as that term is defined below). By clicking the "Accept" button:'
      'a.	you agree to these Terms; and'
      'b.	where your access and use is on behalf of another person (e.g. a company), you confirm that you are authorized to, and do in fact, agree to these Terms on that personâ€™s behalf and that, by agreeing to these Terms on that personâ€™s behalf, that person is bound by these Terms.'
      '1.2 If you do not agree to these Terms, you are not authorized to access and use the Service, and you must immediately stop doing so.'
      '</p>'
      '<p></p><h2>2. CHANGES</h2><p></p>'
      '<p>2.1 We may change these Terms at any time by notifying you of the change by email or by posting a notification on this app. Unless stated otherwise, any change takes effect from the date set out in the notice. You are responsible for ensuring you are familiar with the latest Terms. By continuing to access and use the Service from the date on which the Terms are changed, you agree to be bound by the changed Terms.'
      '2.2 These Terms were last updated on 29-July-2020.'
      '</p>'
      '<p></p><h2>3. INTERPRETATION</h2><p></p>'
      '<p>3.1 In these Terms:'
      'a.	"Voicee" Software means the software owned by us that is used to provide the Service.'
      'b.	"Confidential Information" means any information that is not public knowledge and that is obtained from the other party in the course of, or in connection with, the provision and use of the Service. Our Confidential Information includes Intellectual Property owned by us (or our licensors), including the third-party API providers. Your Confidential Information includes the Data. Data means all data, content, and information (including personal information) owned, held, used, or created by you or on your behalf that is stored using, or inputted into, the Service.'
      'c.	Force Majeure means any event that is beyond the reasonable control of a party, excluding:'
      'i.	an event to the extent that it could have been avoided by a party taking reasonable steps or reasonable care; or'
      'ii.	a lack of funds for any reason.'
      'Including and similar words do not imply any limit.'
      'Intellectual Property Rights includes copyright and all rights existing anywhere in the world conferred under statute, common law or equity relating to inventions (including patents), registered and unregistered trademarks and designs, circuit layouts, data and databases, confidential information, know-how, and all other rights resulting from intellectual activity. Intellectual Property has a consistent meaning and includes any enhancement, modification, or derivative work of the Intellectual Property. Objectionable includes being objectionable, defamatory, obscene, harassing, threatening, harmful, or unlawful in any way. a party includes that partyâ€™s permitted assigns.'
      '</p>'
      '<p></p><h2>4. ACCOUNT</h2><p></p>'
      '<p>In order to use the services, you must:'
      'a.	Be at least 18 (eighteen) years of age and be able to enter into contracts;'
      'b.	Complete the account registration process;'
      'c.	Agree to these terms and conditions'
      'd.	Provide true, complete and accurate information'
      'e.	Not be based in Cuba, Iran, Syria North Korea or any other country that is subject to the U.S. Government embargo, or that is designated by the U.S. Government as "terrorist-supporting" country; and'
      'f.	Not be listed on the U.S.Government list of prohibited persons.'
      'By using this Service, you represent and warrant that you meet all the requirements listed above and that you wonâ€™t use the Service in a way that violates any law or regulations. Note that by representing and warranting, you are making a legally enforceable promise.'
      '</p>'
      '<p></p><h2>5. LICENSING INFORMATION AND LIMITATION</h2><p></p>'
      '<p>5.1 The service of the app â€˜Voiceeâ€™ is free of charge and any legal resident of any country (other than the countries mentioned above).'
      '5.2 Whatever you post using your voice or text remains your intellectual property. In short, what belongs to you stays yours.'
      'When you upload content using your voice or text, you explicitly give permission to the â€˜Voiceeâ€™ app (and those we work with) a worldwide license to use, host, store, reproduce, modify, create derivative works (such as those resulting from translations, adaptions or other changes we make so that your content works better with our Services), communicate, publish, publicly perform, publicly display and distribute such content. The rights you grant for this license are limited to operating, promoting and improving our Services, and to develop new ones. The license continues even after you stop using our Services. Make sure that you have necessary rights to grant us this license for any content that you submit to our Services.'
      '5.3 We can use your post to capture, process, and analyze the intent, sentiment, and perform other important analysis as and when required.'
      '5.4 We are not responsible for your speech, and/or any misinterpretation made by our own software or any third-party partners applications'
      '5.5 If your speech contains any hate, abuse or derogatory comment on any person living or dead, we can remove that content without any notice to you'
      '5.6 We will not identify you or give any data to any third party other than any government agencies and/or any law enforcement agencies'
      '5.7 Your use of the Service must not violate any applicable laws, including but not limited to copyright or trademark laws, export control or sanction laws, or any other laws in your jurisdiction. You are responsible for making sure your use of the Service is in compliance with laws and any applicable regulations.'
      '5.8 Limitation of liability: To the maximum extent permitted by any applicable law, in no event will â€˜Voiceeâ€™ or its partners, be liable for any special, incidental, indirect, exemplary, or consequential damages whatsoever (including, without limitation, damages for loss of business profits, business interruption, loss of personal or business reputation, or any other pecuniary loss or damage) arising out of the use or inability to use the Services or provision of or failure to provide technical or other support services, whether arising in tort (including negligence) contract or any other legal theory, even if â€˜VOICEEâ€™ or its partners/affiliates have been advised of the possibility of such damages. In any case, â€˜Voiceeâ€™s liability and your exclusive remedy for any claims arising out of or relating to this agreement shall be limited to \$0 (U.S. Dollar Zero).'
      '</p>'
      '<p></p><h2>6. REPORTING AND BLOCKING POSTS/ACCOUNTS</h2><p></p>'
      '<p>Any user of Voicee, can report any post or account if they think the post is not approriate, or the publisher is below 13 (thirteen) years of age, or if they presume the publisher is pretending to be someone else. If your post is reported by any user, then we will manually verify the post and delete if it\'s derogatory by any means. If your account is reported multiple times, then all your posts will be reviewed by our team and your account will be blocked if found appropriate.'
      '</p>'
      '<p></p><h2>7. GOVERNING LAW</h2><p></p>'
      '<p>While "Voicee" offers its Services globally, our operations are located in India and these terms of use are based on Indian law. Access to, or use of, this mobile application, or any information, materials, products and/or services made available on or through this mobile application may be prohibited by law in certain countries or jurisdictions. You are solely responsible for ensuring compliance with any applicable laws and regulations from the country from which you are accessing the mobile application. We make no representations that the information contained herein is appropriate or available for use in any location.'
      'Notwithstanding the foregoing, we reserve the right to bring in legal proceedings in any jurisdiction where we believe any infringement of this Terms of Use may be taking place or originating.'
      '</p>'
      '</body></html>';

  @override
  void initState() {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);
    getStringDataLocally(key: userData).then((value) {
      if (value != null) {
        if (value.isNotEmpty) {
          data = UserData.fromJson(jsonDecode(value));
        }
      }
    });
    _scrollController.addListener(() {
      if (_scrollController.position.maxScrollExtent ==
          _scrollController.position.pixels) {
        setState(() {
          isShowButton = true;
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    fit = FmFit(width: MediaQuery.of(context).size.width);
    if (MediaQuery.of(context).size.width > 600) {
      fit.scale = 1.0 + MediaQuery.of(context).size.aspectRatio;
    } else {
      fit.scale = 1.0;
    }
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Container(
          width: MediaQuery.of(context).size.width,
          margin: EdgeInsets.only(
              left: fit.t(16.0), right: fit.t(16.0), bottom: fit.t(0.0)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _widgetAppLogo(),
              SizedBox(
                height: fit.t(40.0),
              ),
              Text(
                'Terms and conditions &\nPrivacy Policy',
                style: TextStyle(
                  color: colorBlack,
                  fontSize: fit.t(20.0),
                  fontFamily: "Roboto",
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(
                height: fit.t(10.0),
              ),
              Expanded(
                child: ListView(
                  physics: BouncingScrollPhysics(),
                  controller: _scrollController,
                  shrinkWrap: true,
                  children: [
                    Html(
                      data: html,
                      style: {
                        "body": Style(
                            fontSize: FontSize(fit.t(14.0)),
                            fontWeight: FontWeight.normal,
                            fontFamily: "Roboto"),
                      },
                    ),
                    SizedBox(
                      height: fit.t(40.0),
                    ),
                  ],
                ),
              ),
              isShowButton
                  ? Column(
                      children: [
                        SocialMediaCustomButton(
                          btnText: 'Accept',
                          buttonColor: colorAcceptBtn,
                          onPressed: _onAccept,
                          size: fit.t(14.0),
                          splashColor: colorAcceptBtnSplash,
                          textColor: colorWhite,
                        ),
                        SizedBox(
                          height: fit.t(40.0),
                        ),
                      ],
                    )
                  : Container()
            ],
          ),
        ),
      ),
    );
  }

  //App Logo widget
  Widget _widgetAppLogo() {
    return Center(
      child: Container(
        padding: EdgeInsets.only(top: fit.t(70.0)),
        child: Image.asset(
          logo_blue,
          width: fit.t(100.0),
          height: fit.t(150.0),
        ),
      ),
    );
  }

  void _onAccept() {
    if (data != null) {
      if (data.is_approved == 1) {
        Navigator.pushNamedAndRemoveUntil(
            context, '/topicScreen', ModalRoute.withName('/'));
      } else {
        Navigator.pushNamedAndRemoveUntil(
            context, '/waitingScreen', ModalRoute.withName('/'));
      }
    } else {
      Navigator.pushNamedAndRemoveUntil(
          context, '/waitingScreen', ModalRoute.withName('/'));
    }
  }
}
