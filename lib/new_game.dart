import 'dart:async';
import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/gestures.dart';
import 'package:flame/palette.dart';
import 'package:flamegame/components/enemy.dart';
import 'package:flamegame/components/health_bar.dart';
import 'package:flamegame/components/highscore_text.dart';
import 'package:flamegame/components/player.dart';
import 'package:flamegame/components/score_text.dart';
import 'package:flamegame/enemy_spawner.dart';
import 'package:flamegame/state.dart';
import 'package:flutter/cupertino.dart';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NewGame extends Game with TapDetector {
  late SharedPreferences storage;
  late Player player;
  late EnemySpawner enemySpawner;
  late List<Enemy> enemies;
  late double tileSize;
  late HealthBar healthBar;
  late int score;
  late ScoreText scoreText;
  late HighscoreText highscoreText;
  late Random rand;
  late StateGame state;
  late SpriteAnimation enemySprite;
  late SpriteAnimation enemySpriteR;

  ///Robot
  // Vector2 is a class from `package:vector_math/vector_math_64.dart` and is widely used
  // in Flame to represent vectors. Here we need two vectors, one to define where we are
  // going to draw our robot and another one to define its size
  late SpriteAnimation runningRobot;
  late SpriteAnimation runningRobot2;
  final robotPosition = Vector2(240, 50);
  final robot2Position = Vector2(140, 50);
  final robotSize = Vector2(80, 80);
  late Sprite pressedButton;
  late Sprite unpressedButton;
  // Just like our robot needs its position and size, here we create two
  // variables for the button as well
  late final Vector2 buttonPosition; //Vector2(200, 120)
  final buttonSize = Vector2(120, 30);
  // Simple boolean variable to tell if the button is pressed or not
  bool isPressed = false;
  double stepTime = 0.1;

  static const squareSpeed = 30;
  late Rect squarePos;
  int squareDirec = 1;

  ///BasicPalette Это ничто иное как Paint: Paint paint() => Paint()..color = color
  static final squarePaint = BasicPalette.white.paint();

  @override
  void onTapDown(TapDownInfo d) {
    // On tap down we need to check if the event ocurred on the
    // button area. There are several ways of doing it, for this
    // tutorial we do that by transforming ours position and size
    // vectors into a dart:ui Rect by using the `&` operator, and
    // with that rect we can use its `contains` method which checks
    // if a point (Offset) is inside that rect
    final buttonArea = buttonPosition & buttonSize;
    isPressed = buttonArea.contains(d.eventPosition.game.toOffset());
    if (state == StateGame.playing) {
      enemies.forEach((Enemy enemy) {
        if (enemy.enemyRect.contains(d.eventPosition.game.toOffset())) {
          enemy.onTapDown();
        }
      });
    }
  }

  // On both tap up and tap cancel we just set the isPressed
  // variable to false
  @override
  void onTapUp(TapUpInfo e) {
    final buttonArea = buttonPosition & buttonSize;
    isPressed = false;
    if (buttonArea.contains(e.eventPosition.game.toOffset())) {
      state = StateGame.playing;
    }
  }

  @override
  void onTapCancel() {
    isPressed = false;
  }

  // @mustCallSuper
  // void prepare(Component c) {
  //   // first time resize
  //   c.onGameResize(size);
  // }

  // Future<Size> initialDimensions() async {
  //   // https://github.com/flutter/flutter/issues/5259
  //   // "In release mode we start off at 0x0 but we don't in debug mode"
  //   return await Future<Size>(() {
  //     if (window.physicalSize.isEmpty) {
  //       final completer = Completer<Size>();
  //       window.onMetricsChanged = () {
  //         if (!window.physicalSize.isEmpty && !completer.isCompleted) {
  //           completer.complete(window.physicalSize / window.devicePixelRatio);
  //         }
  //       };
  //       return completer.future;
  //     }
  //     return window.physicalSize / window.devicePixelRatio;
  //   });
  // }

  // Now, on the `onLoad` method, we need to load our animation. To do that we can use the
  // `loadSpriteAnimation` method, which is present on our game class.
  @override
  Future<void> onLoad() async {
    storage = await SharedPreferences.getInstance();
    tileSize = size.x / 10;
    // resize(await initialDimensions());
    state = StateGame.menu;
    rand = Random();
    player = Player(this);
    enemies = <Enemy>[];
    enemySpawner = EnemySpawner(this);
    healthBar = HealthBar(this);
    score = 0;
    scoreText = ScoreText(this);
    highscoreText = HighscoreText(this);
    buttonPosition =
        Vector2(size.x / 2 - buttonSize.x / 2, size.y / 2 - buttonSize.y / 2);

    enemySpriteR = await loadSpriteAnimation(
      'robotR.png',
      SpriteAnimationData.sequenced(
        amount: 8,
        textureSize: Vector2(16, 18),
        stepTime: stepTime,
      ),
    );

    enemySprite = await loadSpriteAnimation(
      'robot.png',
      SpriteAnimationData.sequenced(
        amount: 8,
        textureSize: Vector2(16, 18),
        stepTime: stepTime,
      ),
    );

    runningRobot = enemySprite;
    runningRobot2 = enemySpriteR;
    // `SpriteAnimationData` is a class used to tell Flame how the animation Sprite Sheet
    // is organized. In this case we are describing that our frames are laid out in a horizontal
    // sequence on the image, that there are 8 frames, that each frame is a sprite of 16x18 pixels,
    // and, finally, that each frame should appear for 0.1 seconds when the animation is running.

    // Just like we have a `loadSpriteAnimation` function, here we can use
    // `loadSprite`. To use it, we just need to inform the asset's path
    // and the position and size defining the section of the whole image
    // that we want. If we wanted to have a sprite with the full image, `srcPosition`
    // and `srcSize` could just be omitted
    unpressedButton = await loadSprite(
      'buttons.png',
      // `srcPosition` and `srcSize` here tells `loadSprite` that we want
      // just a rect (starting at (0, 0) with the dimensions (60, 20)) of the image
      // which gives us only the first button
      srcPosition: Vector2.zero(), // this is zero by default
      srcSize: Vector2(60, 20),
    );

    pressedButton = await loadSprite(
      'buttons.png',
      // Same thing here, but now a rect starting at (0, 20)
      // which gives us only the second button
      srcPosition: Vector2(0, 20),
      srcSize: Vector2(60, 20),
    );

    squarePos = Rect.fromLTWH(0, 0, 100, 100);
  }

  @override
  void render(Canvas c) {
// Since an animation is basically a list of sprites, to render it, we just need to get its
    // current sprite and render it on our canvas. Which frame is the current sprite is updated on the `update` method.
    final button = isPressed ? pressedButton : unpressedButton;
    if (state == StateGame.menu) {
      c.drawRect(squarePos, squarePaint);

      runningRobot
          .getSprite()
          .render(c, position: robotPosition, size: robotSize);
      runningRobot2
          .getSprite()
          .render(c, position: robot2Position, size: robotSize);

      highscoreText.render(c);
      button.render(c, position: buttonPosition, size: buttonSize);
    } else if (state == StateGame.playing) {
      player.render(c);
      enemies.forEach((Enemy enemy) => enemy.render(c));
      healthBar.render(c);
      scoreText.render(c);
    }
  }

  @override
  void update(double t) {
    // Here we just need to "hook" our animation into the game loop update method so the current frame is updated with the specified frequency
    runningRobot.update(t);
    runningRobot2.update(t);

    if (state == StateGame.menu) {
      highscoreText.update(t);
      squarePos = squarePos.translate(squareSpeed * squareDirec * t, 0);
      if (squareDirec == 1 && squarePos.right > size.x) {
        squareDirec = -1;
      } else if (squareDirec == -1 && squarePos.left < 0) {
        squareDirec = 1;
      }
    } else if (state == StateGame.playing) {
      enemySpawner.update(t);
      enemies.forEach((Enemy enemy) => enemy.update(t));
      enemies.removeWhere((Enemy enemy) => enemy.isDead);
      player.update(t);
      healthBar.update(t);
      scoreText.update(t);
    }
  }

  // void resize(Size size) {
  //   tileSize = size.width / 10;
  // }
  void spawnEnemy() {
    late double x, y;
    switch (rand.nextInt(4)) {
      case 0:
        // Top
        x = rand.nextDouble() * size.x;
        y = -tileSize * 2.5;
        break;
      case 1:
        // Right
        x = size.x + tileSize * 2.5;
        y = rand.nextDouble() * size.y;
        break;
      case 2:
        // Bottom
        x = rand.nextDouble() * size.x;
        y = size.y + tileSize * 2.5;
        break;
      case 3:
        // Left
        x = -tileSize * 2.5;
        y = rand.nextDouble() * size.y;
        break;
    }
    enemies.add(Enemy(this, x, y, x < size.x / 2 ? enemySprite : enemySpriteR));
  }

  @override
  Color backgroundColor() => const Color(0xFF222222);
}
