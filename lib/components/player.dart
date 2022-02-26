
import 'dart:ui';

import 'package:flame/palette.dart';
import 'package:flamegame/new_game.dart';


class Player {
  late NewGame newGame;
  late int maxHealth;
  late int currentHealth;
  late Rect playerRect;
  late bool isDead = false;

  Player(this.newGame) {
    maxHealth = currentHealth = 300;
    final pSize = newGame.tileSize * 1.5;
    playerRect = Rect.fromLTWH(
      newGame.size.x / 2 - pSize / 2,
      newGame.size.y / 2 - pSize / 2,
      pSize,
      pSize,
    );
  }

  void render(Canvas c) {

    // Paint color = Paint()..color = Color(0xFF0000FF);
    c.drawRect(playerRect, BasicPalette.green.paint());
  }

  void update(double t) {
    if (!isDead && currentHealth <= 0) {
      isDead = true;
      newGame.onLoad();
    }
  }

}
