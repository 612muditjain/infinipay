import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class MLMLeaderboardPage extends StatelessWidget {
  const MLMLeaderboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    // Mock data - Replace with actual data from API
    final leaderboardData = [
      {
        'rank': 1,
        'name': 'John Doe',
        'points': 5000,
        'level': 'Diamond',
        'isCurrentUser': false,
      },
      {
        'rank': 2,
        'name': 'Jane Smith',
        'points': 4500,
        'level': 'Platinum',
        'isCurrentUser': true,
      },
      {
        'rank': 3,
        'name': 'Mike Johnson',
        'points': 4000,
        'level': 'Gold',
        'isCurrentUser': false,
      },
      {
        'rank': 4,
        'name': 'Sarah Wilson',
        'points': 3500,
        'level': 'Gold',
        'isCurrentUser': false,
      },
      {
        'rank': 5,
        'name': 'David Brown',
        'points': 3000,
        'level': 'Silver',
        'isCurrentUser': false,
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('MLM Leaderboard'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Top Performers Section
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    theme.primaryColor,
                    theme.primaryColor.withOpacity(0.8),
                  ],
                ),
              ),
              child: Column(
                children: [
                  Text(
                    'Top Performers',
                    style: theme.textTheme.titleLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ).animate().fadeIn().slideY(begin: 0.2, end: 0),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // Second Place
                      _buildTopPerformer(
                        context,
                        leaderboardData[1],
                        2,
                        Colors.grey[300]!,
                      ).animate().fadeIn(delay: const Duration(milliseconds: 200))
                        .slideY(begin: 0.2, end: 0),
                      // First Place
                      _buildTopPerformer(
                        context,
                        leaderboardData[0],
                        1,
                        Colors.amber,
                      ).animate().fadeIn(delay: const Duration(milliseconds: 400))
                        .slideY(begin: 0.2, end: 0),
                      // Third Place
                      _buildTopPerformer(
                        context,
                        leaderboardData[2],
                        3,
                        Colors.brown[300]!,
                      ).animate().fadeIn(delay: const Duration(milliseconds: 600))
                        .slideY(begin: 0.2, end: 0),
                    ],
                  ),
                ],
              ),
            ),

            // Full Leaderboard
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Full Leaderboard',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ).animate().fadeIn(delay: const Duration(milliseconds: 800))
                    .slideY(begin: 0.2, end: 0),
                  const SizedBox(height: 16),
                  ...leaderboardData.asMap().entries.map((entry) {
                    final index = entry.key;
                    final user = entry.value;
                    return Card(
                      margin: const EdgeInsets.only(bottom: 8),
                      color: user['isCurrentUser'] as bool
                          ? theme.primaryColor.withOpacity(0.1)
                          : null,
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: _getRankColor(user['rank'] as int),
                          child: Text(
                            '#${user['rank']}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        title: Text(
                          user['name'] as String,
                          style: TextStyle(
                            fontWeight: user['isCurrentUser'] as bool
                                ? FontWeight.bold
                                : null,
                          ),
                        ),
                        subtitle: Text(user['level'] as String),
                        trailing: Text(
                          '${user['points']} pts',
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: theme.primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ).animate().fadeIn(
                      delay: Duration(milliseconds: 1000 + (index * 100)),
                    ).slideX(begin: 0.2, end: 0);
                  }).toList(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopPerformer(
    BuildContext context,
    Map<String, dynamic> user,
    int rank,
    Color medalColor,
  ) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            CircleAvatar(
              radius: 40,
              backgroundColor: Colors.white,
              child: Text(
                user['name'].toString().substring(0, 1),
                style: TextStyle(
                  fontSize: 24,
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: medalColor,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  '#$rank',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          user['name'] as String,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          '${user['points']} pts',
          style: TextStyle(
            color: Colors.white.withOpacity(0.8),
          ),
        ),
      ],
    );
  }

  Color _getRankColor(int rank) {
    switch (rank) {
      case 1:
        return Colors.amber;
      case 2:
        return Colors.grey[400]!;
      case 3:
        return Colors.brown[300]!;
      default:
        return Colors.blue;
    }
  }
} 