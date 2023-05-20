import 'package:chess2/game.dart';
import 'package:flutter/material.dart';
import 'util.dart';
import 'home_screen.dart';

void main() {
  runApp(const MaterialApp(
    title: 'Chess',
    home: ChessGame(),
  ));
}
