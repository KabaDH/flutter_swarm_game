import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/palette.dart';
import 'package:flamegame/new_game.dart';
import 'package:flame/game.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/gestures.dart';
import 'package:flame/palette.dart';

class Enemy {
  final NewGame newGame;
  late int health;
  late int damage;
  late double speed;
  late Rect enemyRect;
  late SpriteAnimation enemySprite;
  late Vector2 enemyPosition;
  // double stepTime = 0.1;
  // final Vector2 enemySize = Vector2(48, 60);
  final List<Vector2> enemySizes = [Vector2(48, 60),Vector2(32, 30),Vector2(16, 15)];
  late Vector2 enemySize;

  bool isDead = false;
  // Enemy(this.newGame, double x, double y)
  Enemy(this.newGame, double x, double y, SpriteAnimation sprite) {
    health = 3;
    damage = 1;
    speed = newGame.tileSize * 2;
    // enemyRect = Rect.fromLTWH(
    //   x,
    //   y,
    //   newGame.size.x / 10 * 1.2,
    //   newGame.size.x / 10 * 1.2,
    // );
    enemyPosition = Vector2(x, y);
    enemySprite = sprite;
    enemySize = enemySizes[0];
  }

  Future<void> onLoad() async {
    // enemySprite = await newGame.loadSpriteAnimation(
    //   'robot.png',
    //   SpriteAnimationData.sequenced(
    //     amount: 8,
    //     textureSize: Vector2(16, 18),
    //     stepTime: stepTime,
    //   ),
    // );
  }

  void render(Canvas c) {

    // switch (health) {
    //   case 1:
    //     enemySize = enemySizes[2];
    //     break;
    //   case 2:
    //     enemySize = enemySizes[1];
    //     break;
    //   case 3:
    //     enemySize = enemySizes[0];
    //     break;
    //   default:
    //     enemySize = enemySizes[0];
    //     break;
    // }

    enemySprite.getSprite().render(c, position: enemyPosition, size: enemySize);

    // Color color;
    // switch (health) {
    //   case 1:
    //     color = Color(0xFFFF7F7F);
    //     break;
    //   case 2:
    //     color = Color(0xFFFF4C4C);
    //     break;
    //   case 3:
    //     color = Color(0xFFFF4500);
    //     break;
    //   default:
    //     color = Color(0xFFFF0000);
    //     break;
    // }


    // Paint enemyColor = Paint()..color = color;
    // c.drawRect(enemyRect, PaletteEntry(color).paint());
  }

  void update(double t) {

    switch (health) {
      case 1:
        enemySize = enemySizes[2];
        break;
      case 2:
        enemySize = enemySizes[1];
        break;
      case 3:
        enemySize = enemySizes[0];
        break;
      default:
        enemySize = enemySizes[0];
        break;
    }

    if (!isDead) {
      enemyRect = enemyPosition & enemySize;
      double stepDistance = speed * t;
      Offset toPlayer = newGame.player.playerRect.center - enemyRect.center;
      if (stepDistance <= toPlayer.distance - newGame.tileSize * 1.25) {
        Offset stepToPlayer =
            Offset.fromDirection(toPlayer.direction, stepDistance);
        // print(toPlayer);
        // enemyRect = enemyRect.shift(stepToPlayer);
        enemyPosition = Vector2(enemyRect.shift(stepToPlayer).topLeft.dx,
            enemyRect.shift(stepToPlayer).topLeft.dy);
      } else {
        attack();
      }
    }
  }

  void attack() {
    if (!newGame.player.isDead) {
      newGame.player.currentHealth -= damage;
    }
  }

  void onTapDown() {
    if (!isDead) {
      health--;
      if (health <= 0) {
        isDead = true;
        newGame.score++;
        if (newGame.score > (newGame.storage.getInt('highscore') ?? 0)) {
          newGame.storage.setInt('highscore', newGame.score);
        }
      }
    }
  }
}
