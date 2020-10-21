class CampoModel {
  int id;
  String valor;

  CampoModel(int id,String valor){
      this.id=id;
      this.valor=valor;
  }


  List<CampoModel> fromProvider(List<dynamic> jsons) {
    List<CampoModel> inputs = List();
    for (Map<String, dynamic> json in jsons) {
      CampoModel inputModel = new CampoModel(json["iId"],json["titulo"]);
      inputs.add(inputModel);
    }
    return inputs;
  }
}
