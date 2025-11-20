import 'package:shared_preferences/shared_preferences.dart';

class ProgressionService {
  static const String _waveKey = 'current_wave';
  static const int _baseWave = 1;
  static const int _coinsPerVictory = 10;
  
  static Future<int> getCurrentWave() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_waveKey) ?? _baseWave;
  }
  
  static Future<int> incrementWave() async {
    final prefs = await SharedPreferences.getInstance();
    final currentWave = await getCurrentWave();
    final newWave = currentWave + 1;
    await prefs.setInt(_waveKey, newWave);
    return newWave;
  }
  
  static int getDifficultyMultiplier(int wave) {
    return (1.0 + (wave - 1) * 0.1).round();
  }
  
  static int getEnemyHpBonus(int wave) {
    return (wave - 1) * 2;
  }
  
  static int getEnemyAttackBonus(int wave) {
    return (wave - 1) * 1;
  }
  
  static int getCoinsReward(int wave) {
    return _coinsPerVictory;
  }
  
  static Future<void> resetProgression() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_waveKey, _baseWave);
  }
  
  static String getWaveString(int wave) {
    return 'Onda $wave';
  }
}

