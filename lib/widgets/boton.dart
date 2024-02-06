import 'package:flutter/material.dart';
import '../globals.dart' as globals;

class BotonOwn extends StatelessWidget {
  const BotonOwn(
      {super.key,
      required this.texto,
      required this.function,
      this.colorLetra = Colors.white,
      this.color = Colors.black});
  final String texto;
  final Color colorLetra;
  final Function function;
  final Color color;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => function(),
      child: Container(
          padding: const EdgeInsets.symmetric(vertical: 9, horizontal: 15),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20), color: color),
          child: globals.estaCargando
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 4,
                  ),
                )
              : Text(
                  texto,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: colorLetra,
                      fontFamily: 'Galano',
                      fontWeight: FontWeight.w600,
                      fontSize: 15),
                )),
    );
  }
}
