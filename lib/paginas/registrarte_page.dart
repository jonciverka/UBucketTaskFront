import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ubuckettask/proveedores/sistema_provider.dart';
import '../globals.dart' as globals;

class RegistroPage extends StatefulWidget {
  const RegistroPage({super.key});

  @override
  State<RegistroPage> createState() => _RegistroPageState();
}

class _RegistroPageState extends State<RegistroPage> {
  final usuarioController = TextEditingController();
  final correoController = TextEditingController();
  final passcontroller = TextEditingController();
  GlobalKey<FormState> formState = GlobalKey<FormState>();
  bool _passwordVisible = false;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => asyncInitState());
  }

  void asyncInitState() async {}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 0, 0, 0),
      body: SizedBox(
        width: double.infinity,
        child: Column(
          children: [
            Expanded(flex: 1, child: texto()),
            Expanded(flex: 3, child: inputs()),
          ],
        ),
      ),
    );
  }

  Widget texto() {
    return const Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          "Registro",
          style: TextStyle(
            color: Colors.white,
            fontSize: 34,
            fontStyle: FontStyle.normal,
            fontWeight: FontWeight.w900,
            fontFamily: "Galano",
          ),
        ),
      ],
    );
  }

  Widget inputs() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Form(
        // autovalidateMode: AutovalidateMode.disabled,
        key: formState,
        child: Column(
          children: [
            usernameInput(),
            const SizedBox(height: 15),
            correoInput(),
            const SizedBox(height: 15),
            passwordInput(),
            Expanded(child: Container()),
            registroBoton(),
            const SizedBox(
              height: 20,
            )
          ],
        ),
      ),
    );
  }

  Widget usernameInput() {
    return TextFormField(
      cursorColor: const Color.fromARGB(255, 0, 0, 10),
      cursorHeight: 15,
      keyboardType: TextInputType.text,
      controller: usuarioController,
      validator: (value) {
        if (value == '') {
          return "Campo obligatório";
        }
        return null;
      },
      style: const TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.w400,
        fontSize: 14,
        fontFamily: 'Galano',
      ),
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.person_2_sharp),
        prefixIconColor: const Color(0xff565A66),
        filled: true,
        contentPadding:
            const EdgeInsets.symmetric(vertical: 25.0, horizontal: 10.0),
        fillColor: const Color(0xff22252c),
        hintText: "Usuario",
        hintStyle: const TextStyle(
            fontSize: 14.0,
            fontFamily: 'Galano',
            color: Color(0xff616161),
            fontWeight: FontWeight.w600),
        focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Color(0xff2A2B2E), width: 0),
            borderRadius: BorderRadius.circular(20)),
        enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Color(0xff2A2B2E), width: 0),
            borderRadius: BorderRadius.circular(20)),
        errorBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Color(0xff2A2B2E), width: 1),
            borderRadius: BorderRadius.circular(20)),
        focusedErrorBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Color(0xff2A2B2E), width: 1),
            borderRadius: BorderRadius.circular(20)),
      ),
    );
  }

  Widget correoInput() {
    return TextFormField(
      cursorColor: const Color.fromARGB(255, 0, 0, 10),
      cursorHeight: 15,
      keyboardType: TextInputType.emailAddress,
      controller: correoController,
      validator: (value) {
        if (value == '') {
          return "Campo obligatório";
        }
        return null;
      },
      style: const TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.w400,
        fontSize: 14,
        fontFamily: 'Galano',
      ),
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.email),
        prefixIconColor: const Color(0xff565A66),
        filled: true,
        contentPadding:
            const EdgeInsets.symmetric(vertical: 25.0, horizontal: 10.0),
        fillColor: const Color(0xff22252c),
        hintText: "Correo",
        hintStyle: const TextStyle(
            fontSize: 14.0,
            fontFamily: 'Galano',
            color: Color(0xff616161),
            fontWeight: FontWeight.w600),
        focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Color(0xff2A2B2E), width: 0),
            borderRadius: BorderRadius.circular(20)),
        enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Color(0xff2A2B2E), width: 0),
            borderRadius: BorderRadius.circular(20)),
        errorBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Color(0xff2A2B2E), width: 1),
            borderRadius: BorderRadius.circular(20)),
        focusedErrorBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Color(0xff2A2B2E), width: 1),
            borderRadius: BorderRadius.circular(20)),
      ),
    );
  }

  Widget passwordInput() {
    return TextFormField(
      cursorColor: Colors.black,
      cursorHeight: 15,
      keyboardType: TextInputType.text,
      controller: passcontroller,
      validator: (value) {
        if (value == '') {
          return "Campo obligatório";
        }
        return null;
      },
      style: const TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.w400,
        fontSize: 14,
        fontFamily: 'Galano',
      ),
      obscureText: _passwordVisible,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.lock_outline),
        suffixIcon: IconButton(
          icon: Icon(
            _passwordVisible ? Icons.visibility : Icons.visibility_off,
            color: const Color(0xff565A66),
          ),
          onPressed: () {
            setState(() {
              _passwordVisible = !_passwordVisible;
            });
          },
        ),
        prefixIconColor: const Color(0xff565A66),
        filled: true,
        contentPadding:
            const EdgeInsets.symmetric(vertical: 25.0, horizontal: 10.0),
        fillColor: const Color(0xff22252c),
        hintText: "Contraseña",
        hintStyle: const TextStyle(
            fontSize: 14.0,
            fontFamily: 'Galano',
            color: Color(0xff616161),
            fontWeight: FontWeight.w600),
        focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Color(0xff2A2B2E), width: 0),
            borderRadius: BorderRadius.circular(20)),
        enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Color(0xff2A2B2E), width: 0),
            borderRadius: BorderRadius.circular(20)),
        errorBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Color(0xff2A2B2E), width: 0),
            borderRadius: BorderRadius.circular(20)),
        focusedErrorBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Color(0xff2A2B2E), width: 1),
            borderRadius: BorderRadius.circular(20)),
      ),
    );
  }

  Widget registroBoton() {
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: ElevatedButton(
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ))),
        onPressed: () => globals.estaCargando ? () : registroFunction(),
        child: globals.estaCargando
            ? const CircularProgressIndicator(
                color: Colors.black,
              )
            : const Text("Registrarse",
                style: TextStyle(
                    color: Colors.black,
                    fontFamily: 'Galano',
                    fontWeight: FontWeight.w800,
                    fontSize: 14)),
      ),
    );
  }

  registroFunction() {
    globals.estaCargando = true;
    setState(() {});
    if (!formState.currentState!.validate()) {
      globals.estaCargando = false;
      setState(() {});
      return;
    }
    SitemaProvider()
        .registrarUsuario(correoController.text.trim(),
            passcontroller.text.trim(), usuarioController.text.trim())
        .then((value) async {
      globals.estaCargando = false;
      setState(() {});
      if (value["estado"]) {
        Navigator.pop(context);
      } else {
        Fluttertoast.showToast(
            msg: value["mensaje"],
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.TOP,
            backgroundColor: Colors.red,
            textColor: Colors.black,
            fontSize: 16.0);
      }
    });
  }
}
