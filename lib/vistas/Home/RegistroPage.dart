import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/material.dart';
import 'package:rvaapp/ModelDto/AgenciaModel.dart';
import 'package:rvaapp/Util/widgets.dart';
import 'package:rvaapp/vistas/Login/loginPage.dart';
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
  bool respondio = false;
  String codigobandeja = "";
  RegistroController principalcontroller = new RegistroController();
  SharedPreferences sharedPreferences;
  List<AgenciaModel> agencias = null;
  bool validarboton = false;
  String qrbarra, valuess = "";
  int cantidadrespuesta = 0;
  int estadoenvio = 0;
  bool buttonsend = true;
  bool buttoncamera = true;
  FocusNode _focusNode;
  //Widget proba = Container();
  @override
  void initState() {
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
    WidgetsBinding.instance.addPostFrameCallback((_) => onAfterBuild(context));

    void verificarenvio(BuildContext context) {
      if (_bandejaController.text != "") {
        principalcontroller.recogerdocumento(context, _bandejaController.text);
        setState(() {
          _bandejaController.text = "";
          agencias = null;
          codigobandeja = "";
          buttonsend = true;
        });
        FocusScope.of(context).unfocus();
        new TextEditingController().clear();
      } else {
        mostrarAlerta(context, "Primero registro el código para registrarlo",
            "Codigo vacio");
      }
    }

    final sendButton = Container(
        margin: const EdgeInsets.only(top: 40),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 120),
          child: RaisedButton(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
            onPressed: () {
              if (buttonsend) {
                if (agencias != null && estadoenvio != 2) {
                  buttonsend = false;
                  verificarenvio(context);
                }
              }
            },
            color: agencias != null && estadoenvio != 2
                ? Color(0xFF2C6983)
                : colorletra,
            padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
            child: Text('Registrar', style: TextStyle(color: Colors.white)),
          ),
        ));

    final textBandeja = Container(
      child: Text("código"),
    );

    //codigobandeja

    Widget crearItem(AgenciaModel usuario) {
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
              child: Text("LA AGENCIA YA FUE ENVIADA",
                  style: TextStyle(
                      fontSize: 15,
                      color: Color(0xFF800001),
                      decorationStyle: TextDecorationStyle.wavy,
                      fontWeight: FontWeight.bold)),
            ));
      }
    }

    Widget mostrarmensaje() {
      return Container(
        height: screenHeightExcludingToolbar(context, dividedBy: 10),
        child: Center(
            child: Container(
          child: Center(
              child: Text("No se han encontrado agencias",
                  style: TextStyle(
                    fontSize: 15,
                    color: colorletra2,
                    decorationStyle: TextDecorationStyle.wavy,
                    fontStyle: FontStyle.normal,
                  ))),
        )),
      );
    }

    /*Widget _mostrarAgencia(String codigo) {
      return FutureBuilder(
          future: principalcontroller.listarAgencias(codigo),
          builder: (BuildContext context,
              AsyncSnapshot<List<AgenciaModel>> snapshot) {
            if (snapshot.hasData) {
              final usuarios = snapshot.data;
              cantidadrespuesta = usuarios.length;
              return ListView.builder(
                  itemCount: usuarios.length,
                  itemBuilder: (context, i) => crearItem(usuarios[i]));
            } else {
              return Container();
            }
          });
    }*/

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
        agencias = await principalcontroller.listarAgencias(codigobandeja);
        if (agencias != null) {
          for (AgenciaModel agencia in agencias) {
            setState(() {
              estadoenvio = agencia.estado;
              buttoncamera = true;
            });
          }
        } else {
          setState(() {
            estadoenvio = 0;
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

    var bandeja = TextFormField(
      keyboardType: TextInputType.text,
      controller: _bandejaController,
      textInputAction: TextInputAction.done,
      onFieldSubmitted: (value) {
        setState(() {
          codigobandeja = value;
        });
        if (agencias != null && estadoenvio != 2) {
          verificarenvio(context);
        }else{
           mostrarAlerta(context, 'El registro de la agencia ya se ha realizado',
            'Agencia Enviada');
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

    final campodetextoandIconoBandeja = Row(children: <Widget>[
      Expanded(
        child: bandeja,
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

    return Scaffold(
        appBar: ReusableWidgets.getAppBar('Registro de visita'),
        drawer: crearMenu(context),
        body: new GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
              new TextEditingController().clear();
            },
            child: Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                        margin: const EdgeInsets.only(top: 20),
                        alignment: Alignment.bottomLeft,
                        height: screenHeightExcludingToolbar(context,
                            dividedBy: 30),
                        width: double.infinity,
                        child: textBandeja),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                        margin: const EdgeInsets.only(bottom: 40),
                        alignment: Alignment.centerLeft,
                        height: screenHeightExcludingToolbar(context,
                            dividedBy: 12),
                        width: double.infinity,
                        child: campodetextoandIconoBandeja),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Container(
                        alignment: Alignment.center,
                        height: screenHeightExcludingToolbar(context,
                            dividedBy: 10),
                        width: double.infinity,
                        child: codigobandeja.length <
                                properties['CARACTERES_MINIMOS']
                            ? Container()
                            : listarwidget(agencias)),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Container(
                        alignment: Alignment.center,
                        height:
                            screenHeightExcludingToolbar(context, dividedBy: 5),
                        width: double.infinity,
                        child: sendButton),
                  )
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
