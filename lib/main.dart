import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rvaapp/vistas/Login/loginPage.dart';
import 'package:rvaapp/preferencias_usuario/preferencias_usuario.dart';
import 'package:rvaapp/routes/routes.dart';

 
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
      initialRoute: true==true ? '/login' :"/dfs",  
      routes: getAplicationRoutes(),
      onGenerateRoute: (settings){
        return MaterialPageRoute(
          builder: ( BuildContext context ) =>LoginPage()
        );
      },
    );
  }
}