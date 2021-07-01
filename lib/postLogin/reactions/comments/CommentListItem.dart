import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fm_fit/fm_fit.dart';
import 'package:my_voicee/constants/app_colors.dart';
import 'package:my_voicee/constants/app_images_path.dart';
import 'package:my_voicee/models/ReActionResponse.dart';
import 'package:my_voicee/utils/Utility.dart';
import 'package:my_voicee/utils/date_formatter.dart';

class CommentListItem extends StatefulWidget {
  final ReActionItemModel data;
  final pos;
  final onclickItem;
  final FmFit fit;

  CommentListItem({this.data, this.pos, this.onclickItem, this.fit});

  @override
  _CommentListItemState createState() => _CommentListItemState();
}

class _CommentListItemState extends State<CommentListItem> {
  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: <Widget>[
        ClipRRect(
          borderRadius: BorderRadius.circular(20.0),
          child: Card(
            elevation: widget.fit.t(0.0),
            child: Container(
              padding: EdgeInsets.only(
                  left: widget.fit.t(4.0),
                  right: widget.fit.t(4.0),
                  bottom: widget.fit.t(4.0)),
              decoration: ShapeDecoration(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0)),
              ),
              child: Container(
                padding: EdgeInsets.only(
                    left: widget.fit.t(8.0),
                    right: widget.fit.t(8.0),
                    bottom: widget.fit.t(8.0)),
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
                            widget.data?.user?.dp == null ||
                                    widget.data?.user?.dp.isEmpty ||
                                    !widget.data.user.dp.contains("http")
                                ? Container(
                                    width: widget.fit.t(40.0),
                                    height: widget.fit.t(40.0),
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
                                    imageUrl: '${widget.data.user.dp}',
                                    imageBuilder: (context, imageProvider) =>
                                        ClipRRect(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(80.0)),
                                      child: Container(
                                        height: widget.fit.t(40.0),
                                        width: widget.fit.t(40.0),
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
                                      height: widget.fit.t(40.0),
                                      width: widget.fit.t(40.0),
                                      fit: BoxFit.cover,
                                    ),
                                    errorWidget: (context, url, error) =>
                                        Image.asset(
                                      ic_place_holder,
                                      height: widget.fit.t(40.0),
                                      width: widget.fit.t(40.0),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                            SizedBox(
                              width: widget.fit.t(8.0),
                            ),
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    Container(
                                      width: Platform.isIOS
                                          ? MediaQuery.of(context).size.width /
                                              1.7
                                          : MediaQuery.of(context).size.width /
                                              1.55,
                                      child: RichText(
                                        text: TextSpan(
                                          text:
                                              '${widget.data?.user?.username ?? ""}',
                                          style: TextStyle(
                                              fontFamily: 'Roboto',
                                              fontSize: widget.fit.t(14.0),
                                              fontWeight: FontWeight.w500,
                                              letterSpacing: 0.18,
                                              color:
                                                  Color.fromRGBO(0, 0, 0, 1)),
                                          children: <TextSpan>[
                                            TextSpan(
                                              text: ' •  ',
                                              style: TextStyle(
                                                  fontFamily: 'Roboto',
                                                  fontSize: widget.fit.t(10.0),
                                                  fontWeight: FontWeight.w500,
                                                  letterSpacing: 0.12,
                                                  color: appColor),
                                            ),
                                            TextSpan(
                                                text:
                                                    '${timeAgo(getDateTimeStamp(widget.data.created_at, "yyyy-MM-dd'T'hh:mm:ss.SSS'Z'"))}',
                                                style: TextStyle(
                                                    fontFamily: 'Roboto',
                                                    fontSize: widget.fit.t(9.0),
                                                    fontWeight: FontWeight.w400,
                                                    letterSpacing: 0.12,
                                                    color: Color.fromRGBO(
                                                        119, 113, 113, 1))),
                                            TextSpan(
                                              text: ' •  ',
                                              style: TextStyle(
                                                  fontFamily: 'Roboto',
                                                  fontSize: widget.fit.t(10.0),
                                                  fontWeight: FontWeight.w500,
                                                  letterSpacing: 0.12,
                                                  color: appColor),
                                            ),
                                            TextSpan(
                                              text: ' ${_getLanguage("")}',
                                              style: TextStyle(
                                                fontFamily: 'Roboto',
                                                fontSize: widget.fit.t(9.0),
                                                fontWeight: FontWeight.w400,
                                                letterSpacing: 0.12,
                                                color: Color.fromRGBO(
                                                    119, 113, 113, 1),
                                              ),
                                            ),
                                          ],
                                        ),
                                        textAlign: TextAlign.start,
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 2,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: widget.fit.t(2.0),
                                ),
                                Container(
                                  width: Platform.isIOS
                                      ? MediaQuery.of(context).size.width / 1.7
                                      : MediaQuery.of(context).size.width /
                                          1.55,
                                  child: Text(
                                    '${widget.data?.user?.bio ?? ""}',
                                    maxLines: 3,
                                    textAlign: TextAlign.justify,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        fontFamily: 'Roboto',
                                        fontWeight: FontWeight.w300,
                                        fontSize: fit.t(12.0),
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
                    Container(
                      padding: EdgeInsets.only(
                          left: widget.fit.t(4.0),
                          right: widget.fit.t(4.0),
                          top: widget.fit.t(4.0)),
                      child: Text(
                        '${widget.data.comment}',
                        style: TextStyle(
                            fontFamily: 'Roboto',
                            color: Color.fromRGBO(119, 113, 113, 1)),
                        textAlign: TextAlign.justify,
                      ),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.max,
                          children: <Widget>[
                            InkWell(
                              onTap: () =>
                                  widget.onclickItem.onReverseClick(widget.pos),
                              child: Image.asset(
                                '$ic_reverse',
                                width: widget.fit.t(30.0),
                                height: widget.fit.t(30.0),
                              ),
                            ),
                            SizedBox(
                              width: 5.0,
                            ),
                            InkWell(
                              onTap: !widget.data.is_play
                                  ? () {
                                      widget.onclickItem
                                          .onPlayClick(widget.pos);
                                      setState(() {});
                                    }
                                  : () {
                                      widget.onclickItem
                                          .onPauseClick(widget.pos);
                                      setState(() {});
                                    },
                              child: Image.asset(
                                widget.data.is_play
                                    ? '$ic_pause_recording'
                                    : '$ic_play',
                                width: widget.fit.t(40.0),
                                height: widget.fit.t(40.0),
                              ),
                            ),
                            SizedBox(
                              width: 5.0,
                            ),
                            InkWell(
                              onTap: () =>
                                  widget.onclickItem.onForwardClick(widget.pos),
                              child: Image.asset(
                                '$ic_forward',
                                width: widget.fit.t(30.0),
                                height: widget.fit.t(30.0),
                              ),
                            ),
                            SizedBox(
                              width: 5.0,
                            ),
                            Text(
                              '${widget.data.audio_duration ?? "0"}s',
                              style: TextStyle(
                                  fontFamily: 'Roboto',
                                  fontSize: widget.fit.t(14.0),
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: 0.18,
                                  color: Color.fromRGBO(178, 178, 178, 1)),
                            )
                          ],
                        ),
                        InkWell(
                          onTap: () =>
                              widget.onclickItem.onClickShare(widget.pos),
                          child: Row(
                            children: <Widget>[
                              Image.asset(
                                '$ic_shares',
                                width: widget.fit.t(20.0),
                                height: widget.fit.t(20.0),
                              ),
                              Text(
                                ' Shares',
                                style: TextStyle(
                                    fontFamily: 'Roboto',
                                    fontSize: widget.fit.t(12.0),
                                    fontWeight: FontWeight.w500,
                                    letterSpacing: 0.12,
                                    color: Color.fromRGBO(178, 178, 178, 1)),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Divider(
                      indent: widget.fit.t(8.0),
                      endIndent: widget.fit.t(8.0),
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

  String _getLanguage(String value) {
    switch (value) {
      case "en-IN":
        return "English(IN)";
      case "en-US":
        return "English(US)";
      case "es-ES":
        return "Spanish";
      case "hi-IN":
        return "Hindi";
      case "bn-IN":
        return "Bengali";
      case "gu_IN":
        return "Gujrati";
      case "mr_IN":
        return "Marathi";
      case "ta_IN":
        return "Tamil";
      case "te_IN":
        return "Telegu";
      case "ml_IN":
        return "Malaylam";
      case "kn_IN":
        return "Kannada";
      case "or_IN":
        return "Odiya";
      case "as_IN":
        return "Aasamese";
      case "de":
        return "German";
      case "cmn":
        return "Mandarin Chinese";
      case "pt":
        return "Portuguese";
      case "fr":
        return "French";
      case "ar":
        return "Arabic";
      case "ru":
        return "Russian";
      case "ja":
        return "Japanese";
      default:
        return "English";
    }
  }
}
