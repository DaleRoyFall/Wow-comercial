import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:wow_comercial/helper/size_config.dart';

class FavoriteArc extends StatelessWidget {
  final double diameter;

  const FavoriteArc({Key key, this.diameter = 200}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: MyPainter(),
      size: Size(diameter, 200),
    );
  }
}

class MyPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()..color = Colors.white;
    canvas.drawArc(
      Rect.fromCenter(
        center: Offset(100, 0),
        height: SizeConfig.adaptHeight(25),
        width: SizeConfig.adaptWidth(40),
      ),
      math.pi / 2,
      math.pi * 1 / 2,
      true,
      paint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
