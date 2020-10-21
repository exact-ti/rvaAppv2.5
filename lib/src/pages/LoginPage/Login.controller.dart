import 'package:flutter/cupertino.dart';
import 'package:rvaapp/src/CoreProyecto/LoginCore/ILogin.core.dart';
import 'package:rvaapp/src/CoreProyecto/LoginCore/Login.core.dart';
import 'package:rvaapp/src/CoreProyecto/ValidarUsoCore/IValidarUso.core.dart';
import 'package:rvaapp/src/CoreProyecto/ValidarUsoCore/ValidarUso.core.dart';
import 'package:rvaapp/src/Providers/LoginProvider/Login.provider.dart';
import 'package:rvaapp/src/Providers/ValidarUsoProvider/ValidarUso.provider.dart';
import 'package:rvaapp/src/Util/utils.dart';
import 'package:rvaapp/src/enum/TipoUsuario.dart';
import 'package:rvaapp/src/models/BuzonModel.dart';
import 'package:rvaapp/src/shared/modals/notification.dart';

class LoginController {
  ILoginCore accesoInterface =
      new LoginCore(new LoginProvider(), new ValidarUsoProvider());

  IValidarUsoCore validarUsoCore = new ValidarUsoCore(new ValidarUsoProvider());

  validarlogin(BuildContext context, String username, String password) {
    accesoInterface.login(username, password,context).then((permiso) {
      if (permiso) {
        BuzonModel buzonModel = buzonPreferences();
        if (buzonModel == null) {
          notification(context, "error", "EXACT",
              'El usuario y contraseña son incorrectos');
        } else {
          if (buzonModel.idTipoUsuario != TipoCargoEnum.tipoProveedor) {
            notification(context, "error", "EXACT",
                'El usuario no tiene el perfil para usar la App');
          } else {
            Navigator.of(context).pushNamedAndRemoveUntil(
                "/home", (Route<dynamic> route) => false);
          }
        }
      } else {
        notification(context, "error", "EXACT",
            'El uso de la app ha sido deshabilitado');
      }
    });
  }

  validarUsoApp(BuildContext context) {
    validarUsoCore.validarUsoApp(context);
  }
}
