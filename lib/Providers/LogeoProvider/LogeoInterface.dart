import 'package:rvaapp/ModelDto/BuzonModel.dart';

abstract class LogeoInterface {

  Future<BuzonModel> login(String username, String password);
  
}