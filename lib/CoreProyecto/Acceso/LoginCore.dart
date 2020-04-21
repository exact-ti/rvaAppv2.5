

import 'package:rvaapp/ModelDto/BuzonModel.dart';
import 'package:rvaapp/Providers/LogeoProvider/LogeoInterface.dart';
import 'package:rvaapp/preferencias_usuario/preferencias_usuario.dart';
import 'ILoginCore.dart';

class LoginCore implements ILoginCore {
  
  //TipoBuzonEnum tipoBuzonEnum;
  final _prefs = new PreferenciasUsuario();

  LogeoInterface logeo;


  LoginCore(LogeoInterface logeo) {
    this.logeo = logeo;
  }

  @override
  Future<BuzonModel> login(String username, String password) async{
        BuzonModel buzonprovider = await logeo.login(username, password);
        if(buzonprovider==null){
          return null;
        }
        _prefs.buzon = buzonprovider;

        return buzonprovider;
  }
}
