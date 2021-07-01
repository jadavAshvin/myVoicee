import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fm_fit/fm_fit.dart';
import 'package:my_voicee/constants/app_colors.dart';
import 'package:my_voicee/constants/app_images_path.dart';
import 'package:my_voicee/postLogin/profile/drawerItems/channel/AddChannel.dart';
import 'package:my_voicee/postLogin/profile/drawerItems/channel/EditChannelList.dart';

class CreateChannel extends StatefulWidget {
  @override
  _CreateChannelState createState() => _CreateChannelState();
}

class _CreateChannelState extends State<CreateChannel> {
  var _scaffoldKey = GlobalKey<ScaffoldState>();
  FmFit fit = FmFit(width: 750);

  @override
  void initState() {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    fit = FmFit(width: MediaQuery.of(context).size.width);
    if (MediaQuery.of(context).size.width > 700) {
      fit.scale = 1.0 + MediaQuery.of(context).size.aspectRatio;
    } else {
      fit.scale = 1.0;
    }
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: colorWhite,
      appBar: AppBar(
        backgroundColor: colorWhite,
        elevation: 0,
        leading: _leadingWidget(),
        centerTitle: true,
        title: _titleWidget(),
      ),
      body: DefaultTabController(
        length: 2,
        initialIndex: 1,
        child: Column(
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: colorWhite,
                border: Border.all(
                  color: Color.fromRGBO(195, 218, 253, 1),
                  width: 2,
                ),
              ),
              height: fit.t(50.0),
              child: TabBar(
                isScrollable: false,
                unselectedLabelColor: Colors.black,
                labelColor: appColor,
                indicatorColor: Colors.transparent,
                tabs: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.only(
                        left: 0,
                        right: 0,
                        top: fit.t(10.0),
                        bottom: fit.t(10.0)),
                    child: Text(
                      "Edit",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontFamily: "Roboto",
                          fontSize: fit.t(16.0),
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    child: Text(
                      "Create New",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontFamily: "Roboto",
                          fontSize: fit.t(16.0),
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                ],
                indicator: BoxDecoration(
                  color: Color.fromRGBO(195, 218, 253, 1),
                  border: Border.all(
                    color: Color.fromRGBO(195, 218, 253, 1),
                    width: 2,
                  ),
                ),
              ),
            ),
            Expanded(
              child: TabBarView(
                children: <Widget>[
                  EditChannelList(oldContext: context),
                  AddChannel(oldContext: context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _titleWidget() {
    return Container(
      child: Padding(
        padding: EdgeInsets.only(
            top: fit.t(8.0), left: fit.t(8.0), right: fit.t(8.0)),
        child: Container(
          child: Text(
            'All channel',
            style: TextStyle(
              fontFamily: 'Roboto',
              fontSize: fit.t(18.0),
              color: Colors.black,
              fontWeight: FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }

  Widget _leadingWidget() {
    return InkWell(
      onTap: () => Navigator.of(context).pop(),
      child: Container(
        margin: EdgeInsets.only(left: fit.t(16.0)),
        child: Image.asset(
          ic_left_back,
          width: fit.t(30.0),
          height: fit.t(30.0),
        ),
      ),
    );
  }
}
