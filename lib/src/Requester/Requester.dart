import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:rvaapp/src/Configuration/config.dart';
import 'package:rvaapp/src/preferencias_usuario/preferencias_usuario.dart';

class Requester {
  static final Requester _instancia = new Requester._internal();
  factory Requester() {
    return _instancia;
  }
  Requester._internal();
  final Dio _dio = Dio();
  final _prefs = new PreferenciasUsuario();

  Future<Response> login(String path, String username, String password) async {
    String basic = username + ":" + password;
    var basic8 = utf8.encode(basic);
    String basic64 = base64.encode(basic8);
    Map<String, dynamic> header = {
      'Authorization': 'Basic $basic64',
      "content-type": "application/x-www-form-urlencoded",
      "Accept": "application/json",
    };
    try {
      Response token = await Dio().post(
          properties['LDAP']
              ? properties['API'] + path + "/ldap"
              : properties['API'] + path,
          options: Options(headers: header));
      return token;
    } on DioError catch (e) {
      return e.response;
    }
  }

  Future<Response> get(String url, {Map<String, Object> params}) async {
    Response respuestaGet = await addInterceptors(_dio)
        .get(properties['API'] + url, queryParameters: params);
    return respuestaGet;
  }

  Future<Response> post(String url, dynamic data,
      {Map<String, Object> params}) async {
    Response response =
        await addInterceptors(_dio).post(properties['API'] + url,
            data: data,
            queryParameters: params,
            options: Options(
              contentType: Headers.formUrlEncodedContentType,
            ));
    return response;
  }

  dynamic requestInterceptor(RequestOptions options) async {
    var token = _prefs.token;
    options.headers.addAll({"Authorization": "Bearer $token"});
    return options;
  }

  dynamic responseInterceptor(Response response) async {
    return response;
  }

  dynamic errorInterceptor(DioError dioError) async {
    return dioError;
  }

  Dio addInterceptors(Dio dio) {
    return dio
      ..interceptors.add(InterceptorsWrapper(
          onRequest: (RequestOptions options) => requestInterceptor(options),
          onResponse: (Response response) => responseInterceptor(response),
          onError: (DioError dioError) => errorInterceptor(dioError)));
  }
}
