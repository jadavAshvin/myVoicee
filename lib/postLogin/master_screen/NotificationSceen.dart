import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fm_fit/fm_fit.dart';
import 'package:my_voicee/constants/app_colors.dart';
import 'package:my_voicee/constants/app_images_path.dart';
import 'package:my_voicee/customWidget/Alert/NoDataWidget.dart';
import 'package:my_voicee/customWidget/Alert/top_alert.dart';
import 'package:my_voicee/customWidget/appLoader/custom_progress_loader.dart';
import 'package:my_voicee/models/NotificationModel.dart';
import 'package:my_voicee/models/commonResponse/CommonpiResponse.dart';
import 'package:my_voicee/models/errorResponse/customeError.dart';
import 'package:my_voicee/models/errorResponse/error_reponse.dart';
import 'package:my_voicee/postLogin/master_screen/dashboard/Bloc/DasboardBloc.dart';
import 'package:my_voicee/utils/Utility.dart';

class NotificationScreen extends StatefulWidget {
  final BuildContext menuScreenContext;
  final Function(int index) controller;

  const NotificationScreen({Key key, this.menuScreenContext, this.controller})
      : super(key: key);

  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen>
    with AutomaticKeepAliveClientMixin<NotificationScreen> {
  @override
  bool get wantKeepAlive => false;

  var _scaffoldKey = GlobalKey<ScaffoldState>();
  var refreshKey = GlobalKey<RefreshIndicatorState>();
  FmFit fit = FmFit(width: 750);
  DashboardBloc _bloc;
  StreamController apiResponseController;
  StreamController apiResponseData;

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);
    apiResponseController = StreamController();
    apiResponseData = StreamController<List<Notifications>>.broadcast();
    _bloc = DashboardBloc(apiResponseController, apiResponseData);
    _subscribeToApiResponse();
    _bloc.getAllNotifications(context);
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

  Widget _titleWidget() {
    return Container(
      child: Padding(
        padding: EdgeInsets.only(
            top: fit.t(8.0), left: fit.t(8.0), right: fit.t(8.0)),
        child: Container(
          child: Text(
            'Notifications',
            style: TextStyle(
                color: Colors.black,
                fontSize: fit.t(18.0),
                fontWeight: FontWeight.w400,
                fontFamily: "Roboto"),
          ),
        ),
      ),
    );
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
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(fit.t(50.0)),
        child: AppBar(
          backgroundColor: colorWhite,
          elevation: 0,
          centerTitle: true,
          title: _titleWidget(),
        ),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: double.maxFinite,
        child: Stack(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              color: colorWhite,
              padding: EdgeInsets.only(
                  top: fit.t(8.0),
                  bottom: fit.t(16.0),
                  left: fit.t(16.0),
                  right: fit.t(16.0)),
              child: StreamBuilder<List<Notifications>>(
                stream: apiResponseData.stream,
                builder: (context, snapshot) {
                  if (snapshot != null &&
                      snapshot.hasData &&
                      snapshot.data.length > 0) {
                    return ListView.separated(
                      itemBuilder: (context, index) {
                        return ListTile(
                          dense: true,
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: fit.t(4.0), vertical: fit.t(4.0)),
                          onTap: () => {},
                          leading: snapshot?.data[index]?.user?.dp == null ||
                                  snapshot?.data[index]?.user?.dp?.isEmpty ||
                                  !snapshot?.data[index]?.user?.dp
                                      ?.contains("http")
                              ? Container(
                                  width: fit.t(40.0),
                                  height: fit.t(40.0),
                                  decoration: BoxDecoration(
                                    color: appColor,
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: AssetImage(ic_profile),
                                    ),
                                  ),
                                )
                              : CachedNetworkImage(
                                  imageUrl:
                                      '${snapshot?.data[index]?.user?.dp}',
                                  imageBuilder: (context, imageProvider) =>
                                      ClipRRect(
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
                                    ic_profile,
                                    height: fit.t(40.0),
                                    width: fit.t(40.0),
                                    fit: BoxFit.cover,
                                  ),
                                  errorWidget: (context, url, error) =>
                                      Image.asset(
                                    ic_profile,
                                    height: fit.t(40.0),
                                    width: fit.t(40.0),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                          title: Text(
                            snapshot.data[index].body ?? "",
                            style: TextStyle(
                                fontSize: fit.t(12.0),
                                fontWeight: FontWeight.w400,
                                fontFamily: "Roboto"),
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
                      txt: "No Notifications Found.",
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
      ),
    );
  }

  @override
  void dispose() {
    apiResponseController.close();
    apiResponseData.close();
    super.dispose();
  }
}
