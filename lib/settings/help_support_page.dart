import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:url_launcher/url_launcher.dart';

class HelpSupportPage extends StatefulWidget {
  const HelpSupportPage({super.key});

  @override
  State<HelpSupportPage> createState() => _HelpSupportPageState();
}

class _HelpSupportPageState extends State<HelpSupportPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _subjectController = TextEditingController();
  final _messageController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _subjectController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _launchEmail() async {
    if (_formKey.currentState!.validate()) {
      final Uri emailLaunchUri = Uri(
        scheme: 'mailto',
        path: 'support@infinipay.com',
        queryParameters: {
          'subject': _subjectController.text,
          'body': '''
Name: ${_nameController.text}
Email: ${_emailController.text}

Message:
${_messageController.text}
''',
        },
      );

      if (await canLaunchUrl(emailLaunchUri)) {
        await launchUrl(emailLaunchUri);
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Could not launch email client'),
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    // Mock data - Replace with actual data from API
    final faqItems = [
      {
        'question': 'How do I withdraw my earnings?',
        'answer': 'You can withdraw your earnings by going to the Wallet section and selecting "Withdraw". Choose your preferred payment method and follow the instructions.',
      },
      {
        'question': 'How does the referral system work?',
        'answer': 'When you refer someone using your unique referral code, you earn points and bonuses based on their activities. The more active referrals you have, the more you earn!',
      },
      {
        'question': 'What are MLM points?',
        'answer': 'MLM points are earned through various activities like referrals, completing tasks, and team achievements. These points can be redeemed for rewards and bonuses.',
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Help & Support'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Contact Support Section
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
                    'Need Help?',
                    style: theme.textTheme.titleLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ).animate().fadeIn().slideY(begin: 0.2, end: 0),
                  const SizedBox(height: 16),
                  Text(
                    'Our support team is here to help you',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: Colors.white70,
                    ),
                  ).animate().fadeIn(delay: const Duration(milliseconds: 200))
                    .slideY(begin: 0.2, end: 0),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildContactOption(
                        context,
                        Icons.chat,
                        'Live Chat',
                        'Chat with us',
                        () {
                          // TODO: Implement live chat
                        },
                      ).animate().fadeIn(delay: const Duration(milliseconds: 400))
                        .slideY(begin: 0.2, end: 0),
                      _buildContactOption(
                        context,
                        Icons.email,
                        'Email',
                        'support@infinipay.com',
                        () {
                          _showContactForm(context);
                        },
                      ).animate().fadeIn(delay: const Duration(milliseconds: 600))
                        .slideY(begin: 0.2, end: 0),
                      _buildContactOption(
                        context,
                        Icons.phone,
                        'Call Us',
                        '+1 234 567 890',
                        () {
                          // TODO: Implement phone support
                        },
                      ).animate().fadeIn(delay: const Duration(milliseconds: 800))
                        .slideY(begin: 0.2, end: 0),
                    ],
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // FAQ Section
                  Text(
                    'Frequently Asked Questions',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ).animate().fadeIn(delay: const Duration(milliseconds: 1000))
                    .slideY(begin: 0.2, end: 0),
                  const SizedBox(height: 16),
                  ...faqItems.asMap().entries.map((entry) {
                    final index = entry.key;
                    final faq = entry.value;
                    return Card(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: ExpansionTile(
                        title: Text(
                          faq['question'] as String,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(16),
                            child: Text(faq['answer'] as String),
                          ),
                        ],
                      ),
                    ).animate().fadeIn(
                      delay: Duration(milliseconds: 1200 + (index * 100)),
                    ).slideX(begin: 0.2, end: 0);
                  }).toList(),

                  const SizedBox(height: 32),

                  // App Version
                  Center(
                    child: Text(
                      'App Version 1.0.0',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: Colors.grey,
                      ),
                    ),
                  ).animate().fadeIn(delay: const Duration(milliseconds: 1600))
                    .slideY(begin: 0.2, end: 0),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showContactForm(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Container(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Contact Support',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 24),
                _buildFormField(
                  context,
                  'Your Name',
                  _nameController,
                  Icons.person_outline,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                _buildFormField(
                  context,
                  'Your Email',
                  _emailController,
                  Icons.email_outlined,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    if (!value.contains('@')) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                _buildFormField(
                  context,
                  'Subject',
                  _subjectController,
                  Icons.subject,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a subject';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                _buildFormField(
                  context,
                  'Message',
                  _messageController,
                  Icons.message_outlined,
                  maxLines: 4,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your message';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _launchEmail,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Send Message',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFormField(
    BuildContext context,
    String label,
    TextEditingController controller,
    IconData icon, {
    String? Function(String?)? validator,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      validator: validator,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  Widget _buildContactOption(
    BuildContext context,
    IconData icon,
    String title,
    String subtitle,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: Colors.white,
              size: 24,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            subtitle,
            style: TextStyle(
              color: Colors.white.withOpacity(0.8),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}