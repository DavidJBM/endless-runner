import 'package:flutter/material.dart';

class Obstacle {
  double x;
  final double y;
  final double width;
  final double height;

  bool isPassed = false;

  Obstacle({
    required this.x,
    required this.y,
    required this.width,
    required this.height,
  });

  void update(double dt, double speed) {
    x -= speed * dt;
  }

  Rect get rect => Rect.fromLTWH(x, y - height, width, height);

  bool get isOffScreen => x + width < 0;
}
