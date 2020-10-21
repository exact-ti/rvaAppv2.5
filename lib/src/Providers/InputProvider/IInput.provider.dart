import 'package:rvaapp/src/models/InputModel.dart';

abstract class IInputProvider {
  Future<List<InputModel>> listarInput(int idTipoAgencia, int idTipoRegistro, String idTipoUsuario);
}