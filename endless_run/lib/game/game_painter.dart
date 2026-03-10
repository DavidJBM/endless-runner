import 'package:flutter/material.dart';
import 'game_state.dart';

class GamePainter extends CustomPainter {
  final GameState state;

  GamePainter({required this.state});

  @override
  void paint(Canvas canvas, Size size) {
    // 1. Dibujar fondo oscuro
    final backgroundPaint = Paint()..color = const Color(0xFF0D0221);
    canvas.drawRect(Offset.zero & size, backgroundPaint);

    // 2. Dibujar el suelo (Neon Cyan)
    _drawNeonLine(
      canvas,
      Offset(0, state.groundY),
      Offset(size.width, state.groundY),
      const Color(0xFF00FBFF),
    );

    // 3. Dibujar al Jugador (Neon Magenta)
    _drawNeonRect(canvas, state.player.rect, const Color(0xFFFF00FF));

    // 4. Dibujar Obstáculos (Neon Verde/Amarillo)
    for (var obstacle in state.obstacles) {
      _drawNeonRect(canvas, obstacle.rect, const Color(0xFF39FF14));
    }

    // 5. Dibujar UI (Puntaje)
    final textPainter = TextPainter(
      text: TextSpan(
        text: 'SCORE: ${state.score.toInt()}',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 24,
          fontWeight: FontWeight.bold,
          fontFamily: 'Courier', // Estilo retro
          shadows: [Shadow(color: Colors.white24, blurRadius: 10)],
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(canvas, const Offset(20, 40));

    if (state.status == GameStatus.gameOver) {
      _drawGameOver(canvas, size);
    }
  }

  void _drawNeonLine(Canvas canvas, Offset start, Offset end, Color color) {
    // Brillo exterior
    final glowPaint = Paint()
      ..color = color.withOpacity(0.3)
      ..strokeWidth = 8
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10);
    canvas.drawLine(start, end, glowPaint);

    // Línea central brillante
    final corePaint = Paint()
      ..color = color
      ..strokeWidth = 3;
    canvas.drawLine(start, end, corePaint);
  }

  void _drawNeonRect(Canvas canvas, Rect rect, Color color) {
    // Brillo exterior
    final glowPaint = Paint()
      ..color = color.withOpacity(0.3)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10);
    canvas.drawRect(rect, glowPaint);

    // Borde brillante
    final borderPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawRect(rect, borderPaint);

    // Relleno ligero (opcional para dar volumen)
    final fillPaint = Paint()..color = color.withOpacity(0.1);
    canvas.drawRect(rect, fillPaint);
  }

  void _drawGameOver(Canvas canvas, Size size) {
    final overlayPaint = Paint()..color = Colors.black.withOpacity(0.7);
    canvas.drawRect(Offset.zero & size, overlayPaint);

    final textPainter = TextPainter(
      text: const TextSpan(
        text: 'GAME OVER\nTap to Restart',
        style: TextStyle(
          color: Color(0xFFFF00FF),
          fontSize: 40,
          fontWeight: FontWeight.bold,
          shadows: [Shadow(color: Colors.white, blurRadius: 20)],
        ),
      ),
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    );
    textPainter.layout(maxWidth: size.width);
    textPainter.paint(
      canvas,
      Offset(0, size.height / 2 - textPainter.height / 2),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
