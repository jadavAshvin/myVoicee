import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fm_fit/fm_fit.dart';
import 'package:my_voicee/constants/app_colors.dart';
import 'package:my_voicee/constants/app_images_path.dart';
import 'package:my_voicee/customWidget/Alert/NoDataWidget.dart';
import 'package:my_voicee/customWidget/Alert/top_alert.dart';
import 'package:my_voicee/customWidget/appLoader/custom_progress_loader.dart';
import 'package:my_voicee/models/ChannelDataList.dart';
import 'package:my_voicee/models/commonResponse/CommonpiResponse.dart';
import 'package:my_voicee/models/errorResponse/customeError.dart';
import 'package:my_voicee/models/errorResponse/error_reponse.dart';
import 'package:my_voicee/postLogin/Topics/topicbloc/TopicsBloc.dart';
import 'package:my_voicee/postLogin/profile/drawerItems/channel/EditChannelScreen.dart';
import 'package:my_voicee/utils/Utility.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

class EditChannelList extends StatefulWidget {
  BuildContext oldContext;

  EditChannelList({this.oldContext});

  @override
  _EditChannelListState createState() => _EditChannelListState();
}

class _EditChannelListState extends State<EditChannelList> {
  FmFit fit = FmFit(width: 750);
  TopicsBloc _bloc;
  StreamController apiResponseController;
  StreamController apiSuccessResponseController;

  @override
  void initState() {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);
    apiResponseController = StreamController();
    apiSuccessResponseController = StreamController<List<Channels>>.broadcast();
    _bloc = TopicsBloc(apiResponseController, apiSuccessResponseController);
    _subscribeToApiResponse();
    _bloc.getChannelsList(context);
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
    return Container(
      width: MediaQuery.of(context).size.width,
      height: double.maxFinite,
      child: Stack(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            color: colorWhite,
            padding: EdgeInsets.only(
                top: fit.t(8.0),
                bottom: fit.t(8.0),
                left: fit.t(16.0),
                right: fit.t(16.0)),
            child: StreamBuilder<List<Channels>>(
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
                        onTap: () => _onEditChannel(snapshot.data[index]),
                        leading: snapshot.data[index].img == null ||
                                snapshot.data[index].img.isEmpty
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
                            : snapshot.data[index].img.contains('http')
                                ? Container(
                                    width: fit.t(45.0),
                                    height: fit.t(45.0),
                                    decoration: BoxDecoration(
                                      color: appColor,
                                      shape: BoxShape.circle,
                                      image: DecorationImage(
                                          fit: BoxFit.fill,
                                          image: NetworkImage(
                                              snapshot.data[index].img)),
                                    ),
                                  )
                                : Container(
                                    width: fit.t(45.0),
                                    height: fit.t(45.0),
                                  ),
                        trailing: Image.asset(
                          edit,
                          scale: 2,
                        ),
                        title: Text(
                          snapshot.data[index].title ?? "",
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
                    txt: "No Channel Found.",
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

  void _onEditChannel(Channels data) async {
    var result = await pushNewScreen(context,
        withNavBar: false, screen: EditChannelScreen(channel: data));
    if (result != null) {
      if (result) {
        _bloc.getChannelsList(context);
      }
    }
  }

  @override
  void dispose() {
    apiResponseController.close();
    apiSuccessResponseController.close();
    super.dispose();
  }
}
