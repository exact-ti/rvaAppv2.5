import 'package:dio/dio.dart';
import 'package:rvaapp/src/Requester/Requester.dart';
import 'package:rvaapp/src/models/BuzonModel.dart';
import 'ILogin.provider.dart';

class LoginProvider implements ILoginProvider {
  BuzonModel buzonModelclass = new BuzonModel();
  Requester req = Requester();
  @override
  Future<BuzonModel> login(String username, String password) async {
    Response resp = await req.get('/UsuarioWS.asmx/ValidarUsuario',
        params: {"sUsuario": username, "sPass": password});
    List<dynamic> decodedData = resp.data;
    if (decodedData.isEmpty) return null;
    return  buzonModelclass.fromProvider(decodedData);
  }
}
