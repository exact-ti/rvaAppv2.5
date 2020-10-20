import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rvaapp/src/CoreProyecto/RegistroCore/IRegistro.core.dart';
import 'package:rvaapp/src/CoreProyecto/RegistroCore/Registro.core.dart';
import 'package:rvaapp/src/Providers/RegistroProvider/Registro.provider.dart';
import 'package:rvaapp/src/models/AgenciaModel.dart';
import 'package:rvaapp/src/shared/modals/notification.dart';
 

class RegistroController {

  IRegistroCore intersedeInterface =new RegistroCore(new RegistroProvider());

  void recogerdocumento(BuildContext context, String codigo,String codigosobre, bool modo) async {
    bool respuesta = await intersedeInterface.registrocodigoCore(codigo,modo,codigosobre);
    if(!respuesta){
      notification(context, "error", "EXACT", "No se pudo completar la operación");
    }else{
      notification(context, "success", "EXACT", "Registro correcto");
    }

  }
    Future<List<AgenciaModel>>  listarAgencias(String codigo, bool modo) async {
       List<AgenciaModel> agencias =  await intersedeInterface.listarAgencias(codigo,modo);
        return agencias;
    }

}
