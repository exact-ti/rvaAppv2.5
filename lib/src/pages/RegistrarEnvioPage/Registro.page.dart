import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rvaapp/src/Configuration/config.dart';
import 'package:rvaapp/src/Util/utils.dart';
import 'package:rvaapp/src/enum/EstadosEnvios.dart';
import 'package:rvaapp/src/enum/TipoCampoEnum.dart';
import 'package:rvaapp/src/icons/theme_data.dart';
import 'package:rvaapp/src/models/AgenciaModel.dart';
import 'package:rvaapp/src/models/CampoModel.dart';
import 'package:rvaapp/src/models/InputModel.dart';
import 'package:rvaapp/src/pages/layout/app-bar/AppBar.page.dart';
import 'package:rvaapp/src/pages/layout/menu-bar/DrawerPage.dart';
import 'package:rvaapp/src/services/notificationProvider.dart';
import 'package:rvaapp/src/shared/modals/notification.dart';
import 'package:rvaapp/src/shared/widgets/ButtonWidget.dart';
import 'package:rvaapp/src/shared/widgets/InputWidget.dart';
import 'package:rvaapp/src/shared/widgets/LoadingWidget.dart';
import 'package:rvaapp/src/styles/theme_data.dart';
import 'Registro.controller.dart';

class HomePage extends StatefulWidget {
  final bool enRecojo;

  const HomePage({Key key, this.enRecojo}) : super(key: key);

  @override
  _HomePageState createState() => new _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _codigoController = TextEditingController();
  String valueCodigoController = "";
  List<TextEditingController> _listController;
  List<FocusNode> _fxs;
  RegistroController registroController = new RegistroController();
  FocusNode focusCodigo = new FocusNode();
  List<InputModel> listInputs;
  List<CampoModel> listCampo;
  AgenciaModel agenciaModel;
  bool enRecojo = true;
  int valorminimo, valormaximo;

  @override
  void initState() {
    inicializarState();
    super.initState();
  }

  inicializarState() async {
    listInputs = await registroController.listarInput(widget.enRecojo);
    _listController = List.generate(listInputs.length,
        (i) => TextEditingController(text: listInputs[i].valorInicial));
    _fxs = List.generate(listInputs.length, (i) => FocusNode());
    listCampo = List.generate(
        listInputs.length,
        (i) => CampoModel(listInputs[i].id, listInputs[i].valorInicial,
            listInputs[i].idTipoCampo));
    if (mounted) {
      setState(() {
        listInputs = listInputs;
        _listController = _listController;
        listCampo = listCampo;
      });
      valorminimo = properties['CARACTERES_MINIMOS'];
      valormaximo = properties['CARACTERES_MAXIMOS'];
    }
  }

  listarInput(bool modoRecojo) async {
    listInputs = await registroController.listarInput(modoRecojo);
    _listController = List.generate(listInputs.length,
        (i) => TextEditingController(text: listInputs[i].valorInicial));
    _fxs = List.generate(listInputs.length, (i) => FocusNode());
    listCampo = List.generate(
        listInputs.length,
        (i) => CampoModel(listInputs[i].id, listInputs[i].valorInicial,
            listInputs[i].idTipoCampo));
    setState(() {
      _listController = _listController;
      listCampo = listCampo;
      listInputs = listInputs;
    });
  }

  void inicializarValores() async {
    setState(() {
      valueCodigoController = "";
      _codigoController.clear();
      _listController = null;
      listInputs = null;
      listCampo = null;
      this.agenciaModel = null;
    });
  }

  void onPressedButton() {
    if (enRecojo) {
      if (agenciaModel != null &&
          this.agenciaModel.estado != EstadosEnviosEnum.VISITADA) {
        verificarenvio();
      }
    } else {
      if (agenciaModel != null &&
          this.agenciaModel.estado == EstadosEnviosEnum.ENVIADO) {
        verificarenvio();
      }
    }
  }

  Future<bool> validarInputs(String valorInput, int tipoCampoId) async {
    if (tipoCampoId == TipoCampoEnum.TYPENUMERO) {
      return true;
    } else {
      if (valorInput.length < properties['CARACTERES_MINIMOS']) {
        bool respuesta = await notification(context, "error", "EXACT",
            "Complete al menos $valorminimo caracteres");
        if (respuesta) return false;
      }
      if (valorInput.length > properties['CARACTERES_MAXIMOS']) {
        bool respuesta = await notification(context, "error", "EXACT",
            "El código sobrepasa los caracteres máximos");
        if (respuesta) return false;
      }
    }
    return true;
  }

  void validarLista() async {
    setState(() {
      this.agenciaModel = null;
      this.valueCodigoController = _codigoController.text;
    });
    if (_codigoController.text.length >= properties['CARACTERES_MINIMOS']) {
      this.agenciaModel = await registroController.listarAgencias(
          _codigoController.text, enRecojo);
      setState(() {
        this.agenciaModel = this.agenciaModel;
        this.valueCodigoController = this._codigoController.text;
      });
    } else {
      setState(() {
        this.valueCodigoController = this._codigoController.text;
      });
    }
  }

  void onchangeCodigo(valueCodigo) {
    validarLista();
  }

  verificarenvio() async {
    List<CampoModel> listaInputErrores = listCampo.where((element) {
      if (element.tipoCampoId == TipoCampoEnum.TYPENUMERO) {
        return false;
      } else {
        if (element.valor.length < properties['CARACTERES_MINIMOS'] &&
            element.valor.length > 0) {
          return true;
        }
        if (element.valor.length > properties['CARACTERES_MAXIMOS']) {
          return true;
        }
      }
      return false;
    }).toList();

    if (listaInputErrores.isEmpty) {
      desenfocarInputfx(context);
      bool respuestaRegistro = await registroController.recogerdocumento(
          context, _codigoController.text, enRecojo, listCampo);
      if (respuestaRegistro) {
        inicializarValores();
        listarInput(enRecojo);
      }
    } else if (listaInputErrores.length == 1) {
      String tituloError = listInputs
          .where((element) => element.id == listaInputErrores[0].id)
          .map((e) => e.titulo)
          .toList()
          .first;
      notification(context, "error", "EXACT",
          "El campo $tituloError no cumple con el formato requerido");
    } else {
      notification(context, "error", "EXACT",
          "Hay campos que no cumplen con el formato requerido");
    }
  }

  void onPressCodigo(dynamic valueCodigo) {
    setState(() {
      valueCodigoController = valueCodigo;
    });
    if (enRecojo) {
      if (this.agenciaModel != null &&
          this.agenciaModel.estado == EstadosEnviosEnum.PENDIENTE) {
        verificarenvio();
      } else {
        FocusScope.of(context).requestFocus(focusCodigo);
        if (_codigoController.text.length < valorminimo) {
          notification(context, "Error", "EXACT",
              'Llene al menos $valorminimo caracteres');
        }

        if (this.agenciaModel.estado == EstadosEnviosEnum.VACIO &&
            _codigoController.text.length >= valorminimo) {
          notification(context, "Error", "EXACT", 'No hay valijas pendientes');
        }
        if (this.agenciaModel.estado == EstadosEnviosEnum.VISITADA) {
          notification(context, "Error", "EXACT", 'La agencia ya fue visitada');
        }
      }
    } else {
      if (this.agenciaModel != null &&
          this.agenciaModel.estado == EstadosEnviosEnum.ENVIADO) {
        verificarenvio();
      } else {
        if (_codigoController.text.length < valorminimo) {
          notification(context, "Error", "EXACT",
              'Llene al menos $valorminimo caracteres');
        }
        if (_codigoController.text.length > valormaximo) {
          notification(context, "Error", "EXACT",
              'No sobrepase los $valormaximo caracteres');
        }

        if (this.agenciaModel.estado == EstadosEnviosEnum.VACIO) {
          notification(context, "Error", "EXACT", 'No existe la agencia');
        }
        if (this.agenciaModel.estado == EstadosEnviosEnum.ENVIADO) {
          notification(context, "Error", "EXACT", 'No hay valijas pendientes');
        }
        if (this.agenciaModel.estado == EstadosEnviosEnum.ENTREGADO) {
          notification(
              context, "Error", "EXACT", 'Las valijas ya fueron entregadas');
        }
        focusCodigo.unfocus();
        FocusScope.of(context).requestFocus(focusCodigo);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget crearItemAgencia(AgenciaModel agencia) {
      if (agencia.estado == 0) {
        return Container(
          height: 80,
          decoration: BoxDecoration(
            border: Border.all(color: StylesThemeData.SECOND_COLOR),
            color: StylesThemeData.SECOND_COLOR,
          ),
          child: Center(
              child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                child: Center(
                    child: Text(agencia.nombre,
                        style: TextStyle(
                            fontSize: 15,
                            color: Colors.black,
                            decorationStyle: TextDecorationStyle.wavy,
                            fontWeight: FontWeight.bold))),
              ),
            ],
          )),
        );
      }
      if (enRecojo) {
        if (agencia.estado == 1) {
          return Container(
            height: 80,
            decoration: BoxDecoration(
              border: Border.all(color: StylesThemeData.BORDER_COLOR),
              color: StylesThemeData.BORDER_COLOR,
            ),
            child: Center(
                child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  margin: const EdgeInsets.only(left: 20),
                  child: Center(
                      child: Text("Agencia:",
                          style: TextStyle(
                            fontSize: 15,
                            color: StylesThemeData.SUCCESS_COLOR,
                            decorationStyle: TextDecorationStyle.wavy,
                            fontStyle: FontStyle.normal,
                          ))),
                ),
                Container(
                  margin: const EdgeInsets.only(left: 10),
                  child: Center(
                      child: Text(agencia.nombre,
                          style: TextStyle(
                              fontSize: 15,
                              color: StylesThemeData.SUCCESS_COLOR,
                              decorationStyle: TextDecorationStyle.wavy,
                              fontWeight: FontWeight.bold))),
                ),
              ],
            )),
          );
        } else {
          return Container(
              height: 80,
              decoration: BoxDecoration(
                border: Border.all(color: StylesThemeData.BORDER_ERROR_COLOR),
                color: StylesThemeData.BORDER_ERROR_COLOR,
              ),
              child: Center(
                child: Text("LA AGENCIA YA FUE VISITADA",
                    style: TextStyle(
                        fontSize: 15,
                        color: StylesThemeData.LETTER_ERROR_COLOR,
                        decorationStyle: TextDecorationStyle.wavy,
                        fontWeight: FontWeight.bold)),
              ));
        }
      } else {
        if (agencia.estado == 6) {
          return Container(
            height: 80,
            decoration: BoxDecoration(
              border: Border.all(color: StylesThemeData.BORDER_COLOR),
              color: StylesThemeData.BORDER_COLOR,
            ),
            child: Center(
                child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  margin: const EdgeInsets.only(left: 20),
                  child: Center(
                      child: Text("Agencia:",
                          style: TextStyle(
                            fontSize: 15,
                            color: StylesThemeData.LETTER_COLOR,
                            decorationStyle: TextDecorationStyle.wavy,
                            fontStyle: FontStyle.normal,
                          ))),
                ),
                Container(
                  margin: const EdgeInsets.only(left: 20),
                  child: Center(
                      child: Text(agencia.nombre,
                          style: TextStyle(
                              fontSize: 15,
                              color: StylesThemeData.LETTER_COLOR,
                              decorationStyle: TextDecorationStyle.wavy,
                              fontWeight: FontWeight.bold))),
                ),
              ],
            )),
          );
        } else {
          return Container(
              height: 80,
              decoration: BoxDecoration(
                border: Border.all(color: StylesThemeData.BORDER_ERROR_COLOR),
                color: StylesThemeData.BORDER_ERROR_COLOR,
              ),
              child: Center(
                child: Text(
                    agencia.estado == 1
                        ? "Las valijas de esta agencia aún no fueron registradas por UTD"
                        : "Las valijas ya fueron entregadas a esta agencia",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 15,
                        color: StylesThemeData.LETTER_ERROR_COLOR,
                        decorationStyle: TextDecorationStyle.wavy,
                        fontWeight: FontWeight.bold)),
              ));
        }
      }
    }

    Widget switchDoble(bool switchParam) {
      return Center(
        child: Switch(
          value: switchParam,
          onChanged: (value) {
            desenfocarInputfx(context);
            setState(() {
              enRecojo = value;
            });
            inicializarValores();
            listarInput(enRecojo);
          },
          activeTrackColor: StylesThemeData.SWITCH_COLOR_SECONDARY_BODY,
          activeColor: StylesThemeData.PRIMARY_COLOR,
          inactiveThumbColor: StylesThemeData.PRIMARY_COLOR,
          inactiveTrackColor: StylesThemeData.SWITCH_COLOR_SECONDARY_BODY,
        ),
      );
    }

    Widget switchOne(bool switchParam) {
      setState(() {
        enRecojo = switchParam;
      });
      return Center(
        child: Switch(
          value: switchParam,
          onChanged: (value) {},
          activeTrackColor: StylesThemeData.SWITCH_COLOR_SECONDARY_BODY,
          activeColor: StylesThemeData.PRIMARY_COLOR,
        ),
      );
    }

    Widget validarTextSwitch() {
      if (Provider.of<NotificationConfiguration>(context).validarenvio &&
          Provider.of<NotificationConfiguration>(context).validarrecojo) {
        return Container(
          child: enRecojo != true ? Text("En entrega") : Text("En recojo"),
        );
      } else {
        if (Provider.of<NotificationConfiguration>(context).validarrecojo) {
          return Container(
            child: Text("En recojo"),
          );
        } else {
          return Container(
            child: Text("En entrega"),
          );
        }
      }
    }

    Widget validartypeSwitch() {
      if (Provider.of<NotificationConfiguration>(context).validarenvio &&
          Provider.of<NotificationConfiguration>(context).validarrecojo) {
        return switchDoble(enRecojo);
      } else {
        if (Provider.of<NotificationConfiguration>(context).validarrecojo) {
          return switchOne(true);
        } else {
          return switchOne(false);
        }
      }
    }

    Future _scannerCodAgencia() async {
      desenfocarInputfx(context);
      var result = await BarcodeScanner.scan();
      _codigoController.text = result.rawContent;
      validarLista();
    }

    Widget listarAgencia(AgenciaModel agencia, String codigoAgencia) {
      if (codigoAgencia.length < properties['CARACTERES_MINIMOS']) {
        return Container(
          margin: EdgeInsets.only(top: 20, bottom: 20),
        );
      }

      if (agencia == null &&
          codigoAgencia.length >= properties['CARACTERES_MINIMOS']) {
        return Center(
            child: Container(
          margin: EdgeInsets.only(top: 20, bottom: 20),
          child: LoadingWidget(),
        ));
      }

      return Container(
          height: 80,
          margin: EdgeInsets.only(top: 40, bottom: 40),
          alignment: Alignment.center,
          width: double.infinity,
          child: crearItemAgencia(agencia));
    }

    Widget switchWidget() {
      return Container(
          alignment: Alignment.bottomLeft,
          margin: EdgeInsets.only(top: 10),
          width: double.infinity,
          child: Container(
            child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.all(0.0),
                    child: validartypeSwitch(),
                  ),
                  Expanded(
                    child: validarTextSwitch(),
                    flex: 3,
                  )
                ]),
          ));
    }

    Widget listarInputs(List<InputModel> listInputs) {
      if (listInputs == null ||
          this.listCampo == null ||
          (listInputs != null && this._listController.isEmpty))
        return Center(
            child: Container(
          margin: EdgeInsets.only(top: 20, bottom: 20),
          child: LoadingWidget(),
        ));
      if (listInputs.isEmpty ||
          this.listCampo.isEmpty ||
          this._listController.isEmpty) return Container();
      List<Widget> listwidget = new List();
      InputModel latestElement = listInputs[listInputs.length - 1];
      for (int i = 0; i < listInputs.length; i++) {
        listwidget.add(Column(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(
                  bottom: listInputs[i].id != latestElement.id ? 20 : 0),
              child: InputWidget(
                controller: this._listController[i],
                focusInput: _fxs[i],
                hinttext: listInputs[i].titulo,
                idTipoCampo: listInputs[i].idTipoCampo,
                iconSufix: IconsData.ICON_CAMERA,
                methodOnPressed: (value) async {
                  if (await validarInputs(value, listInputs[i].idTipoCampo)) {
                    this.listCampo[i].valor = value;
                    this.listCampo[i].tipoCampoId = listInputs[i].idTipoCampo;
                    if (listInputs[i].id != latestElement.id) {
                      enfocarInputfx(context, _fxs[i + 1]);
                    }
                  } else {
                    this.listCampo[i].valor = "";
                    enfocarInputfx(context, _fxs[i]);
                  }
                },
                methodOnChange: (value) {
                  this.listCampo[i].valor = value;
                  this.listCampo[i].tipoCampoId = listInputs[i].idTipoCampo;
                },
                methodOnPressedSufix: () async {
                  desenfocarInputfx(context);
                  var result = await BarcodeScanner.scan();
                  if (await validarInputs(
                      result.rawContent, listInputs[i].idTipoCampo)) {
                    setState(() {
                      this.listCampo[i].valor = result.rawContent;
                      this.listCampo[i].tipoCampoId = listInputs[i].idTipoCampo;
                      this._listController[i].text = result.rawContent;
                    });
                    if (listInputs[i].id != latestElement.id) {
                      enfocarInputfx(context, _fxs[i + 1]);
                    }
                  } else {
                    setState(() {
                      this.listCampo[i].valor = result.rawContent;
                      this.listCampo[i].tipoCampoId = listInputs[i].idTipoCampo;
                      this._listController[i].text = result.rawContent;
                    });
                    enfocarInputfx(context, _fxs[i]);
                  }
                },
              ),
            )
          ],
        ));
      }
      return Column(
        children: listwidget,
      );
    }

    return Scaffold(
        appBar: CustomAppBar(text: "Registro de visita"),
        drawer: DrawerPage(),
        body: SingleChildScrollView(
            child: Padding(
          padding: EdgeInsets.only(left: 20, right: 20),
          child: Column(
            children: <Widget>[
              switchWidget(),
              Container(
                margin: EdgeInsets.only(bottom: 20),
                child: InputWidget(
                    controller: _codigoController,
                    focusInput: focusCodigo,
                    iconSufix: IconsData.ICON_CAMERA,
                    iconPrefix: IconsData.ICON_QR,
                    methodOnChange: onchangeCodigo,
                    methodOnPressed: onPressCodigo,
                    methodOnPressedSufix: _scannerCodAgencia,
                    hinttext: "Código"),
              ),
              listarInputs(this.listInputs),
              listarAgencia(this.agenciaModel, this.valueCodigoController),
              ButtonWidget(
                  onPressed: onPressedButton,
                  iconoButton: IconsData.ICON_SEND,
                  colorParam: enRecojo
                      ? this.agenciaModel != null &&
                              agenciaModel.estado != EstadosEnviosEnum.VACIO &&
                              agenciaModel.estado != EstadosEnviosEnum.VISITADA
                          ? StylesThemeData.PRIMARY_COLOR
                          : StylesThemeData.DISABLE_COLOR
                      : this.agenciaModel != null &&
                              agenciaModel.estado != EstadosEnviosEnum.VACIO &&
                              agenciaModel.estado == EstadosEnviosEnum.ENVIADO
                          ? StylesThemeData.PRIMARY_COLOR
                          : StylesThemeData.DISABLE_COLOR,
                  texto: 'Registrar')
            ],
          ),
        )));
  }
}
