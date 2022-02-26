import 'package:flame/palette.dart';
import 'package:flamegame/new_game.dart';

import 'components/enemy.dart';


class EnemySpawner {
  final NewGame newGame;
  final int maxSpawnInterval = 3000;
  final int minSpawnInterval = 700;
  final int intervalChange = 3;
  final int maxEnemies = 5;
  late int currentInterval;
  late int nextSpawn;

  EnemySpawner(this.newGame) {
    onLoad();
  }

  void onLoad() {
    killAllEnemies();
    currentInterval = maxSpawnInterval;
    nextSpawn = DateTime.now().millisecondsSinceEpoch + currentInterval;
  }

  void killAllEnemies() {
    newGame.enemies.forEach((Enemy enemy) => enemy.isDead = true);
    // newGame.enemy.isDead = true;
  }

  void update(double t) {
    int now = DateTime.now().millisecondsSinceEpoch;
    if (newGame.enemies.length < maxEnemies && now >= nextSpawn) {
      newGame.spawnEnemy();
      if (currentInterval > minSpawnInterval) {
        currentInterval -= intervalChange;
        currentInterval -= (currentInterval * 0.1).toInt();
      }
      nextSpawn = now + currentInterval;
    }
  }

}