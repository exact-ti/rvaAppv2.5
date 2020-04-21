import 'dart:convert';

String utdModelToJson(AgenciaModel data) => json.encode(data.toJson() );


class AgenciaModel {

  int id;
  String nombre;



    List<AgenciaModel> fromProvider(List< dynamic> jsons){
      List<AgenciaModel> agencias = List();
        for(Map<String, dynamic> json in jsons){
        AgenciaModel agencia = new AgenciaModel();
            agencia.nombre = json["dFechaRegistroJSON"];
            agencia.id  = json["iIdTipo"]; 
            agencias.add(agencia);
        }
          return agencias;
    }


    AgenciaModel fromPreferencs(var json){
       AgenciaModel buzones= new AgenciaModel();

            buzones.nombre = json["dFechaRegistroJSON"];
            buzones.id  = json["iIdTipo"];
                     
          return buzones;
    }
  
    Map<String, dynamic> toJson() => {
        "dFechaRegistroJSON"  : nombre,
        "iIdTipo"         : id,
    };

}