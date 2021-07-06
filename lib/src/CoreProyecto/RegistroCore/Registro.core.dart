import 'dart:convert';
import 'package:rvaapp/src/Providers/RegistroProvider/IRegistro.provider.dart';
import 'package:rvaapp/src/Providers/RegistroProvider/Registro.provider.dart';
import 'package:rvaapp/src/Util/utils.dart';
import 'package:rvaapp/src/enum/TipoRegistro.dart';
import 'package:rvaapp/src/models/AgenciaModel.dart';
import 'package:rvaapp/src/models/CampoModel.dart';
import 'IRegistro.core.dart';

class RegistroCore implements IRegistroCore {
  IRegistroProvider registro;

  RegistroCore(RegistroProvider registro) {
    this.registro = registro;
  }

  @override
  Future<bool> registrocodigoCore(
      bool modo, String codigoAgencia, List<CampoModel> listCampo) async {
    List<Map<String, dynamic>> listCampos = listCampo
        .map((campo) => {"iId": "${campo.id}", "valor": campo.valor})
        .toList();
    Map<String, dynamic> dataMap = {
      'codigoUsuario': buzonId(),
      'codigoAgencia': codigoAgencia,
      'tipoRegistro':
          modo ? TipoRegistro.TIPO_RECOJO.toString() : TipoRegistro.TIPO_ENTREGA.toString(),
      'campos': json.encode(listCampos)
    };
    return await registro.registroCodigo(dataMap);
  }

  @override
  Future<AgenciaModel> listarAgencias(String codigo, bool modo) async {
    Map<String, dynamic> dataMap = {
      'codigoUsuario': buzonId(),
      'codigoAgencia': codigo,
      'idTipoRegistro':
          modo ? TipoRegistro.TIPO_RECOJO : TipoRegistro.TIPO_ENTREGA
    };
    return await registro.listarAgenciaModalidad(dataMap);
  }
}
