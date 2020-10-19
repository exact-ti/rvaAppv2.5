import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:rvaapp/ModelDto/AgenciaModel.dart';
import 'package:rvaapp/preferencias_usuario/preferencias_usuario.dart';
import 'IRegistroProvider.dart';
import 'package:rvaapp/Configuration/config.dart';
import 'package:rvaapp/ModelDto/BuzonModel.dart';
import 'package:dio/dio.dart';

class RegistroProvider implements IRegistroProvider {
  final Dio _dio = Dio();

  BuzonModel buzonModelclass = new BuzonModel();
  AgenciaModel agenciaModel = new AgenciaModel();
  final _prefs = new PreferenciasUsuario();
    @override
  Future<bool> registroCodigoEntrega(String codigo,String codigoSobre) async {
    Map<String, dynamic> buzon = json.decode(_prefs.buzon);
    BuzonModel bznmodel = buzonModelclass.fromPreferencs(buzon);
    String idbuzon = bznmodel.idUsuario;
    final url = "/AgenciaTrasladoWS.asmx/RegistrarEntregaProveedor";

    Map<String, dynamic> jsonMap = {
      'codigoUsuario': idbuzon,
      'codigoAgencia': codigo,
      'comprobante': codigoSobre
    };

    final respuesta = await http.post(properties['API'] + url,
        body: jsonMap,
        headers: {"Content-Type": "application/x-www-form-urlencoded"},
        encoding: Encoding.getByName("utf-8"));

    var res = json.decode(respuesta.body);
    if (res == 1) {
      return true;
    } else {
      return false;
    }
  }
  @override
  Future<bool> registroCodigo(String codigo, String codigoSobre) async {
    Map<String, dynamic> buzon = json.decode(_prefs.buzon);
    BuzonModel bznmodel = buzonModelclass.fromPreferencs(buzon);
    String idbuzon = bznmodel.idUsuario;
    final url = "/AgenciaTrasladoWS.asmx/RegistrarRecojoProveedor";

    Map<String, dynamic> jsonMap = {
      'codigoUsuario': idbuzon,
      'codigoAgencia': codigo,
      'comprobante': codigoSobre
    };

    final respuesta = await http.post(properties['API'] + url,
        body: jsonMap,
        headers: {"Content-Type": "application/x-www-form-urlencoded"},
        encoding: Encoding.getByName("utf-8"));

    var res = json.decode(respuesta.body);
    if (res == 1) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Future<List<AgenciaModel>> listarAgenciaRecojo(String codigo) async {
    Map<String, dynamic> buzon = json.decode(_prefs.buzon);
    BuzonModel bznmodel = buzonModelclass.fromPreferencs(buzon);
    String idbuzon = bznmodel.idUsuario;
    final url = "/AgenciaWS.asmx/FiltrarAgenciaPorCodigoProveedor";

    Map<String, dynamic> jsonMap = {
      'codigoUsuario': idbuzon,
      'codigoAgencia': codigo
    };

    final respuesta = await http.post(properties['API'] + url,
        body: jsonMap,
        headers: {"Content-Type": "application/x-www-form-urlencoded"},
        encoding: Encoding.getByName("utf-8"));

      List<dynamic> decodedData = json.decode(respuesta.body);
      List<AgenciaModel> agencias = agenciaModel.fromProvider(decodedData);
      if(agencias.length==0){
        return null;
      }
      return agencias;
  
  }



  @override
  Future<List<AgenciaModel>> listarAgenciaModalidad(String codigo,int indice) async {
    Map<String, dynamic> buzon = json.decode(_prefs.buzon);
    BuzonModel bznmodel = buzonModelclass.fromPreferencs(buzon);
    String idbuzon = bznmodel.idUsuario;
    final url = "/AgenciaWS.asmx/FiltrarAgenciaPorCodigoProveedor";

    Map<String, dynamic> jsonMap = {
      'codigoUsuario': idbuzon,
      'codigoAgencia': codigo,
      'idTipoRegistro': "$indice"
    };

    final respuesta = await http.post(properties['API'] + url,
        body: jsonMap,
        headers: {"Content-Type": "application/x-www-form-urlencoded"},
        encoding: Encoding.getByName("utf-8"));

      List<dynamic> decodedData = json.decode(respuesta.body);
      List<AgenciaModel> agencias = agenciaModel.fromProvider(decodedData);
      if(agencias.length==0){
        return null;
      }
      return agencias;
  
  }


  @override
  Future<List<AgenciaModel>> listarAgenciaEntrega(String codigo) async {
    Map<String, dynamic> buzon = json.decode(_prefs.buzon);
    BuzonModel bznmodel = buzonModelclass.fromPreferencs(buzon);
    String idbuzon = bznmodel.idUsuario;
    final url = "/AgenciaWS.asmx/FiltrarAgenciaPorCodigoProveedor";

    Map<String, dynamic> jsonMap = {
      'codigoUsuario': idbuzon,
      'codigoAgencia': codigo
    };

    final respuesta = await http.post(properties['API'] + url,
        body: jsonMap,
        headers: {"Content-Type": "application/x-www-form-urlencoded"},
        encoding: Encoding.getByName("utf-8"));

      List<dynamic> decodedData = json.decode(respuesta.body);
      List<AgenciaModel> agencias = agenciaModel.fromProviderEntrega(decodedData);
      if(agencias.length==0){
        return null;
      }
      return agencias;
  
  }

}