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
  Future<bool> registroCodigo(dynamic dataMap) async {
    Response respuesta = await req.post(
        "/AgenciaTrasladoWS.asmx/RegistrarTrasladoProveedor", dataMap, params:null);
    return respuesta.data == 1 ? true : false;
  }

  @override
  Future<List<AgenciaModel>> listarAgenciaRecojo(dynamic dataMap) async {
    Response respuesta = await req.post(
        "/AgenciaWS.asmx/FiltrarAgenciaPorCodigoProveedor", dataMap, params:null);
    List<dynamic> decodedData = respuesta.data;
    List<AgenciaModel> agencias = agenciaModel.fromProvider(decodedData);
    return agencias.isEmpty ? null : agencias;
  }

  @override
  Future<AgenciaModel> listarAgenciaModalidad(dynamic dataMap) async {
    Response respuesta = await req.post(
        "/AgenciaWS.asmx/FiltrarAgenciaPorCodigoProveedor", dataMap, params:null);
    List<dynamic> decodedData = respuesta.data;
    if(decodedData.isEmpty) return agenciaModel.agenciaModelVacio(); 
    List<AgenciaModel> agencias = agenciaModel.fromProvider(decodedData);
    return agencias[0]; 
  }

  @override
  Future<List<AgenciaModel>> listarAgenciaEntrega(dynamic dataMap) async {
    Response respuesta = await req.post(
        "/AgenciaWS.asmx/FiltrarAgenciaPorCodigoProveedor", dataMap, params:null);
    List<dynamic> decodedData = respuesta.data;
    List<AgenciaModel> agencias = agenciaModel.fromProviderEntrega(decodedData);
    return agencias.isEmpty ? null : agencias;
  }
}
