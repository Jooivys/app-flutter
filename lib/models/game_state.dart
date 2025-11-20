import 'battle_log.dart';

class GameState {
  int playerHp;
  int enemyHp;
  final int playerMaxHp;
  final int enemyMaxHp;
  final int playerAttack;
  final int enemyAttack;
  final String playerClassName;
  final String enemyName;
  String lastMessage;
  bool isPlayerTurn;
  bool gameEnded;
  bool playerWon;
  final List<BattleLogEntry> battleLogs;

  GameState({
    required this.playerHp,
    required this.enemyHp,
    required this.playerMaxHp,
    required this.enemyMaxHp,
    required this.playerAttack,
    required this.enemyAttack,
    required this.playerClassName,
    required this.enemyName,
    this.lastMessage = '',
    this.isPlayerTurn = true,
    this.gameEnded = false,
    this.playerWon = false,
    List<BattleLogEntry>? battleLogs,
  }) : battleLogs = battleLogs ?? [];
  
  void updateMessage(String message) {
    lastMessage = message;
  }
  
  void addLog(BattleLogEntry log) {
    battleLogs.add(log);
  }
  
  void switchTurn() {
    isPlayerTurn = !isPlayerTurn;
  }
  
  void endGame(bool winner) {
    gameEnded = true;
    playerWon = winner;
  }
}

