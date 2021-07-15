import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fm_fit/fm_fit.dart';
import 'package:my_voicee/constants/app_colors.dart';
import 'package:my_voicee/constants/app_images_path.dart';
import 'package:my_voicee/customWidget/Alert/NoDataWidget.dart';
import 'package:my_voicee/customWidget/appLoader/custom_progress_loader.dart';
import 'package:my_voicee/customWidget/imageViewer/ImageViewer.dart';
import 'package:my_voicee/models/channelListModel.dart';
import 'package:my_voicee/postLogin/profile/ChannelList/channelItemPlay.dart';
import 'package:my_voicee/postLogin/profile/ChannelList/Controller/ChannelListController.dart';
import 'package:my_voicee/postLogin/profile/drawerItems/channel/CreateChannel.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:get/get.dart';

class ChannelListScreen extends StatefulWidget {
  final String userChannelId;
  const ChannelListScreen({Key key, @required this.userChannelId}) : super(key: key);

  @override
  _ChannelListScreenState createState() => _ChannelListScreenState();
}

class _ChannelListScreenState extends State<ChannelListScreen> {
  FmFit fit = FmFit(width: 750);
  final controller = Get.put(ChannelListController());
  @override
  void initState() {
    super.initState();
    print("User Id: ${widget.userChannelId}");
    controller.getUserProfile(context, widget.userChannelId);
    controller.menuScreenContext = context;
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
      backgroundColor: colorWhite,
      appBar: _appBarWidget(),
      body: bodyWidget(context),
    );
  }

  Widget bodyWidget(context) {
    return Stack(children: <Widget>[
      Obx(() {
        return controller.isLoading.value
            ? ProgressLoader(
                fit: fit,
                isShowLoader: controller.isLoading.value,
                color: appColor,
              )
            : channelBody();
      }),
    ]);
  }

  Widget channelBody() {
    return Container(
      margin: EdgeInsets.only(top: fit.t(8.0), left: fit.t(8.0), right: fit.t(4.0)),
      child: Stack(
        children: [
          Positioned(
            right: fit.t(0.0),
            top: fit.t(0.0),
            child: Container(
              height: fit.t(30.0),
              width: fit.t(60.0),
              child: InkWell(
                onTap: () {},
                child: Icon(
                  Icons.block_flipped,
                  color: Colors.red,
                  size: fit.t(24.0),
                ),
              ),
            ),
          ),
          Wrap(
            children: <Widget>[
              Column(
                children: [
                  Container(
                    height: fit.t(60.0),
                    width: fit.t(60.0),
                    margin: EdgeInsets.only(
                      left: fit.t(60.0),
                      right: fit.t(60.0),
                    ),
                    child: Stack(
                      children: <Widget>[
                        GestureDetector(
                          onTap: () => onImageClick(),
                          child: CachedNetworkImage(
                            imageUrl: '${controller.imagePath}',
                            imageBuilder: (context, imageProvider) => ClipRRect(
                              borderRadius: BorderRadius.all(Radius.circular(80.0)),
                              child: Container(
                                  height: fit.t(60.0),
                                  width: fit.t(60.0),
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: imageProvider,
                                      fit: BoxFit.cover,
                                    ),
                                  )),
                            ),
                            placeholder: (context, image) => Image.asset(
                              ic_profile,
                              height: fit.t(60.0),
                              width: fit.t(60.0),
                              fit: BoxFit.cover,
                            ),
                            errorWidget: (context, url, error) => Image.asset(
                              ic_profile,
                              height: fit.t(60.0),
                              width: fit.t(60.0),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 5.0,
                  ),
                  controller.userDataBean?.user?.isPublisher ?? false
                      ? Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              padding: EdgeInsets.all(4.0),
                              child: Text(
                                '${controller.userDataBean?.title ?? ""}',
                                textAlign: TextAlign.center,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontFamily: 'Roboto', fontSize: fit.t(30.0), fontWeight: FontWeight.bold, color: Color.fromRGBO(0, 0, 0, 1)),
                              ),
                            ),
                            Image.asset(
                              badge,
                              scale: 2.5,
                            )
                          ],
                        )
                      : Container(
                          padding: EdgeInsets.all(4.0),
                          child: Text(
                            '${controller.userDataBean?.title ?? ""}',
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontFamily: 'Roboto', fontSize: fit.t(18.0), fontWeight: FontWeight.bold, color: Color.fromRGBO(0, 0, 0, 1)),
                          ),
                        ),
                  SizedBox(
                    height: 5.0,
                  ),
                  Container(
                    padding: EdgeInsets.all(4.0),
                    child: Text(
                      '${controller.userDataBean?.user?.username ?? ""}',
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontFamily: 'Roboto', fontSize: fit.t(18.0), fontWeight: FontWeight.bold, color: Color.fromRGBO(0, 0, 0, 1)),
                    ),
                  ),
                  SizedBox(
                    height: 5.0,
                  ),
                  //bio
                  Container(
                    child: Text(
                      '${controller.userDataBean?.user?.bio ?? ""}',
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontFamily: 'Roboto', fontWeight: FontWeight.w400, fontSize: fit.t(16.0), color: Color.fromRGBO(119, 113, 113, 1)),
                    ),
                  ),
                  SizedBox(
                    height: 5.0,
                  ),
                  // Container(
                  //   height: fit.t(30.0),
                  //   child: RaisedButton(
                  //     color: colorAcceptBtn,
                  //     textColor: colorWhite,
                  //     onPressed: () => onClickFollow(),
                  //     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
                  //     child: Text(
                  //       controller.userDataBean?.following ?? false ? 'UnFollow' : 'Follow',
                  //       textAlign: TextAlign.center,
                  //       style: TextStyle(
                  //         fontWeight: FontWeight.w500,
                  //         color: colorWhite,
                  //         letterSpacing: 0.18,
                  //         fontFamily: "Roboto",
                  //         fontSize: fit.t(14.0),
                  //       ),
                  //     ),
                  //     splashColor: colorAcceptBtnSplash,
                  //   ),
                  // ),
                  SizedBox(
                    height: fit.t(10.0),
                  ),
                  //divider
                  Divider(
                    height: fit.t(2.0),
                    endIndent: fit.t(15.0),
                    indent: fit.t(15.0),
                  ),
                  //column
                ],
              ),
              SizedBox(
                height: fit.t(10.0),
              ),
              Container(height: MediaQuery.of(context).size.height, child: _createListView(controller.allPosts)),
              SizedBox(
                height: fit.t(10.0),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _createListView(List<ChannelPost> itemList) {
    return ListView.builder(
      physics: BouncingScrollPhysics(),
      itemBuilder: (BuildContext context, int index) {
        return (index == 0 && itemList[index].id == null)
            ? NoDataWidget(
                fit: fit,
                txt: 'No Posts',
              )
            : itemList[index].id == null
                ? NoDataWidget(
                    fit: fit,
                    txt: '\n\n\n\n\n\n\n\n\n\n\n',
                  )
                : ChannelItemPlay(
                    fit: fit,
                    pos: index,
                    isTutShown: _isShown,
                    isShown: true,
                    from: "profile",
                    data: itemList[index],
                    callBack: controller.itemCallBacks,
                  );
      },
      itemCount: itemList.length,
      shrinkWrap: false,
      controller: controller.scrollController,
    );
  }

  _isShown(bool shown) {}

  Widget _appBarWidget() {
    return AppBar(
      backgroundColor: colorWhite,
      elevation: 0,
      leading: _leadingWidget(),
      centerTitle: true,
      title: _titleWidget(),
      actions: <Widget>[trailingWidget()],
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

  Widget _titleWidget() {
    return Container(
      child: Padding(
        padding: EdgeInsets.only(top: fit.t(8.0), left: fit.t(8.0), right: fit.t(8.0)),
        child: Container(
          child: Text(
            'Channel Profile',
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

  onImageClick() {
    if (controller.imagePath != null) {
      if (controller.imagePath.toString().contains('https://')) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => PhotoViewer(controller.imagePath, fit)),
        );
      }
    }
  }
}
