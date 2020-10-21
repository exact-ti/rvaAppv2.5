class InputModel {
  int id;
  String titulo;
  String campo;
  int idTipoCampo;
  String valorInicial;
  String valor;

  List<InputModel> fromProvider(List<dynamic> jsons) {
    List<InputModel> inputs = List();
    for (Map<String, dynamic> json in jsons) {
      InputModel inputModel = new InputModel();
      inputModel.id = json["iId"];
      inputModel.titulo = json["titulo"];
      inputModel.campo = json["campo"];
      inputModel.idTipoCampo = json["iIdTipoCampo"];
      inputModel.valorInicial = json["valorInicial"];
      inputs.add(inputModel);
    }
    return inputs;
  }
}
