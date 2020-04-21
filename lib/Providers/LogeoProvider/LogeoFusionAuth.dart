import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
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
    if (resp.body.isEmpty) {
      return null;
    } else {
      List<dynamic> decodedData = json.decode(resp.body);
      BuzonModel buzonModel = buzonModelclass.fromProvider(decodedData);
      return buzonModel;
    }
  }
}
