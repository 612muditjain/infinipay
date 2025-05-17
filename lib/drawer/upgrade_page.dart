import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class UpgradePage extends StatelessWidget {
  const UpgradePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upgrade Membership'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.blue.shade900,
                    Colors.blue.shade700,
                  ],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Membership Tiers',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Upgrade your membership to unlock exclusive benefits',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white.withOpacity(0.8),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Important Notes:',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildNoteItem(
                    'Membership upgrades are permanent and cannot be downgraded',
                    Icons.info_outline,
                    Colors.blue,
                  ),
                  _buildNoteItem(
                    'Once you purchase a higher tier, you cannot purchase lower tiers',
                    Icons.warning_amber_rounded,
                    Colors.orange,
                  ),
                  _buildNoteItem(
                    'Free tier (Silver) is available to all users',
                    Icons.check_circle_outline,
                    Colors.green,
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Available Plans',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildPlanCard(
                    context,
                    'Silver',
                    '₹10',
                    [
                      'Basic MLM Points',
                      'Standard Referral Bonus',
                      'Community Access',
                      'Basic Support',
                    ],
                    Colors.grey,
                    isFree: false,
                    isCurrent: false,
                    isLowerTier: true, // Lower than Gold
                  ),
                       _buildPlanCard(
                    context,
                    'Platinum',
                    '₹20',
                    [
                      '3x MLM Points',
                      '2x Referral Bonus',
                      'VIP Support',
                      'Premium Rewards',
                      'Early Access',
                      'Weekly Bonus',
                    ],
                    Colors.blueGrey,
                    isLowerTier: true, // Lower than Gold in this context
                  ),
                  _buildPlanCard(
                    context,
                    'Gold',
                    '₹30',
                    [
                      '2x MLM Points',
                      '1.5x Referral Bonus',
                      'Priority Support',
                      'Exclusive Rewards',
                      'Daily Bonus',
                    ],
                    Colors.amber,
                    isCurrent: true,
                    isLowerTier: false,
                  ),
             
                  _buildPlanCard(
                    context,
                    'Diamond',
                    '₹100',
                    [
                      '5x MLM Points',
                      '3x Referral Bonus',
                      '24/7 Support',
                      'Elite Rewards',
                      'Priority Access',
                      'Exclusive Events',
                      'Monthly Bonus',
                      'Special Offers',
                    ],
                    Colors.blue,
                    isLowerTier: false,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNoteItem(String text, IconData icon, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 14,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlanCard(
    BuildContext context,
    String title,
    String price,
    List<String> benefits,
    Color color, {
    bool isFree = false,
    bool isCurrent = false,
    bool isLowerTier = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
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
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: Row(
              children: [
                Icon(Icons.workspace_premium, color: color),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: color,
                        ),
                      ),
                      if (isCurrent)
                        Container(
                          margin: const EdgeInsets.only(top: 4),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.green.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Text(
                            'Current Plan',
                            style: TextStyle(
                              color: Colors.green,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      price,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: color,
                      ),
                    ),
                    if (title == 'Platinum')
                      Container(
                        margin: const EdgeInsets.only(top: 4),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.orange.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text(
                          'Limited Time Offer',
                          style: TextStyle(
                            color: Colors.orange,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                ...benefits.map((benefit) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    children: [
                      Icon(
                        Icons.check_circle,
                        color: Colors.green,
                        size: 20,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          benefit,
                          style: const TextStyle(fontSize: 14),
                        ),
                      ),
                    ],
                  ),
                )),
                const SizedBox(height: 16),
                if (!isCurrent)
                  ElevatedButton(
                    onPressed: isLowerTier
                        ? null // Disable button for lower-tier plans
                        : () {
                            // Implement purchase logic for allowed plans
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Processing $title plan purchase...'),
                              ),
                            );
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isLowerTier ? Colors.grey : color,
                      minimumSize: const Size(double.infinity, 45),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      isLowerTier ? 'Not Available' : 'Upgrade to $title',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    ).animate()
      .fadeIn(delay: Duration(milliseconds: 200))
      .slideY(begin: 0.2, end: 0);
  }
}