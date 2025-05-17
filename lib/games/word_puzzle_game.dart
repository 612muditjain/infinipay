import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'base_game.dart';
import '../services/game_service.dart';

class WordPuzzleGame extends BaseGame {
  WordPuzzleGame()
      : super(
          title: 'Word Puzzle',
          description: 'Find hidden words for rewards',
          icon: Icons.text_fields,
          color: Colors.purple,
          reward: '₹0.40 - ₹1.80',
        );

  @override
  Future<Map<String, dynamic>> play(double betAmount) async {
    final result = await GameService.playGame(betAmount);
    // Calculate 70% of bet amount as win amount
    if (result['success'] == true) {
      result['winAmount'] = betAmount * 0.7;
    }
    return result;
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

    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Balance Display
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [color, color.withOpacity(0.7)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Text(
                        'Your Balance',
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '₹${balance.toStringAsFixed(2)}',
                        style: theme.textTheme.headlineSmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ).animate()
                    .fadeIn(duration: const Duration(milliseconds: 600))
                    .slideY(begin: -0.2, end: 0),

                const SizedBox(height: 24),

                // Bet Selection
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Select Bet Amount',
                        style: theme.textTheme.titleLarge?.copyWith(
                          color: color,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Wrap(
                        spacing: 12,
                        runSpacing: 12,
                        children: [
                          BetChip(
                            amount: 10,
                            isSelected: selectedBet == 10,
                            onTap: () => onBetSelected(10),
                            color: color,
                          ),
                          BetChip(
                            amount: 20,
                            isSelected: selectedBet == 20,
                            onTap: () => onBetSelected(20),
                            color: color,
                          ),
                          BetChip(
                            amount: 30,
                            isSelected: selectedBet == 30,
                            onTap: () => onBetSelected(30),
                            color: color,
                          ),
                          CustomBetChip(
                            onBetSelected: onBetSelected,
                            color: color,
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Selected Bet: ₹${selectedBet.toStringAsFixed(2)}',
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: color,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ).animate()
                    .fadeIn(duration: const Duration(milliseconds: 800))
                    .slideX(begin: -0.2, end: 0),

                const SizedBox(height: 24),

                // Word Grid
                Container(
                  width: size.width * 0.9,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Text(
                        'Find the Hidden Word',
                        style: theme.textTheme.titleLarge?.copyWith(
                          color: color,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        alignment: WrapAlignment.center,
                        children: [
                          'F',
                          'L',
                          'U',
                          'T',
                          'T',
                          'E',
                          'R',
                        ].map((letter) => Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(8),
                                boxShadow: [
                                  BoxShadow(
                                    color: color.withOpacity(0.2),
                                    blurRadius: 4,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Center(
                                child: Text(
                                  letter,
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: color,
                                  ),
                                ),
                              ),
                            )).toList(),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'Hint: A mobile app framework',
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: color.withOpacity(0.7),
                        ),
                      ),
                    ],
                  ),
                ).animate()
                    .fadeIn(duration: const Duration(milliseconds: 1000))
                    .slideY(begin: 0.2, end: 0),

                const SizedBox(height: 32),

                // Play Button
                ElevatedButton.icon(
                  onPressed: selectedBet > 0 && !isPlaying ? onPlay : null,
                  icon: isPlaying
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
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
                    elevation: 4,
                  ),
                ).animate()
                    .fadeIn(delay: const Duration(milliseconds: 1200))
                    .scale(
                        begin: const Offset(0.8, 0.8),
                        end: const Offset(1, 1)),

                if (hasWon) ...[
                  const SizedBox(height: 24),
                  Container(
                    width: size.width * 0.9,
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
                      .fadeIn(delay: const Duration(milliseconds: 1400))
                      .scale(
                          begin: const Offset(0.8, 0.8),
                          end: const Offset(1, 1)),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Bet Chip Widget
class BetChip extends StatelessWidget {
  final double amount;
  final bool isSelected;
  final VoidCallback onTap;
  final Color color;

  const BetChip({
    super.key,
    required this.amount,
    required this.isSelected,
    required this.onTap,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? color : Colors.grey[300],
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? color : Colors.grey,
          ),
        ),
        child: Text(
          '₹${amount.toStringAsFixed(0)}',
          style: TextStyle(
            color: isSelected ? Colors.white : color,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

// Custom Bet Chip Widget
class CustomBetChip extends StatefulWidget {
  final Function(double) onBetSelected;
  final Color color;

  const CustomBetChip({
    super.key,
    required this.onBetSelected,
    required this.color,
  });

  @override
  _CustomBetChipState createState() => _CustomBetChipState();
}

class _CustomBetChipState extends State<CustomBetChip> {
  final TextEditingController _controller = TextEditingController();
  bool _isEditing = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _isEditing = true;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.grey),
        ),
        child: _isEditing
            ? SizedBox(
                width: 80,
                child: TextField(
                  controller: _controller,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: 'Custom',
                    border: InputBorder.none,
                    hintStyle: TextStyle(color: widget.color.withOpacity(0.7)),
                  ),
                  style: TextStyle(color: widget.color, fontWeight: FontWeight.bold),
                  onSubmitted: (value) {
                    final amount = double.tryParse(value) ?? 0;
                    if (amount > 0) {
                      widget.onBetSelected(amount);
                    }
                    setState(() {
                      _isEditing = false;
                    });
                  },
                ),
              )
            : Text(
                'Custom',
                style: TextStyle(
                  color: widget.color,
                  fontWeight: FontWeight.bold,
                ),
              ),
      ),
    );
  }
}