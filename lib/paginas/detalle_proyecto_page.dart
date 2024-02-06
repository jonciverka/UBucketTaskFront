import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ubuckettask/modelos/proyectos.dart';
import 'package:ubuckettask/proveedores/proyecto_provider.dart';
import 'package:ubuckettask/proveedores/tareas_provider.dart';
import 'package:ubuckettask/widgets/dialog_pregunta.dart';
import '../globals.dart' as globals;

class DetalleProyectoPage extends StatefulWidget {
  const DetalleProyectoPage({super.key, required this.proyecto});
  final Proyecto proyecto;

  @override
  State<DetalleProyectoPage> createState() => _DetalleProyectoPageState();
}

class _DetalleProyectoPageState extends State<DetalleProyectoPage>
    with TickerProviderStateMixin {
  bool backPressed = false;
  late AnimationController controllerToIncreasingCurve;
  late AnimationController controllerToDecreasingCurve;
  final tareaController = TextEditingController();
  final descripcionController = TextEditingController();
  final nombreProyecto = TextEditingController();
  late Animation<double> animationToIncreasingCurve;
  late Animation<double> animationToDecreasingCurve;
  int? pkTareaSeleccionado;
  int? indexDestruccion;
  bool editProyecto = false;
  Color? colorOriginal;
  Color? colorSeleccionado;

  @override
  void initState() {
    colorOriginal = Color(int.parse("0xff${widget.proyecto.color}"));
    controllerToIncreasingCurve = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    controllerToDecreasingCurve = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    animationToIncreasingCurve = Tween<double>(begin: 500, end: 0).animate(
      CurvedAnimation(
        parent: controllerToIncreasingCurve,
        curve: Curves.fastLinearToSlowEaseIn,
      ),
    )..addListener(() {
        setState(() {});
      });

    animationToDecreasingCurve = Tween<double>(begin: 0, end: 200).animate(
      CurvedAnimation(
        parent: controllerToDecreasingCurve,
        curve: Curves.fastLinearToSlowEaseIn,
      ),
    )..addListener(() {
        setState(() {});
      });

    controllerToIncreasingCurve.forward();

    super.initState();
  }

  @override
  void dispose() {
    controllerToIncreasingCurve.dispose();
    controllerToDecreasingCurve.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (didPop) {
          return;
        }
        backPressed = true;
        controllerToDecreasingCurve.forward();
        Navigator.pop(context, false);
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(
          backPressed == false
              ? animationToIncreasingCurve.value
              : animationToDecreasingCurve.value,
        ),
        child: Scaffold(
          backgroundColor: Color(int.parse("0xff${widget.proyecto.color}")),
          body: SafeArea(
            child: GestureDetector(
              onTap: () {
                if (editProyecto) {
                  actualizarProyecto();
                } else {
                  actualizarTarea();
                }
              },
              child: SizedBox(
                  width: double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 15.0, horizontal: 20),
                    child: Column(
                      children: [
                        header(),
                        const SizedBox(height: 20),
                        tareas()
                      ],
                    ),
                  )),
            ),
          ),
        ),
      ),
    );
  }

  Widget header() {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          alignment: Alignment.center,
          child: GestureDetector(
            onTap: () {
              editProyecto = true;
              nombreProyecto.text = widget.proyecto.nombre!;
              setState(() {});
            },
            child: Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: editProyecto
                  ? inputProyecto()
                  : Text(
                      widget.proyecto.nombre!,
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                        fontFamily: 'Galano',
                      ),
                    ),
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            backPressed = true;
            controllerToDecreasingCurve.forward();
            Navigator.pop(context, false);
          },
          child: const Padding(
            padding: EdgeInsets.only(top: 4.0),
            child: Icon(
              Icons.arrow_back_rounded,
              size: 30,
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            CustomDialogPreguntaEliminar.show(context,
                '¿Seguro que deseas eliminar el proyecto ${widget.proyecto.nombre}?',
                () {
              globals.estaCargando = true;
              setState(() {});
              ProyectoProvider()
                  .eliminarProyecto(widget.proyecto.pkProyecto)
                  .then((value) {
                if (value["estado"]) {
                  Navigator.pop(context);
                  backPressed = true;
                  controllerToDecreasingCurve.forward();
                  Navigator.pop(context, true);
                } else {
                  Fluttertoast.showToast(
                      msg: value["mensaje"],
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.CENTER,
                      backgroundColor: Colors.white,
                      textColor: Colors.black,
                      fontSize: 16.0);
                }
              });
            });
          },
          child: Container(
            alignment: Alignment.bottomRight,
            padding: const EdgeInsets.only(top: 4.0),
            child: const Icon(
              Icons.delete_outline_rounded,
              size: 30,
            ),
          ),
        )
      ],
    );
  }

  Widget tareas() {
    return Expanded(
      child: ListView.builder(
        itemCount: widget.proyecto.tareas!.length,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              pkTareaSeleccionado = widget.proyecto.tareas![index].pkTarea;
              tareaController.text = widget.proyecto.tareas![index].tarea!;
              descripcionController.text =
                  widget.proyecto.tareas![index].comentario!;
              setState(() {});
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: AnimatedSize(
                curve: Curves.bounceOut,
                alignment: Alignment.topCenter,
                duration: const Duration(milliseconds: 700),
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeIn,
                  opacity: indexDestruccion == index ? 0 : 1,
                  onEnd: () {
                    if (indexDestruccion == index) {
                      indexDestruccion = null;
                      TareasProvider().eliminarTarea(
                          widget.proyecto.tareas![index].pkTarea!);
                      widget.proyecto.tareas!.removeAt(index);
                      setState(() {});
                    }
                  },
                  child: Container(
                    alignment: Alignment.topCenter,
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 15),
                    margin: const EdgeInsets.only(bottom: 10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: const Color.fromARGB(102, 255, 255, 255)),
                    child: Stack(
                      children: [
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            pkTareaSeleccionado ==
                                    widget.proyecto.tareas![index].pkTarea
                                ? inputTarea()
                                : Text(
                                    widget.proyecto.tareas![index].tarea!,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                      fontFamily: 'Galano',
                                    ),
                                  ),
                            const Divider(
                              color: Color.fromARGB(119, 255, 255, 255),
                            ),
                            const Text(
                              "Descripción/Comentario",
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Galano',
                              ),
                            ),
                            pkTareaSeleccionado ==
                                    widget.proyecto.tareas![index].pkTarea
                                ? inputDescripcion()
                                : Text(
                                    widget.proyecto.tareas![index].comentario ==
                                                null ||
                                            widget.proyecto.tareas![index]
                                                    .comentario ==
                                                ''
                                        ? "Sin comentario"
                                        : widget.proyecto.tareas![index]
                                            .comentario!,
                                    style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w400,
                                      fontFamily: 'Galano',
                                    ),
                                  )
                          ],
                        ),
                        Positioned(
                            right: 0,
                            child: GestureDetector(
                                onTap: () {
                                  indexDestruccion = index;
                                  setState(() {});
                                },
                                child: const Icon(Icons.close_rounded))),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget inputTarea() {
    return SizedBox(
      height: 25,
      child: TextFormField(
        onEditingComplete: () {
          actualizarTarea();
        },
        cursorColor: Colors.white,
        cursorHeight: 17.7,
        autofocus: true,
        keyboardType: TextInputType.text,
        controller: tareaController,
        validator: (value) {
          if (value == '') {
            return "Campo obligatório";
          }
          return null;
        },
        style: const TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.w600,
          fontSize: 17.7,
          fontFamily: 'Galano',
        ),
        inputFormatters: [
          LengthLimitingTextInputFormatter(99),
        ],
        decoration: InputDecoration(
          filled: true,
          contentPadding: const EdgeInsets.symmetric(vertical: 0),
          fillColor: Colors.transparent,
          hintText: "Elige el nombre del proyecto",
          hintStyle: const TextStyle(
              fontSize: 17.7,
              color: Color(0xff8A8A8A),
              fontFamily: 'Galano',
              fontWeight: FontWeight.w600),
          focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.transparent, width: 0),
              borderRadius: BorderRadius.circular(20)),
          enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.transparent, width: 0),
              borderRadius: BorderRadius.circular(20)),
          errorBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.transparent, width: 1),
              borderRadius: BorderRadius.circular(20)),
        ),
      ),
    );
  }

  Widget inputProyecto() {
    return SizedBox(
      height: 25,
      width: MediaQuery.sizeOf(context).width * .5,
      child: TextFormField(
        onEditingComplete: () {
          actualizarProyecto();
        },
        cursorColor: Colors.white,
        textAlign: TextAlign.center,
        cursorHeight: 16,
        autofocus: true,
        keyboardType: TextInputType.text,
        controller: nombreProyecto,
        validator: (value) {
          if (value == '') {
            return "Campo obligatório";
          }
          return null;
        },
        style: const TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.w600,
          fontSize: 16,
          fontFamily: 'Galano',
        ),
        inputFormatters: [
          LengthLimitingTextInputFormatter(99),
        ],
        decoration: InputDecoration(
          filled: true,
          contentPadding: const EdgeInsets.symmetric(vertical: 0),
          fillColor: Colors.transparent,
          hintText: "Elige el nombre para la tarea",
          hintStyle: const TextStyle(
              fontSize: 16,
              color: Color(0xff8A8A8A),
              fontFamily: 'Galano',
              fontWeight: FontWeight.w600),
          focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.transparent, width: 0),
              borderRadius: BorderRadius.circular(20)),
          enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.transparent, width: 0),
              borderRadius: BorderRadius.circular(20)),
          errorBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.transparent, width: 1),
              borderRadius: BorderRadius.circular(20)),
        ),
      ),
    );
  }

  Widget inputDescripcion() {
    return TextFormField(
      onEditingComplete: () {
        actualizarTarea();
      },
      cursorColor: Colors.white,
      maxLines: 5,
      cursorHeight: 15.6,
      keyboardType: TextInputType.text,
      controller: descripcionController,
      inputFormatters: [
        LengthLimitingTextInputFormatter(499),
      ],
      validator: (value) {
        if (value == '') {
          return "Campo obligatório";
        }
        return null;
      },
      style: const TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.w400,
        fontSize: 15.6,
        fontFamily: 'Galano',
      ),
      decoration: InputDecoration(
        filled: true,
        contentPadding: const EdgeInsets.symmetric(vertical: 0),
        fillColor: Colors.transparent,
        hintText: "Elige una descripción o comentario para esa tarea",
        hintStyle: const TextStyle(
            fontSize: 15.6,
            fontFamily: 'Galano',
            color: Color(0xff8A8A8A),
            fontWeight: FontWeight.w600),
        focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.transparent, width: 0),
            borderRadius: BorderRadius.circular(20)),
        enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.transparent, width: 0),
            borderRadius: BorderRadius.circular(20)),
        errorBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.transparent, width: 0),
            borderRadius: BorderRadius.circular(20)),
      ),
    );
  }

  actualizarTarea() {
    FocusScope.of(context).unfocus();
    if (pkTareaSeleccionado != null) {
      TareasProvider()
          .editarTarea(
              tareaController.text,
              // ignore: unnecessary_null_comparison
              descripcionController.text == null ||
                      descripcionController.text == ''
                  ? null
                  : descripcionController.text,
              pkTareaSeleccionado!)
          .then(
        (value) {
          for (var element in widget.proyecto.tareas!) {
            if (element.pkTarea == pkTareaSeleccionado) {
              element.tarea = tareaController.text;
              element.comentario = descripcionController.text;
            }
          }
          pkTareaSeleccionado = null;
          tareaController.text = '';
          descripcionController.text = '';
          descripcionController.clear();
          tareaController.clear();

          setState(() {});
        },
      );
    }
  }

  actualizarProyecto() {
    FocusScope.of(context).unfocus();
    var colorString = colorSeleccionado == null
        ? colorOriginal!.value.toRadixString(16).substring(2, 8)
        : colorSeleccionado!.value.toRadixString(16).substring(2, 8);
    ProyectoProvider()
        .editarProyecto(
            widget.proyecto.pkProyecto, nombreProyecto.text, colorString)
        .then((value) {
      if (value["estado"]) {
        widget.proyecto.nombre = nombreProyecto.text;
        widget.proyecto.color = colorString;
      }
      editProyecto = false;
      nombreProyecto.text = '';
      nombreProyecto.clear();
      setState(() {});
    });
  }
}
