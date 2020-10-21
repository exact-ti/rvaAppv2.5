import 'package:dio/dio.dart';
import 'package:rvaapp/src/Requester/Requester.dart';
import 'package:rvaapp/src/models/InputModel.dart';
import 'IInput.provider.dart';

class InputProvider implements IInputProvider {
  InputModel inputModel = new InputModel();
  Requester req = Requester();

  @override
  Future<List<InputModel>> listarInput(int idTipoAgencia, int idTipoRegistro, String idTipoUsuario) async {
/*     Response resp = await req.post('/UsuarioWS.asmx/ValidarUsuario', null, params: {
      "iIdTipoAgencia": idTipoAgencia,
      "iIdTipoRegistro": idTipoRegistro,
      "iIdTipoUsuario": idTipoUsuario
    });
    return inputModel.fromProvider(resp.data); */
    List<InputModel> listinputs = new List();
    InputModel inputModel = new InputModel();
    inputModel.id=1;
    inputModel.titulo="Input 1";
    inputModel.campo="Input 1";
    inputModel.idTipoCampo=2;
    inputModel.valorInicial="valor inicial 1";
    InputModel inputModel2 = new InputModel();
    inputModel2.id=2;
    inputModel2.titulo="Input 2";
    inputModel2.campo="Input 2";
    inputModel2.idTipoCampo=1;
    inputModel2.valorInicial="12456789";
    listinputs.add(inputModel);
    listinputs.add(inputModel2);
    InputModel inputModel3 = new InputModel();
    inputModel3.id=3;
    inputModel3.titulo="Input 3";
    inputModel3.campo="Input 3";
    inputModel3.idTipoCampo=2;
    inputModel3.valorInicial="";
    listinputs.add(inputModel3);
    InputModel inputModel4 = new InputModel();
    inputModel4.id=3;
    inputModel4.titulo="Input 4";
    inputModel4.campo="Input 4";
    inputModel4.idTipoCampo=2;
    inputModel4.valorInicial="valor inicial 4";
    listinputs.add(inputModel4);
    return listinputs;
  }
}
