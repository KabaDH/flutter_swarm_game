import 'dart:ui';

import 'package:flame/palette.dart';
import 'package:flamegame/new_game.dart';

class HealthBar {
  final NewGame newGame;
  late Rect healthBarRect;
  late Rect remainingHealthRect;

  HealthBar(this.newGame) {
    double barWidth = newGame.size.x / 1.75;
    healthBarRect = Rect.fromLTWH(
      newGame.size.x / 2 - barWidth / 2,
      newGame.size.y * 0.8,
      barWidth,
      newGame.tileSize * 0.5,
    );
    remainingHealthRect = Rect.fromLTWH(
      newGame.size.x / 2 - barWidth / 2,
      newGame.size.y * 0.8,
      barWidth,
      newGame.tileSize * 0.5,
    );
  }

  void render(Canvas c) {

    // Paint healthBarColor = Paint()..color = Color(0xFFFF0000);
    // Paint remainingBarColor = Paint()..color = Color(0xFF00FF00);
    c.drawRect(healthBarRect, PaletteEntry(Color(0xFFFF0000)).paint());
    c.drawRect(remainingHealthRect, PaletteEntry(Color(0xFF00FF00)).paint());
  }

  void update(double t) {
    double barWidth = newGame.size.x / 1.75;
    double percentHealth = newGame.player.currentHealth / newGame.player.maxHealth;
    remainingHealthRect = Rect.fromLTWH(
      newGame.size.x / 2 - barWidth / 2,
      newGame.size.y * 0.8,
      barWidth * percentHealth,
      newGame.tileSize * 0.5,
    );
  }
}
