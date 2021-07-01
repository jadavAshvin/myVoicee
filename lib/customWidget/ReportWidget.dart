import 'package:flutter/material.dart';
import 'package:fm_fit/fm_fit.dart';
import 'package:my_voicee/constants/app_colors.dart';
import 'package:my_voicee/constants/app_images_path.dart';
import 'package:my_voicee/customWidget/radio_group.dart';
import 'package:my_voicee/customWidget/radio_item.dart';

class ReportWidget extends StatefulWidget {
  final String title;
  final String body;
  final Function(GroupItem selectedItem) onReportClick;

  ReportWidget(this.title, this.body, this.onReportClick);

  @override
  _ReportWidgetState createState() => _ReportWidgetState();
}

class _ReportWidgetState extends State<ReportWidget> {
  Color color = Color(0xccE4A244);
  FmFit fit = FmFit(width: 750);
  bool isEnable = false;
  String selected = "";
  GroupItem selectedItem;
  final List<GroupItem> radioItems = [
    GroupItem(title: "It’s posting content that shouldn’t be on Voicee"),
    GroupItem(title: "It’s pretending to be someone else"),
    GroupItem(title: "They may be under the age of 13"),
  ];

  @override
  void initState() {
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
    return Container(
        padding: EdgeInsets.symmetric(
            horizontal: fit.t(20.0), vertical: fit.t(10.0)),
        width: fit.t(MediaQuery.of(context).size.width),
        height: fit.t(MediaQuery.of(context).size.height),
        margin: EdgeInsets.only(top: fit.t(10.0)),
        child: Stack(
          children: <Widget>[
            ListView(
              physics: NeverScrollableScrollPhysics(),
              children: <Widget>[
                SizedBox(
                  height: fit.t(60.0),
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(fit.t(5.0)),
                    color: Colors.white,
                  ),
                  margin: EdgeInsets.only(
                      top: fit.t(30.0), left: fit.t(10.0), right: fit.t(10.0)),
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    children: <Widget>[
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(fit.t(4.0)),
                              topRight: Radius.circular(fit.t(4.0))),
                          color: btnAppColor,
                        ),
                        height: fit.t(50.0),
                        child: Center(
                          child: Image.asset(
                            ic_logo_small,
                            color: Colors.white,
                            height: fit.t(20.0),
                            width: fit.t(20.0),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(fit.t(4.0)),
                        bottomRight: Radius.circular(fit.t(4.0))),
                    color: Colors.white,
                  ),
                  margin: EdgeInsets.only(
                      top: fit.t(0.0), left: fit.t(10.0), right: fit.t(10.0)),
                  child: Column(
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.only(
                            left: fit.t(20.0),
                            right: fit.t(20.0),
                            top: fit.t(15.0),
                            bottom: fit.t(10.0)),
                        child: Text(
                          '${widget.title}',
                          style: TextStyle(
                              color: colorBlack,
                              fontSize: fit.t(20.0),
                              fontFamily: "Roboto",
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(
                        height: fit.t(20.0),
                      ),
                      RadioGroup(items: radioItems, onSelected: _onSelected),
                      SizedBox(
                        height: fit.t(10.0),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          GestureDetector(
                            onTap: () => Navigator.of(context).pop(),
                            child: Container(
                              margin: EdgeInsets.only(
                                  left: fit.t(24.0),
                                  right: fit.t(24.0),
                                  bottom: fit.t(10.0),
                                  top: fit.t(8.0)),
                              decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.circular(fit.t(24.0)),
                                  color: btnAppColor),
                              height: fit.t(35.0),
                              child: Center(
                                child: Container(
                                  padding: EdgeInsets.only(
                                      top: fit.t(4.0),
                                      bottom: fit.t(4.0),
                                      left: fit.t(20.0),
                                      right: fit.t(20.0)),
                                  child: Text(
                                    'Cancel',
                                    style: TextStyle(
                                        fontSize: fit.t(18.0),
                                        fontFamily: "Roboto",
                                        color: Colors.white,
                                        fontWeight: FontWeight.w800),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: isEnable
                                ? () => widget.onReportClick(selectedItem)
                                : () {},
                            child: Container(
                              margin: EdgeInsets.only(
                                  left: fit.t(24.0),
                                  right: fit.t(24.0),
                                  bottom: fit.t(10.0),
                                  top: fit.t(8.0)),
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.circular(fit.t(24.0)),
                                color: isEnable
                                    ? btnAppColor
                                    : btnAppColor.withOpacity(0.5),
                              ),
                              height: fit.t(35.0),
                              child: Center(
                                child: Container(
                                  padding: EdgeInsets.only(
                                      top: fit.t(4.0),
                                      bottom: fit.t(4.0),
                                      left: fit.t(20.0),
                                      right: fit.t(20.0)),
                                  child: Text('Report',
                                      style: TextStyle(
                                          fontSize: fit.t(20.0),
                                          fontFamily: "Roboto",
                                          color: isEnable
                                              ? Colors.white
                                              : Colors.white.withOpacity(0.5),
                                          fontWeight: FontWeight.w600)),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: fit.t(10.0),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Positioned(
              right: 0,
              top: fit.t(80.0),
              child: GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: Container(
                  height: fit.t(30.0),
                  width: fit.t(30.0),
                  child: Icon(
                    Icons.close,
                    color: appColor,
                    size: fit.t(15.0),
                  ),
                  decoration:
                      BoxDecoration(shape: BoxShape.circle, color: colorWhite),
                ),
              ),
            ),
          ],
        ));
  }

  void _onSelected(GroupItem item) {
    setState(() {
      isEnable = true;
      selectedItem = item;
    });
  }
}
