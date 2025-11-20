import 'package:flutter/material.dart';
import '../services/currency_service.dart';

class CoinDisplayWidget extends StatefulWidget {
  const CoinDisplayWidget({super.key});

  @override
  State<CoinDisplayWidget> createState() => CoinDisplayWidgetState();
}

class CoinDisplayWidgetState extends State<CoinDisplayWidget> {

  int _coins = 0;

  @override
  void initState() {
    super.initState();
    _loadCoins();
  }

  Future<void> _loadCoins() async {
    final coins = await CurrencyService.getCoins();
    if (mounted) {
      setState(() {
        _coins = coins;
      });
    }
  }

  void refresh() {
    _loadCoins();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.amber.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.amber, width: 2),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.monetization_on,
            color: Colors.amber,
            size: 24,
          ),
          const SizedBox(width: 8),
          Text(
            '$_coins',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.amber,
            ),
          ),
          const SizedBox(width: 4),
          const Text(
            'moedas',
            style: TextStyle(
              fontSize: 14,
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }
}

