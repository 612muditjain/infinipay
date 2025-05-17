import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:url_launcher/url_launcher.dart';

class ReferralEarningsPage extends StatelessWidget {
  const ReferralEarningsPage({super.key});

  Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri)) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    // Mock data - Replace with actual data from API
    final referralStats = {
      'totalReferrals': 15,
      'activeReferrals': 8,
      'totalEarnings': 1250.0,
      'pendingEarnings': 250.0,
      'referralCode': 'INFINI123',
    };

    final earningsHistory = [
      {
        'date': DateTime.now().subtract(const Duration(days: 1)),
        'amount': 150.0,
        'referral': 'User 1',
        'status': 'claimed',
      },
      {
        'date': DateTime.now().subtract(const Duration(days: 3)),
        'amount': 200.0,
        'referral': 'User 2',
        'status': 'pending',
      },
      {
        'date': DateTime.now().subtract(const Duration(days: 5)),
        'amount': 300.0,
        'referral': 'User 3',
        'status': 'claimed',
      },
    ];

    // Mock referral tree data
    final referralTree = {
      'level1': [
        {'name': 'User 1', 'joined': '2024-01-15', 'earnings': 150.0},
        {'name': 'User 2', 'joined': '2024-01-20', 'earnings': 200.0},
      ],
      'level2': [
        {'name': 'User 3', 'joined': '2024-01-25', 'earnings': 100.0},
        {'name': 'User 4', 'joined': '2024-01-28', 'earnings': 150.0},
      ],
      'level3': [
        {'name': 'User 5', 'joined': '2024-02-01', 'earnings': 75.0},
      ],
      'level4': [
        {'name': 'User 6', 'joined': '2024-02-05', 'earnings': 50.0},
      ],
      'level5': [
        {'name': 'User 7', 'joined': '2024-02-10', 'earnings': 25.0},
      ],
    };

    return Scaffold(
      appBar: AppBar(
        title: const Text('Referral & Earnings'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Stats Cards
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    context,
                    'Total Referrals',
                    referralStats['totalReferrals'].toString(),
                    Icons.people,
                    Colors.blue,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildStatCard(
                    context,
                    'Active Referrals',
                    referralStats['activeReferrals'].toString(),
                    Icons.person,
                    Colors.green,
                  ),
                ),
              ],
            ).animate().fadeIn().slideY(begin: 0.2, end: 0),

            const SizedBox(height: 16),

            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    context,
                    'Total Earnings',
                    '₹${referralStats['totalEarnings']}',
                    Icons.account_balance_wallet,
                    Colors.orange,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildStatCard(
                    context,
                    'Pending Earnings',
                    '₹${referralStats['pendingEarnings']}',
                    Icons.pending_actions,
                    Colors.purple,
                  ),
                ),
              ],
            ).animate().fadeIn(delay: const Duration(milliseconds: 200))
                .slideY(begin: 0.2, end: 0),

            const SizedBox(height: 24),

            // Referral Code Section with Share Options
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Your Referral Code',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: theme.primaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            referralStats['referralCode'] as String,
                            style: theme.textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              letterSpacing: 2,
                            ),
                          ),
                          Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.copy),
                                onPressed: () {
                                  // TODO: Implement copy to clipboard
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Referral code copied!'),
                                    ),
                                  );
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.share),
                                onPressed: () {
                                  _showShareOptions(context, referralStats['referralCode'] as String);
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ).animate().fadeIn(delay: const Duration(milliseconds: 400))
                .slideY(begin: 0.2, end: 0),

            const SizedBox(height: 24),

            // Referral Tree
            Text(
              'Referral Tree',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ...referralTree.entries.map((entry) {
              final level = entry.key;
              final users = entry.value as List<Map<String, dynamic>>;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Level ${level.substring(5)}',
                    style: theme.textTheme.titleSmall?.copyWith(
                      color: theme.primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ...users.map((user) => Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: theme.primaryColor,
                        child: Text(
                          user['name'].toString().substring(0, 1),
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                      title: Text(user['name'] as String),
                      subtitle: Text('Joined: ${user['joined']}'),
                      trailing: Text(
                        '₹${user['earnings']}',
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  )).toList(),
                  const SizedBox(height: 16),
                ],
              );
            }).toList(),

            const SizedBox(height: 24),

            // Earnings History
            Text(
              'Earnings History',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ...earningsHistory.asMap().entries.map((entry) {
              final index = entry.key;
              final history = entry.value;
              return Card(
                margin: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: theme.primaryColor,
                    child: const Icon(Icons.person, color: Colors.white),
                  ),
                  title: Text(history['referral'] as String),
                  subtitle: Text(
                    _formatDate(history['date'] as DateTime),
                    style: theme.textTheme.bodySmall,
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '₹${history['amount']}',
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (history['status'] == 'pending')
                        TextButton(
                          onPressed: () {
                            // TODO: Implement claim functionality
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Earnings claimed successfully!'),
                              ),
                            );
                          },
                          child: const Text('Claim'),
                        ),
                    ],
                  ),
                ),
              ).animate().fadeIn(
                delay: Duration(milliseconds: 600 + (index * 100)),
              ).slideX(begin: 0.2, end: 0);
            }).toList(),
          ],
        ),
      ),
    );
  }

  void _showShareOptions(BuildContext context, String referralCode) {
    final shareText = 'Join using my referral code: $referralCode\nDownload the app: https://infinipay.app';
    
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.copy),
                title: const Text('Copy Link'),
                onTap: () {
                  Navigator.pop(context);
                  // TODO: Implement copy to clipboard
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Link copied to clipboard!')),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.share),
                title: const Text('Share via Other Apps'),
                onTap: () {
                  Navigator.pop(context);
                  final whatsappUrl = 'whatsapp://send?text=$shareText';
                  _launchUrl(whatsappUrl);
                },
              ),
              ListTile(
                leading: const Icon(Icons.telegram),
                title: const Text('Share via Telegram'),
                onTap: () {
                  Navigator.pop(context);
                  final telegramUrl = 'https://t.me/share/url?url=https://infinipay.app&text=$shareText';
                  _launchUrl(telegramUrl);
                },
              ),
              ListTile(
                leading: const Icon(Icons.email),
                title: const Text('Share via Email'),
                onTap: () {
                  Navigator.pop(context);
                  final emailUrl = 'mailto:?subject=Join InfiniPay&body=$shareText';
                  _launchUrl(emailUrl);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatCard(
    BuildContext context,
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    final theme = Theme.of(context);
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color),
            const SizedBox(height: 8),
            Text(
              title,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
} 