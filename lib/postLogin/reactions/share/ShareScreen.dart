import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fm_fit/fm_fit.dart';
import 'package:my_voicee/constants/app_colors.dart';
import 'package:my_voicee/customWidget/Alert/NoDataWidget.dart';
import 'package:my_voicee/customWidget/Alert/top_alert.dart';
import 'package:my_voicee/customWidget/appLoader/custom_progress_loader.dart';
import 'package:my_voicee/models/ReActionResponse.dart';
import 'package:my_voicee/models/commonResponse/CommonpiResponse.dart';
import 'package:my_voicee/models/errorResponse/customeError.dart';
import 'package:my_voicee/models/errorResponse/error_reponse.dart';
import 'package:my_voicee/postLogin/reactions/ReActionsBloc/ReActionsBloc.dart';
import 'package:my_voicee/postLogin/reactions/share/ShareListItem.dart';
import 'package:my_voicee/utils/Utility.dart';

class ShareScreen extends StatefulWidget {
  final data;
  final id;

  ShareScreen({this.data, this.id});

  @override
  _ShareScreenState createState() => _ShareScreenState();
}

class _ShareScreenState extends State<ShareScreen> {
  bool isLoading = false;
  bool lastPage = false;
  ReActionsBloc _bloc;
  StreamController apiResponseData;
  StreamController apiResponse;
  FmFit fit = FmFit(width: 750);
  ScrollController _scrollController = ScrollController();
  var page = 0;
  List<ReActionItemModel> allPosts = List();

  @override
  void initState() {
    apiResponse = StreamController<List<ReActionItemModel>>.broadcast();
    apiResponseData = StreamController<List<ReActionItemModel>>.broadcast();
    apiResponse = StreamController();
    _bloc = ReActionsBloc(apiResponseData, apiResponse);
    _subscribeToApiResponse();
    _bloc.callApiGetReactions(context, widget.id, 4, page);

    _scrollController.addListener(() {
      if (_scrollController.position.maxScrollExtent ==
          _scrollController.position.pixels) {
        if (!isLoading) {
          isLoading = !isLoading;
          if (!lastPage) _bloc.callApiGetReactions(context, widget.id, 4, page);
        }
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    apiResponse.close();
    _bloc.dispose();
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
    return Stack(
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(
              top: fit.t(10.0), left: fit.t(16.0), right: fit.t(16.0)),
          child: StreamBuilder<List<ReActionItemModel>>(
            stream: apiResponseData.stream,
            builder: (context, snapshot) {
              if (snapshot != null &&
                  snapshot.data != null &&
                  snapshot.hasData) {
                if (snapshot.data.length > 0) {
                  if (page == 0) {
                    allPosts.clear();
                  }
                  allPosts.addAll(snapshot.data);
                  if (page == 0) {
                    allPosts.add(ReActionItemModel());
                  }
                  isLoading = false;
                  if (snapshot.data.length == 10) {
                    page += 1;
                  }
                  if (snapshot.data.length < 10) {
                    lastPage = true;
                  }
                  if (allPosts.length > 0) {
                    if (allPosts.firstWhere(
                            (element) => element.created_at == null,
                            orElse: null) !=
                        null) {
                      allPosts.remove(allPosts
                          .firstWhere((element) => element.created_at == null));
                      allPosts.add(ReActionItemModel());
                    }
                  }
                }
                if (allPosts.length == 0) {
                  allPosts.add(ReActionItemModel());
                }
                return _createListView(allPosts);
              } else if (snapshot != null && snapshot.hasError) {
                return Text(snapshot.error.toString());
              } else {
                return Container(
                  child: Text(''),
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
    );
  }

  Widget _createListView(List<ReActionItemModel> itemList) {
    return ListView.builder(
      physics: AlwaysScrollableScrollPhysics(),
      itemBuilder: (BuildContext context, int index) {
        return index == 0 && itemList[index].created_at == null
            ? NoDataWidget(
                fit: fit,
                txt: 'No Reactions Found.',
              )
            : itemList[index].created_at == null
                ? NoDataWidget(
                    fit: fit,
                    txt: '\n',
                  )
                : ShareListItem(fit: fit, pos: index, data: itemList[index]);
      },
      itemCount: itemList.length,
      shrinkWrap: false,
      controller: _scrollController,
    );
  }

  void _subscribeToApiResponse() {
    StreamSubscription subscription;
    subscription = apiResponse.stream.listen((data) {
      if (data is CommonApiReponse) {
        TopAlert.showAlert(context, data.message, false);
      } else if (data is ErrorResponse) {
        TopAlert.showAlert(context, data.message, true);
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
}
