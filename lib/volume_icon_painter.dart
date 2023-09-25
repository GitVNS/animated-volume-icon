import 'dart:math';

import 'package:flutter/material.dart';

class VolumeIconPainter extends CustomPainter {
  final double value;
  final double crossLine;
  final double innerArcOpacity;
  final double outerArcOpacity;
  VolumeIconPainter(
      {required this.value,
      required this.crossLine,
      required this.innerArcOpacity,
      required this.outerArcOpacity});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()..color = Colors.white;

    Path mainPath = Path()
      ..moveTo(0, size.height * 0.25)
      ..lineTo(size.width * 0.25, size.height * 0.25)
      ..lineTo(size.width * 0.53, 0)
      ..lineTo(size.width * 0.53, size.height)
      ..lineTo(size.width * 0.25, size.height * 0.75)
      ..lineTo(0, size.height * 0.75)
      ..close();

    canvas.drawPath(mainPath, paint);

    canvas.save();

    //clips the arcs at right side only
    Path clipPath = Path()
      ..moveTo(size.width * 0.6, 0)
      ..lineTo(size.width, 0)
      ..lineTo(size.width, size.height)
      ..lineTo(size.width * 0.6, size.height)
      ..close();
    canvas.clipPath(clipPath);

    //draws inner arc
    if (value > 0 || value == 0) {
      drawLowVolume(
          canvas: canvas,
          size: size,
          paint: Paint()..color = Colors.white.withOpacity(innerArcOpacity));
    }
    //draws outer arc
    if (value > 50 || value == 0) {
      drawHighVolume(
          canvas: canvas,
          size: size,
          paint: Paint()..color = Colors.white.withOpacity(outerArcOpacity));
    }

    canvas.restore();

    if (value == 0) {
      canvas.drawLine(
          Offset(size.width * 0.08, size.height * 0.08),
          Offset(size.width * crossLine, size.height * crossLine),
          Paint()
            ..color = Colors.deepPurple.shade900
            ..style = PaintingStyle.stroke
            ..strokeWidth = size.width * 0.26);
      canvas.drawLine(
          Offset(size.width * 0.08, size.height * 0.08),
          Offset(size.width * crossLine, size.height * crossLine),
          Paint()
            ..color = Colors.white
            ..style = PaintingStyle.stroke
            ..strokeWidth = size.width * 0.16);
    }
  }

  drawLowVolume(
      {required Canvas canvas, required Size size, required Paint paint}) {
    Rect inner = Rect.fromCenter(
        center: Offset(size.width / 2, size.height / 2),
        width: (size.width / 2),
        height: (size.height / 2));

    canvas.drawArc(inner, 270 * pi / 180, 180 * pi / 180, false, paint);
  }

  drawHighVolume(
      {required Canvas canvas, required Size size, required Paint paint}) {
    Rect outer = Rect.fromCenter(
        center: Offset(size.width / 2, size.height / 2),
        width: size.width - (size.width * 0.16),
        height: size.height - (size.height * 0.16));

    canvas.drawArc(
        outer,
        270 * pi / 180,
        180 * pi / 180,
        false,
        paint
          ..style = PaintingStyle.stroke
          ..strokeWidth = size.width * 0.15);
  }

  @override
  bool shouldRepaint(VolumeIconPainter oldDelegate) =>
      value != oldDelegate.value ||
      crossLine != oldDelegate.crossLine ||
      innerArcOpacity != oldDelegate.innerArcOpacity ||
      outerArcOpacity != oldDelegate.outerArcOpacity;
}
