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
    /* Response respuesta = await req.post(
        "/AgenciaTrasladoWS.asmx/RegistrarEntregaProveedor", dataMap, params:null);
    return respuesta.data == 1 ? true : false; */
    return true;
  }

  @override
  Future<bool> registroCodigoRecojo(dynamic dataMap) async {
    /* Response respuesta = await req.post(
        "/AgenciaTrasladoWS.asmx/RegistrarRecojoProveedor", dataMap, params:null);
    return respuesta.data == 1 ? true : false; */
    return true;
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
  Future<List<AgenciaModel>> listarAgenciaModalidad(dynamic dataMap) async {
    /* Response respuesta = await req.post(
        "/AgenciaWS.asmx/FiltrarAgenciaPorCodigoProveedor", dataMap, params:null);
    List<dynamic> decodedData = respuesta.data;
    List<AgenciaModel> agencias = agenciaModel.fromProvider(decodedData);
    return agencias.isEmpty ? null : agencias; */
    List<AgenciaModel> lista = new List();
    AgenciaModel agenciaModel = new AgenciaModel();
    agenciaModel.id="1";
    agenciaModel.nombre="Ni idea";
    agenciaModel.idtipo=6;
    agenciaModel.estado=1;
    agenciaModel.nombretipo="Normal";

    lista.add(agenciaModel);
    return lista;
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
