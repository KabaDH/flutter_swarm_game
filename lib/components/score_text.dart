import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flamegame/new_game.dart';

class ScoreText {
  final NewGame newGame;
  late TextPainter painter;
  late Offset position;

  ScoreText(this.newGame) {
    painter = TextPainter(
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );
    position = Offset.zero;
  }

  void render(Canvas c) {
    painter.paint(c, position);
  }

  void update(double t) {
    if ((painter.text ?? '') != newGame.score.toString()) {
      painter.text = TextSpan(
        text: newGame.score.toString(),
        style: TextStyle(
          color: Colors.white,
          fontSize: 70.0,
        ),
      );
      painter.layout();

      position = Offset(
        (newGame.size.x / 2) - (painter.width / 2),
        (newGame.size.y * 0.2) - (painter.height / 2),
      );
    }
  }
}
