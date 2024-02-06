import 'package:flutter/material.dart';

class MyCustomAnimatedRoute extends PageRouteBuilder {
  final Widget enterWidget;
  final double coordenadaX;
  final double coordenadaY;

  MyCustomAnimatedRoute(
      {required this.enterWidget,
      required this.coordenadaX,
      required this.coordenadaY})
      : super(
          opaque: false,
          pageBuilder: (context, animation, secondaryAnimation) => enterWidget,
          transitionDuration: const Duration(milliseconds: 400),
          reverseTransitionDuration: const Duration(milliseconds: 300),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            animation = CurvedAnimation(
                parent: animation,
                curve: Curves.fastLinearToSlowEaseIn,
                reverseCurve: Curves.fastOutSlowIn);
            return ScaleTransition(
                alignment: Alignment(coordenadaX, coordenadaY),
                scale: animation,
                child: child);
          },
        );
}
