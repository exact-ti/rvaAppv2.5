import 'package:rvaapp/src/Providers/InputProvider/IInput.provider.dart';
import 'package:rvaapp/src/Util/utils.dart';
import 'package:rvaapp/src/enum/TipoAgencia.dart';
import 'package:rvaapp/src/enum/TipoRegistro.dart';
import 'package:rvaapp/src/models/BuzonModel.dart';
import 'package:rvaapp/src/models/InputModel.dart';
import 'IInput.core.dart';

class InputCore implements IInputCore {
  IInputProvider inputProvider;

  InputCore(IInputProvider inputProvider) {
    this.inputProvider = inputProvider;
  }

  @override
  Future<List<InputModel>> listarInputs(bool modoRecojo) async {
    BuzonModel buzonModel = buzonPreferences();
    return await inputProvider.listarInput(
        TipoAgenciaEnum.idAgenciaLima, modoRecojo?TipoRegistro.TIPO_RECOJO:TipoRegistro.TIPO_ENTREGA, buzonModel.idTipoUsuario);
  }
}
