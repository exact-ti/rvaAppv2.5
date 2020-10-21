import 'package:rvaapp/src/Requester/Requester.dart';
import 'package:rvaapp/src/models/AgenciaModel.dart';
import 'package:rvaapp/src/models/BuzonModel.dart';
import 'IValidarUso.provider.dart';
import 'package:dio/dio.dart';

class ValidarUsoProvider implements IValidarUsoProvider {
  BuzonModel buzonModelclass = new BuzonModel();
  AgenciaModel agenciaModel = new AgenciaModel();
  Requester req = Requester();
  
  @override
  Future<dynamic> validarUsoApp() async {
    Map<String, Object> respuesta = {'valido': true, 'envio': true, 'recojo': false};
    return respuesta;
/*     Response respuesta = await req.post(
        "/ConfiguracionWS.asmx/ValidarUsoApp", null, null);
    return respuesta.data; */
  }

}
