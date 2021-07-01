import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fm_fit/fm_fit.dart';
import 'package:my_voicee/constants/app_colors.dart';
import 'package:my_voicee/constants/app_images_path.dart';
import 'package:my_voicee/postLogin/addPost/AddPostScreen.dart';
import 'package:my_voicee/postLogin/master_screen/NotificationSceen.dart';
import 'package:my_voicee/postLogin/master_screen/TopicsScreen.dart';
import 'package:my_voicee/postLogin/master_screen/dashboard/DashBoardScreen.dart';
import 'package:my_voicee/postLogin/profile/ProfileScreen.dart';

class MasterDashboardScreenNew extends StatefulWidget {
  final BuildContext menuScreenContext;

  MasterDashboardScreenNew({Key key, this.menuScreenContext}) : super(key: key);

  @override
  _MasterDashboardScreenNewState createState() =>
      _MasterDashboardScreenNewState();
}

class _MasterDashboardScreenNewState extends State<MasterDashboardScreenNew> {
  FmFit fit = FmFit(width: 750);
  var _scaffoldKey = GlobalKey<ScaffoldState>();
  var globalKey = GlobalKey();
  int _currentIndex = 0;

  List<Widget> _buildScreens;

  var _keyPost = GlobalKey<_MasterDashboardScreenNewState>();

  @override
  void initState() {
    super.initState();
    _buildScreens = [
      DashBoardScreen(
        menuScreenContext: widget.menuScreenContext,
        myKey: _keyPost,
        controller: (index) => _controller(index),
      ),
      TopicsScreen(
        menuScreenContext: widget.menuScreenContext,
        controller: (index) => _controller(index),
      ),
      AddPostScreen(
        menuScreenContext: widget.menuScreenContext,
        controller: (index) => _controller(index),
      ),
      ProfileScreen(
        menuScreenContext: widget.menuScreenContext,
        controller: (index) => _controller(index),
      ),
      NotificationScreen(
        menuScreenContext: widget.menuScreenContext,
        controller: (index) => _controller(index),
      ),
    ];
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);
  }

  @override
  Widget build(BuildContext context) {
    fit = FmFit(width: MediaQuery.of(context).size.width);
    if (MediaQuery.of(context).size.width > 600) {
      fit.scale = 1.0 + MediaQuery.of(context).size.aspectRatio;
    } else {
      fit.scale = 1.0;
    }
    return WillPopScope(
      onWillPop: () async {
        if (_currentIndex == 0) {
          return true;
        } else {
          setState(() {
            _currentIndex = 0;
          });
          return false;
        }
      },
      child: Scaffold(
        backgroundColor: Color.fromRGBO(243, 243, 243, 1),
        key: _scaffoldKey,
        resizeToAvoidBottomInset: false,
        body: _buildScreens[_currentIndex],
        floatingActionButton: FloatingActionButton(
          key: _keyPost,
          onPressed: () {
            setState(() {
              _controller(2);
            });
          },
          backgroundColor: appColor,
          tooltip: 'Post',
          mini: false,
          child: Image.asset(
            ic_mic_add,
            color: colorWhite,
            width: 20.0,
            height: 20.0,
          ),
          elevation: 4.0,
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: _controller,
          items: [
            BottomNavigationBarItem(
              icon: Icon(
                Icons.home,
                size: fit.t(30.0),
              ),
              activeIcon: Icon(
                Icons.home,
                size: fit.t(30.0),
                color: appColor,
              ),
              label: "Home",
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.note_add_rounded,
                size: fit.t(30.0),
              ),
              activeIcon: Icon(
                Icons.note_add_rounded,
                size: fit.t(30.0),
                color: appColor,
              ),
              label: "Topics",
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.home,
                size: fit.t(30.0),
                color: Colors.transparent,
              ),
              activeIcon: Icon(
                Icons.home,
                size: fit.t(30.0),
                color: Colors.transparent,
              ),
              label: "Post",
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.person_rounded,
                size: fit.t(30.0),
              ),
              activeIcon: Icon(
                Icons.person_rounded,
                size: fit.t(30.0),
                color: appColor,
              ),
              label: "Profile",
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.notifications,
                size: fit.t(30.0),
              ),
              activeIcon: Icon(
                Icons.notifications,
                size: fit.t(30.0),
                color: appColor,
              ),
              label: "Notifications",
            ),
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      ),
    );
  }

  _controller(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
}
