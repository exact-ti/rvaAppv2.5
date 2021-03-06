import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rvaapp/src/Providers/ValidarUsoProvider/IValidarUso.provider.dart';
import 'package:rvaapp/src/Util/utils.dart';
import 'package:rvaapp/src/pages/RegistrarEnvioPage/Registro.page.dart';
import 'package:rvaapp/src/services/notificationProvider.dart';
import 'package:rvaapp/src/shared/modals/notification.dart';
import 'IValidarUso.core.dart';

class ValidarUsoCore implements IValidarUsoCore {

  IValidarUsoProvider validarusoProvider;

  ValidarUsoCore(IValidarUsoProvider validarusoProvider) {
    this.validarusoProvider = validarusoProvider;
  }

  @override
  void validarUsoApp(BuildContext context) async {
    dynamic configurationModel = await validarusoProvider.validarUsoApp();
    Provider.of<NotificationConfiguration>(context, listen: false).validouso =
        configurationModel["valido"];
    Provider.of<NotificationConfiguration>(context, listen: false)
        .validarenvio = configurationModel["envio"];
    Provider.of<NotificationConfiguration>(context, listen: false)
        .validarrecojo = configurationModel["recojo"];
    if (!configurationModel["valido"]) {
      bool respuesta = await notification(
          context, "error", "EXACT", "La app ha sido deshabilitada");
      if (respuesta) {
        eliminarpreferences(context);
      }
    }
  }

  @override
  void validarUsoOpenApp(BuildContext context) async {
    dynamic configurationModel = await validarusoProvider.validarUsoApp();
    Provider.of<NotificationConfiguration>(context, listen: false).validouso =
        configurationModel["valido"];
    Provider.of<NotificationConfiguration>(context, listen: false)
        .validarenvio = configurationModel["envio"];
    Provider.of<NotificationConfiguration>(context, listen: false)
        .validarrecojo = configurationModel["recojo"];
    if (!configurationModel["valido"]) {
      bool respuesta = await notification(
          context, "error", "EXACT", "La app ha sido deshabilitada");
      if (respuesta) {
        eliminarpreferences(context);
      }
    }else{
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (BuildContext context) => HomePage(enRecojo:  configurationModel["recojo"],)),
          (Route<dynamic> route) => false);
    }
  }
}
