import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class DailyTasksPage extends StatefulWidget {
  const DailyTasksPage({super.key});

  @override
  State<DailyTasksPage> createState() => _DailyTasksPageState();
}

class _DailyTasksPageState extends State<DailyTasksPage> {
  final int _totalVideos = 10;
  int _watchedVideos = 0;
  double _earnings = 0.0;
  bool _isWatching = false;

  Future<void> _watchVideo() async {
    if (_watchedVideos >= _totalVideos || _isWatching) return;

    setState(() {
      _isWatching = true;
    });

    try {
      // TODO: Implement actual video ad integration
      await Future.delayed(const Duration(seconds: 30)); // Simulated video duration
      
      if (!mounted) return;

      setState(() {
        _watchedVideos++;
        _earnings = _watchedVideos * 0.20;
        _isWatching = false;
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error watching video: $e')),
      );
      setState(() {
        _isWatching = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
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
                                'Videos Watched',
                                style: theme.textTheme.titleMedium,
                              ),
                              Text(
                                '$_watchedVideos/$_totalVideos',
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
                                'Today\'s Earnings',
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
                        value: _watchedVideos / _totalVideos,
                        backgroundColor: theme.primaryColor.withOpacity(0.1),
                        valueColor: AlwaysStoppedAnimation<Color>(theme.primaryColor),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '₹0.20 per video (Total: ₹2.00)',
                        style: theme.textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
              )
              .animate()
              .fadeIn(duration: const Duration(milliseconds: 600))
              .slideY(begin: 0.3, end: 0),

              const SizedBox(height: 32),

              // Video List
              Expanded(
                child: ListView.builder(
                  itemCount: _totalVideos,
                  itemBuilder: (context, index) {
                    final isWatched = index < _watchedVideos;
                    final isCurrent = index == _watchedVideos;
                    
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        leading: Icon(
                          isWatched ? Icons.check_circle : Icons.play_circle,
                          color: isWatched ? Colors.green : theme.primaryColor,
                        ),
                        title: Text(
                          'Watch Video ${index + 1}',
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: isWatched ? Colors.grey : null,
                          ),
                        ),
                        subtitle: Text(
                          isWatched ? 'Completed' : '₹0.20 reward',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: isWatched ? Colors.grey : null,
                          ),
                        ),
                        trailing: isCurrent && !_isWatching
                            ? ElevatedButton(
                                onPressed: _watchVideo,
                                child: const Text('Watch'),
                              )
                            : isCurrent && _isWatching
                                ? const CircularProgressIndicator()
                                : null,
                      ),
                    )
                    .animate()
                    .fadeIn(delay: Duration(milliseconds: 100 * index))
                    .slideX(begin: 0.2, end: 0);
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