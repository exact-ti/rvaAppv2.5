import 'package:rvaapp/src/models/InputModel.dart';

abstract class IInputCore {
  Future<List<InputModel>> listarInputs(bool modoRecojo);
}
