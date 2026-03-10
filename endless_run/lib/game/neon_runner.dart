import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'game_state.dart';
import 'game_painter.dart';

class NeonRunner extends StatefulWidget {
  const NeonRunner({super.key});

  @override
  State<NeonRunner> createState() => _NeonRunnerState();
}

class _NeonRunnerState extends State<NeonRunner>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late GameState _gameState;
  double _lastElapsedTime = 0;

  @override
  void initState() {
    super.initState();

    // El groundY se ajustará cuando sepamos el tamaño de la pantalla,
    // por ahora usamos un valor por defecto que se actualizará en el primer frame.
    _gameState = GameState(groundY: 0);

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..addListener(_update);

    _controller.repeat();
  }

  void _update() {
    if (!mounted) return;

    final double currentTime =
        _controller.lastElapsedDuration?.inMilliseconds.toDouble() ?? 0;
    final double dt = (currentTime - _lastElapsedTime) / 1000.0;
    _lastElapsedTime = currentTime;

    // Solo actualizar si el dt es razonable (evitar saltos grandes al inicio)
    if (dt > 0 && dt < 0.1) {
      setState(() {
        _gameState.update(
          dt,
          currentTime / 1000.0,
          MediaQuery.of(context).size.width,
        );
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTap() {
    if (_gameState.status == GameStatus.gameOver) {
      setState(() {
        _gameState.reset();
        _lastElapsedTime =
            _controller.lastElapsedDuration?.inMilliseconds.toDouble() ?? 0;
      });
    } else {
      _gameState.player.jump();
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Actualizar groundY basado en el tamaño real de la pantalla
        _gameState.groundY = constraints.maxHeight * 0.8;

        return Focus(
          autofocus: true,
          onKeyEvent: (node, event) {
            if (event is KeyDownEvent) {
              if (event.logicalKey == LogicalKeyboardKey.space ||
                  event.logicalKey == LogicalKeyboardKey.keyW) {
                _handleTap();
                return KeyEventResult.handled;
              }
            }
            return KeyEventResult.ignored;
          },
          child: GestureDetector(
            onTapDown: (_) => _handleTap(),
            child: Container(
              color: const Color(0xFF0D0221),
              child: CustomPaint(
                painter: GamePainter(state: _gameState),
                size: Size(constraints.maxWidth, constraints.maxHeight),
              ),
            ),
          ),
        );
      },
    );
  }
}
