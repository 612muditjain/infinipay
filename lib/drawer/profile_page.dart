import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _imagePicker = ImagePicker();
  File? _profileImage;

  Future<void> _pickImage(ImageSource source) async {
    try {
      final pickedFile = await _imagePicker.pickImage(
        source: source,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 85,
      );
      
      if (pickedFile != null) {
        setState(() {
          _profileImage = File(pickedFile.path);
        });
        // TODO: Implement API call to update profile picture
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error picking image: $e')),
      );
    }
  }

  void _showImagePickerModal() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Choose from Gallery'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.gallery);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: const Text('Take a Photo'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.camera);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    // Mock user data with proper typing
    final Map<String, dynamic> userData = {
      'name': 'John Doe',
      'email': 'john.doe@example.com',
      'phone': '+91 98765 43210',
      'joinDate': 'January 2024',
      'referralCode': 'INFINI123',
      'totalEarnings': '₹2,500',
      'totalReferrals': '15',
      'level': 'Gold',
      'plan': {
        'type': 'Gold',
        'minWithdrawal': 300,
        'maxWithdrawal': 10000,
        'referralBonus': 50,
      },
      'bankDetails': {
        'accountNumber': 'XXXX XXXX 1234',
        'accountHolder': 'John Doe',
        'bankName': 'State Bank of India',
        'ifscCode': 'SBIN0001234',
        'branch': 'Mumbai Main Branch'
      },
      'achievements': <Map<String, dynamic>>[
        {'title': 'Early Adopter', 'icon': Icons.star, 'color': Colors.amber},
        {'title': 'Top Referrer', 'icon': Icons.people, 'color': Colors.blue},
        {'title': 'Active User', 'icon': Icons.emoji_events, 'color': Colors.purple},
      ],
    };

    // Plan colors and icons
    final Map<String, Map<String, dynamic>> planStyles = {
      'Gold': {
        'color': Colors.amber,
        'gradient': [Colors.amber, Colors.orange],
        'icon': Icons.workspace_premium,
      },
      'Silver': {
        'color': Colors.grey,
        'gradient': [Colors.grey, Colors.blueGrey],
        'icon': Icons.star,
      },
      'Platinum': {
        'color': Colors.blue,
        'gradient': [Colors.blue, Colors.indigo],
        'icon': Icons.diamond,
      },
      'Free': {
        'color': Colors.green,
        'gradient': [Colors.green, Colors.teal],
        'icon': Icons.card_giftcard,
      },
    };

    final currentPlan = userData['plan'] as Map<String, dynamic>;
    final planStyle = planStyles[userData['level'] as String]!;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Profile Header
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: theme.primaryColor,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: Column(
                children: [
                  Stack(
                    children: [
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white,
                            width: 2,
                          ),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(50),
                          child: _profileImage != null
                              ? Image.file(
                                  _profileImage!,
                                  fit: BoxFit.cover,
                                )
                              : Container(
                                  color: Colors.white.withOpacity(0.2),
                                  child: const Icon(
                                    Icons.person,
                                    size: 50,
                                    color: Colors.white,
                                  ),
                                ),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: GestureDetector(
                          onTap: _showImagePickerModal,
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Icon(
                              Icons.camera_alt,
                              color: theme.primaryColor,
                              size: 16,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ).animate()
                    .fadeIn(duration: const Duration(milliseconds: 500))
                    .scale(begin: const Offset(0.5, 0.5), end: const Offset(1, 1)),
                  const SizedBox(height: 16),
                  Text(
                    userData['name'] as String,
                    style: theme.textTheme.headlineSmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ).animate()
                    .fadeIn(delay: const Duration(milliseconds: 200))
                    .slideY(begin: 0.2, end: 0),
                  Text(
                    userData['email'] as String,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: Colors.white70,
                    ),
                  ).animate()
                    .fadeIn(delay: const Duration(milliseconds: 300))
                    .slideY(begin: 0.2, end: 0),
                ],
              ),
            ),

            // Plan Card
            Padding(
              padding: const EdgeInsets.all(16),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: planStyle['gradient'] as List<Color>,
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: (planStyle['color'] as Color).withOpacity(0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              planStyle['icon'] as IconData,
                              color: Colors.white,
                              size: 32,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${userData['level']} Plan',
                                  style: theme.textTheme.titleLarge?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  'Active Member',
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: Colors.white70,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              'Current',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(20),
                          bottomRight: Radius.circular(20),
                        ),
                      ),
                      child: Column(
                        children: [
                          _buildPlanBenefit(
                            context,
                            'Min Withdrawal',
                            '₹${currentPlan['minWithdrawal']}',
                            Icons.account_balance_wallet,
                          ),
                          const SizedBox(height: 12),
                          _buildPlanBenefit(
                            context,
                            'Max Withdrawal',
                            '₹${currentPlan['maxWithdrawal']}',
                            Icons.account_balance,
                          ),
                          const SizedBox(height: 12),
                          _buildPlanBenefit(
                            context,
                            'Referral Bonus',
                            '₹${currentPlan['referralBonus']}',
                            Icons.card_giftcard,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ).animate()
              .fadeIn(delay: const Duration(milliseconds: 400))
              .slideY(begin: 0.2, end: 0),

            // User Stats
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: _buildStatCard(
                      context,
                      'Total Earnings',
                      userData['totalEarnings'] as String,
                      Icons.account_balance_wallet,
                      Colors.green,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildStatCard(
                      context,
                      'Referrals',
                      userData['totalReferrals'] as String,
                      Icons.people,
                      Colors.blue,
                    ),
                  ),
                ],
              ),
            ).animate()
              .fadeIn(delay: const Duration(milliseconds: 500))
              .slideY(begin: 0.2, end: 0),

            // User Details Card
            Card(
              margin: const EdgeInsets.all(16),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'User Details',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildDetailRow(
                      context,
                      Icons.phone,
                      'Phone',
                      userData['phone'] as String,
                    ),
                    const Divider(),
                    _buildDetailRow(
                      context,
                      Icons.calendar_today,
                      'Joined',
                      userData['joinDate'] as String,
                    ),
                    const Divider(),
                    _buildDetailRow(
                      context,
                      Icons.card_giftcard,
                      'Referral Code',
                      userData['referralCode'] as String,
                    ),
                    const Divider(),
                    _buildDetailRow(
                      context,
                      Icons.workspace_premium,
                      'Level',
                      userData['level'] as String,
                    ),
                  ],
                ),
              ),
            ).animate()
              .fadeIn(delay: const Duration(milliseconds: 600))
              .slideY(begin: 0.2, end: 0),

            // Bank Account Details
            Card(
              margin: const EdgeInsets.all(16),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Bank Account Details',
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () {
                            // TODO: Implement edit bank details
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _buildDetailRow(
                      context,
                      Icons.account_balance,
                      'Bank Name',
                      (userData['bankDetails'] as Map<String, dynamic>)['bankName'] as String,
                    ),
                    const Divider(),
                    _buildDetailRow(
                      context,
                      Icons.person,
                      'Account Holder',
                      (userData['bankDetails'] as Map<String, dynamic>)['accountHolder'] as String,
                    ),
                    const Divider(),
                    _buildDetailRow(
                      context,
                      Icons.credit_card,
                      'Account Number',
                      (userData['bankDetails'] as Map<String, dynamic>)['accountNumber'] as String,
                    ),
                    const Divider(),
                    _buildDetailRow(
                      context,
                      Icons.code,
                      'IFSC Code',
                      (userData['bankDetails'] as Map<String, dynamic>)['ifscCode'] as String,
                    ),
                    const Divider(),
                    _buildDetailRow(
                      context,
                      Icons.location_on,
                      'Branch',
                      (userData['bankDetails'] as Map<String, dynamic>)['branch'] as String,
                    ),
                  ],
                ),
              ),
            ).animate()
              .fadeIn(delay: const Duration(milliseconds: 700))
              .slideY(begin: 0.2, end: 0),

            // Achievements
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Achievements',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ...(userData['achievements'] as List<Map<String, dynamic>>).asMap().entries.map((entry) {
                    final index = entry.key;
                    final achievement = entry.value;
                    return Card(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: achievement['color'] as Color,
                          child: Icon(
                            achievement['icon'] as IconData,
                            color: Colors.white,
                          ),
                        ),
                        title: Text(achievement['title'] as String),
                      ),
                    ).animate()
                      .fadeIn(delay: Duration(milliseconds: 800 + (index * 100)))
                      .slideX(begin: 0.2, end: 0);
                  }).toList(),
                ],
              ),
            ),
          ],
        ),
      ),
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
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 8),
            Text(
              value,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              title,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(
    BuildContext context,
    IconData icon,
    String title,
    String value,
  ) {
    final theme = Theme.of(context);
    
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: theme.primaryColor),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: Colors.grey,
                ),
              ),
              Text(
                value,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPlanBenefit(
    BuildContext context,
    String title,
    String value,
    IconData icon,
  ) {
    final theme = Theme.of(context);
    
    return Row(
      children: [
        Icon(icon, color: Colors.white70),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: theme.textTheme.bodySmall?.copyWith(
                color: Colors.white70,
              ),
            ),
            Text(
              value,
              style: theme.textTheme.titleMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ],
    );
  }
}