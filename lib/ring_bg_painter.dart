import 'package:flutter/material.dart';

class RingBgPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var center = Offset(size.width / 2, size.height / 2);

    Paint radialGradient = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.5
      ..shader = RadialGradient(
        colors: [
          Colors.white.withOpacity(0),
          Colors.white.withOpacity(0.5),
        ],
        radius: 1.5,
      ).createShader(Rect.fromCenter(
          center: center, width: size.width, height: size.height));

    for (double r = 0; r < 3; r += 0.15) {
      canvas.drawCircle(center, size.width * r, radialGradient);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
