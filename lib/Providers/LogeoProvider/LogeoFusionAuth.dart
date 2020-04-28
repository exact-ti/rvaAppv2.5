import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:rvaapp/enum/TipoUsuario.dart';
import 'LogeoInterface.dart';
import 'package:rvaapp/Configuration/config.dart';
import 'package:rvaapp/ModelDto/BuzonModel.dart';

class LogeoFusionAuth implements LogeoInterface {
  BuzonModel buzonModelclass = new BuzonModel();

  @override
  Future<BuzonModel> login(String username, String password) async {
    final url =
        "/UsuarioWS.asmx/ValidarUsuario?sUsuario=$username&sPass=$password";

    final resp = await http.get(properties['API'] + url);

    List<dynamic> decodedData = json.decode(resp.body);
    if (decodedData.length == 0) {
      return null;
    }
    BuzonModel buzonModel = buzonModelclass.fromProvider(decodedData);

    return buzonModel;
  } 
}
