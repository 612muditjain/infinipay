import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../theme/theme_provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final _storage = const FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    await Future.delayed(const Duration(seconds: 3));
    if (!mounted) return;

    final token = await _storage.read(key: 'auth_token');
    if (!mounted) return;

    Navigator.pushReplacementNamed(
      context,
      token != null ? '/home' : '/onboarding',
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // App Logo
            Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                color: theme.primaryColor,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.payment,
                size: 80,
                color: Colors.white,
              ),
            )
            .animate()
            .fadeIn(duration: const Duration(milliseconds: 800))
            .scale(delay: const Duration(milliseconds: 400)),
            
            const SizedBox(height: 24),
            
            // App Name
            Text(
              'InfiniPay',
              style: theme.textTheme.headlineMedium?.copyWith(
                color: theme.primaryColor,
                fontWeight: FontWeight.bold,
              ),
            )
            .animate()
            .fadeIn(delay: const Duration(milliseconds: 600))
            .slideY(begin: 0.3, end: 0),
            
            const SizedBox(height: 16),
            
            // Tagline
            Text(
              'Your Infinite Payment Solution',
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.textTheme.bodyLarge?.color?.withOpacity(0.7),
              ),
            )
            .animate()
            .fadeIn(delay: const Duration(milliseconds: 800))
            .slideY(begin: 0.3, end: 0),
          ],
        ),
      ),
    );
  }
} 