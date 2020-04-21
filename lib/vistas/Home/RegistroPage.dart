import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:rvaapp/ModelDto/AgenciaModel.dart';
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
  RegistroController principalcontroller = new RegistroController();
  SharedPreferences sharedPreferences;

  String qrbarra, valuess = "";

  @override
  void initState() {
    super.initState();
    cargarPreferences();
  }

  var colorplomos = const Color(0xFFEAEFF2);
  @override
  Widget build(BuildContext context) {
    void verificarenvio(BuildContext context) {
      if (_bandejaController.text != "") {
        principalcontroller.recogerdocumento(context, _bandejaController.text);
        setState(() {
          _bandejaController.text = "";
        });
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
              verificarenvio(context);
            },
            color: Color(0xFF2C6983),
            padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
            child: Text('Registrar', style: TextStyle(color: Colors.white)),
          ),
        ));

    final primertitulo = Text("Código proveedor",
        style: TextStyle(color: colorletra, fontSize: 40.0));

    final textBandeja = Container(
      child: Text("código"),
      margin: const EdgeInsets.only(left: 15),
    );

    Future _traerdatosescanerBandeja() async {
      qrbarra =
          await FlutterBarcodeScanner.scanBarcode("#004297", "Cancel", true);
      /* setState(() {
        _bandejaController.text = qrbarra;
      });*/
    }

    var bandeja = TextFormField(
      keyboardType: TextInputType.text,
      autofocus: false,
      controller: _bandejaController,
      textInputAction: TextInputAction.done,
      onFieldSubmitted: (value) {
        setState(() {
          _bandejaController.text = value;
        });
        verificarenvio(context);
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

    Widget crearItem(AgenciaModel usuario) {

        return Container(
          child:Row(
            children: <Widget>[
              Text("Agencia:"),
              Text(usuario.nombre),
            ],
          )
        );

    }

    Widget _mostrarAgencia(String codigo) {
      return FutureBuilder(
          future: principalcontroller.listarAgencias(codigo),
          builder: (BuildContext context,
              AsyncSnapshot<List<AgenciaModel>> snapshot) {
            if (snapshot.hasData) {
              final usuarios = snapshot.data;
              return ListView.builder(
                  itemCount: usuarios.length,
                  itemBuilder: (context, i) => crearItem(usuarios[i]));
            } else {
              return Container();
            }
          });
    }

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
        appBar: AppBar(
          backgroundColor: PrimaryColor,
          actions: [botonLogOut(context)],
          title: Text('Registro de visita',
              style: TextStyle(
                  fontSize: 18,
                  decorationStyle: TextDecorationStyle.wavy,
                  fontStyle: FontStyle.normal,
                  fontWeight: FontWeight.normal)),
        ),
        drawer: crearMenu(context),
        body: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Align(
                  alignment: Alignment.center,
                  child: Container(
                      margin: const EdgeInsets.only(top: 50, bottom: 10),
                      alignment: Alignment.center,
                      height:
                          screenHeightExcludingToolbar(context, dividedBy: 15),
                      width: double.infinity,
                      child: primertitulo)),
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
                    alignment: Alignment.centerLeft,
                    height:
                        screenHeightExcludingToolbar(context, dividedBy: 12),
                    width: double.infinity,
                    child: campodetextoandIconoBandeja),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Container(
                    alignment: Alignment.centerLeft,
                    height:
                        screenHeightExcludingToolbar(context, dividedBy: 10),
                    width: double.infinity,
                    child: _bandejaController.text == "" ||
                            _bandejaController.text.length <
                                properties['CARACTERES_MINIMOS']
                        ? Container()
                        : _mostrarAgencia(_bandejaController.text)),
              ),
              Align(
                alignment: Alignment.center,
                child: Container(
                    alignment: Alignment.center,
                    height: screenHeightExcludingToolbar(context, dividedBy: 5),
                    width: double.infinity,
                    child: sendButton),
              )
            ],
          ),
        ));
  }

  Widget botonLogOut(BuildContext context) {
    return InkWell(
      child: Container(
          margin: const EdgeInsets.only(right: 10),
          child: Row(
            children: <Widget>[
              Icon(Icons.exit_to_app),
              Text('Cerrar sesión',
                  style: TextStyle(
                      fontSize: 18,
                      decorationStyle: TextDecorationStyle.wavy,
                      fontStyle: FontStyle.normal,
                      fontWeight: FontWeight.normal))
            ],
          )),
      onTap: () {
        sharedPreferences.clear();
        sharedPreferences.commit();
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (BuildContext context) => LoginPage()),
            (Route<dynamic> route) => false);
      },
    );
  }

  Size screenSize(BuildContext context) {
    return MediaQuery.of(context).size;
  }

  double screenHeight(BuildContext context,
      {double dividedBy = 1, double reducedBy = 0.0}) {
    return (screenSize(context).height - reducedBy) / dividedBy;
  }

  BoxDecoration myBoxDecoration() {
    return BoxDecoration(
      border: Border.all(color: colorletra),
    );
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
}
