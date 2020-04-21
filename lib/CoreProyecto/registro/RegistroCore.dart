

import 'package:rvaapp/ModelDto/AgenciaModel.dart';
import 'package:rvaapp/ModelDto/BuzonModel.dart';
import 'package:rvaapp/Providers/RegistroProvider/IRegistroProvider.dart';
import 'package:rvaapp/Providers/RegistroProvider/RegistroProvider.dart';
import 'package:rvaapp/preferencias_usuario/preferencias_usuario.dart';
import 'IRegistroCore.dart';

class RegistroCore implements IRegistroCore {
  
  //TipoBuzonEnum tipoBuzonEnum;
  final _prefs = new PreferenciasUsuario();

  IRegistroProvider registro;


  RegistroCore(RegistroProvider registro) {
    this.registro = registro;
  }

  @override
  Future<bool> registrocodigoCore(String codigo) async{
        bool respuesta = await registro.registroCodigo(codigo);

        return respuesta;
  }

  @override
  Future<List<AgenciaModel>> listarAgencias(String codigo) async {
     List<AgenciaModel> agencias = await registro.listarAgencia2(codigo);
        return agencias;
  }
}
