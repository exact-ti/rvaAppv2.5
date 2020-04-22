import 'package:flutter/material.dart';
import 'package:rvaapp/preferencias_usuario/preferencias_usuario.dart';
import 'package:rvaapp/vistas/Login/loginPage.dart';
import 'package:shared_preferences/shared_preferences.dart';

var colorletra = const Color(0xFFACADAD);
var colorletra2 = const Color(0xFF466C7A);
const PrimaryColor = const Color(0xFF2C6983);
const colorback = const Color(0xFFD2E3EA);
const colorred = const Color(0xFFFF7375);


void mostrarAlerta(BuildContext context, String mensaje, String titulo) {
  showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('$titulo'),
          content: Text(mensaje),
          actions: <Widget>[
            FlatButton(
              child: Text('Ok'),
              onPressed: () => Navigator.of(context).pop(),
            )
          ],
        );
      });
}

Drawer crearMenu(BuildContext context) {
  return Drawer(
    child: ListView(padding: EdgeInsets.zero, children: milistview(context)),
  );
}

Future<bool> confirmarRespuesta(
    BuildContext context, String title, String description) async {
  bool respuesta = await showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(description),
          actions: <Widget>[
            FlatButton(
              onPressed: () {
                Navigator.pop(context, true);
                // Navigator.of(context).pop();
              },
              child: Text('Aceptar'),
            ),
            FlatButton(
              onPressed: () {
                Navigator.pop(context, false);
                // Navigator.of(context).pop();
                return false;
              },
              child: Text('Cancelar'),
            )
          ],
        );
      });

  return respuesta;
}

Widget respuesta(String contenido) {
  return Text(contenido, style: TextStyle(color: Colors.red, fontSize: 15));
}

Widget errorbandeja(String rest, int numero) {
  int minvalor = 5;

  if (rest.length == 0 && numero == 0) {
    return Container();
  }

  if (rest.length > 0 && rest.length < minvalor) {
    return respuesta("La longitud mínima es de $minvalor caracteres");
  }
/*
  if(envioController.validarexistenciabandeja(rest) && rest.length>0 ){
      return respuesta("El código no existe");
  }*/

  return Container();
}

List<Widget> milistview(BuildContext context) {
  List<Widget> list = new List<Widget>();

  final _prefs = new PreferenciasUsuario();
  if(_prefs.buzon!=""){
  list.add(DrawerHeader(
    child: Container(),
    decoration: BoxDecoration(
        image: DecorationImage(
            image: AssetImage('assets/original.jpg'), fit: BoxFit.cover)),
  ));
    list.add(cerrarsesion(context));
  }
  return list;
}

Widget cerrarsesion(BuildContext context){
     return ListTile(
        leading: Icon(Icons.pages, color: Colors.blue),
        title: Text("Cerrar Sesión"),
        onTap: () {
          eliminarpreferences(context);
        });
}

void eliminarpreferences(BuildContext context) async {
  SharedPreferences sharedPreferences;
  sharedPreferences = await SharedPreferences.getInstance();
        sharedPreferences.clear();
      sharedPreferences.commit();
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (BuildContext context) => LoginPage()),
          (Route<dynamic> route) => false);
}



final _icons = <String, IconData>{
  'add_alert': Icons.add_alert,
  'accessibility': Icons.accessibility,
  'folder_open': Icons.folder_open,
};

Icon getICon(String nombreIcono) {
  return Icon(_icons[nombreIcono], color: Colors.blue);
}

void redirection(BuildContext context, String ruta) {
  Navigator.pushReplacementNamed(context, ruta);
}

////////////

Size screenSize(BuildContext context) {
  return MediaQuery.of(context).size;
}

double screenHeight(BuildContext context,
    {double dividedBy = 1, double reducedBy = 0.0}) {
  return (screenSize(context).height - reducedBy) / dividedBy;
}

double screenHeightExcludingToolbar(BuildContext context,
    {double dividedBy = 1}) {
  return screenHeight(context, dividedBy: dividedBy, reducedBy: kToolbarHeight);
}

BoxDecoration myBoxDecoration(Color colorletra) {
  return BoxDecoration(
    border: Border.all(color: colorletra),
  );
}

 AppBar appbarUtil(String text){
  return  AppBar(
          backgroundColor: PrimaryColor,
          title: Text('$text',
              style: TextStyle(
                  fontSize: 18,
                  decorationStyle: TextDecorationStyle.wavy,
                  fontStyle: FontStyle.normal,
                  fontWeight: FontWeight.normal)),
        );
}