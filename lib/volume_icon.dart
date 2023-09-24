import 'dart:math';

import 'package:flutter/material.dart';

class VolumeIcon extends StatelessWidget {
  VolumeIcon({super.key});

  final volume = ValueNotifier<double>(0);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.black,
      body: ValueListenableBuilder(
          valueListenable: volume,
          builder: (context, val, _) {
            return Column(
              children: [
                Expanded(
                  child: Center(
                    child: Container(
                      color: Colors.white10,
                      width: size.width * 0.5,
                      height: size.width * 0.5,
                      child: CustomPaint(
                        painter: VolumeIconPainter(value: val),
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(
                      horizontal: size.width * 0.1, vertical: size.width * 0.1),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white10,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Slider(
                    value: val,
                    min: 0,
                    max: 100,
                    onChanged: (value) => volume.value = value,
                  ),
                )
              ],
            );
          }),
    );
  }
}

class VolumeIconPainter extends CustomPainter {
  final double value;
  VolumeIconPainter({required this.value});

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

    if (value == 0) {
      canvas.drawLine(
          Offset(size.width * 0.08, size.height * 0.08),
          Offset(size.width * 0.92, size.height * 0.92),
          Paint()
            ..color = Colors.white
            ..style = PaintingStyle.stroke
            ..strokeWidth = size.width * 0.16);
    }

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
      drawLowVolume(canvas: canvas, size: size, paint: paint);
    }
    //draws outer arc
    if (value > 50 || value == 0) {
      drawHighVolume(canvas: canvas, size: size, paint: paint);
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
      value != oldDelegate.value;
}
