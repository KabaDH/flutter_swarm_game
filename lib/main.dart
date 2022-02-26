import 'package:flame/game.dart';
import 'package:flamegame/new_game.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flame/flame.dart';
import 'package:shared_preferences/shared_preferences.dart';


Future<void> main()  async {

  // await Flame.device.fullScreen();
  // await Flame.device.setOrientation(DeviceOrientation.portraitUp);


  // SharedPreferences storage = await SharedPreferences.getInstance();
  final newGame = NewGame();
  // newGame.storage = storage;
  runApp(GameWidget(game: newGame));
}
