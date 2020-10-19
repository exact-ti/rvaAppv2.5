import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rvaapp/ModelDto/AgenciaModel.dart';
import 'package:rvaapp/Util/utils.dart';
import 'package:rvaapp/CoreProyecto/registro/IRegistroCore.dart';
import 'package:rvaapp/CoreProyecto/registro/RegistroCore.dart';
import 'package:rvaapp/Providers/RegistroProvider/RegistroProvider.dart';
 

class RegistroController {


  IRegistroCore intersedeInterface =new RegistroCore(new RegistroProvider());

  void recogerdocumento(BuildContext context, String codigo,String codigosobre, bool modo) async {
    bool respuesta = await intersedeInterface.registrocodigoCore(codigo,modo,codigosobre);
    if(respuesta==false){
      mostrarAlerta(context,"No se pudo completar la operación", "Código incorrecto");
    }else{
      mostrarAlerta(context,"Registro correcto", "Mensaje");
    }

  }
    Future<List<AgenciaModel>>  listarAgencias(String codigo, bool modo) async {
       List<AgenciaModel> agencias =  await intersedeInterface.listarAgencias(codigo,modo);
        return agencias;
    }

}
