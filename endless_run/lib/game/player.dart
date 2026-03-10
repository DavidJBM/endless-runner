import 'package:flutter/material.dart';

class Player {
  // Posición Y (el eje X es estático)
  double y;
  double velocityY = 0;

  static const double gravity = 1500;
  static const double jumpStrength = -600;
  static const double playerSize = 40;

  double groundY;

  Player({required this.groundY}) : y = groundY;

  void jump() {
    if (y >= groundY) {
      velocityY = jumpStrength;
    }
  }

  void update(double dt) {
    // Aplicar gravedad
    velocityY += gravity * dt;
    y += velocityY * dt;

    // Colisión con el suelo
    if (y > groundY) {
      y = groundY;
      velocityY = 0;
    }
  }

  Rect get rect => Rect.fromLTWH(50, y - playerSize, playerSize, playerSize);
}
