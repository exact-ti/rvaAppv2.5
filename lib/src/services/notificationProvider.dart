import 'package:flutter/material.dart';

class NotificationConfiguration with ChangeNotifier {

  bool _validoUso = true;

  bool get validouso => this._validoUso;

  set validouso( bool validoUso ) {
    this._validoUso = validoUso;
    notifyListeners();
  }

  bool _validarEnvio = true;

  bool get validarenvio => this._validarEnvio;

  set validarenvio( bool validarEnvio ) {
    this._validarEnvio = validarEnvio;
    notifyListeners();
  }

  bool _validarRecojo = true;

  bool get validarrecojo => this._validarRecojo;

  set validarrecojo( bool validarRecojo ) {
    this._validarRecojo = validarRecojo;
    notifyListeners();
  }

}