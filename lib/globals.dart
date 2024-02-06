import 'dart:ui';

Color colorFondoNegro = const Color(0xff17181c);
String userName = '';
String correo = '';
int pkUsuario = 0;
String url = "51.222.30.154:3011";
bool _estaCargando = false;

bool get estaCargando => _estaCargando;
set estaCargando(bool valor) {
  _estaCargando = valor;
}
