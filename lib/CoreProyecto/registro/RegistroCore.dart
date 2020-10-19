

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
  Future<bool> registrocodigoCore(String codigo,bool modo,String codigoSobre) async{
        bool respuesta;
    if(modo){
    respuesta = await registro.registroCodigo(codigo,codigoSobre);
    }else{
    respuesta  = await registro.registroCodigoEntrega(codigo,codigoSobre);

    }
        return respuesta;
  }

  @override
  Future<List<AgenciaModel>> listarAgencias(String codigo, bool modo) async {
    List<AgenciaModel> agencias;
    int indice;

    if(modo){
      indice=1;
    }else{
      indice=2;
    }

    agencias = await registro.listarAgenciaModalidad(codigo,indice);

   /* if(modo){
    agencias = await registro.listarAgenciaRecojo(codigo);
    }else{
    agencias = await registro.listarAgenciaEntrega(codigo);

    }*/
        return agencias;
  }
}
