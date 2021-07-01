import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:fm_fit/fm_fit.dart';
import 'package:my_voicee/constants/app_colors.dart';
import 'package:my_voicee/constants/app_constants.dart';
import 'package:my_voicee/constants/app_images_path.dart';
import 'package:my_voicee/customWidget/Alert/top_alert.dart';
import 'package:my_voicee/customWidget/SocialMediaCustomButton.dart';
import 'package:my_voicee/customWidget/appLoader/custom_progress_loader.dart';
import 'package:my_voicee/models/CountryResponse.dart';
import 'package:my_voicee/models/DistrictAcPc.dart';
import 'package:my_voicee/models/OnlyAcPcResponse.dart';
import 'package:my_voicee/models/StateResponse.dart';
import 'package:my_voicee/models/UserResponse.dart';
import 'package:my_voicee/models/errorResponse/customeError.dart';
import 'package:my_voicee/models/errorResponse/error_reponse.dart';
import 'package:my_voicee/prelogin/login/styles.dart';
import 'package:my_voicee/prelogin/personalInfo/personalInfoBlock/UpdateInfoBloc.dart';
import 'package:my_voicee/utils/Utility.dart';

class PersonalInfoScreen extends StatefulWidget {
  @override
  _PersonalInfoScreenState createState() => _PersonalInfoScreenState();
}

class _PersonalInfoScreenState extends State<PersonalInfoScreen> {
  var _scaffoldKey = GlobalKey<ScaffoldState>();
  FmFit fit = FmFit(width: 750);
  UpdateInfoBloc _bloc;
  StreamController apiResponse;
  List<Countries> countries = List();
  List<States> states = List();
  List<District> districts = List();
  List<Assembly> assemblies = List();
  List<Parliament> parliaments = List();
  bool isAcPcAvailable = true;
  var stateId, countryId, districtId, vidhaanId, lokId;

  var _screenFocusNode = FocusNode();
  var _countryFocusNode = FocusNode();
  var _stateFocusNode = FocusNode();
  var _districtFocusNode = FocusNode();
  var _vidhaanSabhaFocusNode = FocusNode();
  var _lokSabhaFocusNode = FocusNode();

  var _countryController = TextEditingController();
  var _stateController = TextEditingController();
  var _districtController = TextEditingController();
  var _vidhaanSabhaController = TextEditingController();
  var _lokSabhaController = TextEditingController();

  var countryList = List<String>();
  var stateList = List<String>();
  var districtList = List<String>();
  var vidhaanSabhaList = List<String>();
  var lokSabhaList = List<String>();

  @override
  void initState() {
    apiResponse = StreamController();
    _bloc = UpdateInfoBloc(apiResponse);
    _bloc.getAllCountries(context);
    _subscribeToApiResponse();
    super.initState();
  }

  @override
  void dispose() {
    apiResponse?.close();
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
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      body: GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(_screenFocusNode),
        child: Stack(
          children: <Widget>[
            SingleChildScrollView(
              child: Container(
                margin: EdgeInsets.only(left: fit.t(16.0), right: fit.t(16.0)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    _widgetAppLogo(),
                    SizedBox(
                      height: fit.t(40.0),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      alignment: Alignment.centerLeft,
                      margin:
                          EdgeInsets.symmetric(horizontal: 8.0, vertical: 3.0),
                      child: Text(
                        'Fill out personal\ninformation',
                        style: Styles.textHeaderStyle,
                      ),
                    ),
                    SizedBox(
                      height: fit.t(20.0),
                    ),
                    Column(
                      children: <Widget>[
                        _countryTypeHead(),
                        SizedBox(
                          height: fit.t(10.0),
                        ),
                        _stateTypeHead(),
                        SizedBox(
                          height: fit.t(10.0),
                        ),
                        _districtTypeHead(),
                        SizedBox(
                          height: fit.t(10.0),
                        ),
                        isAcPcAvailable ? _vidhaanSabhaTypeHead() : Container(),
                        SizedBox(
                          height: isAcPcAvailable ? fit.t(10.0) : fit.t(0),
                        ),
                        isAcPcAvailable ? _lokSabhaTypeHead() : Container(),
                        SizedBox(
                          height: isAcPcAvailable ? fit.t(10.0) : fit.t(0),
                        ),
                      ],
                    ),
                    Container(
                      margin: EdgeInsets.only(bottom: fit.t(30.0)),
                      child: SocialMediaCustomButton(
                        btnText: 'Save & Proceed',
                        buttonColor: colorAcceptBtn,
                        onPressed: _onSave,
                        size: 18.0,
                        splashColor: colorAcceptBtnSplash,
                        textColor: colorWhite,
                      ),
                    ),
                  ],
                ),
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

  //App Logo widget
  Widget _widgetAppLogo() {
    return Center(
      child: Container(
        padding: EdgeInsets.only(top: fit.t(70.0)),
        child: Image.asset(
          logo_blue,
          width: MediaQuery.of(context).size.width,
          height: fit.t(150.0),
          alignment: Alignment.center,
        ),
      ),
    );
  }

  void _onSave() {
    if (countryId != null) {
      if (countryId.toString().isNotEmpty) {
        if (stateId != null) {
          if (stateId.toString().isNotEmpty) {
            if (districtId != null) {
              if (districtId.toString().isNotEmpty) {
                Map<String, dynamic> map = Map();
                map.putIfAbsent('state_id', () => stateId);
                map.putIfAbsent('country_id', () => countryId);
                map.putIfAbsent('district_id', () => districtId);
                if (isAcPcAvailable) {
                  if (vidhaanId != null) {
                    if (vidhaanId.toString().isNotEmpty) {
                      map.putIfAbsent('ac_id', () => vidhaanId);
                    }
                  }
                  if (lokId != null) {
                    if (lokId.toString().isNotEmpty) {
                      map.putIfAbsent('pc_id', () => lokId);
                    }
                  }
                }
                _bloc.saveUpdateProfile(context, map);
              } else {
                TopAlert.showAlert(
                    context, "Please select district/county.", true);
              }
            } else {
              TopAlert.showAlert(
                  context, "Please select district/county.", true);
            }
          } else {
            TopAlert.showAlert(context, "Please select state/province.", true);
          }
        } else {
          TopAlert.showAlert(context, "Please select state/province.", true);
        }
      } else {
        TopAlert.showAlert(context, "Please select country.", true);
      }
    } else {
      TopAlert.showAlert(context, "Please select country.", true);
    }
  }

  Widget _countryTypeHead() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 3.0),
          child: Text(
            'Select your Country',
            style: Styles.textStyleLabelTypeHead,
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: borderBackgroundColor,
            border: Border.all(
              color: borderBackgroundColor,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(5.0),
          ),
          margin: EdgeInsets.symmetric(horizontal: 8.0),
          child: TypeAheadField(
            textFieldConfiguration: TextFieldConfiguration(
              keyboardType: TextInputType.text,
              cursorColor: colorGrey,
              controller: _countryController,
              keyboardAppearance: Brightness.light,
              style: Styles.inputHintStyle,
              maxLines: 1,
              textInputAction: TextInputAction.next,
              focusNode: _countryFocusNode,
              onEditingComplete: () =>
                  FocusScope.of(context).requestFocus(_stateFocusNode),
              decoration: InputDecoration(
                hintText: '',
                labelText: '',
                suffixIcon: Image.asset(
                  arrow_down_blue,
                  scale: 1.1,
                ),
                contentPadding: const EdgeInsets.symmetric(
                    vertical: 15.0, horizontal: 20.0),
                hintStyle: TextStyle(color: Color(0xFF262628)),
                labelStyle: TextStyle(color: Color(0xFF262628)),
                alignLabelWithHint: true,
                fillColor: borderBackgroundColor,
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(0.0)),
                    borderSide: BorderSide(color: borderBackgroundColor)),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(0.0)),
                    borderSide: BorderSide(color: borderBackgroundColor)),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(0.0)),
                    borderSide: BorderSide(color: borderBackgroundColor)),
              ),
            ),
            onSuggestionSelected: (suggestion) {
              var text = suggestion;
              _countryController.text = text.toString().replaceAll("\n", " ");
              Countries country =
                  countries.firstWhere((element) => suggestion == element.name);
              isAcPcAvailable = country.is_ac_pc_avail;
              countryId = country.id;
              _bloc.getAllStatesInCountry(context, country.id);
              _stateController.text = "";
              stateId = "";
              _districtController.text = "";
              districtId = "";
              _vidhaanSabhaController.text = "";
              vidhaanId = "";
              _lokSabhaController.text = "";
              lokId = "";
            },
            transitionBuilder: (context, suggestionsBox, controller) {
              return suggestionsBox;
            },
            suggestionsCallback: (pattern) {
              List<String> data = List<String>();
              for (var i = 0; i < countryList.length; i++) {
                if (countryList[i] != null) if (countryList[i]
                    .toLowerCase()
                    .contains(pattern.toLowerCase())) {
                  data.add(countryList[i]);
                }
              }
              return data;
            },
            itemBuilder: (BuildContext context, suggestion) {
              return ListTile(
                title: Text(
                  suggestion,
                  textAlign: TextAlign.start,
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _stateTypeHead() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 3.0),
          child: Text(
            'State/Province',
            style: Styles.textStyleLabelTypeHead,
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: borderBackgroundColor,
            border: Border.all(
              color: borderBackgroundColor,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(5.0),
          ),
          margin: EdgeInsets.symmetric(horizontal: 8.0),
          child: TypeAheadField(
            textFieldConfiguration: TextFieldConfiguration(
              keyboardType: TextInputType.text,
              cursorColor: colorGrey,
              controller: _stateController,
              maxLines: 1,
              keyboardAppearance: Brightness.light,
              style: Styles.inputHintStyle,
              textInputAction: TextInputAction.next,
              focusNode: _stateFocusNode,
              onEditingComplete: () =>
                  FocusScope.of(context).requestFocus(_districtFocusNode),
              decoration: InputDecoration(
                hintText: '',
                labelText: '',
                suffixIcon: Image.asset(
                  arrow_down_blue,
                  scale: 1.1,
                ),
                contentPadding: const EdgeInsets.symmetric(
                    vertical: 15.0, horizontal: 20.0),
                hintStyle: TextStyle(color: Color(0xFF262628)),
                labelStyle: TextStyle(color: Color(0xFF262628)),
                alignLabelWithHint: true,
                fillColor: borderBackgroundColor,
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(0.0)),
                    borderSide: BorderSide(color: borderBackgroundColor)),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(0.0)),
                    borderSide: BorderSide(color: borderBackgroundColor)),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(0.0)),
                    borderSide: BorderSide(color: borderBackgroundColor)),
              ),
            ),
            onSuggestionSelected: (suggestion) {
              var text = suggestion;
              _stateController.text = text.toString().replaceAll("\n", " ");
              States country =
                  states.firstWhere((element) => suggestion == element.name);
              stateId = country.id;
              _bloc.getAllDistrictAcPc(context, country.id);
              _districtController.text = "";
              districtId = "";
              _vidhaanSabhaController.text = "";
              vidhaanId = "";
              _lokSabhaController.text = "";
              lokId = "";
            },
            transitionBuilder: (context, suggestionsBox, controller) {
              return suggestionsBox;
            },
            suggestionsCallback: (pattern) {
              List<String> data = List<String>();
              for (var i = 0; i < stateList.length; i++) {
                if (stateList[i] != null) if (stateList[i]
                    .toLowerCase()
                    .contains(pattern.toLowerCase())) {
                  data.add(stateList[i]);
                }
              }
              return data;
            },
            itemBuilder: (BuildContext context, suggestion) {
              return ListTile(
                title: Text(
                  suggestion,
                  textAlign: TextAlign.start,
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _districtTypeHead() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 3.0),
          child: Text(
            'District/County',
            style: Styles.textStyleLabelTypeHead,
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: borderBackgroundColor,
            border: Border.all(
              color: borderBackgroundColor,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(5.0),
          ),
          margin: EdgeInsets.symmetric(horizontal: 8.0),
          child: TypeAheadField(
            textFieldConfiguration: TextFieldConfiguration(
              keyboardType: TextInputType.text,
              cursorColor: colorGrey,
              controller: _districtController,
              keyboardAppearance: Brightness.light,
              style: Styles.inputHintStyle,
              textInputAction: TextInputAction.next,
              focusNode: _districtFocusNode,
              maxLines: 1,
              onEditingComplete: () =>
                  FocusScope.of(context).requestFocus(_vidhaanSabhaFocusNode),
              decoration: InputDecoration(
                hintText: '',
                labelText: '',
                suffixIcon: Image.asset(
                  arrow_down_blue,
                  scale: 1.1,
                ),
                contentPadding: const EdgeInsets.symmetric(
                    vertical: 15.0, horizontal: 20.0),
                hintStyle: TextStyle(color: Color(0xFF262628)),
                labelStyle: TextStyle(color: Color(0xFF262628)),
                alignLabelWithHint: true,
                fillColor: borderBackgroundColor,
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(0.0)),
                    borderSide: BorderSide(color: borderBackgroundColor)),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(0.0)),
                    borderSide: BorderSide(color: borderBackgroundColor)),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(0.0)),
                    borderSide: BorderSide(color: borderBackgroundColor)),
              ),
            ),
            onSuggestionSelected: (suggestion) {
              var text = suggestion;
              _districtController.text = text.toString().replaceAll("\n", " ");
              District country =
                  districts.firstWhere((element) => suggestion == element.name);
              districtId = country.id;
              _bloc.getOnlyAcPC(context, country.id);
              _vidhaanSabhaController.text = "";
              vidhaanId = "";
              _lokSabhaController.text = "";
              lokId = "";
            },
            transitionBuilder: (context, suggestionsBox, controller) {
              return suggestionsBox;
            },
            suggestionsCallback: (pattern) {
              List<String> data = List<String>();
              for (var i = 0; i < districtList.length; i++) {
                if (districtList[i] != null) {
                  if (districtList[i]
                      .toLowerCase()
                      .contains(pattern.toLowerCase())) {
                    data.add(districtList[i]);
                  }
                }
              }
              return data;
            },
            itemBuilder: (BuildContext context, suggestion) {
              return ListTile(
                title: Text(
                  suggestion,
                  textAlign: TextAlign.start,
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _vidhaanSabhaTypeHead() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 3.0),
          child: Text(
            'Vidhan Sabha Constituency',
            style: Styles.textStyleLabelTypeHead,
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: borderBackgroundColor,
            border: Border.all(
              color: borderBackgroundColor,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(5.0),
          ),
          margin: EdgeInsets.symmetric(horizontal: 8.0),
          child: TypeAheadField(
            textFieldConfiguration: TextFieldConfiguration(
              keyboardType: TextInputType.text,
              cursorColor: colorGrey,
              controller: _vidhaanSabhaController,
              keyboardAppearance: Brightness.light,
              style: Styles.inputHintStyle,
              textInputAction: TextInputAction.next,
              focusNode: _vidhaanSabhaFocusNode,
              onEditingComplete: () =>
                  FocusScope.of(context).requestFocus(_lokSabhaFocusNode),
              maxLines: 1,
              decoration: InputDecoration(
                hintText: '',
                labelText: '',
                suffixIcon: Image.asset(
                  arrow_down_blue,
                  scale: 1.1,
                ),
                contentPadding: const EdgeInsets.symmetric(
                    vertical: 15.0, horizontal: 20.0),
                hintStyle: TextStyle(color: Color(0xFF262628)),
                labelStyle: TextStyle(color: Color(0xFF262628)),
                alignLabelWithHint: true,
                fillColor: borderBackgroundColor,
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(0.0)),
                    borderSide: BorderSide(color: borderBackgroundColor)),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(0.0)),
                    borderSide: BorderSide(color: borderBackgroundColor)),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(0.0)),
                    borderSide: BorderSide(color: borderBackgroundColor)),
              ),
            ),
            onSuggestionSelected: (suggestion) {
              var text = suggestion;
              _vidhaanSabhaController.text =
                  text.toString().replaceAll("\n", " ");
              Assembly country = assemblies
                  .firstWhere((element) => suggestion == element.name);
              vidhaanId = country.id;
              _lokSabhaController.text = "";
              lokId = "";
            },
            transitionBuilder: (context, suggestionsBox, controller) {
              return suggestionsBox;
            },
            suggestionsCallback: (pattern) {
              List<String> data = List<String>();
              for (var i = 0; i < vidhaanSabhaList.length; i++) {
                if (vidhaanSabhaList[i] != null) if (vidhaanSabhaList[i]
                    .toLowerCase()
                    .contains(pattern.toLowerCase())) {
                  data.add(vidhaanSabhaList[i]);
                }
              }
              return data;
            },
            itemBuilder: (BuildContext context, suggestion) {
              return ListTile(
                title: Text(
                  suggestion,
                  textAlign: TextAlign.start,
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _lokSabhaTypeHead() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 3.0),
          child: Text(
            'Lok Sabha Constituency',
            style: Styles.textStyleLabelTypeHead,
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: borderBackgroundColor,
            border: Border.all(
              color: borderBackgroundColor,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(5.0),
          ),
          margin: EdgeInsets.symmetric(horizontal: 8.0),
          child: TypeAheadField(
            textFieldConfiguration: TextFieldConfiguration(
              keyboardType: TextInputType.text,
              cursorColor: colorGrey,
              controller: _lokSabhaController,
              keyboardAppearance: Brightness.light,
              style: Styles.inputHintStyle,
              textInputAction: TextInputAction.next,
              focusNode: _lokSabhaFocusNode,
              maxLines: 1,
              onEditingComplete: () =>
                  FocusScope.of(context).requestFocus(_screenFocusNode),
              decoration: InputDecoration(
                hintText: '',
                labelText: '',
                suffixIcon: Image.asset(
                  arrow_down_blue,
                  scale: 1.1,
                ),
                contentPadding: const EdgeInsets.symmetric(
                    vertical: 15.0, horizontal: 20.0),
                hintStyle: TextStyle(color: Color(0xFF262628)),
                labelStyle: TextStyle(color: Color(0xFF262628)),
                alignLabelWithHint: true,
                fillColor: borderBackgroundColor,
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(0.0)),
                    borderSide: BorderSide(color: borderBackgroundColor)),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(0.0)),
                    borderSide: BorderSide(color: borderBackgroundColor)),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(0.0)),
                    borderSide: BorderSide(color: borderBackgroundColor)),
              ),
            ),
            onSuggestionSelected: (suggestion) {
              var text = suggestion;
              _lokSabhaController.text = text.toString().replaceAll("\n", " ");
              Parliament country = parliaments
                  .firstWhere((element) => suggestion == element.name);
              lokId = country.id;
            },
            transitionBuilder: (context, suggestionsBox, controller) {
              return suggestionsBox;
            },
            suggestionsCallback: (pattern) {
              List<String> data = List<String>();
              for (var i = 0; i < lokSabhaList.length; i++) {
                if (lokSabhaList[i] != null) if (lokSabhaList[i]
                    .toLowerCase()
                    .contains(pattern.toLowerCase())) {
                  data.add(lokSabhaList[i]);
                }
              }
              return data;
            },
            itemBuilder: (BuildContext context, suggestion) {
              return ListTile(
                title: Text(
                  suggestion,
                  textAlign: TextAlign.start,
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  //listen to api response
  void _subscribeToApiResponse() {
    StreamSubscription subscription;
    subscription = apiResponse.stream.listen((data) {
      if (data is CountryResponse) {
        countries.clear();
        countryList.clear();
        countries.addAll(data.response);
        countryList.addAll(countries.map((e) => e.name));
        writeStringDataLocally(key: countryData, value: jsonEncode(data));
        if (mounted) setState(() {});
      } else if (data is StateResponse) {
        states.clear();
        stateList.clear();
        states.addAll(data.response);
        stateList.addAll(states.map((e) => e.name));
        writeStringDataLocally(key: stateData, value: jsonEncode(data));
        if (mounted) setState(() {});
      } else if (data is DistrictAcPc) {
        districts.clear();
        districtList.clear();
        districts.addAll(data.response.districts);
        if (districts.length > 0)
          districtList.addAll(districts.map((e) => e.name));

        writeStringDataLocally(key: distictAcPcData, value: jsonEncode(data));
        if (mounted) setState(() {});
      } else if (data is OnlyAcPcResponse) {
        vidhaanSabhaList.clear();
        assemblies.clear();
        assemblies.addAll(data.response.assemblies);
        if (assemblies.length > 0)
          vidhaanSabhaList.addAll(assemblies.map((e) => e.name));
        parliaments.clear();
        lokSabhaList.clear();
        parliaments.addAll(data.response.parliaments);
        if (parliaments.length > 0)
          lokSabhaList.addAll(parliaments.map((e) => e.name));
        if (mounted) setState(() {});
      } else if (data is UserResponse) {
        if (data.response.is_approved == 1) {
          Navigator.pushNamedAndRemoveUntil(
              context, '/dashboardScreen', ModalRoute.withName('/'));
        } else {
          Navigator.pushNamedAndRemoveUntil(
              context, '/termsOfUse', ModalRoute.withName('/'));
        }
      } else if (data is ErrorResponse) {
        TopAlert.showAlert(
            _scaffoldKey.currentState.context, data.message, true);
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
        TopAlert.showAlert(
            _scaffoldKey.currentState.context, error.errorMessage, true);
      } else {
        TopAlert.showAlert(
            _scaffoldKey.currentState.context, error.toString(), true);
      }
    });
  }
}
