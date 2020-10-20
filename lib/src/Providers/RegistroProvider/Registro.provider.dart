import 'package:rvaapp/src/Requester/Requester.dart';
import 'package:rvaapp/src/models/AgenciaModel.dart';
import 'package:rvaapp/src/models/BuzonModel.dart';
import 'IRegistro.provider.dart';
import 'package:dio/dio.dart';

class RegistroProvider implements IRegistroProvider {
  BuzonModel buzonModelclass = new BuzonModel();
  AgenciaModel agenciaModel = new AgenciaModel();
  Requester req = Requester();
  
  @override
  Future<bool> registroCodigoEntrega(dynamic dataMap) async {
    Response respuesta = await req.post(
        "/AgenciaTrasladoWS.asmx/RegistrarEntregaProveedor", dataMap, null);
    return respuesta.data == 1 ? true : false;
  }

  @override
  Future<bool> registroCodigoRecojo(dynamic dataMap) async {
    Response respuesta = await req.post(
        "/AgenciaTrasladoWS.asmx/RegistrarRecojoProveedor", dataMap, null);
    return respuesta.data == 1 ? true : false;
  }

  @override
  Future<List<AgenciaModel>> listarAgenciaRecojo(dynamic dataMap) async {
    Response respuesta = await req.post(
        "/AgenciaWS.asmx/FiltrarAgenciaPorCodigoProveedor", dataMap, null);
    List<dynamic> decodedData = respuesta.data;
    List<AgenciaModel> agencias = agenciaModel.fromProvider(decodedData);
    return agencias.isEmpty ? null : agencias;
  }

  @override
  Future<List<AgenciaModel>> listarAgenciaModalidad(dynamic dataMap) async {
    Response respuesta = await req.post(
        "/AgenciaWS.asmx/FiltrarAgenciaPorCodigoProveedor", dataMap, null);
    List<dynamic> decodedData = respuesta.data;
    List<AgenciaModel> agencias = agenciaModel.fromProvider(decodedData);
    return agencias.isEmpty ? null : agencias;
  }

  @override
  Future<List<AgenciaModel>> listarAgenciaEntrega(dynamic dataMap) async {
    Response respuesta = await req.post(
        "/AgenciaWS.asmx/FiltrarAgenciaPorCodigoProveedor", dataMap, null);
    List<dynamic> decodedData = respuesta.data;
    List<AgenciaModel> agencias = agenciaModel.fromProviderEntrega(decodedData);
    return agencias.isEmpty ? null : agencias;
  }
}
