import 'package:flutter/material.dart';
import 'package:rvaapp/vistas/Home/RegistroPage.dart';
import 'package:rvaapp/vistas/Login/loginPage.dart';



Map<String, WidgetBuilder> getAplicationRoutes() {
  return <String, WidgetBuilder>{
    '/login': (BuildContext context) => LoginPage(),
    '/home': (BuildContext context) => HomePage(),
  };
}
