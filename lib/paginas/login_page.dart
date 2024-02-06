import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:page_animation_transition/animations/bottom_to_top_transition.dart';
import 'package:page_animation_transition/page_animation_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ubuckettask/paginas/home_page.dart';
import 'package:ubuckettask/paginas/registrarte_page.dart';
import 'package:ubuckettask/proveedores/sistema_provider.dart';
import '../globals.dart' as globals;

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final usuarioController = TextEditingController();
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
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 0, 0, 0),
        body: SizedBox(
          width: double.infinity,
          child: Column(
            children: [
              Expanded(flex: 1, child: texto()),
              Expanded(flex: 2, child: inputs()),
              registerButton(),
              const SizedBox(
                height: 20,
              ),
            ],
          ),
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
          "¡Bienvenido!",
          style: TextStyle(
            color: Colors.white,
            fontSize: 34,
            fontStyle: FontStyle.normal,
            fontWeight: FontWeight.w900,
            fontFamily: "Galano",
          ),
        ),
        Text(
          "Por favor inicia sesión con tu cuenta",
          style: TextStyle(
              color: Color(0xff616161),
              fontSize: 16,
              fontWeight: FontWeight.w300,
              fontFamily: "Galano"),
        )
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
            passwordInput(),
            Expanded(child: Container()),
            loginBoton(),
            const SizedBox(
              height: 20,
            ),
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

  Widget loginBoton() {
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
        onPressed: () => globals.estaCargando ? () : loginFunction(),
        child: globals.estaCargando
            ? const CircularProgressIndicator(
                color: Colors.black,
              )
            : const Text("Inicar sesión",
                style: TextStyle(
                    color: Colors.black,
                    fontFamily: 'Galano',
                    fontWeight: FontWeight.w800,
                    fontSize: 14)),
      ),
    );
  }

  Widget registerButton() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      width: double.infinity,
      height: 60,
      child: ElevatedButton(
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(Colors.black),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    side: const BorderSide(
                      width: 1.0,
                      color: Colors.white,
                    )))),
        onPressed: () => Navigator.of(context).push(PageAnimationTransition(
            page: const RegistroPage(),
            pageAnimationType: BottomToTopTransition())),
        child: const Text("Registrarse",
            style: TextStyle(
                color: Colors.white,
                fontFamily: 'Galano',
                fontWeight: FontWeight.w800,
                fontSize: 14)),
      ),
    );
  }

  loginFunction() {
    globals.estaCargando = true;
    setState(() {});
    if (!formState.currentState!.validate()) {
      globals.estaCargando = false;
      setState(() {});
      return;
    }
    SitemaProvider()
        .login(usuarioController.text.trim(), passcontroller.text.trim())
        .then((value) async {
      globals.estaCargando = false;
      setState(() {});
      if (value["estado"]) {
        globals.userName = value["mensaje"][0]["TUS_USERNAME"];
        globals.pkUsuario = value["mensaje"][0]["TUS_PK_USUARIO"];
        globals.correo = value["mensaje"][0]["TUS_EMAIL"];
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString("userName", globals.userName);
        prefs.setInt("pkUsuario", globals.pkUsuario);
        prefs.setString("correo", globals.correo);
        Navigator.of(context).push(PageAnimationTransition(
            page: const HomePage(),
            pageAnimationType: BottomToTopTransition()));
      } else {
        Fluttertoast.showToast(
            msg: value["mensaje"],
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.red,
            textColor: Colors.black,
            fontSize: 16.0);
      }
    });
  }
}
