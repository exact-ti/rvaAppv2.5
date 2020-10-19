

import 'package:rvaapp/src/ModelDto/AgenciaModel.dart';

abstract class IRegistroCore {

    Future<bool> registrocodigoCore(String codigo,bool modo,String codigosobre);

    Future<List<AgenciaModel>> listarAgencias(String codigo, bool modo);

}
