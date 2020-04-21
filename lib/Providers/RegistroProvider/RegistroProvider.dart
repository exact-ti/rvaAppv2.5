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
    final url ="/UsuarioWS.asmx/ValidarUsuario?sUsuario=$codigo";

    final resp = await http.get(properties['API'] + url);
    if (resp.body.isEmpty) {
      return null;
    } else {
      return true;
    }
  }

  @override
  Future<List<AgenciaModel>> listarAgencia(String codigo) async {
    Map<String,dynamic> buzon = json.decode(_prefs.buzon);
    BuzonModel bznmodel = buzonModelclass.fromPreferencs(buzon);

    final url ="/UsuarioWS.asmx/ValidarUsuario?sUsuario=$codigo";

    final resp = await http.get(properties['API'] + url);
    
    if (resp.body.isEmpty) {
      return null;
    } else {
      List<dynamic> decodedData = json.decode(resp.body);
      List<AgenciaModel> agencias = agenciaModel.fromProvider(decodedData);
      return agencias;
    }
  }
}
