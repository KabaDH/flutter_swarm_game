import 'package:flamegame/new_game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';


class HighscoreText {
  final NewGame newGame;
  late TextPainter painter;
  late Offset position;

  HighscoreText(this.newGame) {
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
    int highscore = newGame.storage.getInt('highscore') ?? 0;
    // int highscore = 10000;
    painter.text = TextSpan(
      text: 'Highscore: $highscore',
      style: TextStyle(
        color: Colors.white,
        fontSize: 40.0,
      ),
    );
    painter.layout();

    position = Offset(
      (newGame.size.x / 2) - (painter.width / 2),
      (newGame.size.y * 0.2) - (painter.height / 2),
    );
  }
}
