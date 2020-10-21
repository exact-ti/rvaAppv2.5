import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:rvaapp/src/pages/LoginPage/Login.page.dart';
import 'package:rvaapp/src/preferencias_usuario/preferencias_usuario.dart';
import 'package:rvaapp/src/routes/routes.dart';
import 'package:rvaapp/src/services/locator.dart';
import 'package:rvaapp/src/services/navigation_service_file.dart';
import 'package:rvaapp/src/services/notificationProvider.dart';

 
void main() async { 
  final prefs = new PreferenciasUsuario();
  Provider.debugCheckInvalidValueType = null;
  WidgetsFlutterBinding.ensureInitialized();
  await prefs.initPrefs();
  setupLocator();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp,DeviceOrientation.portraitDown])
      .then((_) => runApp(MyApp()),
  );
  }

class MyApp extends StatelessWidget {  
  @override
  Widget build(BuildContext context) { 
    return ChangeNotifierProvider(
      create: (_) => new NotificationConfiguration(),
      child:MaterialApp(
      title: 'Componentes App',
      debugShowCheckedModeBanner: false,
      //home: HomePage()
      initialRoute:'/login',  
      routes: getAplicationRoutes(),
      navigatorKey: locator<NavigationService>().navigatorKey,
      onGenerateRoute: (settings){
        return MaterialPageRoute(
          builder: ( BuildContext context ) =>LoginPage()
        );
      },
    ));
  }
}