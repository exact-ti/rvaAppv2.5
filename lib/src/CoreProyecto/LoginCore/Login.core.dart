import 'package:rvaapp/src/ModelDto/BuzonModel.dart';
import 'package:rvaapp/src/Providers/LoginProvider/ILogin.provider.dart';
import 'package:rvaapp/src/preferencias_usuario/preferencias_usuario.dart';
import 'ILogin.core.dart';

class LoginCore implements ILoginCore {
  final _prefs = new PreferenciasUsuario();

  ILoginProvider loginProvider;

  LoginCore(ILoginProvider loginProvider) {
    this.loginProvider = loginProvider;
  }

  @override
  Future<BuzonModel> login(String username, String password) async {
    BuzonModel buzonprovider = await loginProvider.login(username, password);
    if (buzonprovider == null) return null;
    _prefs.buzon = buzonprovider;
    return buzonprovider;
  }
}
