import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../theme/theme_provider.dart';
import '../settings/security_settings_page.dart';
import '../settings/payment_methods_page.dart';
import '../settings/help_support_page.dart';
import '../settings/terms_conditions_page.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final themeProvider = Provider.of<ThemeProvider>(context);
    
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Profile Header
                Center(
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundColor: theme.primaryColor,
                        child: Text(
                          'U',
                          style: TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      )
                      .animate()
                      .scale(duration: const Duration(milliseconds: 600))
                      .fadeIn(),
                      const SizedBox(height: 16),
                      Text(
                        'User Name',
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      )
                      .animate()
                      .fadeIn(delay: const Duration(milliseconds: 200))
                      .slideY(begin: 0.2, end: 0),
                      Text(
                        'user@email.com',
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: theme.textTheme.bodySmall?.color,
                        ),
                      )
                      .animate()
                      .fadeIn(delay: const Duration(milliseconds: 400))
                      .slideY(begin: 0.2, end: 0),
                    ],
                  ),
                ),

                const SizedBox(height: 32),

                // Settings Section
                Text(
                  'Settings',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                )
                .animate()
                .fadeIn(delay: const Duration(milliseconds: 600))
                .slideY(begin: 0.1, end: 0),

                const SizedBox(height: 16),

                // Settings List
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [
                      _buildSettingItem(
                        context,
                        Icons.security,
                        'Security',
                        'Manage security settings',
                        () {
                          Navigator.push(
                            context,
                            PageRouteBuilder(
                              pageBuilder: (context, animation, secondaryAnimation) =>
                                  const SecuritySettingsPage(),
                              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                const begin = Offset(1.0, 0.0);
                                const end = Offset.zero;
                                const curve = Curves.easeInOut;
                                var tween = Tween(begin: begin, end: end).chain(
                                  CurveTween(curve: curve),
                                );
                                var offsetAnimation = animation.drive(tween);
                                return SlideTransition(
                                  position: offsetAnimation,
                                  child: child,
                                );
                              },
                              transitionDuration: const Duration(milliseconds: 300),
                            ),
                          );
                        },
                      ),
                      const Divider(height: 1),
                      _buildSettingItem(
                        context,
                        Icons.payment,
                        'Payment Methods',
                        'Manage payment options',
                        () {
                          Navigator.push(
                            context,
                            PageRouteBuilder(
                              pageBuilder: (context, animation, secondaryAnimation) =>
                                  const PaymentMethodsPage(),
                              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                const begin = Offset(1.0, 0.0);
                                const end = Offset.zero;
                                const curve = Curves.easeInOut;
                                var tween = Tween(begin: begin, end: end).chain(
                                  CurveTween(curve: curve),
                                );
                                var offsetAnimation = animation.drive(tween);
                                return SlideTransition(
                                  position: offsetAnimation,
                                  child: child,
                                );
                              },
                              transitionDuration: const Duration(milliseconds: 300),
                            ),
                          );
                        },
                      ),
                      const Divider(height: 1),
                      _buildSettingItem(
                        context,
                        Icons.help,
                        'Help & Support',
                        'Get help and contact support',
                        () {
                          Navigator.push(
                            context,
                            PageRouteBuilder(
                              pageBuilder: (context, animation, secondaryAnimation) =>
                                  const HelpSupportPage(),
                              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                const begin = Offset(1.0, 0.0);
                                const end = Offset.zero;
                                const curve = Curves.easeInOut;
                                var tween = Tween(begin: begin, end: end).chain(
                                  CurveTween(curve: curve),
                                );
                                var offsetAnimation = animation.drive(tween);
                                return SlideTransition(
                                  position: offsetAnimation,
                                  child: child,
                                );
                              },
                              transitionDuration: const Duration(milliseconds: 300),
                            ),
                          );
                        },
                      ),
                      const Divider(height: 1),
                      _buildSettingItem(
                        context,
                        Icons.description,
                        'Terms & Conditions',
                        'Read our terms and conditions',
                        () {
                          Navigator.push(
                            context,
                            PageRouteBuilder(
                              pageBuilder: (context, animation, secondaryAnimation) =>
                                  const TermsConditionsPage(),
                              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                const begin = Offset(1.0, 0.0);
                                const end = Offset.zero;
                                const curve = Curves.easeInOut;
                                var tween = Tween(begin: begin, end: end).chain(
                                  CurveTween(curve: curve),
                                );
                                var offsetAnimation = animation.drive(tween);
                                return SlideTransition(
                                  position: offsetAnimation,
                                  child: child,
                                );
                              },
                              transitionDuration: const Duration(milliseconds: 300),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                )
                .animate()
                .fadeIn(delay: const Duration(milliseconds: 800))
                .slideY(begin: 0.2, end: 0),

                const SizedBox(height: 32),

                // Theme Toggle
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: ListTile(
                    leading: Icon(
                      themeProvider.isDarkMode ? Icons.dark_mode : Icons.light_mode,
                      color: theme.primaryColor,
                    ),
                    title: Text(
                      'Dark Mode',
                      style: theme.textTheme.titleMedium,
                    ),
                    subtitle: Text(
                      'Toggle dark/light theme',
                      style: theme.textTheme.bodySmall,
                    ),
                    trailing: Switch(
                      value: themeProvider.isDarkMode,
                      onChanged: (value) async {
                        try {
                          await themeProvider.toggleTheme();
                        } catch (e) {
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Error toggling theme: $e')),
                            );
                          }
                        }
                      },
                    ),
                  ),
                )
                .animate()
                .fadeIn(delay: const Duration(milliseconds: 1000))
                .slideY(begin: 0.2, end: 0),

                const SizedBox(height: 32),

                // App Version
                Center(
                  child: Text(
                    'App Version 1.0.0',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: Colors.grey,
                    ),
                  ),
                )
                .animate()
                .fadeIn(delay: const Duration(milliseconds: 1200))
                .slideY(begin: 0.2, end: 0),

                const SizedBox(height: 32),

                // Logout Button
                ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Logout'),
                          content: const Text('Are you sure you want to logout?'),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text('Cancel'),
                            ),
                            ElevatedButton(
                              onPressed: () async {
                                Navigator.pop(context); // Close dialog
                                try {
                                  final storage = const FlutterSecureStorage();
                                  await storage.delete(key: 'auth_token');
                                  if (context.mounted) {
                                    Navigator.pushNamedAndRemoveUntil(
                                      context,
                                      '/login',
                                      (route) => false,
                                    );
                                  }
                                } catch (e) {
                                  if (context.mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text('Error logging out: $e')),
                                    );
                                  }
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                              ),
                              child: const Text(
                                'Logout',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Logout',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
                .animate()
                .fadeIn(delay: const Duration(milliseconds: 1400))
                .slideY(begin: 0.2, end: 0),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSettingItem(
    BuildContext context,
    IconData icon,
    String title,
    String subtitle,
    VoidCallback onTap,
  ) {
    return ListTile(
      leading: Icon(icon, color: Theme.of(context).primaryColor),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}