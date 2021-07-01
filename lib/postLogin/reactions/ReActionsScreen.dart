import 'package:flutter/material.dart';
import 'package:fm_fit/fm_fit.dart';
import 'package:my_voicee/constants/app_colors.dart';
import 'package:my_voicee/constants/app_images_path.dart';
import 'package:my_voicee/models/GetAllPostsResponse.dart';
import 'package:my_voicee/models/UserResponse.dart';
import 'package:my_voicee/postLogin/profile/ProfileScreen.dart';
import 'package:my_voicee/postLogin/reactions/donwVote/DownVoteScreen.dart';
import 'package:my_voicee/postLogin/reactions/share/ShareScreen.dart';
import 'package:my_voicee/postLogin/reactions/upVote/UpVoteScreen.dart';

class ReActionsScreen extends StatefulWidget {
  final data;

  ReActionsScreen({this.data});

  @override
  _ReActionsScreenState createState() => _ReActionsScreenState();
}

class _ReActionsScreenState extends State<ReActionsScreen> {
  var _scaffoldKey = GlobalKey<ScaffoldState>();
  FmFit fit = FmFit(width: 750);

  String userId;
  int page = 0;
  UserData userDataBean;
  AllPostResponse data;

  @override
  void initState() {
    data = widget.data;
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
      backgroundColor: Color.fromRGBO(243, 243, 243, 1),
      key: _scaffoldKey,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(fit.t(60.0)),
        child: AppBar(
          backgroundColor: Color.fromRGBO(243, 243, 243, 1),
          elevation: 0,
          leading: _leadingWidget(),
          centerTitle: true,
          title: _titleWidget(),
          actions: <Widget>[trailingWidget()],
        ),
      ),
      body: Stack(children: <Widget>[
        Container(
          margin: EdgeInsets.only(
              top: fit.t(0.0), left: fit.t(16.0), right: fit.t(16.0)),
          child: DefaultTabController(
            length: 3,
            initialIndex: 0,
            child: Column(
              children: <Widget>[
                Container(
                  decoration: new BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(15.0),
                          topRight: Radius.circular(15.0))),
                  width: MediaQuery.of(context).size.width,
                  height: fit.t(60.0),
                  child: Stack(
                    fit: StackFit.passthrough,
                    alignment: Alignment.bottomCenter,
                    children: <Widget>[
                      Container(
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                                color: Color.fromRGBO(243, 243, 243, 1),
                                width: 3.0),
                          ),
                        ),
                      ),
                      TabBar(
                        indicatorWeight: fit.t(3.0),
                        isScrollable: false,
                        indicatorColor: appColor,
                        indicatorSize: TabBarIndicatorSize.tab,
                        unselectedLabelColor: colorBlack,
                        unselectedLabelStyle: TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: fit.t(12.0),
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.12,
                        ),
                        labelColor: appColor,
                        labelStyle: TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: fit.t(12.0),
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.12,
                        ),
                        tabs: [
                          Padding(
                            padding: EdgeInsets.all(fit.t(2.0)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Image.asset(
                                  '$ic_upvotes',
                                  color: appColor,
                                  width: fit.t(20.0),
                                  height: fit.t(20.0),
                                ),
                                Text('${data.n_likes}')
                              ],
                            ),
                          ),
                          // Padding(
                          //   padding: EdgeInsets.all(fit.t(2.0)),
                          //   child: Row(
                          //     mainAxisAlignment: MainAxisAlignment.center,
                          //     mainAxisSize: MainAxisSize.min,
                          //     children: <Widget>[
                          //       Image.asset(
                          //         '$ic_replies',
                          //         color: appColor,
                          //         width: fit.t(20.0),
                          //         height: fit.t(20.0),
                          //       ),
                          //       Text('${data.n_comments}')
                          //     ],
                          //   ),
                          // ),
                          Padding(
                            padding: EdgeInsets.all(fit.t(2.0)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Image.asset(
                                  '$ic_downvotes',
                                  color: appColor,
                                  width: fit.t(20.0),
                                  height: fit.t(20.0),
                                ),
                                Text('${data.n_dislikes}')
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(fit.t(2.0)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Image.asset(
                                  '$ic_shares',
                                  color: appColor,
                                  width: fit.t(20.0),
                                  height: fit.t(20.0),
                                ),
                                Text('${data.n_shares}')
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: TabBarView(
                    children: <Widget>[
                      Container(
                        color: colorWhite,
                        child: UpVoteScreen(data: data.n_likes, id: data.id),
                      ),
                      // Container(
                      //   color: colorWhite,
                      //   child:
                      //       CommentScreen(data: data.n_comments, id: data.id),
                      // ),
                      Container(
                        color: colorWhite,
                        child:
                            DownVoteScreen(data: data.n_dislikes, id: data.id),
                      ),
                      Container(
                        color: colorWhite,
                        child: ShareScreen(data: data.n_shares, id: data.id),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ]),
    );
  }

  Widget _titleWidget() {
    return Container(
      child: Padding(
        padding: EdgeInsets.only(
            top: fit.t(8.0), left: fit.t(8.0), right: fit.t(8.0)),
        child: Container(
          child: Text(
            'Reactions',
            style: TextStyle(
              fontFamily: 'Roboto',
              fontSize: fit.t(18.0),
              fontWeight: FontWeight.w400,
              color: Colors.black,
            ),
          ),
        ),
      ),
    );
  }

  Widget _leadingWidget() {
    return Container(
      margin: EdgeInsets.only(left: fit.t(16.0)),
      child: Container(
        child: Image.asset(
          ic_logo_small,
        ),
      ),
    );
  }

  Widget trailingWidget() {
    return InkWell(
      onTap: () => Navigator.of(context).pop(),
      child: Container(
        margin: EdgeInsets.only(right: fit.t(16.0), top: fit.t(4.0)),
        child: Image.asset(
          ic_back_img,
          height: fit.t(40.0),
          width: fit.t(40.0),
        ),
      ),
    );
  }

  void onClickProfile() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ProfileScreen()),
    );
  }
}
