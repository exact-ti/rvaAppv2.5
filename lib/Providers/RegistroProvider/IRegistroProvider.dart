import 'package:rvaapp/ModelDto/AgenciaModel.dart';

abstract class IRegistroProvider {

  Future<bool> registroCodigo(String codigo, String codigoSobre);

  Future<bool> registroCodigoEntrega(String codigo,String codigoSobre);

  Future<List<AgenciaModel>> listarAgenciaModalidad(String codigo, int i);


  Future<List<AgenciaModel>> listarAgenciaRecojo(String codigo);

  Future<List<AgenciaModel>> listarAgenciaEntrega(String codigo);

  
}