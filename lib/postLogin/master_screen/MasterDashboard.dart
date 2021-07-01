// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:fm_fit/fm_fit.dart';
// import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
// import 'package:my_voicee/constants/app_colors.dart';
// import 'package:my_voicee/constants/app_images_path.dart';
// import 'package:my_voicee/customWidget/noInternet/NoInternetWidget.dart';
// import 'package:my_voicee/postLogin/Topics/ChooseTopicsScreen.dart';
// import 'package:my_voicee/postLogin/addPost/AddPostScreen.dart';
// import 'package:my_voicee/postLogin/master_screen/NotificationSceen.dart';
// import 'package:my_voicee/postLogin/master_screen/TopicsScreen.dart';
// import 'package:my_voicee/postLogin/master_screen/dashboard/DashBoardScreen.dart';
// import 'package:my_voicee/postLogin/profile/ProfileScreen.dart';
// import 'package:my_voicee/postLogin/tut_video/TutorialVideoScreen.dart';
// import 'package:my_voicee/prelogin/TermsOfUse.dart';
// import 'package:my_voicee/prelogin/WaitingScreen.dart';
// import 'package:my_voicee/prelogin/login/loginScreen.dart';
//
// class MasterDashboardScreen extends StatefulWidget {
//   final BuildContext menuScreenContext;
//
//   MasterDashboardScreen({Key key, this.menuScreenContext}) : super(key: key);
//
//   @override
//   _MasterDashboardScreenState createState() => _MasterDashboardScreenState();
// }
//
// class _MasterDashboardScreenState extends State<MasterDashboardScreen> {
//   FmFit fit = FmFit(width: 750);
//   var _scaffoldKey = GlobalKey<ScaffoldState>();
//   var globalKey = GlobalKey();
//
//   PersistentTabController _controller =
//       PersistentTabController(initialIndex: 0);
//   bool _hideNavBar;
//   BuildContext testContext;
//
//   List<Widget> _buildScreens() {
//     return [
//       DashBoardScreen(
//         menuScreenContext: widget.menuScreenContext,
//         hideStatus: _hideNavBar,
//         controller: _controller,
//         onScreenHideButtonPressed: () {
//           setState(() {
//             _hideNavBar = !_hideNavBar;
//           });
//         },
//       ),
//       TopicsScreen(
//         menuScreenContext: widget.menuScreenContext,
//         hideStatus: _hideNavBar,
//         controller: _controller,
//         onScreenHideButtonPressed: () {
//           setState(() {
//             _hideNavBar = !_hideNavBar;
//           });
//         },
//       ),
//       AddPostScreen(
//         menuScreenContext: widget.menuScreenContext,
//         hideStatus: _hideNavBar,
//         controller: _controller,
//         onScreenHideButtonPressed: () {
//           setState(() {
//             _hideNavBar = !_hideNavBar;
//           });
//         },
//       ),
//       ProfileScreen(
//         menuScreenContext: widget.menuScreenContext,
//         hideStatus: _hideNavBar,
//         controller: _controller,
//         onScreenHideButtonPressed: () {
//           setState(() {
//             _hideNavBar = !_hideNavBar;
//           });
//         },
//       ),
//       NotificationScreen(
//         menuScreenContext: widget.menuScreenContext,
//         hideStatus: _hideNavBar,
//         controller: _controller,
//         onScreenHideButtonPressed: () {
//           setState(() {
//             _hideNavBar = !_hideNavBar;
//           });
//         },
//       ),
//     ];
//   }
//
//   List<PersistentBottomNavBarItem> _navBarsItems() {
//     return [
//       PersistentBottomNavBarItem(
//         icon: Icon(Icons.home),
//         title: "Home",
//         activeColor: appColor,
//         inactiveColor: Colors.grey.shade500,
//       ),
//       PersistentBottomNavBarItem(
//         icon: Icon(Icons.note_add_rounded),
//         title: ("Topic"),
//         activeColor: appColor,
//         inactiveColor: Colors.grey.shade500,
//       ),
//       PersistentBottomNavBarItem(
//         icon: Image.asset(
//           ic_mic_add,
//           color: colorWhite,
//           width: 20.0,
//           height: 20.0,
//         ),
//         title: ("Post"),
//         activeColor: appColor,
//         inactiveColor: Colors.grey.shade500,
//         activeColorAlternate: Colors.white,
//       ),
//       PersistentBottomNavBarItem(
//         icon: Icon(Icons.person_rounded),
//         title: ("Profile"),
//         activeColor: appColor,
//         inactiveColor: Colors.grey.shade500,
//       ),
//       PersistentBottomNavBarItem(
//         icon: Icon(Icons.notifications),
//         title: ("Notifications"),
//         activeColor: appColor,
//         inactiveColor: Colors.grey.shade500,
//       ),
//     ];
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     SystemChrome.setPreferredOrientations(
//         [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);
//     _hideNavBar = false;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     fit = FmFit(width: MediaQuery.of(context).size.width);
//     if (MediaQuery.of(context).size.width > 600) {
//       fit.scale = 1.0 + MediaQuery.of(context).size.aspectRatio;
//     } else {
//       fit.scale = 1.0;
//     }
//     return Scaffold(
//       backgroundColor: Color.fromRGBO(243, 243, 243, 1),
//       key: _scaffoldKey,
//       resizeToAvoidBottomInset: false,
//       body: PersistentTabView(
//         context,
//         key: globalKey,
//         controller: _controller,
//         screens: _buildScreens(),
//         items: _navBarsItems(),
//         confineInSafeArea: true,
//         backgroundColor: Colors.white,
//         handleAndroidBackButtonPress: true,
//         resizeToAvoidBottomInset: true,
//         stateManagement: false,
//         navBarHeight: MediaQuery.of(context).viewInsets.bottom > 0
//             ? 0.0
//             : kBottomNavigationBarHeight,
//         hideNavigationBarWhenKeyboardShows: true,
//         margin: EdgeInsets.all(0.0),
//         popActionScreens: PopActionScreensType.once,
//         bottomScreenMargin: 0.0,
//         routeAndNavigatorSettings: RouteAndNavigatorSettings(
//           initialRoute: '/',
//           routes: {
//             '/login': (BuildContext context) => LoginScreen(),
//             '/dashboardScreen': (BuildContext context) => DashBoardScreen(),
//             '/topicScreen': (BuildContext context) => ChooseTopicsScreen(),
//             '/addPostScreen': (context) => AddPostScreen(),
//             '/userProfileScreen': (context) => ProfileScreen(),
//             '/notificationScreen': (context) => NotificationScreen(),
//             '/personalInfoScreen': (BuildContext context) => TutorialVideo(),
//             '/termsOfUse': (BuildContext context) => TermsOfUse(),
//             '/waitingScreen': (BuildContext context) => WaitingScreen(),
//             '/noInternet': (BuildContext context) => NoInternet(),
//           },
//         ),
//         selectedTabScreenContext: (context) {
//           testContext = context;
//         },
//         hideNavigationBar: _hideNavBar,
//         decoration: NavBarDecoration(
//             colorBehindNavBar: colorWhite,
//             boxShadow: <BoxShadow>[
//               BoxShadow(
//                 color: Colors.grey,
//                 blurRadius: 2.0,
//               ),
//             ],
//             borderRadius: BorderRadius.circular(0.0)),
//         popAllScreensOnTapOfSelectedTab: true,
//         itemAnimationProperties: ItemAnimationProperties(
//           duration: Duration(milliseconds: 400),
//           curve: Curves.ease,
//         ),
//         screenTransitionAnimation: ScreenTransitionAnimation(
//           animateTabTransition: true,
//           curve: Curves.ease,
//           duration: Duration(milliseconds: 200),
//         ),
//         navBarStyle:
//             NavBarStyle.style15, // Choose the nav bar style with this property
//       ),
//     );
//   }
// }
