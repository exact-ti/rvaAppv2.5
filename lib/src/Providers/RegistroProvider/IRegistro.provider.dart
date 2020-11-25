import 'package:rvaapp/src/models/AgenciaModel.dart';

abstract class IRegistroProvider {
  
  Future<bool> registroCodigo(dynamic dataMap);

  Future<AgenciaModel> listarAgenciaModalidad(dynamic dataMap);

  Future<List<AgenciaModel>> listarAgenciaRecojo(dynamic dataMap);

  Future<List<AgenciaModel>> listarAgenciaEntrega(dynamic dataMap);
}
