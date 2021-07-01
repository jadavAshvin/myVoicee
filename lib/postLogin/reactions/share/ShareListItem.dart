import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fm_fit/fm_fit.dart';
import 'package:my_voicee/constants/app_colors.dart';
import 'package:my_voicee/constants/app_images_path.dart';
import 'package:my_voicee/models/ReActionResponse.dart';

class ShareListItem extends StatelessWidget {
  final ReActionItemModel data;
  final pos;
  final onclickItem;
  final FmFit fit;

  ShareListItem({this.data, this.pos, this.onclickItem, this.fit});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: <Widget>[
        ClipRRect(
          borderRadius: BorderRadius.circular(20.0),
          child: Card(
            elevation: fit.t(0.0),
            child: Container(
              padding: EdgeInsets.only(
                  left: fit.t(4.0), right: fit.t(4.0), bottom: fit.t(4.0)),
              decoration: ShapeDecoration(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0)),
              ),
              child: Container(
                padding: EdgeInsets.only(
                    left: fit.t(8.0), right: fit.t(8.0), bottom: fit.t(8.0)),
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
                            data?.user?.dp == null ||
                                    data.user.dp.isEmpty ||
                                    !data.user.dp.contains("http")
                                ? Container(
                                    width: fit.t(40.0),
                                    height: fit.t(40.0),
                                    decoration: BoxDecoration(
                                      color: appColor,
                                      shape: BoxShape.circle,
                                      image: DecorationImage(
                                        fit: BoxFit.cover,
                                        image: AssetImage(ic_place_holder),
                                      ),
                                    ),
                                  )
                                : CachedNetworkImage(
                                    imageUrl: '${data.user.dp}',
                                    imageBuilder: (context, imageProvider) =>
                                        ClipRRect(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(80.0)),
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
                                    placeholder: (context, image) =>
                                        Image.asset(
                                      ic_place_holder,
                                      height: fit.t(40.0),
                                      width: fit.t(40.0),
                                      fit: BoxFit.cover,
                                    ),
                                    errorWidget: (context, url, error) =>
                                        Image.asset(
                                      ic_place_holder,
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
                                      : MediaQuery.of(context).size.width /
                                          1.55,
                                  child: Text(
                                    '${data?.user?.username ?? ""}',
                                    textAlign: TextAlign.start,
                                    overflow: TextOverflow.ellipsis,
                                    softWrap: true,
                                    style: TextStyle(
                                        fontFamily: 'Roboto',
                                        fontSize: fit.t(12.0),
                                        fontWeight: FontWeight.w400,
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
                                      : MediaQuery.of(context).size.width /
                                          1.55,
                                  child: Text(
                                    '${data?.user?.bio ?? ""}',
                                    maxLines: 3,
                                    textAlign: TextAlign.justify,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        fontFamily: 'Roboto',
                                        fontWeight: FontWeight.w400,
                                        fontSize: fit.t(9.0),
                                        color:
                                            Color.fromRGBO(119, 113, 113, 1)),
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
            shadowColor: Color.fromRGBO(243, 243, 243, 1),
            semanticContainer: true,
          ),
        )
      ],
    );
  }
}
