import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';
import 'package:fm_fit/fm_fit.dart';
import 'package:my_voicee/CallBacks/DashBaordListCallBack.dart';
import 'package:my_voicee/constants/app_colors.dart';
import 'package:my_voicee/constants/app_constants.dart';
import 'package:my_voicee/constants/app_images_path.dart';
import 'package:my_voicee/customWidget/ExpandableText.dart';
import 'package:my_voicee/customWidget/super_tooltip.dart';
import 'package:my_voicee/models/channelListModel.dart';
import 'package:my_voicee/postLogin/profile/ChannelList/ChannelListScreen.dart';
import 'package:my_voicee/utils/Utility.dart';
import 'package:my_voicee/utils/date_formatter.dart';

class ChannelItemPlay extends StatefulWidget {
  final int pos;
  final dynamic from;
  final ChannelPost data;
  final DashboardCallBack callBack;
  final FmFit fit;
  final AudioPlayer player;
  final bool isShown;
  final Function(bool shown) isTutShown;
  final GlobalKey parentKey;
  final BuildContext menuContext;

  ChannelItemPlay(
      {this.fit, this.pos, this.parentKey, this.from, this.data, this.callBack, this.player, this.isTutShown, this.isShown, this.menuContext});

  @override
  _ChannelItemPlayState createState() => _ChannelItemPlayState();
}

class _ChannelItemPlayState extends State<ChannelItemPlay> {
  bool isVisualizer = false;
  SuperTooltip tooltip;
  GlobalKey _key1 = GlobalKey<_ChannelItemPlayState>();
  GlobalKey _key2 = GlobalKey<_ChannelItemPlayState>();
  GlobalKey _key3 = GlobalKey<_ChannelItemPlayState>();
  GlobalKey _key4 = GlobalKey<_ChannelItemPlayState>();

  @override
  void initState() {
    if (isShowTut && (widget.pos == 0) && !widget.isShown) SchedulerBinding.instance.addPostFrameCallback((_) => showTooltip());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        print("On Tap from Item called");
        Navigator.push(
          widget.menuContext,
          MaterialPageRoute(
            builder: (context) => ChannelListScreen(
              userChannelId: widget.data?.channel[0].id,
            ),
          ),
        );
      },
      child: Wrap(
        children: <Widget>[
          Card(
            elevation: widget.fit.t(1.0),
            color: colorWhite,
            child: Container(
              decoration: ShapeDecoration(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                color: colorWhite,
              ),
              child: Container(
                color: colorWhite,
                padding: EdgeInsets.only(
                  left: widget.fit.t(8.0),
                  right: widget.fit.t(8.0),
                  bottom: widget.fit.t(8.0),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        Flexible(
                          flex: 20,
                          child: Row(
                            children: <Widget>[
                              widget.data.isCampaign ?? false
                                  ? Container(
                                      width: widget.fit.t(16.0),
                                      height: widget.fit.t(14.0),
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          fit: BoxFit.cover,
                                          image: AssetImage(is_campaign),
                                        ),
                                      ),
                                    )
                                  : Container(),
                              SizedBox(
                                width: fit.t(2.0),
                              ),
                              widget.data?.channel.length > 0
                                  ? widget.data?.channel[0]?.img == null ||
                                          widget.data?.channel[0]?.img.isEmpty ||
                                          !widget.data?.channel[0]?.img.contains("http")
                                      ? Container(
                                          width: widget.fit.t(40.0),
                                          height: widget.fit.t(40.0),
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
                                          imageUrl: '${widget.data?.channel[0]?.img}',
                                          imageBuilder: (context, imageProvider) => ClipRRect(
                                            borderRadius: BorderRadius.all(Radius.circular(80.0)),
                                            child: Container(
                                              height: widget.fit.t(40.0),
                                              width: widget.fit.t(40.0),
                                              decoration: BoxDecoration(
                                                image: DecorationImage(
                                                  image: imageProvider,
                                                  fit: BoxFit.contain,
                                                ),
                                              ),
                                            ),
                                          ),
                                          placeholder: (context, image) => Image.asset(
                                            ic_profile,
                                            height: widget.fit.t(40.0),
                                            width: widget.fit.t(40.0),
                                            fit: BoxFit.cover,
                                          ),
                                          errorWidget: (context, url, error) => Image.asset(
                                            ic_profile,
                                            height: widget.fit.t(40.0),
                                            width: widget.fit.t(40.0),
                                            fit: BoxFit.cover,
                                          ),
                                        )
                                  : widget.data?.user?.dp == null || widget.data.user.dp.isEmpty || !widget.data.user.dp.contains("http")
                                      ? Container(
                                          width: widget.fit.t(40.0),
                                          height: widget.fit.t(40.0),
                                          decoration: BoxDecoration(
                                            color: appColor,
                                            shape: BoxShape.circle,
                                            image: DecorationImage(
                                              fit: BoxFit.cover,
                                              image: AssetImage(ic_profile),
                                            ),
                                          ),
                                        )
                                      : InkWell(
                                          onTap: () => widget.callBack.onClickItem(widget.pos),
                                          child: CachedNetworkImage(
                                            imageUrl: '${widget.data.user.dp}',
                                            imageBuilder: (context, imageProvider) => ClipRRect(
                                              borderRadius: BorderRadius.all(Radius.circular(80.0)),
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
                                            placeholder: (context, image) => Image.asset(
                                              ic_profile,
                                              height: widget.fit.t(40.0),
                                              width: widget.fit.t(40.0),
                                              fit: BoxFit.cover,
                                            ),
                                            errorWidget: (context, url, error) => Image.asset(
                                              ic_profile,
                                              height: widget.fit.t(40.0),
                                              width: widget.fit.t(40.0),
                                              fit: BoxFit.cover,
                                            ),
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
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      Wrap(
                                        direction: Axis.vertical,
                                        children: [
                                          GestureDetector(
                                            onTap: () => widget.data.isCampaign ?? false ? {} : widget.callBack.onClickItem(widget.pos),
                                            child: Container(
                                              width:
                                                  Platform.isIOS ? MediaQuery.of(context).size.width / 1.7 : MediaQuery.of(context).size.width / 1.55,
                                              child: Row(
                                                children: [
                                                  widget.data?.channel.length > 0
                                                      ? Container(
                                                          child: Text(
                                                            "${widget.data?.channel.length > 0 ? widget.data?.channel[0]?.title ?? "" : ""}",
                                                            style: TextStyle(
                                                              fontFamily: 'Roboto',
                                                              fontSize: widget.fit.t(14.0),
                                                              fontWeight: FontWeight.w500,
                                                              letterSpacing: 0.18,
                                                              color: Color.fromRGBO(0, 0, 0, 1),
                                                            ),
                                                          ),
                                                        )
                                                      : widget.data.user.isPublisher ?? false
                                                          ? Row(
                                                              children: [
                                                                Text(
                                                                  "${widget.data?.user?.username ?? ""}",
                                                                  style: TextStyle(
                                                                    fontFamily: 'Roboto',
                                                                    fontSize: widget.fit.t(12.0),
                                                                    fontWeight: FontWeight.w400,
                                                                    letterSpacing: 0.18,
                                                                    color: Color.fromRGBO(0, 0, 0, 1),
                                                                  ),
                                                                ),
                                                                Container(
                                                                  width: fit.t(3.0),
                                                                ),
                                                                Image.asset(
                                                                  badge,
                                                                  scale: 3,
                                                                )
                                                              ],
                                                            )
                                                          : Container(
                                                              child: Text(
                                                                "${widget.data?.user?.username ?? ""}",
                                                                style: TextStyle(
                                                                  fontFamily: 'Roboto',
                                                                  fontSize: widget.fit.t(12.0),
                                                                  fontWeight: FontWeight.w400,
                                                                  letterSpacing: 0.18,
                                                                  color: Color.fromRGBO(0, 0, 0, 1),
                                                                ),
                                                              ),
                                                            ),
                                                  RichText(
                                                    text: TextSpan(
                                                      text: '  •  ',
                                                      style: TextStyle(
                                                          fontFamily: 'Roboto',
                                                          fontSize: widget.fit.t(8.0),
                                                          fontWeight: FontWeight.w900,
                                                          letterSpacing: 0.12,
                                                          color: Colors.black),
                                                      children: <TextSpan>[
                                                        TextSpan(
                                                            text:
                                                                '${timeAgo(getDateTimeStamp(widget.data.createdAt, "yyyy-MM-dd'T'hh:mm:ss.SSS'Z'"))}',
                                                            style: TextStyle(
                                                                fontFamily: 'Roboto',
                                                                fontSize: widget.fit.t(8.0),
                                                                fontWeight: FontWeight.w400,
                                                                letterSpacing: 0.12,
                                                                color: Color.fromRGBO(119, 113, 113, 1))),
                                                      ],
                                                    ),
                                                    textAlign: TextAlign.start,
                                                    overflow: TextOverflow.ellipsis,
                                                    maxLines: 2,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: widget.fit.t(2.0),
                                  ),
                                  Container(
                                    width: Platform.isIOS ? MediaQuery.of(context).size.width / 2.0 : MediaQuery.of(context).size.width / 1.7,
                                    child: widget.data?.channel.length > 0
                                        ? Text(
                                            '${widget.data?.channel.length > 0 ? widget.data?.channel[0]?.description ?? "" : ""}',
                                            maxLines: 5,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                                fontFamily: 'Roboto',
                                                fontWeight: FontWeight.w400,
                                                fontSize: widget.fit.t(9.0),
                                                color: Color.fromRGBO(119, 113, 113, 1)),
                                          )
                                        : Text(
                                            '${widget.data?.user?.bio ?? ""}',
                                            maxLines: 5,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                                fontFamily: 'Roboto',
                                                fontWeight: FontWeight.w400,
                                                fontSize: widget.fit.t(9.0),
                                                color: Color.fromRGBO(119, 113, 113, 1)),
                                          ),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                        Flexible(
                          flex: 1,
                          child: InkWell(
                            onTap: () => widget.callBack.onClickMenu(widget.pos),
                            child: Image.asset(
                              ic_menu_nav,
                              width: widget.fit.t(30.0),
                              height: widget.fit.t(65.0),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: EdgeInsets.only(left: widget.fit.t(4.0), right: widget.fit.t(4.0)),
                      child: widget.data.text.length > 150
                          ? ExpandableText(
                              '${widget.data.text}',
                              trimLines: 2,
                            )
                          : Text(
                              '${widget.data.text}',
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(fontFamily: 'Roboto', fontSize: widget.fit.t(12.0), fontWeight: FontWeight.w500, color: Colors.black),
                              textAlign: TextAlign.justify,
                            ),
                    ),
                    SizedBox(
                      height: 5.0,
                    ),
                    Container(
                      padding: EdgeInsets.only(left: widget.fit.t(4.0), right: widget.fit.t(4.0)),
                      child: Text(
                        '${widget.data.hashTag ?? ""}',
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontFamily: 'Roboto', fontSize: widget.fit.t(12.0), fontWeight: FontWeight.normal, color: appColor),
                        textAlign: TextAlign.justify,
                      ),
                    ),
                    widget.data.hashTag != null
                        ? SizedBox(
                            height: 10.0,
                          )
                        : Container(),
                    Container(
                      child: Image.asset(isVisualizer ? waves_half : waves_empty),
                      margin: EdgeInsets.symmetric(vertical: widget.fit.t(0.0)),
                    ),
                    SizedBox(
                      height: 5.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        InkWell(
                          onTap: () => widget.callBack.onReverseClick(widget.pos),
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
                          key: _key1,
                          onTap: !widget.data.is_play
                              ? () {
                                  widget.callBack.onPlayClick(widget.pos);
                                  isVisualizer = true;
                                  setState(() {});
                                }
                              : () {
                                  widget.callBack.onPauseClick(widget.pos);
                                  isVisualizer = false;
                                  setState(() {});
                                },
                          child: Image.asset(
                            widget.data.is_play ? '$ic_pause_recording' : '$ic_play',
                            width: widget.fit.t(40.0),
                            height: widget.fit.t(40.0),
                          ),
                        ),
                        SizedBox(
                          width: 5.0,
                        ),
                        InkWell(
                          onTap: () => widget.callBack.onForwardClick(widget.pos),
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
                          '${widget.data.audioDuration ?? "0"}s',
                          style: TextStyle(
                              fontFamily: 'Roboto',
                              fontSize: widget.fit.t(12.0),
                              fontWeight: FontWeight.w400,
                              letterSpacing: 0.18,
                              color: Color.fromRGBO(0, 0, 0, 1)),
                        ),
                        SizedBox(
                          width: 10.0,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    widget.data.isCampaign ?? false
                        ? Container(
                            padding: EdgeInsets.only(left: widget.fit.t(4.0), right: widget.fit.t(4.0)),
                            child: Text(
                              '${widget.data.campaignDesc ?? ""}',
                              overflow: TextOverflow.ellipsis,
                              maxLines: 10,
                              style: TextStyle(fontFamily: 'Roboto', fontWeight: FontWeight.normal, fontSize: widget.fit.t(12.0), color: appColor),
                              textAlign: TextAlign.justify,
                            ),
                          )
                        : Container(),
                    widget.data.isCampaign ?? false
                        ? SizedBox(
                            height: 10.0,
                          )
                        : Container(),
                    widget.data.isCampaign ?? false
                        ? widget.data.campaignImg.isEmpty
                            ? Container()
                            : Container(
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(color: colorWhite),
                                child: CachedNetworkImage(
                                  imageUrl: '${widget.data.campaignImg}',
                                  imageBuilder: (context, imageProvider) => Container(
                                    width: MediaQuery.of(context).size.width,
                                    height: widget.fit.t(150.0),
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image: imageProvider,
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                  ),
                                  placeholder: (context, image) => Center(
                                    child: Icon(Icons.image),
                                  ),
                                  errorWidget: (context, url, error) => Center(
                                    child: Icon(Icons.image),
                                  ),
                                ),
                              )
                        : Container(),
                    SizedBox(
                      height: 10.0,
                    ),
                    widget.data.isCampaign ?? false
                        ? Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              InkWell(
                                key: _key2,
                                onTap: () => widget.callBack.onUpVoteClick(widget.pos),
                                child: Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Row(
                                    children: <Widget>[
                                      Icon(
                                        Icons.thumb_up_alt_outlined,
                                        color: widget.data.isLiked ? appColor : colorGrey2,
                                        size: widget.fit.t(20.0),
                                      ),
                                      SizedBox(
                                        width: widget.fit.t(4.0),
                                      ),
                                      Text(
                                        widget.data.nLikes > 0 ? '${widget.data.nLikes}' : '',
                                        style: TextStyle(
                                            fontFamily: 'Roboto',
                                            fontSize: widget.fit.t(12.0),
                                            fontWeight: FontWeight.w500,
                                            letterSpacing: 0.12,
                                            color: widget.data.isLiked ? appColor : Color.fromRGBO(178, 178, 178, 1)),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              InkWell(
                                key: _key3,
                                onTap: () => widget.callBack.onReplyClick(widget.pos),
                                child: Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Row(
                                    children: <Widget>[
                                      Image.asset(
                                        '$ic_replies',
                                        color: widget.data.isCommented ? appColor : colorGrey2,
                                        width: widget.fit.t(20.0),
                                        height: widget.fit.t(20.0),
                                      ),
                                      Text(
                                        widget.data.nComments > 0 ? ' ${widget.data.nComments}' : '',
                                        style: TextStyle(
                                          fontFamily: 'Roboto',
                                          fontSize: widget.fit.t(12.0),
                                          fontWeight: FontWeight.w500,
                                          letterSpacing: 0.12,
                                          color: widget.data.isCommented ? appColor : Color.fromRGBO(178, 178, 178, 1),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              InkWell(
                                key: _key4,
                                onTap: () => widget.callBack.onShareClick(widget.pos),
                                child: Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Row(
                                    children: <Widget>[
                                      Image.asset(
                                        '$ic_shares',
                                        color: widget.data.isShared ? appColor : colorGrey2,
                                        width: widget.fit.t(20.0),
                                        height: widget.fit.t(20.0),
                                      ),
                                      Text(
                                        widget.data.nShares > 0 ? ' ${widget.data.nShares}' : '',
                                        style: TextStyle(
                                            fontFamily: 'Roboto',
                                            fontSize: widget.fit.t(12.0),
                                            fontWeight: FontWeight.w500,
                                            letterSpacing: 0.12,
                                            color: widget.data.isShared ? appColor : Color.fromRGBO(178, 178, 178, 1)),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          )
                        : widget.from == -2
                            ? Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  InkWell(
                                    key: _key2,
                                    onTap: () => widget.callBack.onUpVoteClick(widget.pos),
                                    child: Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: Row(
                                        children: <Widget>[
                                          Image.asset(
                                            '$ic_upvotes',
                                            color: widget.data.isLiked ? appColor : colorGrey2,
                                            width: widget.fit.t(20.0),
                                            height: widget.fit.t(20.0),
                                          ),
                                          Text(
                                            widget.data.nLikes > 0 ? '${widget.data.nLikes}' : '',
                                            style: TextStyle(
                                                fontFamily: 'Roboto',
                                                fontSize: widget.fit.t(12.0),
                                                fontWeight: FontWeight.w500,
                                                letterSpacing: 0.12,
                                                color: widget.data.isLiked ? appColor : Color.fromRGBO(178, 178, 178, 1)),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () => widget.callBack.onDownVoteClick(widget.pos),
                                    child: Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: Row(
                                        children: <Widget>[
                                          Image.asset(
                                            '$ic_downvotes',
                                            color: widget.data.isDisliked ? appColor : colorGrey2,
                                            width: widget.fit.t(20.0),
                                            height: widget.fit.t(20.0),
                                          ),
                                          Text(
                                            widget.data.nDislikes > 0 ? ' ${widget.data.nDislikes}' : '',
                                            style: TextStyle(
                                                fontFamily: 'Roboto',
                                                fontSize: widget.fit.t(12.0),
                                                fontWeight: FontWeight.w500,
                                                letterSpacing: 0.12,
                                                color: widget.data.isDisliked ? appColor : Color.fromRGBO(178, 178, 178, 1)),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  InkWell(
                                    key: _key4,
                                    onTap: () => widget.callBack.onShareClick(widget.pos),
                                    child: Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: Row(
                                        children: <Widget>[
                                          Image.asset(
                                            '$ic_shares',
                                            color: widget.data.isShared ? appColor : colorGrey2,
                                            width: widget.fit.t(20.0),
                                            height: widget.fit.t(20.0),
                                          ),
                                          Text(
                                            widget.data.nShares > 0 ? ' ${widget.data.nShares}' : '',
                                            style: TextStyle(
                                                fontFamily: 'Roboto',
                                                fontSize: widget.fit.t(12.0),
                                                fontWeight: FontWeight.w500,
                                                letterSpacing: 0.12,
                                                color: widget.data.isShared ? appColor : Color.fromRGBO(178, 178, 178, 1)),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            : Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  InkWell(
                                    key: _key2,
                                    onTap: () => widget.callBack.onUpVoteClick(widget.pos),
                                    child: Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: Row(
                                        children: <Widget>[
                                          Image.asset(
                                            '$ic_upvotes',
                                            color: widget.data.isLiked ? appColor : colorGrey2,
                                            width: widget.fit.t(20.0),
                                            height: widget.fit.t(20.0),
                                          ),
                                          Text(
                                            widget.data.nLikes > 0 ? '${widget.data.nLikes}' : '',
                                            style: TextStyle(
                                                fontFamily: 'Roboto',
                                                fontSize: widget.fit.t(12.0),
                                                fontWeight: FontWeight.w500,
                                                letterSpacing: 0.12,
                                                color: widget.data.isLiked ? appColor : Color.fromRGBO(178, 178, 178, 1)),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  InkWell(
                                    key: _key3,
                                    onTap: () => widget.callBack.onReplyClick(widget.pos),
                                    child: Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: Row(
                                        children: <Widget>[
                                          Image.asset(
                                            '$ic_replies',
                                            color: widget.data.isCommented ? appColor : colorGrey2,
                                            width: widget.fit.t(20.0),
                                            height: widget.fit.t(20.0),
                                          ),
                                          Text(
                                            widget.data.nComments > 0 ? ' ${widget.data.nComments}' : '',
                                            style: TextStyle(
                                              fontFamily: 'Roboto',
                                              fontSize: widget.fit.t(12.0),
                                              fontWeight: FontWeight.w500,
                                              letterSpacing: 0.12,
                                              color: widget.data.isCommented ? appColor : Color.fromRGBO(178, 178, 178, 1),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () => widget.callBack.onDownVoteClick(widget.pos),
                                    child: Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: Row(
                                        children: <Widget>[
                                          Image.asset(
                                            '$ic_downvotes',
                                            color: widget.data.isDisliked ? appColor : colorGrey2,
                                            width: widget.fit.t(20.0),
                                            height: widget.fit.t(20.0),
                                          ),
                                          Text(
                                            widget.data.nDislikes > 0 ? ' ${widget.data.nDislikes}' : '',
                                            style: TextStyle(
                                                fontFamily: 'Roboto',
                                                fontSize: widget.fit.t(12.0),
                                                fontWeight: FontWeight.w500,
                                                letterSpacing: 0.12,
                                                color: widget.data.isDisliked ? appColor : Color.fromRGBO(178, 178, 178, 1)),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  InkWell(
                                    key: _key4,
                                    onTap: () => widget.callBack.onShareClick(widget.pos),
                                    child: Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: Row(
                                        children: <Widget>[
                                          Image.asset(
                                            '$ic_shares',
                                            color: widget.data.isShared ? appColor : colorGrey2,
                                            width: widget.fit.t(20.0),
                                            height: widget.fit.t(20.0),
                                          ),
                                          Text(
                                            widget.data.nShares > 0 ? ' ${widget.data.nShares}' : '',
                                            style: TextStyle(
                                                fontFamily: 'Roboto',
                                                fontSize: widget.fit.t(12.0),
                                                fontWeight: FontWeight.w500,
                                                letterSpacing: 0.12,
                                                color: widget.data.isShared ? appColor : Color.fromRGBO(178, 178, 178, 1)),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              )
                  ],
                ),
              ),
            ),
            shadowColor: colorWhite,
            semanticContainer: true,
          )
        ],
      ),
    );
  }

  void showTooltip() {
    widget.isTutShown(true);
    if (tooltip?.isOpen ?? false) {
      tooltip?.close();
    }
    // We create the tooltip on the first use
    tooltip = SuperTooltip(
      popupDirection: TooltipDirection.down,
      backgroundColor: Colors.amberAccent,
      myOffset: Offset(20, 40),
      borderRadius: fit.t(24.0),
      borderWidth: fit.t(2.0),
      borderColor: Colors.black,
      dismissOnTapOutside: false,
      maxWidth: MediaQuery.of(context).size.width / 1.2,
      touchThroughAreaShape: ClipAreaShape.oval,
      hasShadow: true,
      content: Material(
        child: Container(
          color: Colors.amberAccent,
          child: Wrap(
            children: [
              Text(
                "Click on the 'Play' icon to listen to the post.",
                softWrap: true,
                style: TextStyle(fontWeight: FontWeight.bold, fontFamily: "Roboto"),
              ),
              Container(
                height: fit.t(2.0),
              ),
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  InkWell(
                      onTap: () {
                        tooltip.close();
                        isShowTut = false;
                      },
                      child: Text(
                        " Skip all ",
                        style: TextStyle(fontWeight: FontWeight.bold, fontFamily: "Roboto"),
                      )),
                  Text(
                    "|",
                    style: TextStyle(fontWeight: FontWeight.bold, fontFamily: "Roboto"),
                  ),
                  InkWell(
                      onTap: () {
                        tooltip?.close();
                        showTooltipUpvote();
                      },
                      child: Text(
                        " Next ",
                        style: TextStyle(fontWeight: FontWeight.bold, fontFamily: "Roboto"),
                      )),
                  SizedBox(
                    width: fit.t(10.0),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
    tooltip.show(_key1.currentContext);
  }

  void showTooltipUpvote() {
    if (tooltip?.isOpen ?? false) {
      tooltip?.close();
    }

    // We create the tooltip on the first use
    tooltip = SuperTooltip(
      popupDirection: TooltipDirection.down,
      backgroundColor: Colors.amberAccent,
      myOffset: Offset(20, 20),
      borderRadius: fit.t(24.0),
      borderWidth: fit.t(2.0),
      borderColor: Colors.black,
      dismissOnTapOutside: false,
      maxWidth: MediaQuery.of(context).size.width / 1.2,
      touchThroughAreaShape: ClipAreaShape.oval,
      hasShadow: true,
      content: Material(
        child: Container(
          color: Colors.amberAccent,
          child: Wrap(
            children: [
              Text(
                "You can upvote using this icon.",
                softWrap: true,
                style: TextStyle(fontWeight: FontWeight.bold, fontFamily: "Roboto"),
              ),
              Container(
                height: fit.t(2.0),
              ),
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  InkWell(
                      onTap: () {
                        tooltip?.close();
                        isShowTut = false;
                      },
                      child: Text(
                        " Skip all ",
                        style: TextStyle(fontWeight: FontWeight.bold, fontFamily: "Roboto"),
                      )),
                  Text(
                    "|",
                    style: TextStyle(fontWeight: FontWeight.bold, fontFamily: "Roboto"),
                  ),
                  InkWell(
                      onTap: () {
                        tooltip?.close();
                        showReplyToolTip();
                      },
                      child: Text(
                        " Next ",
                        style: TextStyle(fontWeight: FontWeight.bold, fontFamily: "Roboto"),
                      )),
                  SizedBox(
                    width: fit.t(10.0),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
    tooltip.show(_key2.currentContext);
  }

  void showReplyToolTip() {
    if (tooltip?.isOpen ?? false) {
      tooltip?.close();
    }

    // We create the tooltip on the first use
    tooltip = SuperTooltip(
      popupDirection: TooltipDirection.down,
      backgroundColor: Colors.amberAccent,
      myOffset: Offset(20, 20),
      borderRadius: fit.t(24.0),
      borderWidth: fit.t(2.0),
      borderColor: Colors.black,
      dismissOnTapOutside: false,
      maxWidth: MediaQuery.of(context).size.width / 1.2,
      touchThroughAreaShape: ClipAreaShape.oval,
      hasShadow: true,
      content: Material(
        child: Container(
          color: Colors.amberAccent,
          child: Wrap(
            children: [
              Text(
                "You also reply to any post.",
                softWrap: true,
                style: TextStyle(fontWeight: FontWeight.bold, fontFamily: "Roboto"),
              ),
              Container(
                height: fit.t(2.0),
              ),
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  InkWell(
                      onTap: () {
                        tooltip?.close();
                        isShowTut = false;
                      },
                      child: Text(
                        " Skip all ",
                        style: TextStyle(fontWeight: FontWeight.bold, fontFamily: "Roboto"),
                      )),
                  Text(
                    "|",
                    style: TextStyle(fontWeight: FontWeight.bold, fontFamily: "Roboto"),
                  ),
                  InkWell(
                      onTap: () {
                        tooltip?.close();
                        showShareToolTip();
                      },
                      child: Text(
                        " Next ",
                        style: TextStyle(fontWeight: FontWeight.bold, fontFamily: "Roboto"),
                      )),
                  SizedBox(
                    width: fit.t(10.0),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
    tooltip.show(_key3.currentContext);
  }

  void showShareToolTip() {
    if (tooltip?.isOpen ?? false) {
      tooltip?.close();
    }

    // We create the tooltip on the first use
    tooltip = SuperTooltip(
      popupDirection: TooltipDirection.down,
      backgroundColor: Colors.amberAccent,
      myOffset: Offset(20, 20),
      borderRadius: fit.t(24.0),
      borderWidth: fit.t(2.0),
      borderColor: Colors.black,
      dismissOnTapOutside: false,
      maxWidth: MediaQuery.of(context).size.width / 1.2,
      touchThroughAreaShape: ClipAreaShape.oval,
      hasShadow: true,
      content: Material(
        child: Container(
          color: Colors.amberAccent,
          child: Wrap(
            children: [
              Text(
                "You can share on any social platform.",
                softWrap: true,
                style: TextStyle(fontWeight: FontWeight.bold, fontFamily: "Roboto"),
              ),
              Container(
                height: fit.t(2.0),
              ),
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  InkWell(
                      onTap: () {
                        tooltip?.close();
                        isShowTut = false;
                      },
                      child: Text(
                        " Skip all ",
                        style: TextStyle(fontWeight: FontWeight.bold, fontFamily: "Roboto"),
                      )),
                  Text(
                    "|",
                    style: TextStyle(fontWeight: FontWeight.bold, fontFamily: "Roboto"),
                  ),
                  InkWell(
                      onTap: () {
                        tooltip?.close();
                        ShowParentTooltip();
                      },
                      child: Text(
                        " Next ",
                        style: TextStyle(fontWeight: FontWeight.bold, fontFamily: "Roboto"),
                      )),
                  SizedBox(
                    width: fit.t(10.0),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
    tooltip.show(_key4.currentContext);
  }

  void ShowParentTooltip() {
    if (tooltip?.isOpen ?? false) {
      tooltip?.close();
    }

    // We create the tooltip on the first use
    tooltip = SuperTooltip(
      popupDirection: TooltipDirection.up,
      backgroundColor: Colors.amberAccent,
      myOffset: Offset(30, 0),
      borderRadius: fit.t(24.0),
      borderWidth: fit.t(2.0),
      borderColor: Colors.black,
      dismissOnTapOutside: false,
      maxWidth: MediaQuery.of(context).size.width / 1.2,
      touchThroughAreaShape: ClipAreaShape.oval,
      hasShadow: true,
      content: Material(
        child: Container(
          color: Colors.amberAccent,
          child: Wrap(
            children: [
              Text(
                "You can publish your own post using this icon.",
                softWrap: true,
                style: TextStyle(fontWeight: FontWeight.bold, fontFamily: "Roboto"),
              ),
              Container(
                height: fit.t(2.0),
              ),
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  InkWell(
                      onTap: () {
                        tooltip?.close();
                        isShowTut = false;
                      },
                      child: Text(
                        " Skip all ",
                        style: TextStyle(fontWeight: FontWeight.bold, fontFamily: "Roboto"),
                      )),
                  Text(
                    "|",
                    style: TextStyle(fontWeight: FontWeight.bold, fontFamily: "Roboto"),
                  ),
                  InkWell(
                      onTap: () {
                        tooltip?.close();
                      },
                      child: Text(
                        " Next ",
                        style: TextStyle(fontWeight: FontWeight.bold, fontFamily: "Roboto"),
                      )),
                  SizedBox(
                    width: fit.t(10.0),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
    tooltip.show(widget.parentKey.currentContext);
  }
}
