import 'package:flutter/material.dart';

enum EnemyType {
  goblin('Goblin', 15, 3, Colors.green),
  orc('Orc', 20, 4, Colors.orange),
  ghost('Espectro', 18, 5, Colors.deepPurple);

  final String name;
  final int hp;
  final int baseAttack;
  final Color color;

  const EnemyType(this.name, this.hp, this.baseAttack, this.color);
}

