import 'package:flutter/cupertino.dart';
import 'package:rvaapp/src/CoreProyecto/LoginCore/ILogin.core.dart';
import 'package:rvaapp/src/CoreProyecto/LoginCore/Login.core.dart';
import 'package:rvaapp/src/Providers/LoginProvider/Login.provider.dart';
import 'package:rvaapp/src/enum/TipoUsuario.dart';
import 'package:rvaapp/src/shared/modals/notification.dart';

class LoginController {
  ILoginCore accesoInterface = new LoginCore(new LoginProvider());
  validarlogin(BuildContext context, String username, String password) {
    print("adsa");
    accesoInterface.login(username, password).then((data) {
      print(data);
      if (data == null) {
        notification(context, "error", "EXACT",
            'El usuario y contraseña son incorrectos');
      } else {
        if (data.idTipoUsuario != TipoCargoEnum.tipoProveedor) {
          notification(context, "error", "EXACT",
              'El usuario no tiene el perfil para usar la App');
        } else {
          Navigator.of(context).pushNamedAndRemoveUntil(
              "/home", (Route<dynamic> route) => false);
        }
      }
    });
  }
}
