import 'dart:convert';
import 'package:rvaapp/src/models/BuzonModel.dart';
import 'package:rvaapp/src/models/ConfigurationModel.dart';
import 'package:shared_preferences/shared_preferences.dart';

/*
  Recordar instalar el paquete de:
    shared_preferences:

  Inicializar en el main
    final prefs = new PreferenciasUsuario();
    prefs.initPrefs();
*/

class PreferenciasUsuario {

  static final PreferenciasUsuario _instancia = new PreferenciasUsuario._internal();

  factory PreferenciasUsuario() {
    return _instancia;
  }

  PreferenciasUsuario._internal();

  SharedPreferences _prefs;

  initPrefs() async {
    this._prefs = await SharedPreferences.getInstance();
  }

  get token {
    return _prefs.getString('token') ?? '';
  }

  set token( String value ) {
    _prefs.setString('token', value);
  }

  get refreshToken {
    return _prefs.getString('refresh_token') ?? '';
  }

  set refreshToken(String value) {
    _prefs.setString('refresh_token', value);
  }
  
  get buzon {
    return _prefs.getString("buzon");
  }

  set buzon (BuzonModel utd) {
    _prefs.setString("buzon", json.encode(utd));
  }

  get configurationModel {
    return _prefs.getString("configurationModel");
  }

  set configurationModel (ConfigurationModel configurationModel) {
    _prefs.setString("configurationModel", json.encode(configurationModel));
  }

  get ultimaPagina {
    return _prefs.getString('ultimaPagina') ?? 'login';
  }

  set ultimaPagina( String value ) {
    _prefs.setString('ultimaPagina', value);
  }

  get nombreUsuario {
    return _prefs.getString('nombreUsuario') ?? '';
  }

  set nombreUsuario( String value ) {
    _prefs.setString('nombreUsuario', value);
  }

}

