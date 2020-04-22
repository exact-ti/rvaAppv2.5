import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:rvaapp/ModelDto/AgenciaModel.dart';
import 'package:rvaapp/preferencias_usuario/preferencias_usuario.dart';
import 'IRegistroProvider.dart';
import 'package:rvaapp/Configuration/config.dart';
import 'package:rvaapp/ModelDto/BuzonModel.dart';

class RegistroProvider implements IRegistroProvider {
  BuzonModel buzonModelclass = new BuzonModel();
  AgenciaModel agenciaModel = new AgenciaModel();
  final _prefs = new PreferenciasUsuario();

  @override
  Future<bool> registroCodigo(String codigo) async {
    Map<String, dynamic> buzon = json.decode(_prefs.buzon);
    BuzonModel bznmodel = buzonModelclass.fromPreferencs(buzon);
    String idbuzon = bznmodel.idUsuario;
    final url =
        "/AgenciaTrasladoWS.asmx/RegistrarRecojoProveedor?codigoUsuario=$idbuzon&codigoAgencia=$codigo";

    final resp = await http.get(properties['API'] + url);
    var res = json.decode(resp.body);
    if (res==1) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Future<List<AgenciaModel>> listarAgencia(String codigo) async {
    Map<String, dynamic> buzon = json.decode(_prefs.buzon);
    BuzonModel bznmodel = buzonModelclass.fromPreferencs(buzon);
    String idbuzon = bznmodel.idUsuario;
    final url =
        "/AgenciaWS.asmx/FiltrarAgenciaPorCodigoProveedor?codigoUsuario=$idbuzon&codigoAgencia=$codigo";
    final resp = await http.get(properties['API'] + url);
    if (resp.body.isEmpty) {
      return null;
    } else {
      List<dynamic> decodedData = json.decode(resp.body);
      List<AgenciaModel> agencias = agenciaModel.fromProvider(decodedData);
      return agencias;
    }
  }

  @override
  Future<List<AgenciaModel>> listarAgencia2(String codigo) {
    return Future.delayed(new Duration(seconds: 1), () {
      return listaporcodigo(codigo);
    });
  }

  List<AgenciaModel> listaporcodigo(String codigo) {
    List<AgenciaModel> agencias = new List();
    if (codigo == "LAS") {
      AgenciaModel agenciaModel = new AgenciaModel();
      //agenciaModel.id=1;
      agenciaModel.nombre = "LAS PALMERAS";
      agenciaModel.estado = 1;
      agencias.add(agenciaModel);
      return agencias;
    }
    if (codigo == "LOS") {
      AgenciaModel agenciaModel = new AgenciaModel();
      //agenciaModel.id=1;
      agenciaModel.nombre = "LOS PALMOS";
      agenciaModel.estado = 2;
      agencias.add(agenciaModel);
      return agencias;
    }
  }
}
