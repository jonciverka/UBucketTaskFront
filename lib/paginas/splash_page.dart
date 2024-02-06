import 'package:flutter/material.dart';
import 'package:page_animation_transition/animations/bottom_to_top_transition.dart';
import 'package:page_animation_transition/page_animation_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ubuckettask/paginas/home_page.dart';
import '../globals.dart' as globals;

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => asyncInitState());
  }

  void asyncInitState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getInt("pkUsuario") == null) {
      Future.delayed(const Duration(seconds: 1), () {
        Navigator.pushNamed(context, '/LoginPage');
      });
    } else {
      globals.userName = prefs.getString("userName")!;
      globals.pkUsuario = prefs.getInt("pkUsuario")!;
      globals.correo = prefs.getString("correo")!;
      Future.delayed(const Duration(seconds: 1), () {
        Navigator.of(context).push(PageAnimationTransition(
            page: const HomePage(),
            pageAnimationType: BottomToTopTransition()));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.black,
        margin: const EdgeInsets.all(0),
        alignment: Alignment.topCenter,
        child: Center(
          child: Image.asset('assets/logo_v2.png',width: 150,),
        ),
      ),
    );
  }
}
