import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  void _showReferralDetails(BuildContext context, Map<String, dynamic> referral) {
    final theme = Theme.of(context);
    
    // Mock user level and plan data
    final userLevel = {
      'current': 3,
      'total': 5,
      'points': 750,
      'nextLevel': 1000,
    };
    
    final userPlan = {
      'name': 'Gold',
      'benefits': [
        'Higher withdrawal limits',
        'Lower transaction fees',
        'Priority support',
        'Exclusive rewards'
      ],
      'validUntil': '2024-12-31',
    };

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: theme.scaffoldBackgroundColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              // User Profile Section
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      theme.primaryColor.withOpacity(0.1),
                      theme.primaryColor.withOpacity(0.05),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundColor: theme.primaryColor,
                      child: Text(
                        (referral['name'] as String? ?? 'U')[0].toUpperCase(),
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ).animate()
                      .scale(duration: const Duration(milliseconds: 300))
                      .fadeIn(),
                    const SizedBox(height: 16),
                    Text(
                      referral['name'] as String? ?? 'Unknown User',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ).animate()
                      .fadeIn(delay: const Duration(milliseconds: 200))
                      .slideY(begin: 0.2, end: 0),
                    const SizedBox(height: 8),
                    Text(
                      referral['email'] as String? ?? 'No email provided',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: Colors.grey,
                      ),
                    ).animate()
                      .fadeIn(delay: const Duration(milliseconds: 300))
                      .slideY(begin: 0.2, end: 0),
                    const SizedBox(height: 8),
                    Text(
                      referral['phone'] as String? ?? 'No phone number',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: Colors.grey,
                      ),
                    ).animate()
                      .fadeIn(delay: const Duration(milliseconds: 400))
                      .slideY(begin: 0.2, end: 0),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Membership Plan Card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.amber.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.amber.withOpacity(0.3),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.workspace_premium,
                          color: Colors.amber[800],
                          size: 24,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '${userPlan['name']} Membership',
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: Colors.amber[800],
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Valid until: ${userPlan['validUntil']}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 12),
                    ...(userPlan['benefits'] as List<String>).map((benefit) => Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        children: [
                          Icon(
                            Icons.check_circle,
                            color: Colors.green,
                            size: 16,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              benefit,
                              style: theme.textTheme.bodyMedium,
                            ),
                          ),
                        ],
                      ),
                    )).toList(),
                  ],
                ),
              ).animate()
                .fadeIn(delay: const Duration(milliseconds: 500))
                .slideY(begin: 0.2, end: 0),

              const SizedBox(height: 20),

              // Level Progress Card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: theme.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Level ${userLevel['current']}',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '${userLevel['points']}/${userLevel['nextLevel']} points',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    LinearProgressIndicator(
                      value: (userLevel['points'] as int) / (userLevel['nextLevel'] as int),
                      backgroundColor: theme.primaryColor.withOpacity(0.2),
                      valueColor: AlwaysStoppedAnimation<Color>(theme.primaryColor),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Next level: ${(userLevel['nextLevel'] as int) - (userLevel['points'] as int)} points needed',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ).animate()
                .fadeIn(delay: const Duration(milliseconds: 600))
                .slideY(begin: 0.2, end: 0),

              const SizedBox(height: 20),

              // Referral Code Section
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: theme.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    Text(
                      'Referral Code',
                      style: theme.textTheme.titleSmall?.copyWith(
                        color: theme.primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      referral['referralCode'] as String? ?? 'N/A',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                      ),
                    ),
                  ],
                ),
              ).animate()
                .fadeIn(delay: const Duration(milliseconds: 700))
                .slideY(begin: 0.2, end: 0),

              const SizedBox(height: 20),

              // Close Button
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Close'),
              ).animate()
                .fadeIn(delay: const Duration(milliseconds: 800))
                .slideY(begin: 0.2, end: 0),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Update sample referral data to include email
    final referrals = [
      {
        'name': 'John Doe',
        'email': 'john.doe@example.com',
        'phone': '+91 9876543210',
        'referralCode': 'JOHN123',
        'date': '2024-03-15',
        'status': 'Active',
      },
      {
        'name': 'Jane Smith',
        'email': 'jane.smith@example.com',
        'phone': '+91 9876543211',
        'referralCode': 'JANE456',
        'date': '2024-03-14',
        'status': 'Active',
      },
      {
        'name': 'Mike Johnson',
        'email': 'mike.johnson@example.com',
        'phone': '+91 9876543212',
        'referralCode': 'MIKE789',
        'date': '2024-03-13',
        'status': 'Pending',
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: referrals.length,
        itemBuilder: (context, index) {
          final referral = referrals[index];
          final status = referral['status'] as String? ?? 'Unknown';
          final isActive = status == 'Active';
          
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => _showReferralDetails(context, referral),
                borderRadius: BorderRadius.circular(16),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isActive ? Colors.green : Colors.orange,
                            width: 2,
                          ),
                        ),
                        child: CircleAvatar(
                          radius: 24,
                          backgroundColor: Theme.of(context).primaryColor,
                          child: Text(
                            (referral['name'] as String? ?? 'U')[0].toUpperCase(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    referral['name'] as String? ?? 'Unknown User',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: isActive
                                        ? Colors.green.withOpacity(0.1)
                                        : Colors.orange.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    status,
                                    style: TextStyle(
                                      color: isActive ? Colors.green : Colors.orange,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Icon(
                                  Icons.phone,
                                  size: 14,
                                  color: Colors.grey.shade600,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  referral['phone'] as String? ?? 'No phone number',
                                  style: TextStyle(
                                    color: Colors.grey.shade600,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Icon(
                                  Icons.calendar_today,
                                  size: 14,
                                  color: Colors.grey.shade600,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  referral['date'] as String? ?? 'No date',
                                  style: TextStyle(
                                    color: Colors.grey.shade600,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Icon(
                        Icons.chevron_right,
                        color: Colors.grey.shade400,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ).animate()
            .fadeIn(delay: Duration(milliseconds: 100 * index))
            .slideX(begin: 0.2, end: 0);
        },
      ),
    );
  }
} 