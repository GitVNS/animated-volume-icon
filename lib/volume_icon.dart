import 'package:animated_volume_icon/volume_icon_painter.dart';
import 'package:flutter/material.dart';

class VolumeIcon extends StatefulWidget {
  const VolumeIcon({super.key});

  @override
  State<VolumeIcon> createState() => _VolumeIconState();
}

class _VolumeIconState extends State<VolumeIcon> with TickerProviderStateMixin {
  //----------
  late AnimationController _crosslineAnimationController;
  late AnimationController _innerArcAnimationController;
  late AnimationController _outerArcAnimationController;
  late Animation<double> crossLine;
  late Animation<double> innerArcOpacity;
  late Animation<double> outerArcOpacity;
  //-----------

  final volume = ValueNotifier<double>(0);

  @override
  void initState() {
    super.initState();
    _crosslineAnimationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300));
    _innerArcAnimationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 100));
    _outerArcAnimationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 100));
    crossLine = Tween<double>(begin: 0.08, end: 0.92).animate(CurvedAnimation(
        parent: _crosslineAnimationController, curve: Curves.decelerate));
    innerArcOpacity = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
        parent: _innerArcAnimationController, curve: Curves.decelerate));
    outerArcOpacity = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
        parent: _outerArcAnimationController, curve: Curves.decelerate));

    initialAnimation();
  }

  void initialAnimation() {
    if (volume.value == 0) {
      _crosslineAnimationController.reset();
      _crosslineAnimationController.forward();
      _innerArcAnimationController.reset();
      _innerArcAnimationController.forward();
      _outerArcAnimationController.reset();
      _outerArcAnimationController.forward();
    }
    if (volume.value < 0) {
      _innerArcAnimationController.reset();
      _innerArcAnimationController.forward();
    }
    if (volume.value < 50) {
      _outerArcAnimationController.reset();
      _outerArcAnimationController.forward();
    }
  }

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
                AnimatedBuilder(
                    animation: _crosslineAnimationController,
                    builder: (context, _) {
                      return Expanded(
                        child: Center(
                          child: SizedBox(
                            width: size.width * 0.5,
                            height: size.width * 0.5,
                            child: CustomPaint(
                              painter: VolumeIconPainter(
                                  value: val,
                                  crossLine: crossLine.value,
                                  innerArcOpacity: innerArcOpacity.value,
                                  outerArcOpacity: outerArcOpacity.value),
                            ),
                          ),
                        ),
                      );
                    }),
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
                    onChanged: (value) {
                      if (value == 0) {
                        _crosslineAnimationController.reset();
                        _crosslineAnimationController.forward();
                      }
                      if (value < 0) {
                        _innerArcAnimationController.reset();
                        _innerArcAnimationController.forward();
                      }
                      if (value < 50) {
                        _outerArcAnimationController.reset();
                        _outerArcAnimationController.forward();
                      }
                      volume.value = value;
                    },
                  ),
                )
              ],
            );
          }),
    );
  }

  @override
  void dispose() {
    _crosslineAnimationController.dispose();
    _innerArcAnimationController.dispose();
    _outerArcAnimationController.dispose();
    super.dispose();
  }
}
