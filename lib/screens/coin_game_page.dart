import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'dart:math' as math;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class CoinGamePage extends StatefulWidget {
  const CoinGamePage({super.key});

  @override
  State<CoinGamePage> createState() => _CoinGamePageState();
}

class _CoinGamePageState extends State<CoinGamePage> with SingleTickerProviderStateMixin {
  int _coins = 0;
  final int _dailyLimit = 1500;
  double _earnings = 0.0;
  bool _isCollecting = false;
  bool _isClaiming = false;
  late AnimationController _coinAnimationController;
  final List<CoinAnimation> _coinAnimations = [];
  DateTime? _lastResetTime;
  bool _isLimitReached = false;

  @override
  void initState() {
    super.initState();
    _coinAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _loadLastResetTime();
    _checkDailyReset();
  }

  Future<void> _loadLastResetTime() async {
    final prefs = await SharedPreferences.getInstance();
    final lastResetString = prefs.getString('lastResetTime');
    if (lastResetString != null) {
      setState(() {
        _lastResetTime = DateTime.parse(lastResetString);
      });
    } else {
      setState(() {
        _lastResetTime = DateTime.now();
      });
      await prefs.setString('lastResetTime', _lastResetTime!.toIso8601String());
    }
  }

  Future<void> _checkDailyReset() async {
    if (_lastResetTime != null) {
      final now = DateTime.now();
      final difference = now.difference(_lastResetTime!);
      
      if (difference.inHours >= 24) {
        // Reset coins and update last reset time
        setState(() {
          _coins = 0;
          _earnings = 0.0;
          _isLimitReached = false;
          _lastResetTime = now;
        });
        
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('lastResetTime', _lastResetTime!.toIso8601String());
      }
    }
  }

  String _getTimeUntilReset() {
    if (_lastResetTime == null) return '';
    
    final now = DateTime.now();
    final nextReset = _lastResetTime!.add(const Duration(hours: 24));
    final difference = nextReset.difference(now);
    
    final hours = difference.inHours;
    final minutes = difference.inMinutes.remainder(60);
    
    return '$hours hours $minutes minutes';
  }

  void _collectCoin() {
    if (_isLimitReached || _coins >= _dailyLimit) return;

    setState(() {
      _coins += 10;
      _earnings = (_coins / _dailyLimit) * 12;
      _isCollecting = true;
      
      if (_coins >= _dailyLimit) {
        _isLimitReached = true;
        _coins = _dailyLimit; // Ensure we don't exceed the limit
      }
    });

    // Add coin animation
    _coinAnimations.add(
      CoinAnimation(
        position: Offset(
          math.Random().nextDouble() * 200 - 100,
          math.Random().nextDouble() * 200 - 100,
        ),
      ),
    );

    // Start animation
    _coinAnimationController.forward(from: 0.0).then((_) {
      setState(() {
        _isCollecting = false;
        if (_coinAnimations.isNotEmpty) {
          _coinAnimations.removeAt(0);
        }
      });
    });
  }

  Future<void> _claimEarnings() async {
    if (_coins < _dailyLimit) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Collect all 1500 coins to claim your earnings!'),
          backgroundColor: Colors.orange,
          duration: Duration(seconds: 3),
        ),
      );
      return;
    }

    setState(() {
      _isClaiming = true;
    });

    try {
      // TODO: Implement actual wallet transfer logic
      await Future.delayed(const Duration(seconds: 2)); // Simulated API call
      
      if (!mounted) return;
      
      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Successfully claimed ₹${_earnings.toStringAsFixed(2)}'),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 3),
        ),
      );

      // Reset coins and earnings
      setState(() {
        _coins = 0;
        _earnings = 0.0;
        _isLimitReached = false;
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error claiming earnings: $e'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isClaiming = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final canClaim = _coins >= _dailyLimit;
    
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Stats Card
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Current Coins',
                                style: theme.textTheme.titleMedium,
                              ),
                              Text(
                                '$_coins',
                                style: theme.textTheme.headlineMedium?.copyWith(
                                  color: theme.primaryColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                'Daily Earnings',
                                style: theme.textTheme.titleMedium,
                              ),
                              Text(
                                '₹${_earnings.toStringAsFixed(2)}',
                                style: theme.textTheme.headlineMedium?.copyWith(
                                  color: theme.primaryColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      LinearProgressIndicator(
                        value: _coins / _dailyLimit,
                        backgroundColor: theme.primaryColor.withOpacity(0.1),
                        valueColor: AlwaysStoppedAnimation<Color>(
                          _isLimitReached ? Colors.green : theme.primaryColor
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Daily Limit: $_coins/$_dailyLimit coins',
                        style: theme.textTheme.bodySmall,
                      ),
                      if (_isLimitReached) ...[
                        const SizedBox(height: 8),
                        Text(
                          'Daily limit reached! You can now claim your earnings.',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              )
              .animate()
              .fadeIn(duration: const Duration(milliseconds: 600))
              .slideY(begin: 0.3, end: 0),

              const SizedBox(height: 16),

              // Claim Button
              if (_coins > 0)
                ElevatedButton(
                  onPressed: _isClaiming ? null : (canClaim ? _claimEarnings : null),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 56),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    backgroundColor: canClaim ? Colors.green : Colors.grey,
                  ),
                  child: _isClaiming
                      ? const CircularProgressIndicator()
                      : Text(
                          canClaim 
                              ? 'Claim ₹${_earnings.toStringAsFixed(2)}'
                              : 'Collect all coins to claim',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                )
                .animate()
                .fadeIn(delay: const Duration(milliseconds: 700))
                .slideY(begin: 0.3, end: 0),

              const SizedBox(height: 16),

              // Coin Game Area
              Expanded(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Coin Animations
                    ..._coinAnimations.map((animation) {
                      return Positioned(
                        left: 150 + animation.position.dx,
                        top: 150 + animation.position.dy,
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: theme.primaryColor.withOpacity(0.1),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: theme.primaryColor.withOpacity(0.2),
                                blurRadius: 8,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          child: Icon(
                            Icons.currency_rupee,
                            color: theme.primaryColor,
                            size: 24,
                          ),
                        )
                        .animate(
                          onPlay: (controller) => controller.repeat(),
                        )
                        .scale(
                          duration: const Duration(milliseconds: 500),
                          begin: const Offset(0.5, 0.5),
                          end: const Offset(1.5, 1.5),
                        )
                        .fadeOut(
                          duration: const Duration(milliseconds: 500),
                        ),
                      );
                    }).toList(),

                    // Main Coin
                    GestureDetector(
                      onTap: _isLimitReached ? null : _collectCoin,
                      child: Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: _isLimitReached 
                              ? Colors.grey.withOpacity(0.1)
                              : theme.primaryColor.withOpacity(0.1),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: _isLimitReached
                                  ? Colors.grey.withOpacity(0.2)
                                  : theme.primaryColor.withOpacity(0.3),
                              blurRadius: 15,
                              spreadRadius: 5,
                            ),
                          ],
                          gradient: _isLimitReached
                              ? null
                              : LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    theme.primaryColor.withOpacity(0.2),
                                    theme.primaryColor.withOpacity(0.1),
                                  ],
                                ),
                        ),
                        child: Icon(
                          Icons.currency_rupee,
                          size: 120,
                          color: _isLimitReached 
                              ? Colors.grey 
                              : theme.primaryColor,
                        ),
                      )
                      .animate(
                        onPlay: (controller) => controller.repeat(),
                      )
                      .scale(
                        duration: const Duration(milliseconds: 1000),
                        begin: const Offset(1, 1),
                        end: const Offset(1.1, 1.1),
                      )
                      .then()
                      .scale(
                        duration: const Duration(milliseconds: 1000),
                        begin: const Offset(1.1, 1.1),
                        end: const Offset(1, 1),
                      ),
                    ),
                  ],
                ),
              ),

              // Instructions
              Text(
                _isLimitReached
                    ? 'Daily limit reached! You can now claim your earnings'
                    : 'Tap the coin to collect!',
                textAlign: TextAlign.center,
                style: theme.textTheme.titleMedium?.copyWith(
                  color: _isLimitReached ? Colors.green : null,
                ),
              )
              .animate()
              .fadeIn(delay: const Duration(milliseconds: 800)),
            ],
          ),
        ),
      ),
    );
  }
}

class CoinAnimation {
  final Offset position;
  CoinAnimation({required this.position});
} 