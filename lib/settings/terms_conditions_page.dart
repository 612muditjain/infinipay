import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class TermsConditionsPage extends StatelessWidget {
  const TermsConditionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Terms & Conditions'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // User Agreement Section
              _buildSection(
                context,
                '1. User Agreement',
                'By using InfiniPay, you agree to these terms and conditions. This includes accepting our rules for using the platform, making payments, and participating in the referral program.',
                delay: 200,
              ),

              const SizedBox(height: 24),

              // Privacy Policy Section
              _buildSection(
                context,
                '2. Privacy Policy',
                'We collect and use your data in accordance with our privacy policy. This includes:',
                delay: 400,
              ),
              _buildBulletPoints(
                context,
                [
                  'Personal information (name, email, phone)',
                  'Transaction history',
                  'Device information',
                  'Usage data',
                ],
                delay: 600,
              ),

              const SizedBox(height: 24),

              // Payment Terms Section
              _buildSection(
                context,
                '3. Payment Terms',
                'All payments are processed securely and are non-refundable. We support various payment methods including UPI, cards, and net banking.',
                delay: 800,
              ),

              const SizedBox(height: 24),

              // Withdrawal Policy Section
              _buildSection(
                context,
                '4. Withdrawal Policy',
                'Our withdrawal policy includes the following terms:',
                delay: 1000,
              ),
              _buildBulletPoints(
                context,
                [
                  'Minimum withdrawal amount: ₹100',
                  'Processing time: 24-48 hours',
                  'Withdrawal fees may apply',
                  'KYC verification required for withdrawals',
                ],
                delay: 1200,
              ),

              const SizedBox(height: 24),

              // Referral Program Section
              _buildSection(
                context,
                '5. Referral Program',
                'Our referral program is governed by the following rules:',
                delay: 1400,
              ),
              _buildBulletPoints(
                context,
                [
                  'Earn rewards for successful referrals',
                  'Referral rewards are subject to terms',
                  'Fraudulent referrals will be penalized',
                  'Rewards are credited after verification',
                ],
                delay: 1600,
              ),

              const SizedBox(height: 32),

              // Accept Button
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Terms & Conditions accepted'),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.primaryColor,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 16,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Accept Terms & Conditions',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ).animate().fadeIn(delay: const Duration(milliseconds: 1800))
                .slideY(begin: 0.2, end: 0),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection(
    BuildContext context,
    String title,
    String content, {
    required int delay,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ).animate().fadeIn(delay: Duration(milliseconds: delay))
          .slideX(begin: 0.2, end: 0),
        const SizedBox(height: 8),
        Text(
          content,
          style: Theme.of(context).textTheme.bodyLarge,
        ).animate().fadeIn(delay: Duration(milliseconds: delay + 100))
          .slideX(begin: 0.2, end: 0),
      ],
    );
  }

  Widget _buildBulletPoints(
    BuildContext context,
    List<String> points, {
    required int delay,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: points.asMap().entries.map((entry) {
        final index = entry.key;
        final point = entry.value;
        return Padding(
          padding: const EdgeInsets.only(left: 16, bottom: 8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '•',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  point,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
            ],
          ),
        ).animate().fadeIn(
          delay: Duration(milliseconds: delay + (index * 100)),
        ).slideX(begin: 0.2, end: 0);
      }).toList(),
    );
  }
} 