class TareasMensaje {
  dynamic mensaje;
  bool? status;

  TareasMensaje();

  TareasMensaje.fromJson(dynamic json) {
    mensaje = json['estado'] == true
        ? Tareas.fromJsonList(json['mensaje']).items
        : json["mensaje"];
    status = json['estado'];
  }
}

class Tareas {
  List items = List.empty(growable: true);
  Tareas();
  Tareas.fromJsonList(List<dynamic>? jsonList) {
    if (jsonList == null) return;
    for (var item in jsonList) {
      final mensaje = Tarea.fromJsonMap(item);
      items.add(mensaje);
    }
  }
}

class Tarea {
  int? pkTarea;
  String? tarea;
  String? comentario;
  bool completada = false;

  Tarea();
  Tarea.fromJsonMap(Map json) {
    pkTarea = json['TTA_PK_TAREA'];
    tarea = json['TTA_TAREA'];
    comentario = json['TT_COMENTARIO'];
    completada = (json['TTA_FK_ESTADO_TAREA'] == 3) ? true : false;
  }
  Map<String, dynamic> toMap() {
    return {
      'nombre': tarea,
      'comentario': comentario,
      'fkTarea': pkTarea,
    };
  }
}
