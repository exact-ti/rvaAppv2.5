import 'package:rvaapp/src/ModelDto/BuzonModel.dart';

abstract class ILoginCore {
  Future<BuzonModel> login(String username, String password);
}
