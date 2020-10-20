import 'package:rvaapp/src/models/BuzonModel.dart';

abstract class ILoginProvider {
  Future<BuzonModel> login(String username, String password);
}