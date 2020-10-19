import 'package:rvaapp/src/ModelDto/BuzonModel.dart';

abstract class ILoginProvider {
  Future<BuzonModel> login(String username, String password);
}