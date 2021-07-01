import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fm_fit/fm_fit.dart';
import 'package:my_voicee/constants/app_colors.dart';
import 'package:my_voicee/customWidget/gradient_app_bar.dart';
import 'package:my_voicee/models/StateResponse.dart';
import 'package:my_voicee/style/theme.dart';

class SearchState extends StatefulWidget {
  final List<States> countryList;

  SearchState(this.countryList);

  @override
  SearchStateState createState() => SearchStateState();
}

class SearchStateState extends State<SearchState> {
  String query = '';
  var _inputController = TextEditingController();
  List<States> countryList = List<States>();
  List<States> dummyListData = List<States>();
  var _blankFocusNode = FocusNode();
  FmFit fit = FmFit(width: 750);

  @override
  Widget build(BuildContext context) {
    fit = FmFit(width: MediaQuery.of(context).size.width);
    if (MediaQuery.of(context).size.width > 600) {
      fit.scale = 1.0 + MediaQuery.of(context).size.aspectRatio;
    } else {
      fit.scale = 1.0;
    }
    return Scaffold(
      appBar: _gradientAppBarWidget(),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: fit.t(8.0)),
        child: Stack(
          children: <Widget>[
            _centerBody(),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);
    countryList.clear();
    countryList.addAll(widget.countryList);
    dummyListData.addAll(widget.countryList);
    super.initState();
  }

  void callApiGetProjects(String query) {
    List<States> queryList = List<States>();
    dummyListData.forEach((item) {
      if (item.name.toLowerCase().contains(query)) {
        queryList.add(item);
      }
    });
    if (mounted)
      setState(() {
        countryList.clear();
        countryList.addAll(queryList);
      });
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget _gradientAppBarWidget() {
    return GradientAppBar(
      elevation: fit.t(2.0),
      leading: Material(
        shadowColor: Colors.transparent,
        color: Colors.transparent,
        child: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            FocusScope.of(context).requestFocus(_blankFocusNode);
            Navigator.of(context).pop();
          },
        ),
      ),
      title: Theme(
        data: ThemeData(
            primaryColor: Colors.white60,
            accentColor: Colors.white60,
            hintColor: Colors.white60,
            inputDecorationTheme: new InputDecorationTheme(
                labelStyle: new TextStyle(color: Colors.white60))),
        child: StreamBuilder(
            stream: null,
            builder: (context, snapshot) {
              return TextField(
                controller: _inputController,
                cursorWidth: fit.t(1.0),
                cursorColor: Colors.white60,
                autofocus: false,
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.search,
                keyboardAppearance: Brightness.light,
                onChanged: callApiGetProjects,
                decoration: InputDecoration(
                    hintMaxLines: 1,
                    border: InputBorder.none,
                    hoverColor: colorWhite,
                    focusColor: colorWhite,
                    fillColor: colorWhite,
                    hintText: "Search States",
                    hintStyle: TextStyle(
                        color: Colors.white54,
                        fontFamily: "Roboto",
                        fontSize: fit.t(18.0))),
                style: TextStyle(
                  color: colorWhite,
                  fontFamily: "Roboto",
                  fontSize: fit.t(18.0),
                ),
              );
            }),
      ),
      centerTitle: true,
      gradient: ColorsTheme.dashBoardGradient,
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.clear),
          onPressed: () {
            query = '';
            _inputController.text = query;
            countryList.clear();
            countryList.addAll(dummyListData);
            if (mounted) setState(() {});
          },
        ),
      ],
    );
  }

  Widget buildList(List<States> countryList) {
    return ListView.separated(
      padding: EdgeInsets.zero,
      itemCount: countryList.length,
      itemBuilder: (context, position) {
        return SearchProjectItem(
          position: position,
          item: countryList[position],
          onItemSelected: onItemSelected,
        );
      },
      separatorBuilder: (BuildContext context, int index) {
        return Divider(
          color: Colors.black12,
          height: fit.t(1.0),
        );
      },
    );
  }

  onItemSelected(int pos) {
    FocusScope.of(context).requestFocus(_blankFocusNode);
    Navigator.of(context).pop(countryList[pos]);
  }

  Widget _centerBody() {
    return buildList(countryList);
  }
}

class SearchProjectItem extends StatelessWidget {
  SearchProjectItem({this.position, this.item, this.onItemSelected});

  final Function(int pos) onItemSelected;
  final int position;
  final States item;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onItemSelected(position),
      child: Center(
        child: ListTile(
            contentPadding: EdgeInsets.symmetric(
                vertical: fit.t(2.0), horizontal: fit.t(8.0)),
            title: Text(item.name)),
      ),
    );
  }
}
