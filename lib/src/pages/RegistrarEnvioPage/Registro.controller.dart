import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rvaapp/src/CoreProyecto/InputCore/IInput.core.dart';
import 'package:rvaapp/src/CoreProyecto/InputCore/Input.core.dart';
import 'package:rvaapp/src/CoreProyecto/RegistroCore/IRegistro.core.dart';
import 'package:rvaapp/src/CoreProyecto/RegistroCore/Registro.core.dart';
import 'package:rvaapp/src/Providers/InputProvider/Input.provider.dart';
import 'package:rvaapp/src/Providers/RegistroProvider/Registro.provider.dart';
import 'package:rvaapp/src/models/AgenciaModel.dart';
import 'package:rvaapp/src/models/CampoModel.dart';
import 'package:rvaapp/src/models/InputModel.dart';
import 'package:rvaapp/src/shared/modals/notification.dart';

class RegistroController {
  IRegistroCore registroCore = new RegistroCore(new RegistroProvider());
  IInputCore inputCore = new InputCore(new InputProvider());

  Future<bool> recogerdocumento(BuildContext context, String codigoAgencia,
      bool modo, List<CampoModel> listCampo) async {
    bool respuesta = await registroCore.registrocodigoCore(modo, codigoAgencia, listCampo);
    if (respuesta) {
      notification(context, "success", "EXACT", "Registro correcto");
    } else {
      notification(
          context, "error", "EXACT", "No se pudo completar la operación");
    }
    return respuesta;
  }

  Future<List<AgenciaModel>> listarAgencias(String codigo, bool modo) async {
    return await registroCore.listarAgencias(codigo, modo);
  }

  Future<List<InputModel>> listarInput() async {
    return await inputCore.listarInputs();
  }
}
