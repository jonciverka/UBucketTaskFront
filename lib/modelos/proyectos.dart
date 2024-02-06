import 'package:ubuckettask/modelos/tareas.dart';

class ProyectosMensaje {
  dynamic mensaje;
  bool? status;

  ProyectosMensaje();

  ProyectosMensaje.fromJson(dynamic json) {
    mensaje = json['estado'] == true
        ? Proyectos.fromJsonList(json['mensaje']).items
        : json["mensaje"];
    status = json['estado'];
  }
}

class Proyectos {
  List items = List.empty(growable: true);
  Proyectos();
  Proyectos.fromJsonList(List<dynamic>? jsonList) {
    if (jsonList == null) return;
    for (var item in jsonList) {
      final mensaje = Proyecto.fromJsonMap(item);
      items.add(mensaje);
    }
  }
}

class Proyecto {
  int? pkProyecto;
  String? nombre = "nombre";
  String? color = "FFFFFF";
  String? fechaRegistro;
  List<Tarea>? tareas;

  Proyecto();
  Proyecto.fromJsonMap(Map json) {
    pkProyecto = json['TPR_PK_PROYECTO'];
    nombre = json['TPR_NOMBRE'];
    color = json['TPR_COLOR'];
    fechaRegistro = json['TPR_FECHA_REGISTRO'];
  }
}
