import 'package:flutter/material.dart';
import '../models/player_class.dart';
import '../services/shop_service.dart';
import '../widgets/coin_display_widget.dart';
import 'game_screen.dart';
import 'shop_screen.dart';

class MainMenuScreen extends StatefulWidget {
  const MainMenuScreen({super.key});

  @override
  State<MainMenuScreen> createState() => _MainMenuScreenState();
}

class _MainMenuScreenState extends State<MainMenuScreen> {
  int _attackBonus = 0;
  int _hpBonus = 0;

  @override
  void initState() {
    super.initState();
    _loadBonuses();
  }

  Future<void> _loadBonuses() async {
    final attackBoost = await _getAttackBoost();
    final hpBoost = await _getHpBoost();
    setState(() {
      _attackBonus = attackBoost;
      _hpBonus = hpBoost;
    });
  }

  Future<int> _getAttackBoost() async {
    return await ShopService.getTotalAttackBoost();
  }

  Future<int> _getHpBoost() async {
    return await ShopService.getTotalHpBoost();
  }

  Future<void> _navigateToShop() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ShopScreen()),
    );
    _loadBonuses();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            const CoinDisplayWidget(),
            const SizedBox(height: 40),
            const Icon(
              Icons.casino,
              size: 80,
              color: Colors.amber,
            ),
            const SizedBox(height: 20),
            const Text(
              '🎲 DICE COMBAT GAME',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.amber,
                letterSpacing: 2,
              ),
            ),
            const SizedBox(height: 60),
            const Text(
              'Escolha sua classe:',
              style: TextStyle(fontSize: 18, color: Colors.white70),
            ),
            const SizedBox(height: 30),
            ...PlayerClass.values.map((playerClass) {
              final totalHp = playerClass.hp + _hpBonus;
              final totalAttack = playerClass.baseAttack + _attackBonus;
              
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 8),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => GameScreen(playerClass: playerClass),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: playerClass.color,
                    padding: const EdgeInsets.all(20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(playerClass.icon, size: 28),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            playerClass.name,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            'HP: $totalHp | Ataque: $totalAttack',
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.white70,
                            ),
                          ),
                          if (_attackBonus > 0 || _hpBonus > 0)
                            Text(
                              _attackBonus > 0 && _hpBonus > 0
                                ? 'Bônus: +$_hpBonus HP | +$_attackBonus ATK'
                                : _hpBonus > 0
                                  ? 'Bônus: +$_hpBonus HP'
                                  : 'Bônus: +$_attackBonus ATK',
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.green[300],
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            }),
            const SizedBox(height: 30),
            ElevatedButton.icon(
              onPressed: _navigateToShop,
              icon: const Icon(Icons.store),
              label: const Text('Loja'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple,
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                textStyle: const TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

