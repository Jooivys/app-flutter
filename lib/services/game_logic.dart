import 'dart:math';
import '../models/enemy_type.dart';

class GameLogic {
  static final Random _random = Random.secure();
  
  static int rollD6() {
    return _random.nextInt(6) + 1;
  }
  
  static EnemyType getRandomEnemy() {
    return EnemyType.values[_random.nextInt(EnemyType.values.length)];
  }
  
  static int calculateDamage(int baseAttack, int diceRoll) {
    return baseAttack + diceRoll;
  }
  
  static bool isHpCritical(int currentHp, int maxHp) {
    return currentHp < maxHp * 0.3;
  }
}

