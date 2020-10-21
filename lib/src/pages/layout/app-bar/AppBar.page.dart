import 'package:flutter/material.dart';
import 'package:rvaapp/src/styles/theme_data.dart';
import 'AppBar.controller.dart';
import 'package:rvaapp/src/enum/EstadoApp.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  final String text;
  final bool leadingbool;
  @override
  final Size preferredSize;
  CustomAppBar({
    @required this.text,
    this.leadingbool,
  }) : preferredSize = Size.fromHeight(56.0);

  @override
  State<StatefulWidget> createState() {
    return new _CustomAppBarState();
  }
}

class _CustomAppBarState extends State<CustomAppBar>
    with WidgetsBindingObserver {
  AppBarController appBarController = new AppBarController();
  int estadoApp;
  int idBuzonOrUTD = 0;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state.index == EstadoAppEnum.resumed) {
      appBarController.verificarUsoApp(context);
    }
  }

  @override
  void initState() {
    estadoApp = 0;
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }


  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
        backgroundColor: StylesThemeData.PRIMARYCOLOR,
        automaticallyImplyLeading:
            widget.leadingbool == null || widget.leadingbool == true
                ? true
                : false,
        title: Text(widget.text,
            style: TextStyle(
                fontSize: 18,
                decorationStyle: TextDecorationStyle.wavy,
                fontStyle: FontStyle.normal,
                fontWeight: FontWeight.normal)));
  }
}
