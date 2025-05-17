import 'package:shared_preferences/shared_preferences.dart';

class GameService {
  static const String _lastSpinKey = 'last_spin_date';
  static const String _balanceKey = 'user_balance';
  
  // Get user balance
  static Future<double> getBalance() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getDouble(_balanceKey) ?? 1000.0;
  }

  // Update user balance
  static Future<void> updateBalance(double amount) async {
    final prefs = await SharedPreferences.getInstance();
    final currentBalance = await getBalance();
    await prefs.setDouble(_balanceKey, currentBalance + amount);
  }

  // Check if daily spin is available
  static Future<bool> isDailySpinAvailable() async {
    final prefs = await SharedPreferences.getInstance();
    final lastSpinDate = prefs.getString(_lastSpinKey);
    
    if (lastSpinDate == null) return true;
    
    final lastDate = DateTime.parse(lastSpinDate);
    final now = DateTime.now();
    
    return lastDate.year != now.year || 
           lastDate.month != now.month || 
           lastDate.day != now.day;
  }

  // Update last spin date
  static Future<void> updateLastSpinDate() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_lastSpinKey, DateTime.now().toIso8601String());
  }

  // Play game with bet amount
  static Future<Map<String, dynamic>> playGame(double betAmount) async {
    final balance = await getBalance();
    
    if (betAmount > balance) {
      return {
        'success': false,
        'message': 'Insufficient balance',
        'winAmount': 0.0,
      };
    }

    // 70% chance to win
    final hasWon = (DateTime.now().millisecondsSinceEpoch % 10) < 7;
    final winAmount = hasWon ? betAmount * 1.7 : 0.0;
    
    // Update balance
    await updateBalance(hasWon ? winAmount : -betAmount);
    
    return {
      'success': true,
      'hasWon': hasWon,
      'winAmount': winAmount,
      'message': hasWon ? 'Congratulations! You won!' : 'Better luck next time!',
    };
  }

  // Play daily spin
  static Future<Map<String, dynamic>> playDailySpin() async {
    if (!await isDailySpinAvailable()) {
      return {
        'success': false,
        'message': 'Daily spin already used. Try again tomorrow!',
        'winAmount': 0.0,
      };
    }

    // Daily spin has higher win chance (80%)
    final hasWon = (DateTime.now().millisecondsSinceEpoch % 10) < 8;
    final winAmount = hasWon ? 50.0 : 0.0; // Fixed reward of ₹50
    
    if (hasWon) {
      await updateBalance(winAmount);
    }
    await updateLastSpinDate();
    
    return {
      'success': true,
      'hasWon': hasWon,
      'winAmount': winAmount,
      'message': hasWon ? 'Congratulations! You won ₹50!' : 'Better luck next time!',
    };
  }
} 