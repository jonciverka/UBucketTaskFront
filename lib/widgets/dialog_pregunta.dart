import 'package:flutter/material.dart';
import 'package:ubuckettask/widgets/boton.dart';

class CustomDialogPreguntaEliminar {
  static Future<void> show(dynamic context, mensaje, function) async {
    await showDialog(
        context: context,
        builder: (BuildContext context) => Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0)),
              child: WidgetDialog(mensaje, function),
            ));
  }
}

// ignore: must_be_immutable
class WidgetDialog extends StatelessWidget {
  WidgetDialog(this.mensaje, this.function, {super.key});
  String? mensaje;
  Function function;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Text(
            mensaje!,
            textAlign: TextAlign.center,
            style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w500,
                fontFamily: 'Galano',
                fontSize: 18),
          ),
          const SizedBox(
            height: 15,
          ),
          Row(
            children: [
              Expanded(
                  child: BotonOwn(
                      function: () => Navigator.of(context).pop(),
                      texto: "No")),
              const SizedBox(
                width: 15,
              ),
              Expanded(child: BotonOwn(function: function, texto: "Yes"))
            ],
          ),
        ],
      ),
    );
  }
}
