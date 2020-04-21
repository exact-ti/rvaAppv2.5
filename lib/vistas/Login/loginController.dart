import 'package:flutter/cupertino.dart';
import 'package:rvaapp/CoreProyecto/Acceso/LoginCore.dart';
import 'package:rvaapp/CoreProyecto/Acceso/ILoginCore.dart';
import 'package:rvaapp/Providers/LogeoProvider/LogeoFusionAuth.dart';
import 'package:rvaapp/Util/utils.dart';
import 'package:rvaapp/preferencias_usuario/preferencias_usuario.dart';


class LoginController {
  ILoginCore accesoInterface = new LoginCore(
      new LogeoFusionAuth());
      
  final _prefs = new PreferenciasUsuario();

  validarlogin(BuildContext context, String username, String password) {
    print("adsa");
    accesoInterface.login(username, password).then((data) {
      print(data);
      if (data == null) {
        mostrarAlerta(context, 'El usuario y contraseña son incorrectos',
            'Información incorrecta');
      } else {
            Navigator.of(context).pushNamedAndRemoveUntil("/home", (Route<dynamic> route) => false);
      }
    });
  }
}
