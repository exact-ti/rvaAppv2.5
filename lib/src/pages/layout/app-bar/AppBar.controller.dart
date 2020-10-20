import 'package:flutter/cupertino.dart';
import 'package:rvaapp/src/CoreProyecto/ValidarUsoCore/IValidarUso.core.dart';
import 'package:rvaapp/src/CoreProyecto/ValidarUsoCore/ValidarUso.core.dart';
import 'package:rvaapp/src/Providers/ValidarUsoProvider/ValidarUso.provider.dart';

class AppBarController {
  IValidarUsoCore validarUsoCore = new ValidarUsoCore(new ValidarUsoProvider());

  verificarUsoApp(BuildContext context) {
    validarUsoCore.validarUsoApp(context);
  }
}
