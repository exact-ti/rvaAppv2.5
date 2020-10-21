import 'package:rvaapp/src/Providers/InputProvider/IInput.provider.dart';
import 'package:rvaapp/src/Util/utils.dart';
import 'package:rvaapp/src/enum/TipoAgencia.dart';
import 'package:rvaapp/src/models/InputModel.dart';
import 'IInput.core.dart';

class InputCore implements IInputCore {

  IInputProvider inputProvider;

  InputCore(IInputProvider inputProvider) {
    this.inputProvider = inputProvider;
  }

  @override
  Future<List<InputModel>> listarInputs() async {
      return await inputProvider.listarInput(TipoAgenciaEnum.idAgenciaLima, 12, buzonId());
  }
}
