import 'package:dio/dio.dart';
import 'package:rvaapp/src/Requester/Requester.dart';
import 'package:rvaapp/src/models/AgenciaModel.dart';
import 'package:rvaapp/src/models/BuzonModel.dart';
import 'IValidarUso.provider.dart';

class ValidarUsoProvider implements IValidarUsoProvider {
  BuzonModel buzonModelclass = new BuzonModel();
  AgenciaModel agenciaModel = new AgenciaModel();
  Requester req = Requester();

  @override
  Future<dynamic> validarUsoApp() async {
    Response respuesta = await req.post("/ConfiguracionWS.asmx/ValidarUsoApp", null, params: null);
    List<dynamic> listData = respuesta.data;
    return listData[0];
  }
}
