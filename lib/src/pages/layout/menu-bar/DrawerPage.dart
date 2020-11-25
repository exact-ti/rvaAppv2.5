import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rvaapp/src/Util/utils.dart';
import 'package:rvaapp/src/icons/theme_data.dart';
import 'package:rvaapp/src/pages/RegistrarEnvioPage/Registro.page.dart';
import 'package:rvaapp/src/preferencias_usuario/preferencias_usuario.dart';
import 'package:rvaapp/src/services/notificationProvider.dart';
import 'package:rvaapp/src/styles/theme_data.dart';

// ignore: must_be_immutable
class DrawerPage extends StatelessWidget {
  final _prefs = new PreferenciasUsuario();

  List<Widget> milistview(BuildContext context) {
    List<Widget> list = new List<Widget>();
    bool enRecojo =
        Provider.of<NotificationConfiguration>(context).validarrecojo;
    list.add(DrawerHeader(
      margin: EdgeInsets.all(0),
      padding: EdgeInsets.all(0),
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Material(
              borderRadius: BorderRadius.all(Radius.circular(50.0)),
              color: StylesThemeData.PRIMARY_COLOR,
              elevation: 10,
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Container(
                  child: Center(
                      child: Text(
                    _prefs.nombreUsuario[0],
                    style: TextStyle(fontSize: 50, color: Colors.white),
                  )),
                  width: 80,
                  height: 80,
                ),
              ),
            ),
            Text(
              "${_prefs.nombreUsuario}",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          ],
        ),
      ),
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/images/header.png'),
              fit: BoxFit.cover)),
    ));
    list.add(Container(
        decoration: new BoxDecoration(color: Colors.white),
        child: ListTile(
            leading: Icon(IconsData.ICON_SEDE,color: StylesThemeData.ICON_COLOR,),
            title: Text(
              "Registro",
              style: TextStyle(color: StylesThemeData.LETTER_COLOR),
            ),
            onTap: () {
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                      builder: (BuildContext context) => HomePage(
                            enRecojo: enRecojo ? true : false,
                          )),
                  (Route<dynamic> route) => false);
            })));
    list.add(Divider());
    list.add(ListTile(
        leading: Icon(IconsData.ICON_EXIT,color: StylesThemeData.ICON_COLOR),
        title: Text("Cerrar Sesión"),
        onTap: () {
          eliminarpreferences(context);
        }));
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(padding: EdgeInsets.zero, children: milistview(context)),
    );
  }
}
