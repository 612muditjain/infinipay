import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/theme_provider.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingPage> _pages = [
    OnboardingPage(
      title: 'Earn Coins',
      description: 'Complete tasks and earn coins that can be redeemed for rewards',
      icon: Icons.monetization_on,
    ),
    OnboardingPage(
      title: 'Refer & Earn',
      description: 'Invite friends and earn bonus coins for each successful referral',
      icon: Icons.people,
    ),
    OnboardingPage(
      title: 'Play & Win',
      description: 'Engage in exciting games and win additional rewards',
      icon: Icons.sports_esports,
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onGetStarted() {
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _pages.length,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemBuilder: (context, index) {
                  final page = _pages[index];
                  return _buildPage(page, theme);
                },
              ),
            ),
            
            // Page Indicator
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  _pages.length,
                  (index) => Container(
                    width: 8,
                    height: 8,
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _currentPage == index
                          ? theme.primaryColor
                          : theme.primaryColor.withOpacity(0.3),
                    ),
                  ),
                ),
              ),
            ),
            
            // Get Started Button
            Padding(
              padding: const EdgeInsets.all(24),
              child: ElevatedButton(
                onPressed: _onGetStarted,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 56),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: const Text(
                  'Get Started',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPage(OnboardingPage page, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            page.icon,
            size: 120,
            color: theme.primaryColor,
          )
          .animate()
          .fadeIn(duration: const Duration(milliseconds: 600))
          .scale(delay: const Duration(milliseconds: 200)),
          
          const SizedBox(height: 32),
          
          Text(
            page.title,
            style: theme.textTheme.headlineMedium?.copyWith(
              color: theme.primaryColor,
              fontWeight: FontWeight.bold,
            ),
          )
          .animate()
          .fadeIn(delay: const Duration(milliseconds: 400))
          .slideY(begin: 0.3, end: 0),
          
          const SizedBox(height: 16),
          
          Text(
            page.description,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.textTheme.bodyLarge?.color?.withOpacity(0.7),
            ),
          )
          .animate()
          .fadeIn(delay: const Duration(milliseconds: 600))
          .slideY(begin: 0.3, end: 0),
        ],
      ),
    );
  }
}

class OnboardingPage {
  final String title;
  final String description;
  final IconData icon;

  OnboardingPage({
    required this.title,
    required this.description,
    required this.icon,
  });
} 