import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fm_fit/fm_fit.dart';
import 'package:my_voicee/constants/app_colors.dart';
import 'package:my_voicee/constants/app_images_path.dart';
import 'package:my_voicee/customWidget/Alert/NoDataWidget.dart';
import 'package:my_voicee/customWidget/Alert/top_alert.dart';
import 'package:my_voicee/customWidget/appLoader/custom_progress_loader.dart';
import 'package:my_voicee/models/FollowersModel.dart';
import 'package:my_voicee/models/commonResponse/CommonpiResponse.dart';
import 'package:my_voicee/models/errorResponse/customeError.dart';
import 'package:my_voicee/models/errorResponse/error_reponse.dart';
import 'package:my_voicee/postLogin/profile/profileBloc/ProfileBloc.dart';
import 'package:my_voicee/utils/Utility.dart';

class FollowersScreen extends StatefulWidget {
  @override
  _FollowersScreenState createState() => _FollowersScreenState();
}

class _FollowersScreenState extends State<FollowersScreen> {
  var _scaffoldKey = GlobalKey<ScaffoldState>();
  FmFit fit = FmFit(width: 750);
  ProfileBloc _bloc;
  StreamController apiResponseController;
  StreamController apiSuccessResponseController;

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);
    apiResponseController = StreamController();
    apiSuccessResponseController =
        StreamController<List<FollowersData>>.broadcast();
    _bloc = ProfileBloc(apiResponseController, apiSuccessResponseController);
    _bloc.getFollowersList(context);
    _subscribeToApiResponse();
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
      body: Stack(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            color: colorWhite,
            padding: EdgeInsets.only(
                top: fit.t(8.0),
                bottom: fit.t(8.0),
                left: fit.t(16.0),
                right: fit.t(16.0)),
            child: StreamBuilder<List<FollowersData>>(
              stream: apiSuccessResponseController.stream,
              builder: (context, snapshot) {
                if (snapshot != null &&
                    snapshot.hasData &&
                    snapshot.data.length > 0) {
                  return ListView.separated(
                    itemBuilder: (context, index) {
                      return ListTile(
                        dense: true,
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: fit.t(8.0), vertical: fit.t(4.0)),
                        leading: snapshot.data[index].followers == null
                            ? Container(
                                width: fit.t(45.0),
                                height: fit.t(45.0),
                                decoration: BoxDecoration(
                                  color: appColor,
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                    fit: BoxFit.fill,
                                    image: AssetImage(ic_user_place_holder),
                                  ),
                                ),
                              )
                            : snapshot.data[index].followers.dp == null ||
                                    snapshot.data[index].followers.dp.isEmpty
                                ? Container(
                                    width: fit.t(45.0),
                                    height: fit.t(45.0),
                                    decoration: BoxDecoration(
                                      color: appColor,
                                      shape: BoxShape.circle,
                                      image: DecorationImage(
                                        fit: BoxFit.fill,
                                        image: AssetImage(ic_user_place_holder),
                                      ),
                                    ),
                                  )
                                : snapshot.data[index].followers.dp
                                        .contains('http')
                                    ? Container(
                                        width: fit.t(45.0),
                                        height: fit.t(45.0),
                                        decoration: BoxDecoration(
                                          color: appColor,
                                          shape: BoxShape.circle,
                                          image: DecorationImage(
                                              fit: BoxFit.fill,
                                              image: NetworkImage(snapshot
                                                  .data[index].followers.dp)),
                                        ),
                                      )
                                    : Container(
                                        width: fit.t(45.0),
                                        height: fit.t(45.0),
                                      ),
                        title: Text(
                          snapshot.data[index].followers == null
                              ? ""
                              : snapshot.data[index].followers.name ?? "",
                          style: TextStyle(
                              fontFamily: "Roboto", fontSize: fit.t(12.0)),
                        ),
                      );
                    },
                    itemCount: snapshot.data.length,
                    separatorBuilder: (BuildContext context, int index) {
                      return Divider();
                    },
                  );
                } else {
                  return NoDataWidget(
                    txt: "No Followers Found.",
                    fit: fit,
                  );
                }
              },
            ),
          ),
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
    );
  }

  Widget _titleWidget() {
    return Container(
      child: Padding(
        padding: EdgeInsets.only(
            top: fit.t(8.0), left: fit.t(8.0), right: fit.t(8.0)),
        child: Container(
          child: Text(
            'Followers',
            style: TextStyle(
              fontFamily: 'Roboto',
              fontSize: fit.t(20.0),
              color: Colors.black,
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

  //listen to api response
  void _subscribeToApiResponse() {
    StreamSubscription subscription;
    subscription = apiResponseController.stream.listen((data) {
      if (data is ErrorResponse) {
        if (data.show_msg == 1) {
          if (data.authType != null) {
            if (data.authType == "login") {
              Navigator.pushReplacementNamed(context, '/waitingScreen');
            } else {
              Navigator.pushReplacementNamed(context, '/termsOfUse');
            }
          } else {
            TopAlert.showAlert(context, data.message, true);
          }
        } else {
          TopAlert.showAlert(context, data.message, true);
        }
      } else if (data is CommonApiReponse) {
        if (data.message == 'Check your internet connection.') {
          pushNamedIfNotCurrent(context, '/noInternet');
        } else {
          TopAlert.showAlert(context, data.message, false);
        }
      } else if (data is CustomError) {
        if (data.errorMessage == 'Check your internet connection.') {
          pushNamedIfNotCurrent(context, '/noInternet');
        } else {
          TopAlert.showAlert(context, data.errorMessage, true);
        }
      } else if (data is Exception) {
        TopAlert.showAlert(context,
            'Oops, Something went wrong please try again later.', true);
      }
    }, onError: (error) {
      if (error is CustomError) {
        TopAlert.showAlert(context, error.errorMessage, true);
      } else {
        TopAlert.showAlert(context, error.toString(), true);
      }
    });
  }

  @override
  void dispose() {
    apiResponseController.close();
    apiSuccessResponseController.close();
    super.dispose();
  }
}
