import 'package:animation_list/animation_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ubuckettask/proveedores/proyecto_provider.dart';
import 'package:ubuckettask/widgets/boton.dart';
import '../globals.dart' as globals;
import 'package:fluttertoast/fluttertoast.dart';

class CrearProyectoPage extends StatefulWidget {
  const CrearProyectoPage({super.key});

  @override
  State<CrearProyectoPage> createState() => _CrearProyectoPageState();
}

class _CrearProyectoPageState extends State<CrearProyectoPage> {
  Color? colorSeleccionado;
  final nombreProyectoController = TextEditingController();
  GlobalKey<FormState> formState = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => asyncInitState());
  }

  void asyncInitState() async {
    globals.estaCargando = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorSeleccionado ?? const Color(0xff1c1c1e),
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
                "Crear proyecto",
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
            BotonOwn(texto: "Crear", function: () => crearProyecto())
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
                "Nombre del proyecto",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontFamily: 'Galano',
                    fontWeight: FontWeight.w400),
              ),
              inputProyecto(),
              const SizedBox(height: 10),
              Expanded(child: color())
            ],
          ),
        ),
      ),
    );
  }

  Widget inputProyecto() {
    return TextFormField(
      cursorColor: Colors.white,
      cursorHeight: 18,
      keyboardType: TextInputType.text,
      controller: nombreProyectoController,
      inputFormatters: [
        LengthLimitingTextInputFormatter(99),
      ],
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
      decoration: InputDecoration(
        filled: true,
        contentPadding: const EdgeInsets.symmetric(vertical: 0),
        fillColor: Colors.transparent,
        hintText: "Elige el nombre del proyecto",
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

  Widget color() {
    List<Color> pastelColors = [
      const Color(0xfff28b82),
      const Color(0xfffbbc04),
      const Color(0xfffff475),
      const Color(0xffccff90),
      const Color(0xffa7ffeb),
      const Color(0xffcbf0f8),
      const Color(0xffaecbfa),
      const Color(0xffd7aefb),
      const Color(0xfffdcfe8),
      const Color(0xffe6c9a8),
      const Color(0xffe8eaed),
    ];
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Color",
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w400,
            fontFamily: 'Galano',
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
              child: AnimationList(
                  duration: 2000,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  reBounceDepth: 10.0,
                  children: pastelColors.map((e) => colorWidget(e)).toList())),
        )
      ],
    );
  }

  Widget colorWidget(Color color) {
    return GestureDetector(
      onTap: () {
        colorSeleccionado = color;
        setState(() {});
      },
      child: Container(
        height: 50,
        margin: const EdgeInsets.only(top: 10),
        decoration: BoxDecoration(
            color: color,
            border: Border.all(
                color: (colorSeleccionado == color)
                    ? Colors.white
                    : Colors.transparent,
                width: (colorSeleccionado == color) ? 1 : 0),
            borderRadius: BorderRadius.circular(5)),
        child: Stack(
          children: [
            Positioned(
                right: 0,
                top: 0,
                child: (colorSeleccionado == color)
                    ? Container(
                        decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(5))),
                        padding: const EdgeInsets.all(3),
                        child: Icon(
                          Icons.check,
                          color: color,
                          size: 15,
                        ),
                      )
                    : Container()),
          ],
        ),
      ),
    );
  }

  crearProyecto() {
    globals.estaCargando = true;
    setState(() {});
    if (!formState.currentState!.validate()) {
      globals.estaCargando = false;
      setState(() {});
      return;
    }
    if (colorSeleccionado == null) {
      return;
    }
    var colorString =
        colorSeleccionado!.value.toRadixString(16).substring(2, 8);
    ProyectoProvider()
        .crearProyecto(
            nombreProyectoController.text, colorString, globals.pkUsuario)
        .then((value) {
      if (value["estado"]) {
        Navigator.pop(context);
        Fluttertoast.showToast(
            msg: "Proyecto creado correctamente",
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
