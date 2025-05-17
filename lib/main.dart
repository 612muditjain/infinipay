import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../onboard/splash_screen.dart';
import '../onboard/onboarding_screen.dart';
import '../auth/login_screen.dart';
import '../auth/register_screen.dart';
import '../screens/payment_screen.dart';
import '../screens/home_screen.dart';
import '../theme/theme_provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    
    return MaterialApp(
      title: 'InfiniPay',
      debugShowCheckedModeBanner: false,
      theme: ThemeProvider.lightTheme,
      darkTheme: ThemeProvider.darkTheme,
      themeMode: themeProvider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/onboarding': (context) => const OnboardingScreen(),
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/payment': (context) => const PaymentScreen(),
        '/home': (context) => const HomeScreen(),
        // Add more routes as needed
      },
      onGenerateRoute: (settings) {
        // Handle any dynamic routes here
        if (settings.name == '/home') {
          // TODO: Add your home screen widget
          return MaterialPageRoute(
            builder: (context) => const Scaffold(
              body: Center(
                child: Text('Home Screen - To be implemented'),
              ),
            ),
          );
        }
        return null;
      },
    );
  }
}

