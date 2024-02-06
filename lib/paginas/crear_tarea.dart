import 'package:animation_list/animation_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ubuckettask/modelos/proyectos.dart';
import 'package:ubuckettask/proveedores/proyecto_provider.dart';
import 'package:ubuckettask/proveedores/tareas_provider.dart';
import 'package:ubuckettask/widgets/boton.dart';
import '../globals.dart' as globals;
import 'package:fluttertoast/fluttertoast.dart';

class CrearTareaPage extends StatefulWidget {
  const CrearTareaPage({super.key});

  @override
  State<CrearTareaPage> createState() => _CrearTareaPageState();
}

class _CrearTareaPageState extends State<CrearTareaPage> {
  Future? proyectos;
  int? proyectoSeleccionado;
  final nombreTarea = TextEditingController();
  final descripcionTarea = TextEditingController();
  GlobalKey<FormState> formState = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => asyncInitState());
  }

  void asyncInitState() async {
    proyectos = ProyectoProvider().obtenerProyectos(globals.pkUsuario);
    setState(() {});
    globals.estaCargando = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff1c1c1e),
      body: SizedBox(
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 10),
            child: Column(
              children: [header(), const SizedBox(height: 20), form()],
            ),
          )),
    );
  }

  Widget header() {
    return Stack(
      children: [
        const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.only(top: 8.0),
              child: Text(
                "Crear tarea",
                style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Galano',
                    fontWeight: FontWeight.w600,
                    fontSize: 15),
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                  decoration: BoxDecoration(
                      color: const Color(0xff696969),
                      borderRadius: BorderRadius.circular(100)),
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Icon(Icons.close_rounded),
                  )),
            ),
            BotonOwn(texto: "Crear", function: () => crearTarea())
          ],
        ),
      ],
    );
  }

  Widget form() {
    return Expanded(
      child: SizedBox(
        width: double.infinity,
        child: Form(
          key: formState,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Nombre de la tarea",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontFamily: 'Galano',
                    fontWeight: FontWeight.w400),
              ),
              inputTarea(),
              const SizedBox(height: 20),
              const Text(
                "Descripción ó comentario",
                style: TextStyle(
                    fontFamily: 'Galano',
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w400),
              ),
              inputDescripcion(),
              const SizedBox(height: 20),
              const Text(
                "En que proyecto",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontFamily: 'Galano',
                    fontWeight: FontWeight.w400),
              ),
              Expanded(child: color())
            ],
          ),
        ),
      ),
    );
  }

  Widget inputDescripcion() {
    return TextFormField(
      cursorColor: Colors.white,
      maxLines: 5,
      cursorHeight: 22,
      keyboardType: TextInputType.text,
      controller: descripcionTarea,
      inputFormatters: [
        LengthLimitingTextInputFormatter(499),
      ],
      style: const TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.w600,
        fontSize: 22,
        fontFamily: 'Galano',
      ),
      decoration: InputDecoration(
        filled: true,
        contentPadding: const EdgeInsets.symmetric(vertical: 0),
        fillColor: Colors.transparent,
        hintText: "Elige una descripción o comentario para esa tarea",
        hintStyle: const TextStyle(
            fontSize: 22.0,
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

  Widget inputTarea() {
    return TextFormField(
      cursorColor: Colors.white,
      cursorHeight: 22,
      keyboardType: TextInputType.text,
      controller: nombreTarea,
      validator: (value) {
        if (value == '') {
          return "Campo obligatório";
        }
        return null;
      },
      style: const TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.w600,
        fontSize: 22,
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
            fontSize: 22.0,
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
    );
  }

  Widget color() {
    return FutureBuilder(
        future: proyectos,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            List data = snapshot.data.mensaje;
            return AnimationList(
                duration: 2000,
                shrinkWrap: true,
                // physics: NeverScrollableScrollPhysics(),
                reBounceDepth: 10.0,
                children: data.map((e) => cartProyecto(e)).toList());
          } else {
            return Container();
          }
        });
  }

  Widget cartProyecto(Proyecto data) {
    return GestureDetector(
      onTap: () {
        proyectoSeleccionado = data.pkProyecto;
        setState(() {});
      },
      child: Container(
        height: 50,
        margin: const EdgeInsets.only(top: 10),
        decoration: BoxDecoration(
            border: Border.all(
                color: (proyectoSeleccionado == data.pkProyecto)
                    ? Colors.white
                    : Colors.transparent,
                width: (proyectoSeleccionado == data.pkProyecto) ? 1 : 0),
            color: Color(int.parse("0xff${data.color}")),
            borderRadius: BorderRadius.circular(5)),
        child: Stack(
          children: [
            Positioned(
                right: 0,
                top: 0,
                child: (proyectoSeleccionado == data.pkProyecto)
                    ? Container(
                        decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(5))),
                        padding: const EdgeInsets.all(3),
                        child: Icon(
                          Icons.check,
                          color: Color(int.parse("0xff${data.color}")),
                          size: 15,
                        ),
                      )
                    : Container()),
            Center(
                child: Text(
              data.nombre!,
              style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  fontFamily: 'Galano',
                  color: Colors.black),
            )),
          ],
        ),
      ),
    );
  }

  crearTarea() {
    globals.estaCargando = true;
    setState(() {});
    if (!formState.currentState!.validate()) {
      globals.estaCargando = false;
      setState(() {});
      return;
    }
    if (proyectoSeleccionado == null) {
      globals.estaCargando = false;
      setState(() {});
      return;
    }
    TareasProvider()
        .registrarTarea(
            nombreTarea.text, descripcionTarea.text, proyectoSeleccionado, 1)
        .then((value) {
      if (value["estado"]) {
        Navigator.pop(context);
        Fluttertoast.showToast(
            msg: "Tarea creada correctamente",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            backgroundColor: Colors.white,
            textColor: Colors.black,
            fontSize: 16.0);
      } else {
        globals.estaCargando = false;
        setState(() {});
        Fluttertoast.showToast(
            msg: value["mensaje"],
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.TOP,
            backgroundColor: Colors.white,
            textColor: Colors.black,
            fontSize: 16.0);
      }
    });
  }
}
