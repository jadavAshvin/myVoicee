import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fm_fit/fm_fit.dart';
import 'package:my_voicee/constants/app_colors.dart';
import 'package:my_voicee/constants/app_constants.dart';
import 'package:my_voicee/constants/app_images_path.dart';
import 'package:my_voicee/customWidget/Alert/NoDataWidget.dart';
import 'package:my_voicee/customWidget/appLoader/custom_progress_loader.dart';
import 'package:my_voicee/customWidget/gradient_app_bar.dart';
import 'package:my_voicee/models/OtherUserResponse.dart';
import 'package:my_voicee/models/UserResponse.dart';
import 'package:my_voicee/postLogin/master_screen/dashboard/searchBloc/SearchBloc.dart';
import 'package:my_voicee/postLogin/profile/OtherProfileScreen.dart';
import 'package:my_voicee/style/theme.dart';
import 'package:my_voicee/utils/Utility.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

class SearchUsers extends StatefulWidget {
  @override
  SearchUsersState createState() => SearchUsersState();
}

class SearchUsersState extends State<SearchUsers> {
  String query = '';
  var _inputController = TextEditingController();
  var _blankFocusNode = FocusNode();
  FmFit fit = FmFit(width: 750);
  List<ProfileResponse> allData = List();
  SearchBloc _bloc;
  StreamController apiResponse;
  UserData bean;

  @override
  void initState() {
    getStringDataLocally(key: userData).then((value) {
      setState(() {
        bean = UserData.fromJson(jsonDecode(value));
      });
    });
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);
    apiResponse = StreamController<List<ProfileResponse>>.broadcast();
    _bloc = SearchBloc(apiResponse);

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
      appBar: _gradientAppBarWidget(),
      body: Container(
        color: Colors.grey.withOpacity(0.1),
        child: Stack(
          children: <Widget>[
            _centerBody(),
            StreamBuilder<Object>(
              stream: _bloc.progressLoaderStream,
              builder: (context, snapshot) {
                return ProgressLoader(
                  fit: fit,
                  isShowLoader: snapshot.hasData ? snapshot.data : false,
                  color: appColor,
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void callApiGetProjects(String query) {
    if (query != null) {
      if (query.trim().isNotEmpty) {
        _bloc.getSearchItem(context, query.trim());
      } else {
        _bloc.getSearchItem(context, "query.trim()");
      }
    }
  }

  @override
  void dispose() {
    apiResponse?.close();
    _bloc?.dispose();
    super.dispose();
  }

  Widget _gradientAppBarWidget() {
    return GradientAppBar(
      elevation: fit.t(2.0),
      leading: Material(
        shadowColor: Colors.transparent,
        color: Colors.transparent,
        child: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            FocusScope.of(context).requestFocus(_blankFocusNode);
            Navigator.of(context).pop();
          },
        ),
      ),
      title: Theme(
        data: ThemeData(
            primaryColor: Colors.white60,
            accentColor: Colors.white60,
            hintColor: Colors.white60,
            inputDecorationTheme: new InputDecorationTheme(
                labelStyle: new TextStyle(color: Colors.white60))),
        child: TextField(
          controller: _inputController,
          cursorWidth: fit.t(1.0),
          cursorColor: Colors.white60,
          autofocus: true,
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.search,
          keyboardAppearance: Brightness.light,
          onChanged: callApiGetProjects,
          // onSubmitted: callApiGetProjects,
          decoration: InputDecoration(
            hintMaxLines: 1,
            border: InputBorder.none,
            hoverColor: colorWhite,
            focusColor: colorWhite,
            fillColor: colorWhite,
            hintText: "Search users...",
            hintStyle: TextStyle(
              color: Colors.white54,
              fontFamily: "Roboto",
              fontSize: fit.t(18.0),
            ),
          ),
          style: TextStyle(
            color: colorWhite,
            fontFamily: "Roboto",
            fontSize: fit.t(18.0),
          ),
        ),
      ),
      centerTitle: true,
      gradient: ColorsTheme.dashBoardGradient,
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.clear),
          onPressed: () {
            query = '';
            _inputController.text = query;
            _bloc.getSearchItem(context, "9012");
          },
        ),
      ],
    );
  }

  Widget buildList() {
    return StreamBuilder<List<ProfileResponse>>(
        stream: apiResponse.stream,
        builder: (context, snapshot) {
          if (snapshot != null && snapshot.hasData) {
            if (snapshot.data.length > 0) {
              allData.clear();
              allData.addAll(snapshot.data);
              return ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: snapshot.data.length,
                itemBuilder: (context, position) {
                  return SearchProjectItem(
                    position: position,
                    fit: fit,
                    item: snapshot.data[position],
                    onItemSelected: onItemSelected,
                  );
                },
              );
            } else {
              return NoDataWidget(
                fit: fit,
                txt: 'No users found.',
              );
            }
          }
          return NoDataWidget(
            fit: fit,
            txt: 'Search Users...',
          );
        });
  }

  onItemSelected(int pos) {
    FocusScope.of(context).requestFocus(_blankFocusNode);
    if (bean != null) {
      if (bean.id == allData[pos].id) {
        Navigator.of(context).pop(true);
      } else {
        pushNewScreen(context,
            screen: OtherProfileScreen(profileData: allData[pos]),
            withNavBar: false);
      }
    } else {
      pushNewScreen(context,
          screen: OtherProfileScreen(profileData: allData[pos]),
          withNavBar: false);
    }
  }

  Widget _centerBody() {
    return buildList();
  }
}

class SearchProjectItem extends StatelessWidget {
  SearchProjectItem({this.position, this.item, this.onItemSelected, this.fit});

  final fit;
  final Function(int pos) onItemSelected;
  final int position;
  final ProfileResponse item;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onItemSelected(position),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20.0),
        child: Container(
          padding: EdgeInsets.all(
            fit.t(16.0),
          ),
          decoration: ShapeDecoration(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)),
          ),
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        if (item?.dp == null ||
                            !item.dp.contains("http") ||
                            item.dp.isEmpty)
                          Container(
                            width: fit.t(40.0),
                            height: fit.t(40.0),
                            decoration: BoxDecoration(
                              color: appColor,
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                fit: BoxFit.cover,
                                image: AssetImage(ic_user_place_holder),
                              ),
                            ),
                          )
                        else
                          CachedNetworkImage(
                            imageUrl: '${item.dp}',
                            imageBuilder: (context, imageProvider) => ClipRRect(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(80.0)),
                              child: Container(
                                height: fit.t(40.0),
                                width: fit.t(40.0),
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: imageProvider,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                            placeholder: (context, image) => Image.asset(
                              ic_user_place_holder,
                              height: fit.t(40.0),
                              width: fit.t(40.0),
                              fit: BoxFit.cover,
                            ),
                            errorWidget: (context, url, error) => Image.asset(
                              ic_user_place_holder,
                              height: fit.t(40.0),
                              width: fit.t(40.0),
                              fit: BoxFit.cover,
                            ),
                          ),
                        SizedBox(
                          width: fit.t(8.0),
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              width: Platform.isIOS
                                  ? MediaQuery.of(context).size.width / 1.7
                                  : MediaQuery.of(context).size.width / 1.55,
                              child: Text(
                                '${item?.username ?? ""}',
                                textAlign: TextAlign.start,
                                overflow: TextOverflow.ellipsis,
                                softWrap: true,
                                style: TextStyle(
                                    fontFamily: 'Roboto',
                                    fontSize: fit.t(14.0),
                                    fontWeight: FontWeight.w500,
                                    letterSpacing: 0.18,
                                    color: Color.fromRGBO(0, 0, 0, 1)),
                              ),
                            ),
                            SizedBox(
                              height: fit.t(2.0),
                            ),
                            Container(
                              width: Platform.isIOS
                                  ? MediaQuery.of(context).size.width / 1.7
                                  : MediaQuery.of(context).size.width / 1.55,
                              child: Text(
                                '${item?.bio ?? ""}',
                                maxLines: 3,
                                textAlign: TextAlign.justify,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontFamily: 'Roboto',
                                    fontWeight: FontWeight.w300,
                                    fontSize: fit.t(12.0),
                                    color: Color.fromRGBO(119, 113, 113, 1)),
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  height: 10.0,
                ),
                Divider(
                  indent: fit.t(8.0),
                  endIndent: fit.t(8.0),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
