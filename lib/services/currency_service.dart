import 'package:shared_preferences/shared_preferences.dart';

class CurrencyService {
  static const String _coinsKey = 'player_coins';
  
  static Future<int> getCoins() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_coinsKey) ?? 0;
  }
  
  static Future<int> addCoins(int amount, {int multiplier = 1}) async {
    final prefs = await SharedPreferences.getInstance();
    final currentCoins = await getCoins();
    final coinsToAdd = amount * multiplier;
    await prefs.setInt(_coinsKey, currentCoins + coinsToAdd);
    return coinsToAdd;
  }
  
  static Future<void> resetCoins() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_coinsKey, 0);
  }
  
  static Future<void> setCoins(int amount) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_coinsKey, amount);
  }
  
  static Future<String> getFormattedCoins() async {
    final coins = await getCoins();
    return '$coins moedas';
  }
}

