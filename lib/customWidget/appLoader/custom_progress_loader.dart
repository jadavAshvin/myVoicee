import 'package:flutter/material.dart';
import 'package:fm_fit/fm_fit.dart';

class ProgressLoader extends StatelessWidget {
  final isShowLoader;
  final color;
  final FmFit fit;

  const ProgressLoader({Key key, this.isShowLoader, this.color, this.fit})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return isShowLoader
        ? AbsorbPointer(
            ignoringSemantics: false,
            child: Center(
              child: Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                decoration:
                    BoxDecoration(color: Color.fromRGBO(243, 243, 243, 0.5)),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      // SpinKitFadingCube(
                      //   color: color,
                      //   size: fit.t(40.0),
                      // ),
                      Image.asset(
                        "assets/images/loading_ball.gif",
                        width: fit.t(80.0),
                        height: fit.t(80.0),
                      )
                    ],
                  ),
                ),
              ),
            ),
          )
        : Container();
  }
}
