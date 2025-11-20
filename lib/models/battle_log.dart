enum BattleLogType {
  playerAttack,
  enemyAttack,
  victory,
  defeat,
  gameStart,
}

class BattleLogEntry {
  final BattleLogType type;
  final String message;
  final int? damage;
  final int? diceRoll;
  final DateTime timestamp;

  BattleLogEntry({
    required this.type,
    required this.message,
    this.damage,
    this.diceRoll,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();

  String get displayMessage {
    final time = '${timestamp.hour.toString().padLeft(2, '0')}:'
        '${timestamp.minute.toString().padLeft(2, '0')}:'
        '${timestamp.second.toString().padLeft(2, '0')}';
    
    if (diceRoll != null && damage != null) {
      return '[$time] $message (🎲 $diceRoll → $damage de dano)';
    } else if (damage != null) {
      return '[$time] $message ($damage de dano)';
    }
    return '[$time] $message';
  }
}

