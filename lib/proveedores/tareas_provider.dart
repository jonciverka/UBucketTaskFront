import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../globals.dart' as globals;

class TareasProvider {
  Future registrarTarea(nombre, comentario, fkProyecto, fkEstadoTarea) async {
    final url = Uri.http(globals.url, '/api/registrarTarea');
    final resp = await http.post(url, body: {
      'nombre': nombre.toString(),
      'comentario': comentario.toString(),
      'fkProyecto': fkProyecto.toString(),
      'fkEstadoTarea': fkEstadoTarea.toString(),
    }).timeout(const Duration(seconds: 10));
    final decodedData = jsonDecode(resp.body);
    return decodedData;
  }

  Future editarTarea(String nombre, String? comentario, int fkTarea) async {
    final url = Uri.http(globals.url, '/api/editarTarea');
    final resp = await http.post(url, body: {
      "nombre": nombre.toString(),
      "comentario": comentario == null ? "" : comentario.toString(),
      "fkTarea": fkTarea.toString()
    }).timeout(const Duration(seconds: 10));
    final decodedData = jsonDecode(resp.body);
    return decodedData;
  }

  Future eliminarTarea(int fkTarea) async {
    final url = Uri.http(globals.url, '/api/eliminarTarea');
    final resp = await http.post(url, body: {
      "pkTarea": fkTarea.toString()
    }).timeout(const Duration(seconds: 10));
    final decodedData = jsonDecode(resp.body);
    return decodedData;
  }

  Future asignarFecha(int fkTarea, DateTime fecha) async {
    final url = Uri.http(globals.url, '/api/asignarFecha');
    final resp = await http.post(url, body: {
      "pkTarea": fkTarea.toString(),
      "fecha": fecha.toString()
    }).timeout(const Duration(seconds: 10));
    final decodedData = jsonDecode(resp.body);
    return decodedData;
  }

  Future completarTarea(int fkTarea) async {
    final url = Uri.http(globals.url, '/api/completarTarea');
    final resp = await http.post(url, body: {
      "pkTarea": fkTarea.toString(),
    }).timeout(const Duration(seconds: 10));
    final decodedData = jsonDecode(resp.body);
    return decodedData;
  }

  Future liberarTarea(int fkTarea) async {
    final url = Uri.http(globals.url, '/api/liberarTarea');
    final resp = await http.post(url, body: {
      "pkTarea": fkTarea.toString(),
    }).timeout(const Duration(seconds: 10));
    final decodedData = jsonDecode(resp.body);
    return decodedData;
  }
}
