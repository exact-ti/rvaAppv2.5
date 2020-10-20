import 'package:rvaapp/src/Providers/RegistroProvider/IRegistro.provider.dart';
import 'package:rvaapp/src/Providers/RegistroProvider/Registro.provider.dart';
import 'package:rvaapp/src/Util/utils.dart';
import 'package:rvaapp/src/models/AgenciaModel.dart';
import 'IRegistro.core.dart';

class RegistroCore implements IRegistroCore {
  IRegistroProvider registro;

  RegistroCore(RegistroProvider registro) {
    this.registro = registro;
  }

  @override
  Future<bool> registrocodigoCore(
      String codigo, bool modo, String codigoSobre) async {
    Map<String, dynamic> dataMap = {
      'codigoUsuario': buzonId(),
      'codigoAgencia': codigo,
      'comprobante': codigoSobre
    };
    if (modo) {
      return await registro.registroCodigoRecojo(dataMap);
    } else {
      return await registro.registroCodigoEntrega(dataMap);
    }
  }

  @override
  Future<List<AgenciaModel>> listarAgencias(String codigo, bool modo) async {
    Map<String, dynamic> dataMap = {
      'codigoUsuario': buzonId(),
      'codigoAgencia': codigo,
      'idTipoRegistro': modo ? "1" : "2"
    };
    return await registro.listarAgenciaModalidad(dataMap);
  }
}
