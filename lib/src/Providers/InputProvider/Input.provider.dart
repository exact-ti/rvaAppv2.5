import 'package:dio/dio.dart';
import 'package:rvaapp/src/Requester/Requester.dart';
import 'package:rvaapp/src/models/InputModel.dart';
import 'IInput.provider.dart';

class InputProvider implements IInputProvider {
  InputModel inputModel = new InputModel();
  Requester req = Requester();

  @override
  Future<List<InputModel>> listarInput(int idTipoAgencia, int idTipoRegistro, int idTipoUsuario) async {
   Response resp = await req.post('/ConfiguracionCampoWS.asmx/ListasCamposDinamicos', {
      "iIdTipoAgencia": idTipoAgencia,
      "iIdTipoRegistro": idTipoRegistro,
      "iIdTipoUsuario": idTipoUsuario
    }, params: null);
    return inputModel.fromProvider(resp.data); 
  }
}
