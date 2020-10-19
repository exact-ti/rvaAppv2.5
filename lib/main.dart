import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rvaapp/src/pages/LoginPage/Login.page.dart';
import 'package:rvaapp/src/preferencias_usuario/preferencias_usuario.dart';
import 'package:rvaapp/src/routes/routes.dart';

 
void main() async { 
  final prefs = new PreferenciasUsuario();
  WidgetsFlutterBinding.ensureInitialized();
  await prefs.initPrefs();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp,DeviceOrientation.portraitDown])
      .then((_) => runApp(MyApp()),
  );
  }

class MyApp extends StatelessWidget {  
  @override
  Widget build(BuildContext context) { 
    return MaterialApp(
      title: 'Componentes App',
      debugShowCheckedModeBanner: false,
      //home: HomePage()
      initialRoute:'/login',  
      routes: getAplicationRoutes(),
      onGenerateRoute: (settings){
        return MaterialPageRoute(
          builder: ( BuildContext context ) =>LoginPage()
        );
      },
    );
  }
}