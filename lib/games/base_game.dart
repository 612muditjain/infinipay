import 'package:flutter/material.dart';
import '../services/game_service.dart';

abstract class BaseGame {
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final String reward;

  BaseGame({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    required this.reward,
  });

  Future<Map<String, dynamic>> play(double betAmount);
  Widget buildGameUI(BuildContext context, {
    required double balance,
    required double selectedBet,
    required bool isPlaying,
    required bool hasWon,
    required double winAmount,
    required Function(double) onBetSelected,
    required Function() onPlay,
  });
} 