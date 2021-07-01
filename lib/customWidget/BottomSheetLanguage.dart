import 'package:flutter/material.dart';
import 'package:fm_fit/fm_fit.dart';
import 'package:my_voicee/constants/app_colors.dart';
import 'package:my_voicee/constants/app_images_path.dart';
import 'package:my_voicee/customWidget/SocialMediaCustomButton.dart';

class BottomSheetLanguage extends StatefulWidget {
  final Function(String) callBack;

  BottomSheetLanguage({this.callBack});

  @override
  _BottomSheetLanguageState createState() => _BottomSheetLanguageState();
}

class _BottomSheetLanguageState extends State<BottomSheetLanguage> {
  var _scaffoldKey = GlobalKey<ScaffoldState>();
  FmFit fit = FmFit(width: 750);
  List<String> _dropdownItems = [
    'Aasamese',
    'Arabic',
    'Bengali',
    'English ( India )',
    'English ( USA )',
    'French',
    'German',
    'Gujrati',
    'Hindi',
    'Japanese',
    'Kannada',
    'Malaylam',
    'Mandarin Chinese',
    'Marathi',
    'Odiya',
    'Portuguese',
    'Russian',
    'Spanish',
    'Tamil',
    'Telegu'
  ];

  List<DropdownMenuItem<String>> _dropdownMenuItems;

  var selectedValue = "";

  List<DropdownMenuItem<String>> buildDropDownMenuItems(List listItems) {
    List<DropdownMenuItem<String>> items = List();
    for (String listItem in listItems) {
      items.add(
        DropdownMenuItem(
          child: Text(listItem),
          value: listItem,
        ),
      );
    }
    return items;
  }

  @override
  void initState() {
    _dropdownMenuItems = buildDropDownMenuItems(_dropdownItems);
    selectedValue = _dropdownMenuItems[0].value;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    fit = FmFit(width: MediaQuery.of(context).size.width);
    if (MediaQuery.of(context).size.width > 600) {
      fit.scale = 1.0 + MediaQuery.of(context).size.aspectRatio;
    } else {
      fit.scale = MediaQuery.of(context).size.aspectRatio;
    }
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.transparent,
      body: Container(
        height: MediaQuery.of(context).size.height,
        decoration: new BoxDecoration(
            color: Colors.white,
            borderRadius: new BorderRadius.only(
                topLeft: const Radius.circular(20.0),
                topRight: const Radius.circular(20.0))),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
                margin: EdgeInsets.only(
                    top: fit.t(60.0), bottom: fit.t(8.0), left: fit.t(50.0)),
                width: MediaQuery.of(context).size.width - 20,
                child: Text(
                  'Which language you want to post?',
                  textAlign: TextAlign.start,
                  style: TextStyle(
                      fontSize: 18.0,
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w500),
                )),
            Container(
              margin: EdgeInsets.only(
                  top: fit.t(40.0), bottom: fit.t(8.0), left: fit.t(50.0)),
              child: Text(
                'Select your language',
                textAlign: TextAlign.start,
                style: TextStyle(
                  color: Color.fromRGBO(0, 0, 0, 0.4),
                  fontSize: 14.0,
                  fontFamily: "Roboto",
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.only(left: fit.t(8.0)),
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(209, 209, 209, 0.14),
                    border: Border.all(
                      color: Color.fromRGBO(209, 209, 209, 0.14),
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  margin: EdgeInsets.symmetric(
                      horizontal: fit.t(50.0), vertical: fit.t(0.0)),
                  child: DropdownButton<String>(
                    isExpanded: true,
                    style: TextStyle(
                      color: Color.fromRGBO(38, 38, 49, 0.6),
                      fontSize: 18.0,
                      fontFamily: "Roboto",
                    ),
                    underline: Container(),
                    icon: RotatedBox(
                        quarterTurns: 45,
                        child: Image.asset(
                          ic_bread_arrow,
                          scale: 2.0,
                          color: appColor,
                        )),
                    value: selectedValue,
                    items: _dropdownMenuItems,
                    onChanged: (value) {
                      setState(() {
                        selectedValue = value;
                      });
                    },
                  ),
                ),
              ],
            ),
            Container(
              margin: EdgeInsets.only(
                  top: fit.t(60.0),
                  bottom: fit.t(8.0),
                  left: fit.t(50.0),
                  right: fit.t(50.0)),
              child: SocialMediaCustomButton(
                btnText: 'GO',
                buttonColor: Color.fromRGBO(18, 51, 145, 1),
                onPressed: () => widget.callBack(selectedValue),
                size: 14.0,
                splashColor: Color.fromRGBO(18, 51, 145, 1),
                textColor: Colors.white,
              ),
            ),
            SizedBox(
              height: fit.t(20.0),
            ),
          ],
        ),
      ),
    );
  }
}
