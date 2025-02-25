import 'package:flame/game.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'package:flutter_loggin/models/usuari.dart'; // Importar el modelo de usuario
import 'package:flutter_loggin/provider/usuarisProvider.dart';

void main() {
  // La instancia de `MyGame` debe recibir un usuario desde `Gametest`
  runApp(MaterialApp(home: Gametest()));
}

class MyGame extends FlameGame {
  final Usuari usuari; // ✅ Guardar el usuario que se recibe
  final UsuarisProvider usuarisProvider = UsuarisProvider();

  MyGame({required this.usuari}); // ✅ Constructor que recibe el usuario

  late Player player;
  late Enemy enemy;
  ValueNotifier<int> score = ValueNotifier<int>(0);
  ValueNotifier<double> timeSurvived = ValueNotifier<double>(0);
  bool isGameOver = false;
  BuildContext? context; // Para mostrar diálogos en Flutter

  @override
  Future<void> onLoad() async {
    player = Player();
    enemy = Enemy();
    add(player);
    add(enemy);
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (!isGameOver) {
      timeSurvived.value += dt;

      Rect playerRect = player.toRect();
      Rect enemyRect = enemy.toRect();
      Rect intersection = playerRect.intersect(enemyRect);

      if (intersection.height >= playerRect.height * 0.5 &&
          intersection.width > 0) {
        isGameOver = true;
        showGameOverDialog();
      }
    }
  }

  void showGameOverDialog() {
    if (context != null) {
      showDialog(
        context: context!,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Game Over"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                    "Usuari: ${usuari.nom}"), // ✅ Mostrar el nombre del usuario
                Text("Score: ${score.value}"),
                Text("Time: ${timeSurvived.value.toStringAsFixed(1)}s"),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  double nouBTC = score.value + 0.0;
                  usuari.btc = usuari.btc + nouBTC;

                  usuarisProvider.actualizarBtc(usuari.id, nouBTC);

                  resetGame();
                },
                child: const Text("Retry"),
              ),
              TextButton(
                onPressed: () {
                  double nouBTC = score.value + 0.0;
                  usuari.btc = usuari.btc + nouBTC;
                  usuarisProvider.actualizarBtc(usuari.id, nouBTC);
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                },
                child: const Text("Exit"),
              ),
            ],
          );
        },
      );
    }
  }

  void resetGame() {
    isGameOver = false;
    score.value = 0;
    timeSurvived.value = 0;
    player.position = Vector2(size.x / 2, size.y - 180);
    enemy.position =
        Vector2(Random().nextDouble() * (size.x - enemy.size.x), 0);
  }
}

class Player extends SpriteComponent with HasGameRef<MyGame> {
  @override
  Future<void> onLoad() async {
    sprite = await gameRef.loadSprite('player.png');
    size = Vector2(150, 150);
    position = Vector2(gameRef.size.x / 2, gameRef.size.y - 180);
  }

  void moveLeft() {
    if (!gameRef.isGameOver) {
      position.x = max(0, position.x - 10);
    }
  }

  void moveRight() {
    if (!gameRef.isGameOver) {
      position.x = min(gameRef.size.x - size.x, position.x + 10);
    }
  }
}

class Enemy extends SpriteComponent with HasGameRef<MyGame> {
  @override
  Future<void> onLoad() async {
    sprite = await gameRef.loadSprite('enemy.png');
    size = Vector2(80, 80);
    position = Vector2(Random().nextDouble() * (gameRef.size.x - size.x), 0);
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (!gameRef.isGameOver) {
      position.y += 2;
      if (position.y > gameRef.size.y) {
        position.y = 0;
        position.x = Random().nextDouble() * (gameRef.size.x - size.x);
        gameRef.score.value += 1;
      }
    }
  }
}

class Gametest extends StatelessWidget {
  const Gametest({super.key});

  @override
  Widget build(BuildContext context) {
    final Usuari? usuari =
        ModalRoute.of(context)?.settings.arguments as Usuari?;
    final MyGame game = MyGame(usuari: usuari!); // ✅ Pasar usuario al juego
    game.context = context; // ✅ Asignar el contexto

    return Scaffold(
      body: Stack(
        children: [
          GameWidget(game: game),
          Positioned(
            top: 40,
            left: 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Usuari: ${usuari.nom}', // ✅ Ahora sí imprime el nombre del usuario
                  style: const TextStyle(fontSize: 24, color: Colors.white),
                ),
                ValueListenableBuilder<int>(
                  valueListenable: game.score,
                  builder: (context, score, _) => Text(
                    'Score: $score',
                    style: const TextStyle(fontSize: 24, color: Colors.white),
                  ),
                ),
                ValueListenableBuilder<double>(
                  valueListenable: game.timeSurvived,
                  builder: (context, time, _) => Text(
                    'Time: ${time.toStringAsFixed(1)}s',
                    style: const TextStyle(fontSize: 24, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 20,
            left: 20,
            child: GestureDetector(
              onTap: () => game.player.moveLeft(),
              child: SizedBox(
                  width: 100,
                  height: 100,
                  child: Container(color: Colors.transparent)),
            ),
          ),
          Positioned(
            bottom: 20,
            right: 20,
            child: GestureDetector(
              onTap: () => game.player.moveRight(),
              child: SizedBox(
                  width: 100,
                  height: 100,
                  child: Container(color: Colors.transparent)),
            ),
          ),
        ],
      ),
    );
  }
}
