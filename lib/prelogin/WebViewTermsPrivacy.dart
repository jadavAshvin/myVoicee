import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:fm_fit/fm_fit.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';
import 'package:my_voicee/constants/app_colors.dart';
import 'package:my_voicee/style/theme.dart';

const kUserAgent =
    'Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/62.0.3202.94 Mobile Safari/537.36';

class WebViewTermsPrivacy extends StatefulWidget {
  final url;
  final title;

  WebViewTermsPrivacy({this.url, this.title});

  @override
  _WebViewTermsPrivacyState createState() => _WebViewTermsPrivacyState();
}

class _WebViewTermsPrivacyState extends State<WebViewTermsPrivacy> {
  FmFit fit = FmFit(width: 750);

  @override
  void initState() {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    fit = FmFit(width: MediaQuery.of(context).size.width);
    if (MediaQuery.of(context).size.width > 600) {
      fit.scale = 1.0 + MediaQuery.of(context).size.aspectRatio;
    } else {
      fit.scale = 1.0;
    }
    return WebviewScaffold(
      appBar: _gradientAppBarWidget(),
      useWideViewPort: false,
      supportMultipleWindows: false,
      url: widget.url,
      withLocalStorage: true,
      hidden: true,
      ignoreSSLErrors: false,
      allowFileURLs: true,
      initialChild: Container(
        color: colorWhite,
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      ),
      clearCache: false,
      clearCookies: true,
      debuggingEnabled: false,
      withJavascript: true,
      userAgent: kUserAgent,
    );
  }

  Widget _gradientAppBarWidget() {
    return GradientAppBar(
      gradient: ColorsTheme.dashBoardGradient,
      centerTitle: true,
      title: Text(
        widget.title,
        style: TextStyle(color: colorWhite),
      ),
    );
  }
}
