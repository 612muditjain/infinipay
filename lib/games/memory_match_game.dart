import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'base_game.dart';
import '../services/game_service.dart';

class MemoryMatchGame extends BaseGame {
  MemoryMatchGame()
      : super(
          title: 'Memory Match',
          description: 'Match pairs to earn coins',
          icon: Icons.grid_view,
          color: Colors.blue,
          reward: '₹0.30 - ₹1.50',
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
    final cardSize = size.width * 0.2;

    // Predefined bet amounts
    final betAmounts = [10.0, 20.0, 30.0, 50.0, 100.0];

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Balance Display
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                theme.primaryColor.withOpacity(0.2),
                theme.primaryColor.withOpacity(0.1),
              ],
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: theme.primaryColor.withOpacity(0.3),
            ),
            boxShadow: [
              BoxShadow(
                color: theme.primaryColor.withOpacity(0.1),
                blurRadius: 10,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: theme.primaryColor.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.account_balance_wallet,
                  color: theme.primaryColor,
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Balance',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.primaryColor.withOpacity(0.8),
                    ),
                  ),
                  Text(
                    '₹${balance.toStringAsFixed(2)}',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: theme.primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ).animate()
          .fadeIn(duration: const Duration(milliseconds: 600))
          .slideY(begin: -0.2, end: 0),

        const SizedBox(height: 24),

        // Memory Grid
        Container(
          width: size.width * 0.9,
          height: size.width * 0.9,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                color.withOpacity(0.2),
                color.withOpacity(0.1),
              ],
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.2),
                blurRadius: 15,
                spreadRadius: 5,
              ),
            ],
          ),
          child: GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemCount: 16,
            itemBuilder: (context, index) {
              return Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: color.withOpacity(0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Center(
                  child: Icon(
                    icon,
                    color: color.withOpacity(0.5),
                    size: cardSize * 0.4,
                  ),
                ),
              ).animate(
                onPlay: (controller) => controller.repeat(),
              )
                .fadeIn(delay: Duration(milliseconds: index * 50))
                .scale(begin: const Offset(0.8, 0.8), end: const Offset(1, 1))
                .then()
                .shimmer(
                  duration: const Duration(seconds: 2),
                  color: color.withOpacity(0.3),
                );
            },
          ),
        ),

        const SizedBox(height: 32),

        // Bet Selection Section
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: theme.cardColor,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Column(
            children: [
              Text(
                'Select Bet Amount',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                alignment: WrapAlignment.center,
                children: betAmounts.map((amount) {
                  final isSelected = selectedBet == amount;
                  return ElevatedButton(
                    onPressed: isPlaying ? null : () => onBetSelected(amount),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isSelected ? color : color.withOpacity(0.1),
                      foregroundColor: isSelected ? Colors.white : color,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: isSelected ? 4 : 0,
                    ),
                    child: Text(
                      '₹${amount.toStringAsFixed(0)}',
                      style: TextStyle(
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ).animate()
          .fadeIn(delay: const Duration(milliseconds: 400))
          .slideY(begin: 0.2, end: 0),

        const SizedBox(height: 24),

        // Play Button
        ElevatedButton.icon(
          onPressed: isPlaying || selectedBet == 0 ? null : onPlay,
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
          label: Text(
            isPlaying 
                ? 'Playing...' 
                : selectedBet == 0 
                    ? 'Select Bet Amount' 
                    : 'Play for ₹${selectedBet.toStringAsFixed(0)}',
          ),
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
            elevation: 4,
          ),
        ).animate()
          .fadeIn(delay: const Duration(milliseconds: 800))
          .scale(begin: const Offset(0.8, 0.8), end: const Offset(1, 1)),

        if (hasWon) ...[
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.green.withOpacity(0.2),
                  Colors.green.withOpacity(0.1),
                ],
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Colors.green.withOpacity(0.3),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.green.withOpacity(0.1),
                  blurRadius: 10,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.celebration,
                    color: Colors.green,
                    size: 32,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'You won ₹${winAmount.toStringAsFixed(2)}!',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '70% of bet amount',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: Colors.green.withOpacity(0.8),
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