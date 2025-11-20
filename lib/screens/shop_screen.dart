import 'package:flutter/material.dart';
import '../models/item.dart';
import '../services/shop_service.dart';
import '../services/currency_service.dart';
import '../widgets/coin_display_widget.dart';

class ShopScreen extends StatefulWidget {
  const ShopScreen({super.key});

  @override
  State<ShopScreen> createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> {
  final GlobalKey<CoinDisplayWidgetState> _coinDisplayKey = GlobalKey();
  List<String> _purchasedItems = [];
  int _currentCoins = 0;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final purchased = await ShopService.getPurchasedItems();
    final coins = await CurrencyService.getCoins();
    
    setState(() {
      _purchasedItems = purchased;
      _currentCoins = coins;
    });
  }

  Future<void> _purchaseItem(Item item) async {
    if (_purchasedItems.contains(item.id)) {
      _showSnackBar('Você já possui este item!', Colors.orange);
      return;
    }

    if (_currentCoins < item.price) {
      _showSnackBar('Moedas insuficientes!', Colors.red);
      return;
    }

    final success = await ShopService.purchaseItem(item.id);
    if (!success) {
      _showSnackBar('Erro ao comprar item!', Colors.red);
      return;
    }

    final currentCoins = await CurrencyService.getCoins();
    await CurrencyService.setCoins(currentCoins - item.price);
    
    _showSnackBar('${item.name} comprado!', Colors.green);
    _coinDisplayKey.currentState?.refresh();
    await _loadData();
  }

  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Widget _buildItemCard(Item item) {
    final isPurchased = _purchasedItems.contains(item.id);
    final canAfford = _currentCoins >= item.price;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isPurchased 
          ? Colors.green.withValues(alpha: 0.1)
          : Colors.grey[900],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isPurchased ? Colors.green : item.color,
          width: 2,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: item.color.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(item.icon, color: item.color, size: 30),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        item.name,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: item.color,
                        ),
                      ),
                      if (isPurchased) ...[
                        const SizedBox(width: 8),
                        const Icon(Icons.check_circle, 
                          color: Colors.green, size: 20),
                      ],
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item.description,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Column(
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.monetization_on, 
                      color: Colors.amber, size: 20),
                    const SizedBox(width: 4),
                    Text(
                      '${item.price}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.amber,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: isPurchased || !canAfford 
                    ? null 
                    : () => _purchaseItem(item),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isPurchased 
                      ? Colors.green
                      : item.color,
                    disabledBackgroundColor: Colors.grey,
                  ),
                  child: Text(
                    isPurchased ? 'COMPRADO' : 'COMPRAR',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final attackItems = ShopItems.catalog
        .where((item) => item.type == ItemType.attackBoost)
        .toList();
    final hpItems = ShopItems.catalog
        .where((item) => item.type == ItemType.hpBoost)
        .toList();
    final coinMultiplierItems = ShopItems.catalog
        .where((item) => item.type == ItemType.coinMultiplier)
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('🏪 LOJA', style: TextStyle(fontWeight: FontWeight.bold)),
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
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            '⚔️ MELHORIAS DE ATAQUE',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 12),
          ...attackItems.map((item) => _buildItemCard(item)),
          
          const SizedBox(height: 32),
          
          const Text(
            '❤️ MELHORIAS DE HP',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 12),
          ...hpItems.map((item) => _buildItemCard(item)),
          
          const SizedBox(height: 32),
          
          const Text(
            '🪙 MULTIPLICADORES DE MOEDAS',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 12),
          ...coinMultiplierItems.map((item) => _buildItemCard(item)),
          
          const SizedBox(height: 32),
          
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.blue.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.blue, width: 2),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '💡 DICA',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  '• Itens comprados são permanentes\n'
                  '• Ganhe moedas vencendo batalhas\n'
                  '• Bônus são aplicados em todas as classes',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

