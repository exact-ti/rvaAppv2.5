import 'dart:convert';

String utdModelToJson(AgenciaModel data) => json.encode(data.toJson());

class AgenciaModel {
  String id;
  String nombre;
  int idtipo;
  String nombretipo;
  int estado;

  List<AgenciaModel> fromProvider(List<dynamic> jsons) {
    List<AgenciaModel> agencias = List();
    for (Map<String, dynamic> json in jsons) {
      AgenciaModel agencia = new AgenciaModel();
      agencia.nombre = json["nombreAgencia"];
      agencia.id = json["sId"];
      agencia.idtipo = json["idTipoTraslado"];
      agencia.nombretipo = json["tipoTraslado"];
      agencia.estado = json["idEstadoTraslado"];

      agencias.add(agencia);
    }
    return agencias;
  }

  AgenciaModel fromPreferencs(var json) {
    AgenciaModel buzones = new AgenciaModel();

      buzones.nombre = json["nombreAgencia"];
      buzones.id = json["sId"];
      buzones.idtipo = json["idTipoTraslado"];
      buzones.nombretipo = json["tipoTraslado"];
      buzones.estado = json["idEstadoTraslado"];

    return buzones;
  }

  Map<String, dynamic> toJson() => {
        "dFechaRegistroJSON": nombre,
        "iIdTipo": id,
      };
}
