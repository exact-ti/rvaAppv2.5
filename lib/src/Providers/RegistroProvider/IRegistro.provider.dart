import 'package:rvaapp/src/models/AgenciaModel.dart';

abstract class IRegistroProvider {
  Future<bool> registroCodigoRecojo(dynamic dataMap);

  Future<bool> registroCodigoEntrega(dynamic dataMap);

  Future<List<AgenciaModel>> listarAgenciaModalidad(dynamic dataMap);

  Future<List<AgenciaModel>> listarAgenciaRecojo(dynamic dataMap);

  Future<List<AgenciaModel>> listarAgenciaEntrega(dynamic dataMap);
}
