import 'dart:convert';

String utdModelToJson(BuzonModel data) => json.encode(data.toJson() );


class BuzonModel {
  String idUsuario;
  String usuario;
  String clave;
  String nombre;
  String apellido;
  String fecharegistro;
  int idtipo;
  int idactivo;
  int idGrupo;  
  int idTipoUsuario;

    BuzonModel fromProvider(List< dynamic> jsons){
           BuzonModel buzon = new BuzonModel();
        
        for(Map<String, dynamic> json in jsons){
            buzon.idUsuario  = json["sIdUsuario"];
            buzon.usuario  = json["sUsuario"];
            buzon.clave = json["sClave"];
            buzon.apellido  = json["sNombre"];
            buzon.nombre  = json["sApellido"];
            buzon.fecharegistro = json["dFechaRegistroJSON"];
            buzon.idtipo  = json["iIdTipo"];
            buzon.idactivo  = json["iActivo"];
            buzon.idGrupo = json["iGrupo"];
            buzon.idTipoUsuario = json["idTipoUsuario"];
        }
          return buzon;
    }


    BuzonModel fromPreferencs(var json){
       BuzonModel buzones= new BuzonModel();
            buzones.idUsuario  = json["sIdUsuario"];
            buzones.usuario  = json["sUsuario"];
            buzones.clave = json["sClave"];
            buzones.apellido  = json["sNombre"];
            buzones.nombre  = json["sApellido"];
            buzones.fecharegistro = json["dFechaRegistroJSON"];
            buzones.idtipo  = json["iIdTipo"];
            buzones.idactivo  = json["iActivo"];
            buzones.idGrupo = json["iGrupo"];                        
          return buzones;
    }
  
    Map<String, dynamic> toJson() => {
        "sIdUsuario"         : idUsuario,
        "sUsuario"     : usuario,
        "sClave"  : clave,
        "sNombre"         : nombre,
        "sApellido"     : apellido,
        "dFechaRegistroJSON"  : fecharegistro,
        "iIdTipo"         : idtipo,
        "iActivo"     : idactivo,
        "iGrupo"  : idGrupo,        
    };

}