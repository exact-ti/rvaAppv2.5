import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:rvaapp/src/Providers/ValidarUsoProvider/IValidarUso.provider.dart';
import 'package:rvaapp/src/Util/utils.dart';
import 'package:rvaapp/src/models/BuzonModel.dart';
import 'package:rvaapp/src/models/ConfigurationModel.dart';
import 'package:rvaapp/src/preferencias_usuario/preferencias_usuario.dart';
import 'package:rvaapp/src/services/notificationProvider.dart';
import 'package:rvaapp/src/shared/modals/notification.dart';
import 'IValidarUso.core.dart';

class ValidarUsoCore implements IValidarUsoCore {
  final _prefs = new PreferenciasUsuario();

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
}
