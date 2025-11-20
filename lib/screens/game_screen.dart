import 'package:flutter/material.dart';
import '../models/player_class.dart';
import '../models/enemy_type.dart';
import '../models/game_state.dart';
import '../models/battle_log.dart';
import '../services/game_logic.dart';
import '../services/currency_service.dart';
import '../services/shop_service.dart';
import '../services/progression_service.dart';
import '../widgets/hp_bar_widget.dart';
import '../widgets/battle_log_widget.dart';
import '../widgets/coin_display_widget.dart';
import '../widgets/animated_dice_widget.dart';
import 'shop_screen.dart';

class GameScreen extends StatefulWidget {
  final PlayerClass playerClass;

  const GameScreen({super.key, required this.playerClass});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late GameState gameState;
  int? lastDiceRoll;
  final GlobalKey<CoinDisplayWidgetState> _coinDisplayKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _initializeGame();
  }

  Future<void> _initializeGame() async {
    final enemyType = GameLogic.getRandomEnemy();
    
    final attackBonus = await ShopService.getTotalAttackBoost();
    final hpBonus = await ShopService.getTotalHpBoost();
    
    final currentWave = await ProgressionService.getCurrentWave();
    final enemyHpBonus = ProgressionService.getEnemyHpBonus(currentWave);
    final enemyAttackBonus = ProgressionService.getEnemyAttackBonus(currentWave);
    
    final totalHp = widget.playerClass.hp + hpBonus;
    final totalAttack = widget.playerClass.baseAttack + attackBonus;
    
    final enemyTotalHp = enemyType.hp + enemyHpBonus;
    final enemyTotalAttack = enemyType.baseAttack + enemyAttackBonus;
    
    setState(() {
      gameState = GameState(
        playerHp: totalHp,
        enemyHp: enemyTotalHp,
        playerMaxHp: totalHp,
        enemyMaxHp: enemyTotalHp,
        playerAttack: totalAttack,
        enemyAttack: enemyTotalAttack,
        playerClassName: widget.playerClass.name,
        enemyName: enemyType.name,
      );
      
      gameState.addLog(BattleLogEntry(
        type: BattleLogType.gameStart,
        message: 'Combate iniciado (${ProgressionService.getWaveString(currentWave)}): ${widget.playerClass.name} vs ${enemyType.name}',
      ));
    });
  }

  void _playerAttack() {
    if (gameState.gameEnded || !gameState.isPlayerTurn) return;

    setState(() {
      lastDiceRoll = GameLogic.rollD6();
      int damage = GameLogic.calculateDamage(
        gameState.playerAttack,
        lastDiceRoll!,
      );
      gameState.enemyHp -= damage;

      if (gameState.enemyHp < 0) gameState.enemyHp = 0;

      gameState.updateMessage(
        'Você rolou $lastDiceRoll! Causou $damage de dano no ${gameState.enemyName}!',
      );
      
      gameState.addLog(BattleLogEntry(
        type: BattleLogType.playerAttack,
        message: 'Você atacou ${gameState.enemyName}',
        diceRoll: lastDiceRoll,
        damage: damage,
      ));
      
      gameState.switchTurn();

      if (gameState.enemyHp <= 0) {
        gameState.endGame(true);
        
        _awardVictoryCoins();
      } else {
        Future.delayed(const Duration(milliseconds: 1500), () {
          if (mounted && !gameState.gameEnded) {
            _enemyAttack();
          }
        });
      }
    });
  }

  void _enemyAttack() async {
    if (gameState.gameEnded) return;

    setState(() {
      int diceRoll = GameLogic.rollD6();
      int damage = GameLogic.calculateDamage(
        gameState.enemyAttack,
        diceRoll,
      );
      gameState.playerHp -= damage;

      if (gameState.playerHp < 0) gameState.playerHp = 0;

      gameState.updateMessage(
        '${gameState.enemyName} rolou $diceRoll! Você recebeu $damage de dano!',
      );
      
      gameState.addLog(BattleLogEntry(
        type: BattleLogType.enemyAttack,
        message: '${gameState.enemyName} atacou você',
        diceRoll: diceRoll,
        damage: damage,
      ));
      
      gameState.switchTurn();
    });

    if (gameState.playerHp <= 0 && !gameState.gameEnded) {
      gameState.endGame(false);
      
      final lostCoins = await CurrencyService.getCoins();
      await CurrencyService.resetCoins();
      _coinDisplayKey.currentState?.refresh();
      
      setState(() {
        gameState.updateMessage(
          lostCoins > 0 
            ? '💀 DERROTA! O ${gameState.enemyName} te derrotou... Perdeu $lostCoins moedas!'
            : '💀 DERROTA! O ${gameState.enemyName} te derrotou...',
        );
        
        gameState.addLog(BattleLogEntry(
          type: BattleLogType.defeat,
          message: lostCoins > 0 
            ? '💀 DERROTA! O ${gameState.enemyName} te derrotou... Perdeu $lostCoins moedas!'
            : '💀 DERROTA! O ${gameState.enemyName} te derrotou...',
        ));
      });
    }
  }

  Future<void> _awardVictoryCoins() async {
    final currentWave = await ProgressionService.getCurrentWave();
    final baseReward = ProgressionService.getCoinsReward(currentWave);
    final multiplier = await ShopService.getCoinMultiplier();
    
    final coinsEarned = await CurrencyService.addCoins(baseReward, multiplier: multiplier);
    
    setState(() {
      final waveString = ProgressionService.getWaveString(currentWave);
      gameState.updateMessage(
        '🎉 VITÓRIA! Você derrotou o ${gameState.enemyName}! Ganhou $coinsEarned moedas ($waveString)!',
      );
      
      gameState.addLog(BattleLogEntry(
        type: BattleLogType.victory,
        message: '🎉 VITÓRIA! Você derrotou ${gameState.enemyName}! Ganhou $coinsEarned moedas',
      ));
    });
    
    await ProgressionService.incrementWave();
    _coinDisplayKey.currentState?.refresh();
  }

  void _resetGame() async {
    final enemyType = GameLogic.getRandomEnemy();
    
    final attackBonus = await ShopService.getTotalAttackBoost();
    final hpBonus = await ShopService.getTotalHpBoost();
    
    final currentWave = await ProgressionService.getCurrentWave();
    final enemyHpBonus = ProgressionService.getEnemyHpBonus(currentWave);
    final enemyAttackBonus = ProgressionService.getEnemyAttackBonus(currentWave);
    
    final totalHp = widget.playerClass.hp + hpBonus;
    final totalAttack = widget.playerClass.baseAttack + attackBonus;
    
    final enemyTotalHp = enemyType.hp + enemyHpBonus;
    final enemyTotalAttack = enemyType.baseAttack + enemyAttackBonus;
    
    setState(() {
      gameState = GameState(
        playerHp: totalHp,
        enemyHp: enemyTotalHp,
        playerMaxHp: totalHp,
        enemyMaxHp: enemyTotalHp,
        playerAttack: totalAttack,
        enemyAttack: enemyTotalAttack,
        playerClassName: widget.playerClass.name,
        enemyName: enemyType.name,
      );
      lastDiceRoll = null;
      
      gameState.addLog(BattleLogEntry(
        type: BattleLogType.gameStart,
        message: 'Novo combate (${ProgressionService.getWaveString(currentWave)}): ${widget.playerClass.name} vs ${enemyType.name}',
      ));
    });
  }

  void _returnToMenu() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final playerClass = widget.playerClass;
    final currentEnemyType = EnemyType.values.firstWhere(
      (e) => e.name == gameState.enemyName,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('⚔️ COMBATE', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.black87,
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: CoinDisplayWidget(key: _coinDisplayKey),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              _buildEnemyCard(currentEnemyType),
              const SizedBox(height: 20),
              _buildCombatMessage(),
              const SizedBox(height: 20),
              _buildPlayerCard(playerClass),
              const SizedBox(height: 20),
              // Battle Log
              BattleLogWidget(logs: gameState.battleLogs),
              const SizedBox(height: 20),
              if (!gameState.gameEnded) _buildAttackButton(),
              if (gameState.gameEnded) _buildGameEndButtons(),
              const SizedBox(height: 20),
              _buildStatsInfo(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEnemyCard(EnemyType enemyType) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: enemyType.color.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: enemyType.color, width: 2),
      ),
      child: Column(
        children: [
          const Text(
            'INIMIGO',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white70,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            gameState.enemyName,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: enemyType.color,
            ),
          ),
          const SizedBox(height: 12),
          HpBarWidget(
            currentHp: gameState.enemyHp,
            maxHp: gameState.enemyMaxHp,
            color: enemyType.color,
          ),
        ],
      ),
    );
  }

  Widget _buildCombatMessage() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.black87,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.amber, width: 1),
      ),
      child: Text(
        gameState.lastMessage.isEmpty
            ? 'Clique no botão para começar o combate!'
            : gameState.lastMessage,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.amber,
        ),
      ),
    );
  }

  Widget _buildPlayerCard(PlayerClass playerClass) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: playerClass.color.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: playerClass.color, width: 2),
      ),
      child: Column(
        children: [
          const Text(
            'VOCÊ',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white70,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            playerClass.name,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: playerClass.color,
            ),
          ),
          const SizedBox(height: 12),
          HpBarWidget(
            currentHp: gameState.playerHp,
            maxHp: gameState.playerMaxHp,
            color: playerClass.color,
          ),
        ],
      ),
    );
  }

  Widget _buildAttackButton() {
    return Column(
      children: [
        if (!gameState.isPlayerTurn && !gameState.gameEnded) ...[
          const SizedBox(height: 10),
          const Text(
            'Aguardando...',
            style: TextStyle(
              fontSize: 16,
              color: Colors.white70,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          const AnimatedDiceWidget(
            isRolling: true,
          ),
          const SizedBox(height: 20),
        ],
        ElevatedButton(
          onPressed: gameState.isPlayerTurn ? _playerAttack : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: gameState.isPlayerTurn
                ? Colors.red.withValues(alpha: 0.9)
                : Colors.grey,
            padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 20),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 8,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (gameState.isPlayerTurn)
                const Icon(Icons.bolt, size: 32)
              else
                const Icon(Icons.hourglass_empty, size: 32),
              const SizedBox(width: 12),
              Flexible(
                child: Text(
                  gameState.isPlayerTurn ? 'ATACAR' : 'Aguarde...',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildGameEndButtons() {
    return Column(
      children: [
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton.icon(
              onPressed: _resetGame,
              icon: const Icon(Icons.refresh),
              label: const Text('Novo Combate'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
            ),
            const SizedBox(width: 8),
            ElevatedButton.icon(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ShopScreen()),
              ),
              icon: const Icon(Icons.store),
              label: const Text('Loja'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
            ),
            const SizedBox(width: 8),
            ElevatedButton.icon(
              onPressed: _returnToMenu,
              icon: const Icon(Icons.home),
              label: const Text('Menu'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatsInfo() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildStatColumn('Ataque Base', '${gameState.playerAttack}'),
          _buildStatColumn('Ataque Inimigo', '${gameState.enemyAttack}'),
          _buildStatColumn('Dado D6', '1-6'),
        ],
      ),
    );
  }

  Widget _buildStatColumn(String label, String value) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.white70,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}
