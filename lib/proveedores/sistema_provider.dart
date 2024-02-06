import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../globals.dart' as globals;

class SitemaProvider {
  Future login(username, pass) async {
    final url = Uri.http(globals.url, '/api/login');
    final resp = await http.post(url, body: {
      'username': username.toString(),
      'pass': pass.toString(),
    }).timeout(const Duration(seconds: 10));
    final decodedData = jsonDecode(resp.body);

    return decodedData;
  }

  Future registrarUsuario(correo, password, username) async {
    final url = Uri.http(globals.url, '/api/registrarUsuario');
    final resp = await http.post(url, body: {
      'correo': correo.toString(),
      'password': password.toString(),
      'username': username.toString(),
    }).timeout(const Duration(seconds: 10));
    final decodedData = jsonDecode(resp.body);
    return decodedData;
  }

  Future eliminarCuenta(
    pkUsuario,
  ) async {
    final url = Uri.http(globals.url, '/api/eliminarCuenta');
    final resp = await http.post(url, body: {
      'pkUsuario': pkUsuario.toString(),
    }).timeout(const Duration(seconds: 10));
    final decodedData = jsonDecode(resp.body);
    return decodedData;
  }
}
