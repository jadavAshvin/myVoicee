import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fm_fit/fm_fit.dart';
import 'package:my_voicee/constants/app_colors.dart';
import 'package:my_voicee/constants/app_images_path.dart';
import 'package:my_voicee/customWidget/Alert/top_alert.dart';
import 'package:my_voicee/customWidget/SocialMediaCustomButton.dart';
import 'package:my_voicee/customWidget/appLoader/custom_progress_loader.dart';
import 'package:my_voicee/models/GetAllPostsResponse.dart';
import 'package:my_voicee/models/UserResponse.dart';
import 'package:my_voicee/models/commonResponse/CommonpiResponse.dart';
import 'package:my_voicee/models/errorResponse/customeError.dart';
import 'package:my_voicee/models/errorResponse/error_reponse.dart';
import 'package:my_voicee/postLogin/profile/profileBloc/ProfileBloc.dart';
import 'package:my_voicee/utils/DialogUtils.dart';
import 'package:my_voicee/utils/Utility.dart';
import 'package:my_voicee/utils/date_formatter.dart';

class EditProfileScreen extends StatefulWidget {
  final data;

  EditProfileScreen({this.data});

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  var _scaffoldKey = GlobalKey<ScaffoldState>();

  var screenFocusNode = FocusNode();

  var nameFocusNode = FocusNode();
  var bioFocusNode = FocusNode();
  var employmentFocusNode = FocusNode();
  var universityFocusNode = FocusNode();
  var concentrationFocusNode = FocusNode();
  var degreeFocusNode = FocusNode();
  var locationFocusNode = FocusNode();

  var nameController = TextEditingController();
  var bioController = TextEditingController();
  var employmentController = TextEditingController();
  var universityController = TextEditingController();
  var degreeController = TextEditingController();
  var locationController = TextEditingController();

  List<String> _dropdownItems = List();
  List<DropdownMenuItem<String>> _dropdownMenuItems;
  FmFit fit = FmFit(width: 750);
  UserData userDataBean;
  ProfileBloc _bloc;
  StreamController apiResponseData;
  StreamController apiResponse;

  var startValue = "";
  var endValue = "";
  var graduationYear = "";

  var chkPresent = false;

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
    _dropdownItems.add("-");
    for (var i = 1970; i < 2022; i++) {
      _dropdownItems.add("$i");
    }
    _dropdownMenuItems = buildDropDownMenuItems(_dropdownItems);
    userDataBean = widget.data;
    if (userDataBean.start_year != null) {
      if (userDataBean.start_year.isNotEmpty) {
        var stYear = getDateTimeStamp2(userDataBean.start_year);
        startValue = stYear;
      } else {
        startValue = _dropdownMenuItems[0].value;
      }
    } else {
      startValue = _dropdownMenuItems[0].value;
    }
    if (userDataBean.end_year != null) {
      if (userDataBean.end_year.isNotEmpty) {
        var endYear = getDateTimeStamp2(userDataBean.end_year);
        endValue = endYear;
      } else {
        endValue = _dropdownMenuItems[0].value;
      }
    } else {
      endValue = _dropdownMenuItems[0].value;
    }
    if (userDataBean.graduation_year != null) {
      if (userDataBean.graduation_year.isNotEmpty) {
        var gYear = getDateTimeStamp2(userDataBean.graduation_year);
        graduationYear = gYear;
      } else {
        graduationYear = _dropdownMenuItems[0].value;
      }
    } else {
      graduationYear = _dropdownMenuItems[0].value;
    }
    setDataUser();
    apiResponseData = StreamController<List<AllPostResponse>>.broadcast();
    apiResponse = StreamController();
    _bloc = ProfileBloc(apiResponseData, apiResponse);
    _subscribeToApiResponse();
    super.initState();
  }

  @override
  void dispose() {
    apiResponse?.close();
    apiResponseData.close();
    _bloc?.dispose();
    super.dispose();
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
      backgroundColor: Color.fromRGBO(243, 243, 243, 1),
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(243, 243, 243, 1),
        elevation: 0,
        leading: _leadingWidget(),
        centerTitle: true,
        title: _titleWidget(),
        actions: <Widget>[trailingWidget()],
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(screenFocusNode),
        child: Stack(
          children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              decoration: new BoxDecoration(
                  color: Colors.white,
                  borderRadius: new BorderRadius.all(
                    const Radius.circular(10.0),
                  )),
              margin: EdgeInsets.only(
                  top: fit.t(16.0), left: fit.t(16.0), right: fit.t(16.0)),
              child: ListView(
                physics: BouncingScrollPhysics(),
                children: <Widget>[
                  SizedBox(
                    height: fit.t(10.0),
                  ),
                  Container(
                    margin:
                        EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
                    child: Text(
                      'Fill out personal information',
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.w600,
                          color: colorBlack,
                          fontSize: fit.t(22.0)),
                    ),
                  ),
                  SizedBox(
                    height: fit.t(10.0),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.symmetric(
                            horizontal: 12.0, vertical: 3.0),
                        child: Text(
                          'Name',
                          style: TextStyle(
                            color: colorBlack.withOpacity(0.4),
                            fontSize: 14.0,
                            fontFamily: "Roboto",
                          ),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: Color.fromRGBO(243, 243, 243, 1),
                          border: Border.all(
                            color: Color.fromRGBO(243, 243, 243, 1),
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        margin: EdgeInsets.symmetric(horizontal: 12.0),
                        child: TextField(
                          keyboardType: TextInputType.text,
                          cursorColor: colorGrey,
                          controller: nameController,
                          keyboardAppearance: Brightness.light,
                          enabled: false,
                          style: TextStyle(
                            color: Color(0xFF262628),
                            fontFamily: "Roboto",
                            fontSize: 18.0,
                          ),
                          textInputAction: TextInputAction.next,
                          focusNode: nameFocusNode,
                          onEditingComplete: () =>
                              FocusScope.of(context).requestFocus(bioFocusNode),
                          decoration: InputDecoration(
                            hintText: '',
                            labelText: '',
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 15.0, horizontal: 20.0),
                            hintStyle: TextStyle(color: Color(0xFF262628)),
                            labelStyle: TextStyle(color: Color(0xFF262628)),
                            alignLabelWithHint: true,
                            fillColor: Color.fromRGBO(243, 243, 243, 1),
                            enabledBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(0.0)),
                                borderSide: BorderSide(
                                    color: Color.fromRGBO(243, 243, 243, 1))),
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(0.0)),
                                borderSide: BorderSide(
                                    color: Color.fromRGBO(243, 243, 243, 1))),
                            focusedBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(0.0)),
                                borderSide: BorderSide(
                                    color: Color.fromRGBO(243, 243, 243, 1))),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: fit.t(10.0),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.symmetric(
                            horizontal: 12.0, vertical: 3.0),
                        child: Text(
                          'Bio',
                          style: TextStyle(
                            color: colorBlack.withOpacity(0.4),
                            fontSize: 14.0,
                            fontFamily: "Roboto",
                          ),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: Color.fromRGBO(243, 243, 243, 1),
                          border: Border.all(
                            color: Color.fromRGBO(243, 243, 243, 1),
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        margin: EdgeInsets.symmetric(horizontal: 12.0),
                        child: TextField(
                          keyboardType: TextInputType.text,
                          cursorColor: colorGrey,
                          controller: bioController,
                          keyboardAppearance: Brightness.light,
                          style: TextStyle(
                            color: Color(0xFF262628),
                            fontFamily: "Roboto",
                            fontSize: 18.0,
                          ),
                          textInputAction: TextInputAction.next,
                          focusNode: bioFocusNode,
                          maxLines: 3,
                          maxLength: 255,
                          onEditingComplete: () => FocusScope.of(context)
                              .requestFocus(employmentFocusNode),
                          decoration: InputDecoration(
                            hintText: '',
                            labelText: '',
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 15.0, horizontal: 20.0),
                            hintStyle: TextStyle(color: Color(0xFF262628)),
                            labelStyle: TextStyle(color: Color(0xFF262628)),
                            alignLabelWithHint: true,
                            fillColor: Color.fromRGBO(243, 243, 243, 1),
                            enabledBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(0.0)),
                                borderSide: BorderSide(
                                    color: Color.fromRGBO(243, 243, 243, 1))),
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(0.0)),
                                borderSide: BorderSide(
                                    color: Color.fromRGBO(243, 243, 243, 1))),
                            focusedBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(0.0)),
                                borderSide: BorderSide(
                                    color: Color.fromRGBO(243, 243, 243, 1))),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: fit.t(10.0),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.symmetric(
                            horizontal: 12.0, vertical: 3.0),
                        child: Text(
                          'Employment',
                          style: TextStyle(
                            color: colorBlack.withOpacity(0.4),
                            fontSize: 14.0,
                            fontFamily: "Roboto",
                          ),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: Color.fromRGBO(243, 243, 243, 1),
                          border: Border.all(
                            color: Color.fromRGBO(243, 243, 243, 1),
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        margin: EdgeInsets.symmetric(horizontal: 12.0),
                        child: TextField(
                          keyboardType: TextInputType.text,
                          cursorColor: colorGrey,
                          controller: employmentController,
                          keyboardAppearance: Brightness.light,
                          style: TextStyle(
                            color: Color(0xFF262628),
                            fontFamily: "Roboto",
                            fontSize: 18.0,
                          ),
                          textInputAction: TextInputAction.next,
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(25),
                          ],
                          focusNode: employmentFocusNode,
                          onEditingComplete: () => FocusScope.of(context)
                              .requestFocus(screenFocusNode),
                          decoration: InputDecoration(
                            hintText: '',
                            labelText: '',
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 15.0, horizontal: 20.0),
                            hintStyle: TextStyle(color: Color(0xFF262628)),
                            labelStyle: TextStyle(color: Color(0xFF262628)),
                            alignLabelWithHint: true,
                            fillColor: Color.fromRGBO(243, 243, 243, 1),
                            enabledBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(0.0)),
                                borderSide: BorderSide(
                                    color: Color.fromRGBO(243, 243, 243, 1))),
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(0.0)),
                                borderSide: BorderSide(
                                    color: Color.fromRGBO(243, 243, 243, 1))),
                            focusedBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(0.0)),
                                borderSide: BorderSide(
                                    color: Color.fromRGBO(243, 243, 243, 1))),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: fit.t(10.0),
                  ),
                  Container(
                    height: fit.t(80.0),
                    width: MediaQuery.of(context).size.width,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              margin: EdgeInsets.symmetric(
                                  horizontal: 0.0, vertical: 3.0),
                              child: Text(
                                'Start Year',
                                style: TextStyle(
                                  color: colorBlack.withOpacity(0.4),
                                  fontSize: 14.0,
                                  fontFamily: "Roboto",
                                ),
                              ),
                            ),
                            Column(
                              children: <Widget>[
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width / 2.5,
                                  padding: EdgeInsets.only(
                                      left: fit.t(8.0), right: fit.t(8.0)),
                                  decoration: BoxDecoration(
                                    color: Color.fromRGBO(243, 243, 243, 1),
                                    border: Border.all(
                                      color: Color.fromRGBO(243, 243, 243, 1),
                                      width: 1,
                                    ),
                                    borderRadius: BorderRadius.circular(5.0),
                                  ),
                                  child: DropdownButton<String>(
                                    isExpanded: true,
                                    style: TextStyle(
                                      color: Color.fromRGBO(0, 0, 0, 1),
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
                                    value: startValue,
                                    items: _dropdownMenuItems,
                                    onChanged: (value) {
                                      setState(() {
                                        startValue = value;
                                      });
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              margin: EdgeInsets.symmetric(
                                  horizontal: 0.0, vertical: 3.0),
                              child: Text(
                                'End Year',
                                style: TextStyle(
                                  color: colorBlack.withOpacity(0.4),
                                  fontSize: 14.0,
                                  fontFamily: "Roboto",
                                ),
                              ),
                            ),
                            Column(
                              children: <Widget>[
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width / 2.5,
                                  padding: EdgeInsets.only(
                                      left: fit.t(8.0), right: fit.t(8.0)),
                                  decoration: BoxDecoration(
                                    color: Color.fromRGBO(243, 243, 243, 1),
                                    border: Border.all(
                                      color: Color.fromRGBO(243, 243, 243, 1),
                                      width: 1,
                                    ),
                                    borderRadius: BorderRadius.circular(5.0),
                                  ),
                                  child: DropdownButton<String>(
                                    isExpanded: true,
                                    style: TextStyle(
                                      color: Color.fromRGBO(0, 0, 0, 1),
                                      fontSize: 18.0,
                                      fontFamily: "Roboto",
                                    ),
                                    icon: RotatedBox(
                                        quarterTurns: 45,
                                        child: Image.asset(
                                          ic_bread_arrow,
                                          scale: 2.0,
                                          color: appColor,
                                        )),
                                    underline: Container(),
                                    value: endValue,
                                    items: _dropdownMenuItems,
                                    onChanged: (value) {
                                      setState(() {
                                        endValue = value;
                                      });
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: fit.t(10.0)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: fit.t(10.0)),
                          width: MediaQuery.of(context).size.width / 2.8,
                        ),
                        SizedBox(
                          height: 30,
                          width: 30,
                          child: Checkbox(
                            value: chkPresent,
                            onChanged: (bool value) {
                              chkPresent = value;
                              setState(() {});
                            },
                          ),
                        ),
                        Expanded(
                          child: RichText(
                            softWrap: true,
                            textAlign: TextAlign.start,
                            text: TextSpan(
                              text: 'I currently work here',
                              style: TextStyle(
                                fontFamily: 'Roboto',
                                color: colorBlack.withOpacity(0.4),
                                decoration: TextDecoration.none,
                                fontSize: fit.t(14.0),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: fit.t(10.0),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.symmetric(
                            horizontal: 12.0, vertical: 3.0),
                        child: Text(
                          'School/University',
                          style: TextStyle(
                            color: colorBlack.withOpacity(0.4),
                            fontSize: 14.0,
                            fontFamily: "Roboto",
                          ),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: Color.fromRGBO(243, 243, 243, 1),
                          border: Border.all(
                            color: Color.fromRGBO(243, 243, 243, 1),
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        margin: EdgeInsets.symmetric(horizontal: 12.0),
                        child: TextField(
                          keyboardType: TextInputType.text,
                          cursorColor: colorGrey,
                          controller: universityController,
                          keyboardAppearance: Brightness.light,
                          style: TextStyle(
                            color: Color(0xFF262628),
                            fontFamily: "Roboto",
                            fontSize: 18.0,
                          ),
                          textInputAction: TextInputAction.next,
                          focusNode: universityFocusNode,
                          onEditingComplete: () => FocusScope.of(context)
                              .requestFocus(concentrationFocusNode),
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(25),
                          ],
                          decoration: InputDecoration(
                            hintText: '',
                            labelText: '',
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 15.0, horizontal: 20.0),
                            hintStyle: TextStyle(color: Color(0xFF262628)),
                            labelStyle: TextStyle(color: Color(0xFF262628)),
                            alignLabelWithHint: true,
                            fillColor: Color.fromRGBO(243, 243, 243, 1),
                            enabledBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(0.0)),
                                borderSide: BorderSide(
                                    color: Color.fromRGBO(243, 243, 243, 1))),
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(0.0)),
                                borderSide: BorderSide(
                                    color: Color.fromRGBO(243, 243, 243, 1))),
                            focusedBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(0.0)),
                                borderSide: BorderSide(
                                    color: Color.fromRGBO(243, 243, 243, 1))),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: fit.t(10.0),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.symmetric(
                            horizontal: 12.0, vertical: 3.0),
                        child: Text(
                          'Degree Type (B.A., M.S., Ph.D.)',
                          style: TextStyle(
                            color: colorBlack.withOpacity(0.4),
                            fontSize: 14.0,
                            fontFamily: "Roboto",
                          ),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: Color.fromRGBO(243, 243, 243, 1),
                          border: Border.all(
                            color: Color.fromRGBO(243, 243, 243, 1),
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        margin: EdgeInsets.symmetric(horizontal: 12.0),
                        child: TextField(
                          keyboardType: TextInputType.text,
                          cursorColor: colorGrey,
                          controller: degreeController,
                          keyboardAppearance: Brightness.light,
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(25),
                          ],
                          style: TextStyle(
                            color: Color(0xFF262628),
                            fontFamily: "Roboto",
                            fontSize: 18.0,
                          ),
                          textInputAction: TextInputAction.next,
                          focusNode: degreeFocusNode,
                          onEditingComplete: () => FocusScope.of(context)
                              .requestFocus(screenFocusNode),
                          decoration: InputDecoration(
                            hintText: '',
                            labelText: '',
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 15.0, horizontal: 20.0),
                            hintStyle: TextStyle(color: Color(0xFF262628)),
                            labelStyle: TextStyle(color: Color(0xFF262628)),
                            alignLabelWithHint: true,
                            fillColor: Color.fromRGBO(243, 243, 243, 1),
                            enabledBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(0.0)),
                                borderSide: BorderSide(
                                    color: Color.fromRGBO(243, 243, 243, 1))),
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(0.0)),
                                borderSide: BorderSide(
                                    color: Color.fromRGBO(243, 243, 243, 1))),
                            focusedBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(0.0)),
                                borderSide: BorderSide(
                                    color: Color.fromRGBO(243, 243, 243, 1))),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: fit.t(10.0),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.symmetric(
                            horizontal: 12.0, vertical: 3.0),
                        child: Text(
                          'Graduation Year',
                          style: TextStyle(
                            color: colorBlack.withOpacity(0.4),
                            fontSize: 14.0,
                            fontFamily: "Roboto",
                          ),
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        margin: EdgeInsets.only(
                            left: fit.t(8.0), right: fit.t(8.0)),
                        padding: EdgeInsets.only(
                            left: fit.t(8.0), right: fit.t(8.0)),
                        decoration: BoxDecoration(
                          color: Color.fromRGBO(243, 243, 243, 1),
                          border: Border.all(
                            color: Color.fromRGBO(243, 243, 243, 1),
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        child: DropdownButton<String>(
                          isExpanded: true,
                          style: TextStyle(
                            color: Color.fromRGBO(0, 0, 0, 1),
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
                          value: graduationYear,
                          items: _dropdownMenuItems,
                          onChanged: (value) {
                            setState(() {
                              graduationYear = value;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: fit.t(10.0),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.symmetric(
                            horizontal: 12.0, vertical: 3.0),
                        child: Text(
                          'Location',
                          style: TextStyle(
                            color: colorBlack.withOpacity(0.4),
                            fontSize: 14.0,
                            fontFamily: "Roboto",
                          ),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: Color.fromRGBO(243, 243, 243, 1),
                          border: Border.all(
                            color: Color.fromRGBO(243, 243, 243, 1),
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        margin: EdgeInsets.symmetric(horizontal: 12.0),
                        child: TextField(
                          keyboardType: TextInputType.text,
                          cursorColor: colorGrey,
                          controller: locationController,
                          keyboardAppearance: Brightness.light,
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(30),
                          ],
                          style: TextStyle(
                            color: Color(0xFF262628),
                            fontFamily: "Roboto",
                            fontSize: 18.0,
                          ),
                          textInputAction: TextInputAction.next,
                          focusNode: locationFocusNode,
                          onEditingComplete: () => FocusScope.of(context)
                              .requestFocus(screenFocusNode),
                          decoration: InputDecoration(
                            hintText: '',
                            labelText: '',
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 15.0, horizontal: 20.0),
                            hintStyle: TextStyle(color: Color(0xFF262628)),
                            labelStyle: TextStyle(color: Color(0xFF262628)),
                            alignLabelWithHint: true,
                            fillColor: Color.fromRGBO(243, 243, 243, 1),
                            enabledBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(0.0)),
                                borderSide: BorderSide(
                                    color: Color.fromRGBO(243, 243, 243, 1))),
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(0.0)),
                                borderSide: BorderSide(
                                    color: Color.fromRGBO(243, 243, 243, 1))),
                            focusedBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(0.0)),
                                borderSide: BorderSide(
                                    color: Color.fromRGBO(243, 243, 243, 1))),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: fit.t(20.0),
                  ),
                  Container(
                    margin:
                        EdgeInsets.symmetric(horizontal: 14.0, vertical: 0.0),
                    child: SocialMediaCustomButton(
                      btnText: 'Save',
                      buttonColor: colorAcceptBtn,
                      onPressed: _onSubmitProfile,
                      size: 16.0,
                      splashColor: colorAcceptBtnSplash,
                      textColor: colorWhite,
                    ),
                  ),
                  SizedBox(
                    height: fit.t(20.0),
                  ),
                  Container(
                    margin:
                        EdgeInsets.symmetric(horizontal: 80.0, vertical: 10.0),
                    child: SocialMediaCustomButton(
                      btnText: 'Logout',
                      buttonColor: colorAcceptBtn,
                      onPressed: logout,
                      size: 16.0,
                      splashColor: colorAcceptBtnSplash,
                      textColor: colorWhite,
                    ),
                  ),
                  SizedBox(
                    height: fit.t(20.0),
                  ),
                ],
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

  void logout() {
    DialogUtils.showCustomDialog(context,
        fit: fit,
        okBtnText: 'Yes',
        cancelBtnText: "No",
        title: '',
        content: "Are you sure you want to logout?",
        okBtnFunction: _onLogout);
  }

  void _onLogout() {
    clearDataLocally();
    Navigator.pushNamedAndRemoveUntil(
        context, '/login', ModalRoute.withName('/'));
  }

  Widget _titleWidget() {
    return Container(
      child: Padding(
        padding: EdgeInsets.only(
            top: fit.t(8.0), left: fit.t(8.0), right: fit.t(8.0)),
        child: Container(
          child: InkWell(
            onTap: () {
              clearDataLocally();
              Navigator.pushNamedAndRemoveUntil(
                  context, '/login', ModalRoute.withName('/'));
            },
            child: Text(
              'Edit Profile',
              style: TextStyle(
                fontFamily: 'Roboto',
                fontSize: fit.t(20.0),
                color: Colors.black,
              ),
            ),
          ),
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

  void _subscribeToApiResponse() {
    StreamSubscription subscription;
    subscription = apiResponse.stream.listen((data) {
      if (data is UserResponse) {
        Navigator.of(context).pop(true);
        TopAlert.showAlert(context, data.message, false);
      } else if (data is CommonApiReponse) {
        TopAlert.showAlert(context, data.message, false);
      } else if (data is ErrorResponse) {
        TopAlert.showAlert(context, data.message, true);
      } else if (data is CustomError) {
        if (data.errorMessage == 'Check your internet connection.') {
          pushNamedIfNotCurrent(context, '/noInternet');
        } else {
          TopAlert.showAlert(
              _scaffoldKey.currentState.context, data.errorMessage, true);
        }
      } else if (data is Exception) {
        TopAlert.showAlert(_scaffoldKey.currentState.context,
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

  void _onSubmitProfile() {
    Map<String, dynamic> map = Map();
    map.putIfAbsent("bio", () => bioController.text.toString().trim());
    map.putIfAbsent(
        "employment", () => employmentController.text.toString().trim());
    map.putIfAbsent(
        "school_university", () => universityController.text.toString().trim());
    map.putIfAbsent("concentration", () => "");
    map.putIfAbsent(
        "location", () => locationController.text.toString().trim());
    map.putIfAbsent(
        "degree_type", () => degreeController.text.toString().trim());
    if (graduationYear.isNotEmpty && graduationYear != "-")
      map.putIfAbsent(
          "graduation_year", () => "$graduationYear-01-01T00:00:00.000Z");
    if (startValue.isNotEmpty && startValue != "-")
      map.putIfAbsent("start_year", () => "$startValue-01-01T00:00:00.000Z");
    if (endValue.isNotEmpty && endValue != "-")
      map.putIfAbsent("end_year", () => "$endValue-01-01T00:00:00.000Z");
    map.putIfAbsent("is_working", () => chkPresent);

    _bloc.saveUpdateProfile(context, map);
  }

  void setDataUser() {
    nameController.text = userDataBean?.name;
    bioController.text = userDataBean?.bio;
    employmentController.text = userDataBean?.employment;
    universityController.text = userDataBean?.school_university;
    degreeController.text = userDataBean?.degree_type;
    locationController.text = userDataBean?.location;
    if (userDataBean?.is_working != null) {
      chkPresent = userDataBean.is_working;
    }
  }
}
