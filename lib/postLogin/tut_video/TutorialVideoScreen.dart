import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fm_fit/fm_fit.dart';
import 'package:my_voicee/constants/app_images_path.dart';

class TutorialVideo extends StatefulWidget {
  @override
  _TutorialVideoState createState() => _TutorialVideoState();
}

class _TutorialVideoState extends State<TutorialVideo> {
  var _scaffoldKey = GlobalKey<ScaffoldState>();
  FmFit fit = FmFit(width: 750);

  // YoutubePlayerController _controller;

  @override
  void initState() {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);
    // _controller = YoutubePlayerController(
    //   initialVideoId: "nPLdkDuoilk",
    //   flags: const YoutubePlayerFlags(autoPlay: false, loop: false),
    // );
    super.initState();
  }

  @override
  void dispose() {
    // _controller.dispose();
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
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _widgetAppLogo(),
              Container(
                padding: EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 40.0,
                    ),
                    Text(
                      'How to use this app',
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: fit.t(28.0),
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.normal,
                          color: Color.fromRGBO(0, 0, 0, 1)),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Center(
                      child: Container(
                        height: fit.t(250.0),
                        width: MediaQuery.of(context).size.width,
                        // YoutubePlayer(
                        //   controller: _controller,
                        //   actionsPadding: const EdgeInsets.only(left: 16.0),
                        //   onEnded: (meta) {
                        //     _controller.seekTo(Duration(milliseconds: 0));
                        //     _controller.pause();
                        //   },
                        //   bottomActions: [
                        //     CurrentPosition(),
                        //     const SizedBox(width: 10.0),
                        //     ProgressBar(isExpanded: true),
                        //     const SizedBox(width: 10.0),
                        //     RemainingDuration(),
                        //     const SizedBox(width: 10.0),
                        //     // FullScreenButton(),
                        //   ],
                        // ),
                      ),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Text(
                      'Watch Video to uses',
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: fit.t(18.0),
                        fontWeight: FontWeight.normal,
                        fontStyle: FontStyle.normal,
                        color: Color.fromRGBO(0, 0, 0, 1),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: fit.t(80.0),
            child: InkWell(
              onTap: () => Navigator.pushNamedAndRemoveUntil(
                  context, '/masterDashboard', ModalRoute.withName('/')),
              child: Padding(
                padding: EdgeInsets.all(10.0),
                child: Text(
                  'SKIP',
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: fit.t(20.0),
                    fontWeight: FontWeight.w500,
                    fontStyle: FontStyle.normal,
                    color: Colors.blueAccent,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _widgetAppLogo() {
    return Center(
      child: Container(
        padding: EdgeInsets.only(top: fit.t(60.0)),
        child: Image.asset(
          logo_blue,
          width: MediaQuery.of(context).size.width,
          height: fit.t(200.0),
        ),
      ),
    );
  }
}
