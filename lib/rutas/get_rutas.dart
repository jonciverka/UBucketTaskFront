import 'package:flutter/material.dart';
import 'package:ubuckettask/paginas/home_page.dart';
import 'package:ubuckettask/paginas/login_page.dart';
import 'package:ubuckettask/paginas/splash_page.dart';

Map<String, WidgetBuilder> getRutas() {
  return <String, WidgetBuilder>{
    '/': (context) => const SplashScreen(),
    '/LoginPage': (context) => const LoginPage(),
    '/HomePage': (context) => const HomePage(),
  };
}
