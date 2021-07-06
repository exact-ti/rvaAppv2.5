import 'package:rvaapp/src/models/AgenciaModel.dart';
import 'package:rvaapp/src/models/CampoModel.dart';

abstract class IRegistroCore {

    Future<bool> registrocodigoCore(bool modo, String codigoAgencia, List<CampoModel> listCampo);

    Future<AgenciaModel> listarAgencias(String codigo, bool modo);

}
