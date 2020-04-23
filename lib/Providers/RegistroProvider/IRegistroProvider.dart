import 'package:rvaapp/ModelDto/AgenciaModel.dart';

abstract class IRegistroProvider {

  Future<bool> registroCodigo(String codigo);

  Future<List<AgenciaModel>> listarAgencia(String codigo);


  
}