import 'package:flutter/material.dart';

enum PlayerClass {
  warrior('Guerreiro', 25, 3, Icons.sports_mma, Colors.blue),
  tank('Tanque', 35, 2, Icons.shield, Colors.cyan),
  mage('Mago', 18, 4, Icons.auto_awesome, Colors.purple);

  final String name;
  final int hp;
  final int baseAttack;
  final IconData icon;
  final Color color;

  const PlayerClass(this.name, this.hp, this.baseAttack, this.icon, this.color);
  
  String get description {
    switch (this) {
      case PlayerClass.warrior:
        return 'Equilibrado entre ataque e defesa';
      case PlayerClass.tank:
        return 'Alta vida, baixo ataque';
      case PlayerClass.mage:
        return 'Baixo HP, mas alto ataque';
    }
  }
}

