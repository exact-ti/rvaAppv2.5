import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:rvaapp/src/styles/theme_data.dart';
import 'package:progress_indicators/progress_indicators.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(top: 30),
          child: SpinKitFadingCube(
            color: StylesThemeData.PRIMARY_COLOR,
            size: 50.0,
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: 30),
          child: Center(
              child: FadingText(
            "Cargando",
            style: TextStyle(fontSize: 20, color: StylesThemeData.PRIMARY_COLOR),
          )),
        )
      ],
    ));
  }
}
