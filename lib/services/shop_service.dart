import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class ShopService {
  static const String _purchasesKey = 'purchased_items';
  
  static Future<List<String>> getPurchasedItems() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_purchasesKey);
    if (jsonString == null) return [];
    try {
      final List<dynamic> decoded = jsonDecode(jsonString);
      return decoded.cast<String>();
    } catch (e) {
      return [];
    }
  }
  
  static Future<bool> purchaseItem(String itemId) async {
    final purchasedItems = await getPurchasedItems();
    if (purchasedItems.contains(itemId)) {
      return false; 
    }
    purchasedItems.add(itemId);
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_purchasesKey, jsonEncode(purchasedItems));
    return true;
  }
  
  static Future<bool> isItemPurchased(String itemId) async {
    final purchasedItems = await getPurchasedItems();
    return purchasedItems.contains(itemId);
  }
  
  static Future<void> resetPurchases() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_purchasesKey);
  }
  
  static Future<int> getTotalAttackBoost() async {
    final purchased = await getPurchasedItems();
    int total = 0;
    
    for (final itemId in purchased) {
      if (itemId.startsWith('attack_boost_')) {
        final boost = itemId.split('_').last;
        total += int.tryParse(boost) ?? 0;
      }
    }
    
    return total;
  }
  
  static Future<int> getTotalHpBoost() async {
    final purchased = await getPurchasedItems();
    int total = 0;
    
    for (final itemId in purchased) {
      if (itemId.startsWith('hp_boost_')) {
        final boostValue = itemId.split('_').last;
        if (boostValue == '1') {
          total += 5;
        } else if (boostValue == '2') {
          total += 10;
        } else if (boostValue == '3') {
          total += 20;
        }
      }
    }
    
    return total;
  }
  
  static Future<int> getCoinMultiplier() async {
    final purchased = await getPurchasedItems();
    
    if (purchased.contains('coin_multiplier_2x')) {
      return 2;
    }
    
    return 1;
  }
}

