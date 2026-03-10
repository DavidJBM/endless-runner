import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'game/neon_runner.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // Forzar orientación horizontal para mejor experiencia de juego
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);
  // Ocultar barra de estado
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: const Scaffold(body: NeonRunner()),
    );
  }
}
