import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rvaapp/src/Util/utils.dart';
import 'package:rvaapp/src/icons/theme_data.dart';
import 'package:rvaapp/src/shared/Animation/FadeAnimationWidget.dart';
import 'package:rvaapp/src/shared/modals/notification.dart';
import 'package:rvaapp/src/styles/theme_data.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Login.controller.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => new _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  SharedPreferences sharedPreferences;
  bool pressbutton = true;
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  FocusNode focusUsername = FocusNode();
  FocusNode focusPassword = FocusNode();
  LoginController logincontroller = new LoginController();
  bool passwordVisible = true;

  @override
  void initState() {
    super.initState();
    checkLoginStatus();
  }

  checkLoginStatus() async {
    sharedPreferences = await SharedPreferences.getInstance();
    if (sharedPreferences.getString("buzon") != null) {
      await logincontroller.validarUsoApp(context);
    }
  }

  performLogin(BuildContext context) {
    String username = _usernameController.text;
    String password = _passwordController.text;
    if (username == "" || password == "") {
      notification(context, "error", "EXACT",
          'Es necesario ingresar el usuario y contraseña');
    } else {
      logincontroller.validarlogin(context, username, password);
    }
    setState(() {
      pressbutton = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final logo = Image.asset(
      'assets/images/logo-header.PNG',
      width: 250.0,
    );

    void enfocarcodigocontrasena() {
      FocusScope.of(context).unfocus();
      enfocarInputfx(context, focusPassword);
    }

    var email = TextFormField(
      controller: _usernameController,
      obscureText: false,
      focusNode: focusUsername,
      cursorColor: StylesThemeData.PRIMARY_COLOR,
      style: TextStyle(
        color: StylesThemeData.PRIMARY_COLOR,
        fontSize: 20.0,
      ),
      textInputAction: TextInputAction.next,
      onFieldSubmitted: (newValue) {
        enfocarcodigocontrasena();
      },
      decoration: InputDecoration(
        labelStyle: TextStyle(color: StylesThemeData.PRIMARY_COLOR),
        focusColor: StylesThemeData.PRIMARY_COLOR,
        filled: true,
        enabledBorder: UnderlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: StylesThemeData.PRIMARY_COLOR),
        ),
        labelText: "Usuario",
        prefixIcon: Icon(
          IconsData.ICON_USERCICLE,
          size: 20,
          color: StylesThemeData.PRIMARY_COLOR,
        ),
      ),
    );

    void enfocarUsuarioOrContrasena() {
      FocusScope.of(context).unfocus();
      if (_usernameController.text.length == 0) {
        enfocarInputfx(context, focusUsername);
      } else {
        if (pressbutton) {
          pressbutton = false;
          performLogin(context);
        }
      }
    }

    final password = TextFormField(
      obscureText: passwordVisible,
      controller: _passwordController,
      focusNode: focusPassword,
      cursorColor: StylesThemeData.PRIMARY_COLOR,
      style: TextStyle(
        color: StylesThemeData.PRIMARY_COLOR,
        fontSize: 20.0,
      ),
      onFieldSubmitted: (value) async {
        enfocarUsuarioOrContrasena();
      },
      textInputAction: TextInputAction.send,
      decoration: InputDecoration(
        labelStyle: TextStyle(color: StylesThemeData.PRIMARY_COLOR),
        focusColor: StylesThemeData.PRIMARY_COLOR,
        filled: true,
        enabledBorder: UnderlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: StylesThemeData.PRIMARY_COLOR),
        ),
        labelText: "Contraseña",
        prefixIcon: Icon(
          IconsData.ICON_PADLOCK,
          size: 20,
          color: StylesThemeData.PRIMARY_COLOR,
        ),
        suffixIcon: GestureDetector(
          onTap: () {
            setState(() {
              passwordVisible = !passwordVisible;
            });
          },
          child: Icon(
            !passwordVisible
                ? IconsData.ICON_EYE_DISABLED
                : IconsData.ICON_EYE_ENABLED,
            size: 20,
            color: StylesThemeData.PRIMARY_COLOR,
          ),
        ),
      ),
    );

    final loginButton = Material(
      child: Ink(
        decoration: BoxDecoration(
          color: StylesThemeData.PRIMARY_COLOR,
          borderRadius: BorderRadius.circular(10),
          border: Border.fromBorderSide(BorderSide.none),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          child: Container(
            height: 60.0,
            child: Center(
              child: Text(
                'Ingresar',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 16.0,
                ),
              ),
            ),
          ),
          onTap: () {
            FocusScope.of(context).unfocus();
            new TextEditingController().clear();
            if (pressbutton) {
              pressbutton = false;
              performLogin(context);
            }
          },
        ),
      ),
    );

    final titulo = Text(
      'Bienvenido Operador',
      textAlign: TextAlign.center,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 30,
          color: StylesThemeData.PRIMARY_COLOR),
    );

        final subtitulo = Text(
      'de Valijas',
      textAlign: TextAlign.center,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 30,
          color: StylesThemeData.PRIMARY_COLOR),
    );

    Widget mainscaffold() {
      return Container(
          child: Column(
        children: <Widget>[
          Container(
            width: double.infinity,
            alignment: Alignment.center,
            padding: EdgeInsets.only(bottom: 60),
            height: screenHeightExcludingToolbar(context, dividedBy: 2),
            decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(60),
                    bottomRight: Radius.circular(60))),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                FadeAnimationWidget(1.7, titulo),
                FadeAnimationWidget(1.7, subtitulo),
                SizedBox(height: 20.0),
                FadeAnimationWidget(1.7, logo),
              ],
            ),
          ),
          Expanded(
              child: Container(
                  padding: EdgeInsets.only(left: 24.0, right: 24.0),
                  child: Column(
                    children: <Widget>[
                      SizedBox(height: 24.0),
                      FadeAnimationWidget(1.7, email),
                      SizedBox(height: 8.0),
                      FadeAnimationWidget(1.7, password),
                      SizedBox(height: 24.0),
                      FadeAnimationWidget(1.7, loginButton),
                    ],
                  )))
        ],
      ));
    }

    return Scaffold(
        backgroundColor: Colors.white,
        body: scaffoldbodyLogin(mainscaffold(), context));
  }
}
