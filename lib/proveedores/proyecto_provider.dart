import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:ubuckettask/modelos/proyectos.dart';
import 'package:ubuckettask/modelos/tareas.dart';
import '../globals.dart' as globals;

class ProyectoProvider {
  Future crearProyecto(nombre, color, pkUsuario) async {
    final url = Uri.http(globals.url, '/api/registrarProyecto');
    final resp = await http.post(url, body: {
      'nombre': nombre.toString(),
      'color': color.toString(),
      'pkUsuario': pkUsuario.toString(),
    }).timeout(const Duration(seconds: 10));
    final decodedData = jsonDecode(resp.body);
    return decodedData;
  }

  Future editarProyecto(pkProyecto, nombre, color) async {
    final url = Uri.http(globals.url, '/api/editarProyecto');
    final resp = await http.post(url, body: {
      'pkProyecto': pkProyecto.toString(),
      'nombre': nombre.toString(),
      'color': color.toString(),
    }).timeout(const Duration(seconds: 10));
    final decodedData = jsonDecode(resp.body);
    return decodedData;
  }

  Future obtenerProyectos(pkUsuario) async {
    final url = Uri.http(globals.url, '/api/obtenerProyectos', {
      'pkUsuario': pkUsuario.toString(),
    });
    final resp = await http.get(url).timeout(const Duration(seconds: 10));
    final decodedData = jsonDecode(resp.body);
    final proyectos = ProyectosMensaje.fromJson(decodedData);
    return proyectos;
  }

  Future eliminarProyecto(pkProyecto) async {
    final url = Uri.http(globals.url, '/api/eliminarProyecto');
    final resp = await http.post(url, body: {
      'pkProyecto': pkProyecto.toString(),
    }).timeout(const Duration(seconds: 10));
    final decodedData = jsonDecode(resp.body);
    return decodedData;
  }

  Future obtenerProyecosConTarea(pkUsuario) async {
    final url = Uri.http(globals.url, '/api/obtenerProyectos', {
      'pkUsuario': pkUsuario.toString(),
    });
    final resp = await http.get(url).timeout(const Duration(seconds: 10));
    final decodedData = jsonDecode(resp.body);
    final proyectos = ProyectosMensaje.fromJson(decodedData);
    for (Proyecto element in proyectos.mensaje) {
      List<Tarea>? tareasList = [];
      var urlDos = Uri.http(globals.url, '/api/obtenerTareaLibrePorProyecto', {
        'pkProyecto': element.pkProyecto.toString(),
      });
      final resp = await http.get(urlDos).timeout(const Duration(seconds: 10));
      final decodedData = jsonDecode(resp.body);
      final tareas = TareasMensaje.fromJson(decodedData);
      for (var element in tareas.mensaje) {
        tareasList.add(element);
      }
      element.tareas = tareasList;
    }
    return proyectos;
  }

  Future obtenerProyectosAsignadosPorFecha(
      int pkUsuario, DateTime fecha) async {
    final url = Uri.http(globals.url, '/api/obtenerProyectosAsignadosPorFecha',
        {"pkUsuario": pkUsuario.toString(), "fecha": fecha.toString()});
    final resp = await http.get(url).timeout(const Duration(seconds: 10));
    final decodedData = jsonDecode(resp.body);
    final proyectos = ProyectosMensaje.fromJson(decodedData);
    for (Proyecto element in proyectos.mensaje) {
      List<Tarea>? tareasList = [];
      var urlDos = Uri.http(globals.url,
          '/api/obtenerTareaAsigandaYTerminadaPorProyectoPorFecha', {
        'pkProyecto': element.pkProyecto.toString(),
        "fecha": fecha.toString()
      });
      final resp = await http.get(urlDos).timeout(const Duration(seconds: 10));
      final decodedData = jsonDecode(resp.body);
      final tareas = TareasMensaje.fromJson(decodedData);
      for (var element in tareas.mensaje) {
        tareasList.add(element);
      }
      tareasList.sort((a, b) {
        if (a.completada && !b.completada) {
          return 1;
        } else if (!a.completada && b.completada) {
          return -1;
        } else {
          return 0;
        }
      });
      element.tareas = tareasList;
    }
    return proyectos;
  }
}
