import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../services/game_service.dart';
import '../games/base_game.dart';
import '../games/lucky_spin_game.dart';
import '../games/memory_match_game.dart';
import '../games/quick_math_game.dart';
import '../games/word_puzzle_game.dart';
import '../games/color_match_game.dart';
import '../games/number_rush_game.dart';

class GamesPage extends StatefulWidget {
  const GamesPage({super.key});

  @override
  State<GamesPage> createState() => _GamesPageState();
}

class _GamesPageState extends State<GamesPage> {
  double _balance = 0.0;
  bool _isDailySpinAvailable = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final balance = await GameService.getBalance();
    final isDailySpinAvailable = await GameService.isDailySpinAvailable();
    
    if (mounted) {
      setState(() {
        _balance = balance;
        _isDailySpinAvailable = isDailySpinAvailable;
      });
    }
  }

  Future<void> _playDailySpin() async {
    final result = await GameService.playDailySpin();
    
    if (!mounted) return;

    if (result['success'] as bool) {
      setState(() {
        _isDailySpinAvailable = false;
        if (result['hasWon'] as bool) {
          _balance += result['winAmount'] as double;
        }
      });
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(result['message'] as String),
        backgroundColor: result['hasWon'] as bool ? Colors.green : Colors.red,
      ),
    );
  }

  void _navigateToGame(BaseGame game) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(
            title: Text(game.title),
            backgroundColor: game.color,
            foregroundColor: Colors.white,
          ),
          body: game.buildGameUI(
            context,
            balance: _balance,
            selectedBet: 1.0,
            isPlaying: false,
            hasWon: false,
            winAmount: 0.0,
            onBetSelected: (bet) {},
            onPlay: () async {
              final result = await game.play(1.0);
              if (result['success'] as bool && result['hasWon'] as bool) {
                setState(() {
                  _balance += result['winAmount'] as double;
                });
              }
            },
          ),
        ),
      ),
    ).then((_) => _loadData());
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    
    final games = [
      LuckySpinGame(),
      MemoryMatchGame(),
      QuickMathGame(),
      WordPuzzleGame(),
      ColorMatchGame(),
      NumberRushGame(),
    ];

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header Section with Balance
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Mini Games',
                          style: theme.textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        )
                        .animate()
                        .fadeIn(duration: const Duration(milliseconds: 600))
                        .slideY(begin: -0.2, end: 0),

                        const SizedBox(height: 4),

                        Text(
                          'Balance: ₹${_balance.toStringAsFixed(2)}',
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: theme.primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                        .animate()
                        .fadeIn(delay: const Duration(milliseconds: 200))
                        .slideY(begin: -0.1, end: 0),
                      ],
                    ),
                  ),
                  // Daily Spin Button
                  ElevatedButton.icon(
                    onPressed: _isDailySpinAvailable ? _playDailySpin : null,
                    icon: const Icon(Icons.casino),
                    label: Text(_isDailySpinAvailable ? 'Daily Spin' : 'Used'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.primaryColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ).animate()
                    .fadeIn(delay: const Duration(milliseconds: 400))
                    .scale(begin: const Offset(0.8, 0.8), end: const Offset(1, 1)),
                ],
              ),

              const SizedBox(height: 24),

              // Popular Games Section
              Text(
                'Popular Games',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              )
              .animate()
              .fadeIn(delay: const Duration(milliseconds: 600))
              .slideX(begin: -0.2, end: 0),

              const SizedBox(height: 16),

              // Popular Games Horizontal List
              SizedBox(
                height: 180,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 2, // First two games are popular
                  itemBuilder: (context, index) {
                    final game = games[index];
                    
                    return Container(
                      width: 140,
                      margin: const EdgeInsets.only(right: 12),
                      child: Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: InkWell(
                          onTap: () => _navigateToGame(game),
                          borderRadius: BorderRadius.circular(16),
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: game.color.withOpacity(0.1),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    game.icon,
                                    size: 28,
                                    color: game.color,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  game.title,
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: game.color,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    game.reward,
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ).animate()
                      .fadeIn(delay: Duration(milliseconds: 200 * index))
                      .scale(begin: const Offset(0.8, 0.8), end: const Offset(1, 1));
                  },
                ),
              ),

              const SizedBox(height: 24),

              // All Games Section
              Text(
                'All Games',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              )
              .animate()
              .fadeIn(delay: const Duration(milliseconds: 800))
              .slideX(begin: -0.2, end: 0),

              const SizedBox(height: 16),

              // All Games Grid
              Expanded(
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.85,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  itemCount: games.length,
                  itemBuilder: (context, index) {
                    final game = games[index];
                    
                    return Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: InkWell(
                        onTap: () => _navigateToGame(game),
                        borderRadius: BorderRadius.circular(16),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: game.color.withOpacity(0.1),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  game.icon,
                                  size: 28,
                                  color: game.color,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                game.title,
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                game.description,
                                style: theme.textTheme.bodySmall,
                                textAlign: TextAlign.center,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: game.color,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  game.reward,
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ).animate()
                      .fadeIn(delay: Duration(milliseconds: 200 * index))
                      .scale(begin: const Offset(0.8, 0.8), end: const Offset(1, 1));
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
} 