import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:rvaapp/src/Configuration/config.dart';
import 'package:rvaapp/src/Util/utils.dart';
import 'package:rvaapp/src/enum/EstadosEnvios.dart';
import 'package:rvaapp/src/enum/TipoCampoEnum.dart';
import 'package:rvaapp/src/models/AgenciaModel.dart';
import 'package:rvaapp/src/models/CampoModel.dart';
import 'package:rvaapp/src/models/InputModel.dart';
import 'package:rvaapp/src/pages/layout/app-bar/AppBar.page.dart';
import 'package:rvaapp/src/services/notificationProvider.dart';
import 'package:rvaapp/src/shared/modals/notification.dart';
import 'package:rvaapp/src/styles/theme_data.dart';
import 'Registro.controller.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => new _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _bandejaController = TextEditingController();
  List<TextEditingController> _listController = [];
  RegistroController principalcontroller = new RegistroController();
  List<InputModel> listInput = new List();
  List<CampoModel> listCampo = new List();
  String codigobandeja = "";
  List<AgenciaModel> agencias;
  int estadoenvio = 0;
  int estadoentrega = 0;
  bool isSwitched = true;
  FocusNode f1 = new FocusNode();
  List<FocusNode> _fxs = [];
  int valorminimo, valormaximo;

  @override
  void initState() {
    inicializarState();
    super.initState();
  }

  inicializarState() async {
    listInput = await principalcontroller.listarInput();
    if (mounted) {
      _listController = List.generate(listInput.length,
          (i) => TextEditingController(text: listInput[i].valorInicial));
      _fxs = List.generate(listInput.length, (i) => FocusNode());
      listCampo = List.generate(listInput.length, (i) => CampoModel(listInput[i].id,listInput[i].valorInicial));
      setState(() {
        listInput = listInput;
        _listController=_listController;
        listCampo=listCampo;
      });
      valorminimo = properties['CARACTERES_MINIMOS'];
      valormaximo = properties['CARACTERES_MAXIMOS'];
    }
  }

  inicializarValores() {
    setState(() {
      _bandejaController.text = "";
      _listController.clear();
      codigobandeja = "";
      agencias = null;
      estadoenvio = 0;
    });
    inicializarState(); 
  }

  verificarenvio() async {
    List<CampoModel> listaInputErrores = listCampo.where((element) {
      if (element.valor.length < properties['CARACTERES_MINIMOS'] &&
          element.valor.length > 0) {
        return true;
      }
      if (element.valor.length > properties['CARACTERES_MAXIMOS']) {
        return true;
      }
      return false;
    }).toList();

    if (listaInputErrores.isEmpty) {
      desenfocarInputfx(context);
      bool respuestaRegistro = await principalcontroller.recogerdocumento(
          context, _bandejaController.text, isSwitched, listCampo);
      if (respuestaRegistro) {
        inicializarValores(); 
      }
    } else if (listaInputErrores.length == 1) {
      String tituloError = listInput.where((element) => element.id==listaInputErrores[0].id).map((e) => e.titulo).toList().first;
      notification(context, "error", "EXACT",
          "El campo $tituloError no cumple con el formato requerido");
    } else {
      notification(context, "error", "EXACT",
          "Hay campos que no cumplen con el formato requerido");
    }
  }

  @override
  Widget build(BuildContext context) {

    Widget crearItemAgencia(AgenciaModel usuario) {
      if (isSwitched) {
        if (usuario.estado == 1) {
          return Container(
            height: screenHeightExcludingToolbar(context, dividedBy: 10),
            decoration: BoxDecoration(
              border: Border.all(color: StylesThemeData.BORDERCOLOR),
              color: StylesThemeData.BORDERCOLOR,
            ),
            child: Center(
                child: Row(
              children: <Widget>[
                Container(
                  margin: const EdgeInsets.only(left: 20),
                  child: Center(
                      child: Text("Agencia:",
                          style: TextStyle(
                            fontSize: 15,
                            color: StylesThemeData.SUCCESSCOLOR,
                            decorationStyle: TextDecorationStyle.wavy,
                            fontStyle: FontStyle.normal,
                          ))),
                ),
                Container(
                  margin: const EdgeInsets.only(left: 20),
                  child: Center(
                      child: Text(usuario.nombre,
                          style: TextStyle(
                              fontSize: 15,
                              color: StylesThemeData.SUCCESSCOLOR,
                              decorationStyle: TextDecorationStyle.wavy,
                              fontWeight: FontWeight.bold))),
                ),
              ],
            )),
          );
        } else {
          return Container(
              height: screenHeightExcludingToolbar(context, dividedBy: 10),
              decoration: BoxDecoration(
                border: Border.all(color: StylesThemeData.BORDER_ERRORCOLOR),
                color: StylesThemeData.BORDER_ERRORCOLOR,
              ),
              child: Center(
                child: Text("LA AGENCIA YA FUE VISITADA",
                    style: TextStyle(
                        fontSize: 15,
                        color: StylesThemeData.LETTER_ERRORCOLOR,
                        decorationStyle: TextDecorationStyle.wavy,
                        fontWeight: FontWeight.bold)),
              ));
        }
      } else {
        if (usuario.estado == 6) {
          return Container(
            height: screenHeightExcludingToolbar(context, dividedBy: 10),
            decoration: BoxDecoration(
              border: Border.all(color: StylesThemeData.BORDERCOLOR),
              color: StylesThemeData.BORDERCOLOR,
            ),
            child: Center(
                child: Row(
              children: <Widget>[
                Container(
                  margin: const EdgeInsets.only(left: 20),
                  child: Center(
                      child: Text("Agencia:",
                          style: TextStyle(
                            fontSize: 15,
                            color: StylesThemeData.LETTERCOLOR,
                            decorationStyle: TextDecorationStyle.wavy,
                            fontStyle: FontStyle.normal,
                          ))),
                ),
                Container(
                  margin: const EdgeInsets.only(left: 20),
                  child: Center(
                      child: Text(usuario.nombre,
                          style: TextStyle(
                              fontSize: 15,
                              color: StylesThemeData.LETTERCOLOR,
                              decorationStyle: TextDecorationStyle.wavy,
                              fontWeight: FontWeight.bold))),
                ),
              ],
            )),
          );
        } else {
          return Container(
              height: screenHeightExcludingToolbar(context, dividedBy: 10),
              decoration: BoxDecoration(
                border: Border.all(color: StylesThemeData.BORDER_ERRORCOLOR),
                color: StylesThemeData.BORDER_ERRORCOLOR,
              ),
              child: Center(
                child: Text(
                    usuario.estado == 1
                        ? "Las valijas de esta agencia aún no fueron registradas por UTD"
                        : "Las valijas ya fueron entregadas a esta agencia",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 15,
                        color: StylesThemeData.LETTER_ERRORCOLOR,
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
              isSwitched = value;
            });
            inicializarValores();
          },
          activeTrackColor: StylesThemeData.SWITCHCOLOR,
          activeColor: StylesThemeData.PRIMARYCOLOR,
        ),
      );
    }

    Widget switchOne(bool switchParam) {
      setState(() {
        isSwitched = switchParam;
      });
      return Center(
        child: Switch(
          value: switchParam,
          onChanged: (value) {},
          activeTrackColor: StylesThemeData.SWITCHCOLOR,
          activeColor: StylesThemeData.PRIMARYCOLOR,
        ),
      );
    }

    Widget validarTextSwitch() {
      if (Provider.of<NotificationConfiguration>(context).validarenvio &&
          Provider.of<NotificationConfiguration>(context).validarrecojo) {
        return Container(
          child: isSwitched != true ? Text("En entrega") : Text("En recojo"),
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
        return switchDoble(isSwitched);
      } else {
        if (Provider.of<NotificationConfiguration>(context).validarrecojo) {
          return switchOne(true);
        } else {
          return switchOne(false);
        }
      }
    }

    Widget mostrarmensaje() {
      return Container(
        height: screenHeightExcludingToolbar(context, dividedBy: 10),
        child: Center(
            child: Container(
          child: Center(
              child: Text("No existe la agencia",
                  style: TextStyle(
                    fontSize: 15,
                    color: StylesThemeData.LETTERCOLOR,
                    decorationStyle: TextDecorationStyle.wavy,
                    fontStyle: FontStyle.normal,
                  ))),
        )),
      );
    }

    void validarLista() async {
      if (_bandejaController.text.length >= properties['CARACTERES_MINIMOS']) {
        agencias =
            await principalcontroller.listarAgencias(codigobandeja, isSwitched);
        if (agencias != null) {
          for (AgenciaModel agencia in agencias) {
            if (isSwitched) {
              setState(() {
                codigobandeja = codigobandeja;
                estadoenvio = agencia.estado;
              });
            } else {
              setState(() {
                codigobandeja = codigobandeja;
                estadoentrega = agencia.estado;
              });
            }
          }
        } else {
          setState(() {
            estadoentrega = 0;
            estadoenvio = 0;
            agencias = null;
            codigobandeja = codigobandeja;
          });
        }
      } else {
        setState(() {
          agencias = null;
          codigobandeja = codigobandeja;
        });
      }
    }

    Future<bool> validarInputs(String valorInput) async {
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
      return true;
    }

    Future _scannerCodAgencia() async {
        desenfocarInputfx(context);
        var result = await BarcodeScanner.scan();
        _bandejaController.text = result.rawContent;
        codigobandeja = result.rawContent;
        validarLista();
    }

    Widget listarAgencia() {
      return Container(
          alignment: Alignment.center,
          width: double.infinity,
          margin: EdgeInsets.only(top: 40),
          height: screenHeightExcludingToolbar(context, dividedBy: 10),
          child: codigobandeja.length < properties['CARACTERES_MINIMOS']
              ? Container()
              : agencias != null
                  ? ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                      itemCount: agencias.length,
                      itemBuilder: (context, i) =>
                          crearItemAgencia(agencias[i]))
                  : mostrarmensaje());
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

    Widget codAgenciaWidget() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Container(
              margin: const EdgeInsets.only(top: 20, bottom: 10),
              alignment: Alignment.bottomLeft,
              width: double.infinity,
              child: Text("Código")),
          Container(
              margin: const EdgeInsets.only(bottom: 10),
              alignment: Alignment.centerLeft,
              width: double.infinity,
              child: Row(children: <Widget>[
                Expanded(
                  child: TextFormField(
                    focusNode: f1,
                    keyboardType: TextInputType.text,
                    controller: _bandejaController,
                    textInputAction: TextInputAction.done,
                    onFieldSubmitted: (value) {
                      setState(() {
                        codigobandeja = value;
                      });
                      if (isSwitched) {
                        if (agencias != null && estadoenvio == 1) {
                          enfocarInputfx(context, _fxs[1]);
                        } else {
                          FocusScope.of(context).requestFocus(f1);
                          if (codigobandeja.length < valorminimo) {
                            notification(context, "Error", "EXACT",
                                'Llene al menos $valorminimo caracteres');
                          }

                          if (estadoenvio == 0 &&
                              codigobandeja.length >= valorminimo) {
                            notification(
                                context, "Error", "EXACT", 'No hay va');
                          }
                          if (estadoenvio == 2) {
                            notification(context, "Error", "EXACT",
                                'La agencia ya fue visitada');
                          }
                        }
                      } else {
                        if (agencias != null && estadoentrega == 6) {
                          enfocarInputfx(context, _fxs[1]);
                        } else {
                          if (codigobandeja.length < valorminimo) {
                            notification(context, "Error", "EXACT",
                                'Llene al menos $valorminimo caracteres');
                          }
                          if (codigobandeja.length > valormaximo) {
                            notification(context, "Error", "EXACT",
                                'No sobrepase los $valormaximo caracteres');
                          }

                          if (estadoentrega == 0) {
                            notification(context, "Error", "EXACT",
                                'No existe la agencia');
                          }
                          if (estadoentrega == 1) {
                            notification(context, "Error", "EXACT",
                                'No hay valijas pendientes');
                          }
                          if (estadoentrega == 7) {
                            notification(context, "Error", "EXACT",
                                'Las valijas ya fueron entregadas');
                          }
                          f1.unfocus();
                          FocusScope.of(context).requestFocus(f1);
                        }
                      }
                    },
                    onChanged: (text) {
                      codigobandeja = text;
                      validarLista();
                    },
                    decoration: InputDecoration(
                      contentPadding: new EdgeInsets.symmetric(
                          vertical: 5.0, horizontal: 10.0),
                      filled: true,
                      fillColor: StylesThemeData.INPUTCOLOR,
                      errorStyle: TextStyle(color: Colors.red, fontSize: 15.0),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(color: Colors.blue),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(
                          color: StylesThemeData.INPUTCOLOR,
                          width: 0.0,
                        ),
                      ),
                    ),
                  ),
                  flex: 5,
                ),
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(left: 15),
                    child: new IconButton(
                        icon: Icon(Icons.camera_alt),
                        tooltip: "Increment",
                        onPressed: _scannerCodAgencia),
                  ),
                ),
              ]))
        ],
      );
    }

    Widget listarInputs(List<InputModel> listInputs) {
      List<Widget> listwidget = new List();
      if (listInputs.isEmpty) return Container();
      InputModel latestElement = listInputs[listInputs.length - 1];
      for (int i = 0; i < listInputs.length; i++) {
        listwidget.add(Column(
          children: <Widget>[
            Container(
                margin: EdgeInsets.only(top: 20, bottom: 10),
                alignment: Alignment.bottomLeft,
                width: double.infinity,
                child: Text(listInputs[i].titulo)),
            Container(
                margin: EdgeInsets.only(bottom: 10),
                alignment: Alignment.centerLeft,
                width: double.infinity,
                child: Row(children: <Widget>[
                  Expanded(
                    child: TextFormField(
                        focusNode: _fxs[i],
                        keyboardType: listInputs[i].idTipoCampo ==
                                TipoCampoEnum.TYPENUMERO
                            ? TextInputType.number
                            : TextInputType.text,
                        controller: _listController[i],
                        textInputAction: TextInputAction.done,
                        decoration: InputDecoration(
                          contentPadding: new EdgeInsets.symmetric(
                              vertical: 5.0, horizontal: 10.0),
                          filled: true,
                          fillColor: StylesThemeData.INPUTCOLOR,
                          errorStyle:
                              TextStyle(color: Colors.red, fontSize: 15.0),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: BorderSide(color: Colors.blue),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: BorderSide(
                              color: StylesThemeData.INPUTCOLOR,
                              width: 0.0,
                            ),
                          ),
                        ),
                        onFieldSubmitted: (value) async {
                          if (await validarInputs(value)) {
                            listCampo[i].valor = value;
                            if (listInputs[i].id != latestElement.id) {
                              enfocarInputfx(context, _fxs[i + 1]);
                            }
                          } else {
                            listCampo[i].valor = "";
                            enfocarInputfx(context, _fxs[i]);
                          }
                        },
                        onChanged: (text) {
                          listCampo[i].valor = text;
                        }),
                    flex: 5,
                  ),
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.only(left: 15),
                      child: new IconButton(
                          icon: Icon(Icons.camera_alt),
                          tooltip: "Increment",
                          onPressed: () async {
                            desenfocarInputfx(context);
                            var result = await BarcodeScanner.scan();
                            if (await validarInputs(result.rawContent)) {
                              _listController[i].text = result.rawContent;
                              if (listInputs[i].id != latestElement.id) {
                                enfocarInputfx(context, _fxs[i + 1]);
                              }
                            } else {
                              _listController[i].text = result.rawContent;
                              enfocarInputfx(context, _fxs[i]);
                            }
                          }),
                    ),
                  ),
                ])),
          ],
        ));
      }
      return Column(
        children: listwidget,
      );
    }

    Widget buttonSend() {
      return Container(
          margin: EdgeInsets.only(bottom: 40),
          alignment: FractionalOffset.bottomCenter,
          height: screenHeightExcludingToolbar(context, dividedBy: 5),
          width: double.infinity,
          child: Container(
              margin: const EdgeInsets.only(top: 40),
              child: ButtonTheme(
                minWidth: 130.0,
                height: 40.0,
                child: RaisedButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  onPressed: () {
                    if (isSwitched) {
                        if (agencias != null && estadoenvio != EstadosEnviosEnum.ENVIADO) {
                          verificarenvio();
                        }
                      
                    } else {
                        if (agencias != null && estadoentrega == EstadosEnviosEnum.ENVIADO) {
                          verificarenvio();
                        }
                      
                    }
                  },
                  color: isSwitched
                      ? agencias != null && estadoenvio != EstadosEnviosEnum.ENVIADO
                          ? StylesThemeData.PRIMARYCOLOR
                          : StylesThemeData.DISABLECOLOR
                      : agencias != null && estadoentrega == EstadosEnviosEnum.ENVIADO
                          ? StylesThemeData.PRIMARYCOLOR
                          : StylesThemeData.DISABLECOLOR,
                  child:
                      Text('Registrar', style: TextStyle(color: Colors.white)),
                ),
              )));
    }

    return Scaffold(
        appBar: CustomAppBar(text: "Registro de visita"),
        drawer: crearMenu(context),
        body: SingleChildScrollView(
            child: Padding(
          padding: EdgeInsets.only(left: 20, right: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              switchWidget(),
              codAgenciaWidget(),
              listarInputs(listInput),
              listarAgencia(),
              buttonSend()
            ],
          ),
        )));
  }
}
