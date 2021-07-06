import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:rvaapp/src/Providers/LoginProvider/ILogin.provider.dart';
import 'package:rvaapp/src/Providers/ValidarUsoProvider/IValidarUso.provider.dart';
import 'package:rvaapp/src/models/BuzonModel.dart';
import 'package:rvaapp/src/preferencias_usuario/preferencias_usuario.dart';
import 'package:rvaapp/src/services/notificationProvider.dart';
import 'ILogin.core.dart';

class LoginCore implements ILoginCore {
  final _prefs = new PreferenciasUsuario();

  ILoginProvider loginProvider;

  IValidarUsoProvider validarUsoProvider;

  LoginCore(ILoginProvider loginProvider, IValidarUsoProvider validarUsoProvider) {
    this.loginProvider = loginProvider;
    this.validarUsoProvider = validarUsoProvider;
  }

  @override
  Future<bool> login(String username, String password,BuildContext context) async {
    dynamic configuration = await validarUsoProvider.validarUsoApp();
    Provider.of<NotificationConfiguration>(context, listen: false).validouso=configuration["valido"];
    Provider.of<NotificationConfiguration>(context, listen: false).validarenvio=configuration["envio"];
    Provider.of<NotificationConfiguration>(context, listen: false).validarrecojo=configuration["recojo"];
    if(!configuration["valido"]) return false;
    BuzonModel buzonModel = await loginProvider.login(username, password);
     _prefs.buzon = buzonModel;
    if(buzonModel!=null) _prefs.nombreUsuario = buzonModel.nombre;
    return true;
  }
}
