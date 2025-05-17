import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'base_game.dart';
import '../services/game_service.dart';

class ColorMatchGame extends BaseGame {
  ColorMatchGame()
      : super(
          title: 'Color Match',
          description: 'Match colors to earn rewards',
          icon: Icons.color_lens,
          color: Colors.pink,
          reward: '₹0.35 - ₹1.20',
        );

  @override
  Future<Map<String, dynamic>> play(double betAmount) async {
    return await GameService.playGame(betAmount);
  }

  @override
  Widget buildGameUI(
    BuildContext context, {
    required double balance,
    required double selectedBet,
    required bool isPlaying,
    required bool hasWon,
    required double winAmount,
    required Function(double) onBetSelected,
    required Function() onPlay,
  }) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;

    final colors = [
      Colors.red,
      Colors.blue,
      Colors.green,
      Colors.yellow,
      Colors.purple,
      Colors.orange,
    ];

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Color Grid
        Container(
          width: size.width * 0.9,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: color.withOpacity(0.3),
            ),
          ),
          child: Column(
            children: [
              Text(
                'Match the colors',
                style: theme.textTheme.titleLarge?.copyWith(
                  color: color,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                itemCount: colors.length,
                itemBuilder: (context, index) {
                  return Container(
                    decoration: BoxDecoration(
                      color: colors[index],
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: colors[index].withOpacity(0.3),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                  ).animate()
                    .fadeIn(delay: Duration(milliseconds: index * 100))
                    .scale(begin: const Offset(0.8, 0.8), end: const Offset(1, 1));
                },
              ),
            ],
          ),
        ).animate()
          .fadeIn(duration: const Duration(milliseconds: 600))
          .slideY(begin: -0.2, end: 0),

        const SizedBox(height: 32),

        // Play Button
        ElevatedButton.icon(
          onPressed: isPlaying ? null : onPlay,
          icon: isPlaying
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
              : const Icon(Icons.play_arrow),
          label: Text(isPlaying ? 'Playing...' : 'Play Game'),
          style: ElevatedButton.styleFrom(
            backgroundColor: color,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(
              horizontal: 32,
              vertical: 16,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        ).animate()
          .fadeIn(delay: const Duration(milliseconds: 800))
          .scale(begin: const Offset(0.8, 0.8), end: const Offset(1, 1)),

        if (hasWon) ...[
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Colors.green.withOpacity(0.3),
              ),
            ),
            child: Column(
              children: [
                const Icon(
                  Icons.celebration,
                  color: Colors.green,
                  size: 32,
                ),
                const SizedBox(height: 8),
                Text(
                  'You won ₹${winAmount.toStringAsFixed(2)}!',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ).animate()
            .fadeIn(delay: const Duration(milliseconds: 1000))
            .scale(begin: const Offset(0.8, 0.8), end: const Offset(1, 1)),
        ],
      ],
    );
  }
} 