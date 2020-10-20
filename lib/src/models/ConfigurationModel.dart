import 'dart:convert';

String utdModelToJson(ConfigurationModel data) => json.encode(data.toJson() );


class ConfigurationModel {
  bool valido;
  bool envio;
  bool recojo;

    ConfigurationModel fromProvider(List< dynamic> jsons){
           ConfigurationModel configurationModel = new ConfigurationModel();
        for(Map<String, dynamic> json in jsons){
            configurationModel.valido  = json["valido"];
            configurationModel.envio  = json["envio"];
            configurationModel.recojo = json["recojo"];
        }
          return configurationModel;
    }


    ConfigurationModel fromPreferencs(var json){
       ConfigurationModel configurationModel= new ConfigurationModel();
            configurationModel.valido  = json["valido"];
            configurationModel.envio  = json["envio"];
            configurationModel.recojo = json["recojo"];                      
          return configurationModel;
    }
  
    Map<String, dynamic> toJson() => {
        "valido"         : valido,
        "envio"     : envio,
        "recojo"  : recojo  
    };

}