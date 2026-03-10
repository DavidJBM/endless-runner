import 'dart:math';
import 'player.dart';
import 'obstacle.dart';

enum GameStatus { playing, gameOver }

class GameState {
  late Player player;
  List<Obstacle> obstacles = [];
  double score = 0;
  GameStatus status = GameStatus.playing;

  double gameSpeed = 300;
  double lastSpawnTime = 0;
  double spawnInterval = 1.5; // segundos

  final Random _random = Random();
  double _groundY;
  double get groundY => _groundY;
  set groundY(double value) {
    _groundY = value;
    player.groundY = value;
  }

  GameState({required double groundY}) : _groundY = groundY {
    player = Player(groundY: groundY);
  }

  void update(double dt, double totalTime, double screenWidth) {
    if (status == GameStatus.gameOver) return;

    player.update(dt);

    // Incrementar dificultad y puntaje
    score += dt * 10;
    gameSpeed += dt * 2;

    // Actualizar obstáculos
    for (var i = obstacles.length - 1; i >= 0; i--) {
      obstacles[i].update(dt, gameSpeed);

      // Detección de colisiones
      if (player.rect.overlaps(obstacles[i].rect)) {
        status = GameStatus.gameOver;
      }

      // Limpieza de memoria (fuera de pantalla)
      if (obstacles[i].isOffScreen) {
        obstacles.removeAt(i);
      }
    }

    // Generación procedural
    if (totalTime - lastSpawnTime > spawnInterval) {
      _spawnObstacle(totalTime, screenWidth);
    }
  }

  void _spawnObstacle(double totalTime, double screenWidth) {
    double width = 30 + _random.nextDouble() * 20;
    double height = 40 + _random.nextDouble() * 40;

    obstacles.add(
      Obstacle(
        x: screenWidth + 20, // Justo fuera de pantalla
        y: groundY,
        width: width,
        height: height,
      ),
    );

    lastSpawnTime = totalTime;
    // Intervalo aleatorio para más dinamismo
    spawnInterval = 1.0 + _random.nextDouble() * 1.5;
  }

  void reset() {
    player = Player(groundY: groundY);
    obstacles.clear();
    score = 0;
    status = GameStatus.playing;
    gameSpeed = 300;
    lastSpawnTime = 0;
  }
}
