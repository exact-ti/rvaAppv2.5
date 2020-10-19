import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rvaapp/ModelDto/AgenciaModel.dart';
import 'package:rvaapp/Util/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'RegistroController.dart';
import 'package:rvaapp/Util/utils.dart';
import 'package:rvaapp/Configuration/config.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => new _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _bandejaController = TextEditingController();
  final _sobreController = TextEditingController();
  bool respondio = false;
  String codigobandeja = "";
  String codigosobre = "";
  RegistroController principalcontroller = new RegistroController();
  SharedPreferences sharedPreferences;
  List<AgenciaModel> agencias = null;
  bool validarboton = false;
  String qrbarra, valuess = "";
  int cantidadrespuesta = 0;
  int estadoenvio = 0;
  int estadoentrega = 0;
  bool buttonsend = true;
  bool buttoncamera = true;
  bool buttoncamera2 = true;
  bool isSwitched = true;
  FocusNode _focusNode;
  FocusNode f1 = FocusNode();
  FocusNode f2 = FocusNode();
  int valorminimo;
  int valormaximo;
  //Widget proba = Container();
  @override
  void initState() {
    valorminimo = properties['CARACTERES_MINIMOS'];
    valormaximo = properties['CARACTERES_MAXIMOS'];
    super.initState();
    _focusNode = FocusNode();
    _focusNode.addListener(() {
      if (_focusNode.hasFocus) _bandejaController.clear();
    });
    cargarPreferences();
  }

  var colorplomos = const Color(0xFFEAEFF2);
  @override
  Widget build(BuildContext context) {
    const SecondColor = const Color(0xFF6698AE);
    WidgetsBinding.instance.addPostFrameCallback((_) => onAfterBuild(context));

    void verificarenvio(BuildContext context) {
      if (_bandejaController.text != "") {
        if (_sobreController.text != "") {
          if (_sobreController.text.length >=
                  properties['CARACTERES_MINIMOS'] &&
              _sobreController.text.length < properties['CARACTERES_MAXIMOS']) {
            principalcontroller.recogerdocumento(context,
                _bandejaController.text, _sobreController.text, isSwitched);
            setState(() {
              _bandejaController.text = "";
              _sobreController.text = "";
              agencias = null;
              codigobandeja = "";
              codigosobre = "";
              buttonsend = true;
            });
            FocusScope.of(context).unfocus();
            new TextEditingController().clear();
          } else {
            if (_sobreController.text.length <
                properties['CARACTERES_MINIMOS']) {
              mostrarAlerta(context,
                  "Complete al menos $valorminimo caracteres", "Error");
            }
            if (_sobreController.text.length >
                properties['CARACTERES_MAXIMOS']) {
              mostrarAlerta(context,
                  "El código sobrepasa los caracteres máximos", "Error");
            }
          }
        } else {
          mostrarAlerta(context, "El Comprobante de servicio es obligatorio",
              "Codigo vacio");
        }
      } else {
        mostrarAlerta(context, "Primero registro el código para registrarlo",
            "Codigo vacio");
      }
    }

    bool cantidadletras(String codigo) {
      if (codigo.length >= properties['CARACTERES_MINIMOS'] &&
          codigo.length < properties['CARACTERES_MAXIMOS']) {
        return true;
      } else {
        return false;
      }
    }

    final sendButton = Container(
        margin: const EdgeInsets.only(top: 40),
        child: ButtonTheme(
          minWidth: 130.0,
          height: 40.0,
          child: RaisedButton(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
            onPressed: () {
              if (buttonsend) {
                if (agencias != null &&
                    estadoenvio != 2 &&
                    cantidadletras(codigosobre)) {
                  buttonsend = false;
                  verificarenvio(context);
                }
              }
            },
            color: agencias != null &&
                    estadoenvio != 2 &&
                    cantidadletras(codigosobre)
                ? Color(0xFF2C6983)
                : colorletra,
            //padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
            child: Text('Registrar', style: TextStyle(color: Colors.white)),
          ),
        ));
    final sendButton2 = Container(
        margin: const EdgeInsets.only(top: 40),
        child: ButtonTheme(
          minWidth: 130.0,
          height: 40.0,
          child: RaisedButton(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
            onPressed: () {
              if (buttonsend) {
                if (agencias != null &&
                    estadoentrega == 6 &&
                    cantidadletras(codigosobre)) {
                  buttonsend = false;
                  verificarenvio(context);
                }
              }
            },
            color: agencias != null &&
                    estadoentrega == 6 &&
                    cantidadletras(codigosobre)
                ? Color(0xFF2C6983)
                : colorletra,
            //padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
            child: Text('Registrar', style: TextStyle(color: Colors.white)),
          ),
        ));

    final textBandeja = Container(
      child: Text("Código"),
    );

    final textSobre = Container(
      child: Text("Comprobante de Servicio"),
    );

    //codigobandeja

    Widget crearItem(AgenciaModel usuario) {
      if (isSwitched) {
        if (usuario.estado == 1) {
          return Container(
            height: screenHeightExcludingToolbar(context, dividedBy: 10),
            decoration: myBoxDecoration(usuario.estado),
            child: Center(
                child: Row(
              children: <Widget>[
                Container(
                  margin: const EdgeInsets.only(left: 20),
                  child: Center(
                      child: Text("Agencia:",
                          style: TextStyle(
                            fontSize: 15,
                            color: colorletra2,
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
                              color: colorletra2,
                              decorationStyle: TextDecorationStyle.wavy,
                              fontWeight: FontWeight.bold))),
                ),
              ],
            )),
          );
        } else {
          return Container(
              height: screenHeightExcludingToolbar(context, dividedBy: 10),
              decoration: myBoxDecoration(usuario.estado),
              child: Center(
                child: Text("LA AGENCIA YA FUE VISITADA",
                    style: TextStyle(
                        fontSize: 15,
                        color: Color(0xFF800001),
                        decorationStyle: TextDecorationStyle.wavy,
                        fontWeight: FontWeight.bold)),
              ));
        }
      } else {
        if (usuario.estado == 6) {
          return Container(
            height: screenHeightExcludingToolbar(context, dividedBy: 10),
            decoration: myBoxDecoration2(usuario.estado),
            child: Center(
                child: Row(
              children: <Widget>[
                Container(
                  margin: const EdgeInsets.only(left: 20),
                  child: Center(
                      child: Text("Agencia:",
                          style: TextStyle(
                            fontSize: 15,
                            color: colorletra2,
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
                              color: colorletra2,
                              decorationStyle: TextDecorationStyle.wavy,
                              fontWeight: FontWeight.bold))),
                ),
              ],
            )),
          );
        } else {
          return Container(
              height: screenHeightExcludingToolbar(context, dividedBy: 10),
              decoration: myBoxDecoration2(usuario.estado),
              child: Center(
                child: Text(
                    usuario.estado == 1
                        ? "Las valijas de esta agencia aún no fueron registradas por UTD"
                        : "Las valijas ya fueron entregadas a esta agencia",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 15,
                        color: Color(0xFF800001),
                        decorationStyle: TextDecorationStyle.wavy,
                        fontWeight: FontWeight.bold)),
              ));
        }
      }
    }

    final valorswitch = Center(
      child: Switch(
        value: isSwitched,
        onChanged: (value) {
                  FocusScope.of(context).unfocus();
          new TextEditingController().clear();
          setState(() {
            isSwitched = value;
            _bandejaController.text = "";
            _sobreController.text = "";
            respondio = false;
            codigobandeja = "";
            codigosobre = "";
            agencias = null;
            validarboton = false;
            qrbarra = "";
            cantidadrespuesta = 0;
            estadoenvio = 0;
            buttonsend = true;
            buttoncamera = true;
            buttoncamera2 = true;
          });
        },
        activeTrackColor: SecondColor,
        activeColor: PrimaryColor,
      ),
    );

    final contenerSwitch2 = Container(
      child:
          Row(crossAxisAlignment: CrossAxisAlignment.center, children: <Widget>[
        Container(
          padding: const EdgeInsets.all(0.0),
          child: valorswitch,
        ),
        /*valorswitch,*/
        Expanded(
          child: Container(
            child: isSwitched != true ? Text("En entrega") : Text("En recojo"),
          ),
          flex: 3,
        )
      ]),
    );
    Widget mostrarmensaje() {
      return Container(
        height: screenHeightExcludingToolbar(context, dividedBy: 10),
        child: Center(
            child: Container(
          child: Center(
              child: Text("No existe la agencia",
                  style: TextStyle(
                    fontSize: 15,
                    color: colorletra2,
                    decorationStyle: TextDecorationStyle.wavy,
                    fontStyle: FontStyle.normal,
                  ))),
        )),
      );
    }

    Widget listarwidget(List<AgenciaModel> usuarios) {
      if (usuarios != null) {
        return ListView.builder(
            itemCount: usuarios.length,
            itemBuilder: (context, i) => crearItem(usuarios[i]));
      } else {
        return mostrarmensaje();
      }
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
                buttoncamera = true;
              });
            } else {
              setState(() {
                codigobandeja = codigobandeja;
                estadoentrega = agencia.estado;
                buttoncamera = true;
              });
            }
          }
        } else {
          setState(() {
            estadoentrega = 0;
            estadoenvio=0;
            agencias = null;
            buttoncamera = true;
            codigobandeja = codigobandeja;
          });
        }
      } else {
        setState(() {
          cantidadrespuesta = 0;
          agencias = null;
          buttoncamera = true;
          codigobandeja = codigobandeja;
        });
      }
    }

    void validarLista2() async {
      if (_sobreController.text.length < properties['CARACTERES_MINIMOS']) {
        mostrarAlerta(
            context, "Complete al menos $valorminimo caracteres", "Error");
        setState(() {
          _sobreController.text = "";
          codigosobre = "";
          buttoncamera2 = true;
        });
      }
      if (_sobreController.text.length > properties['CARACTERES_MAXIMOS']) {
        mostrarAlerta(
            context, "El código sobrepasa los caracteres máximos", "Error");
        setState(() {
          _sobreController.text = "";
          codigosobre = "";
          buttoncamera2 = true;
        });
      }
      if (_sobreController.text.length >= properties['CARACTERES_MINIMOS'] &&
          _sobreController.text.length < properties['CARACTERES_MAXIMOS']) {
        setState(() {
          _sobreController.text = _sobreController.text;
          codigosobre = codigosobre;
          buttoncamera2 = true;
        });
      }
    }

    Future _traerdatosescanerBandeja() async {
      if (buttoncamera) {
        buttoncamera = false;
        FocusScope.of(context).unfocus();
        new TextEditingController().clear();
        var result = await BarcodeScanner.scan();
        _bandejaController.text = result.rawContent;
        codigobandeja = result.rawContent;
        validarLista();
      }
    }

    Future _traerdatosescanerSobre() async {
      if (buttoncamera2) {
        buttoncamera2 = false;
        FocusScope.of(context).unfocus();
        new TextEditingController().clear();
        var result = await BarcodeScanner.scan();
        _sobreController.text = result.rawContent;
        codigosobre = result.rawContent;
        validarLista2();
      }
    }

    Widget changetext2() {
      return new TextFormField(
        focusNode: f2,
        keyboardType: TextInputType.text,
        controller: _sobreController,
        textInputAction: TextInputAction.done,
        onFieldSubmitted: (value) {

          /*setState(() {

            _sobreController.text=value;
          });*/

          if (value.length < properties['CARACTERES_MINIMOS']) {
            mostrarAlerta(
                context, "Complete al menos $valorminimo caracteres", "Error");
                FocusScope.of(context).requestFocus(f2);
                
            /*setState(() {
              _sobreController.text = "";
              codigosobre = "";
            });*/
          }
          if (value.length > properties['CARACTERES_MAXIMOS']) {
            mostrarAlerta(
                context, "El código sobrepasa los caracteres máximos", "Error");
                FocusScope.of(context).requestFocus(f2);
            /*setState(() {
              _sobreController.text = "";
              codigosobre = "";
            });*/
          }
          if (value.length >= properties['CARACTERES_MINIMOS'] &&
              value.length < properties['CARACTERES_MAXIMOS']) {
        FocusScope.of(context).unfocus();
          new TextEditingController().clear();
            setState(() {
              _sobreController.text = _sobreController.text;
              codigosobre = codigosobre;
            });
          }
        },
        onChanged: (text) {
          setState(() {
            codigosobre = text;
          });
        },
        decoration: InputDecoration(
          contentPadding:
              new EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
          filled: true,
          fillColor: Color(0xFFEAEFF2),
          errorStyle: TextStyle(color: Colors.red, fontSize: 15.0),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide(color: Colors.blue),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide(
              color: Color(0xFFEAEFF2),
              width: 0.0,
            ),
          ),
        ),
      );
    }

    Widget changetext() {
      return new TextFormField(
        focusNode: f1,
        keyboardType: TextInputType.text,
        controller: _bandejaController,
        textInputAction: TextInputAction.done,
        onFieldSubmitted: (value) {
          setState(() {
            codigobandeja = value;
          });

        if(isSwitched){
          if (agencias != null && estadoenvio == 1) {
            //verificarenvio(context);
            f1.unfocus();
            FocusScope.of(context).requestFocus(f2);
          } else {
            FocusScope.of(context).requestFocus(f1);
            if (codigobandeja.length < valorminimo) {
              mostrarAlerta(
                  context, 'Llene al menos $valorminimo caracteres', 'Mensaje');
            }

            if (estadoenvio == 0 && codigobandeja.length >= valorminimo) {
              mostrarAlerta(context, 'No hay va', 'Mensaje');
            }
            if (estadoenvio == 2) {
              mostrarAlerta(context, 'La agencia ya fue visitada', 'Mensaje');
            }
          }
        }else{
         if (agencias != null && estadoentrega == 6) {
            //verificarenvio(context);
            f1.unfocus();
            FocusScope.of(context).requestFocus(f2);
          } else {
            if (codigobandeja.length < valorminimo) {
              mostrarAlerta(
                  context, 'Llene al menos $valorminimo caracteres', 'Mensaje');
            }
            if (codigobandeja.length > valormaximo) {
              mostrarAlerta(
                  context, 'No sobrepase los $valormaximo caracteres', 'Mensaje');
            }

             if (estadoentrega == 0) {
              mostrarAlerta(context, 'No existe la agencia', 'Mensaje');
            }
            if (estadoentrega == 1) {
              mostrarAlerta(context, 'No hay valijas pendientes', 'Mensaje');
            }
            if (estadoentrega == 7) {
              mostrarAlerta(context, 'Las valijas ya fueron entregadas', 'Mensaje');
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
          contentPadding:
              new EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
          filled: true,
          fillColor: Color(0xFFEAEFF2),
          errorStyle: TextStyle(color: Colors.red, fontSize: 15.0),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide(color: Colors.blue),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide(
              color: Color(0xFFEAEFF2),
              width: 0.0,
            ),
          ),
        ),
      );
    }

    final campodetextoandIconoBandeja = Row(children: <Widget>[
      Expanded(
        child: changetext(),
        flex: 5,
      ),
      Expanded(
        child: Container(
          margin: const EdgeInsets.only(left: 15),
          child: new IconButton(
              icon: Icon(Icons.camera_alt),
              tooltip: "Increment",
              onPressed: _traerdatosescanerBandeja),
        ),
      ),
    ]);

    final campodetextoandIconoSobre = Row(children: <Widget>[
      Expanded(
        child: changetext2(),
        flex: 5,
      ),
      Expanded(
        child: Container(
          margin: const EdgeInsets.only(left: 15),
          child: new IconButton(
              icon: Icon(Icons.camera_alt),
              tooltip: "Increment",
              onPressed: _traerdatosescanerSobre),
        ),
      ),
    ]);

    return Scaffold(
        appBar: ReusableWidgets.getAppBar('Registro de visita'),
        drawer: crearMenu(context),
        bottomNavigationBar: BottomAppBar(
          color: Colors.transparent,
          child: Container(
              margin: const EdgeInsets.only(bottom: 40),
              alignment: FractionalOffset.bottomCenter,
              height: screenHeightExcludingToolbar(context, dividedBy: 5),
              width: double.infinity,
              child: isSwitched ? sendButton : sendButton2),
          elevation: 0,
        ),
        body: SingleChildScrollView(
            child: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Align(
                alignment: Alignment.centerLeft,
                child: Container(
                    alignment: Alignment.bottomLeft,
                    height:
                        screenHeightExcludingToolbar(context, dividedBy: 12),
                    width: double.infinity,
                    child: contenerSwitch2),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Container(
                    margin: const EdgeInsets.only(top: 20),
                    alignment: Alignment.bottomLeft,
                    height:
                        screenHeightExcludingToolbar(context, dividedBy: 30),
                    width: double.infinity,
                    child: textBandeja),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    alignment: Alignment.centerLeft,
                    height:
                        screenHeightExcludingToolbar(context, dividedBy: 12),
                    width: double.infinity,
                    child: campodetextoandIconoBandeja),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Container(
                    alignment: Alignment.bottomLeft,
                    height:
                        screenHeightExcludingToolbar(context, dividedBy: 30),
                    width: double.infinity,
                    child: textSobre),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Container(
                    margin: const EdgeInsets.only(bottom: 40),
                    alignment: Alignment.centerLeft,
                    height:
                        screenHeightExcludingToolbar(context, dividedBy: 12),
                    width: double.infinity,
                    child: campodetextoandIconoSobre),
              ),
              Align(
                alignment: Alignment.center,
                child: Container(
                    alignment: Alignment.center,
                    height:
                        screenHeightExcludingToolbar(context, dividedBy: 10),
                    width: double.infinity,
                    child:
                        codigobandeja.length < properties['CARACTERES_MINIMOS']
                            ? Container()
                            : listarwidget(agencias)),
              ),
              /*Align(
                alignment: Alignment.center,
                child: Container(
                    alignment: FractionalOffset.bottomCenter,
                    height: screenHeightExcludingToolbar(context, dividedBy: 5),
                    width: double.infinity,
                    child: sendButton),
              )*/
            ],
          ),
        )));
  }

  Size screenSize(BuildContext context) {
    return MediaQuery.of(context).size;
  }

  double screenHeight(BuildContext context,
      {double dividedBy = 1, double reducedBy = 0.0}) {
    return (screenSize(context).height - reducedBy) / dividedBy;
  }

  BoxDecoration myBoxDecoration(int i) {
    if (i == 1) {
      return BoxDecoration(
        border: Border.all(color: colorback),
        color: colorback,
      );
    } else {
      return BoxDecoration(
        border: Border.all(color: Color(0xFFBF8888)),
        color: Color(0xFFBF8888),
      );
    }
  }

  BoxDecoration myBoxDecoration2(int i) {
    if (i == 6) {
      return BoxDecoration(
        border: Border.all(color: colorback),
        color: colorback,
      );
    } else {
      return BoxDecoration(
        border: Border.all(color: Color(0xFFBF8888)),
        color: Color(0xFFBF8888),
      );
    }
  }

  double screenHeightExcludingToolbar(BuildContext context,
      {double dividedBy = 1}) {
    return screenHeight(context,
        dividedBy: dividedBy, reducedBy: kToolbarHeight);
  }

  void cargarPreferences() async {
    sharedPreferences = await SharedPreferences.getInstance();
    print("FSDF");
  }

  onAfterBuild(BuildContext context) {}
}
