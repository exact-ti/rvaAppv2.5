import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:rvaapp/src/models/BuzonModel.dart';
import 'package:rvaapp/src/preferencias_usuario/preferencias_usuario.dart';
import 'package:rvaapp/src/services/locator.dart';
import 'package:rvaapp/src/services/navigation_service_file.dart';
import 'package:shared_preferences/shared_preferences.dart';

final _prefs = new PreferenciasUsuario();
BuzonModel buzonModel = new BuzonModel(); 
final NavigationService _navigationService = locator<NavigationService>();

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
              },
              child: Text('Aceptar'),
            ),
            FlatButton(
              onPressed: () {
                Navigator.pop(context, false);
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
  if(_prefs.buzon!=""){
  list.add(DrawerHeader(
    child: Container(),
    decoration: BoxDecoration(
        image: DecorationImage(
            image: AssetImage('assets/original.jpg'), fit: BoxFit.cover)),
  ));

    list.add(ListTile(
        leading: Icon(Icons.check_circle_outline, color: Colors.blue),
        title: Text("Registro"),
        onTap: () {
         Navigator.pushReplacementNamed(context, "/home");
        }));
    list.add(cerrarsesion(context));
  }
  return list;
}

Widget cerrarsesion(BuildContext context){
     return ListTile(
        leading: Icon(Icons.exit_to_app, color: Colors.blue),
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
     _navigationService.navigationTo("/login");
}

void desenfocarInputfx(BuildContext context) {
  FocusScope.of(context).unfocus();
  FocusScope.of(context).requestFocus(new FocusNode()); //remove focus
  new TextEditingController().clear();
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

BoxDecoration myBoxDecoration(Color colorParam) {
  return BoxDecoration(
    border: Border.all(color: colorParam),
  );
}


String buzonId(){
  Map<String, dynamic> buzon = json.decode(_prefs.buzon);
  BuzonModel bznmodel = buzonModel.fromPreferencs(buzon);
  String idbuzon = bznmodel.idUsuario;
  return idbuzon;
}

BuzonModel buzonPreferences(){
  Map<String, dynamic> buzon = json.decode(_prefs.buzon);
  if(buzon==null) return null;
  return buzonModel.fromPreferencs(buzon);
}

void enfocarInputfx(BuildContext context, FocusNode fx) {
  FocusScope.of(context).unfocus();
  new TextEditingController().clear();
  FocusScope.of(context).requestFocus(fx);
}





