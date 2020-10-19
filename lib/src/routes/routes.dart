import 'package:flutter/material.dart';
import 'package:rvaapp/src/pages/LoginPage/Login.page.dart';
import 'package:rvaapp/src/pages/RegistrarEnvioPage/Registro.page.dart';

Map<String, WidgetBuilder> getAplicationRoutes() {
  return <String, WidgetBuilder>{
    '/login': (BuildContext context) => LoginPage(),
    '/home': (BuildContext context) => HomePage(),
  };
}
