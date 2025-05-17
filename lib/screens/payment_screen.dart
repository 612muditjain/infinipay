import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/theme_provider.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  bool _isLoading = false;
  bool _isPaymentSuccessful = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final plan = args['plan'] as String;
    final amount = args['amount'] as double;
    
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Payment'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Plan Details Card
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      Icon(
                        Icons.card_membership,
                        size: 64,
                        color: theme.primaryColor,
                      )
                      .animate()
                      .fadeIn(duration: const Duration(milliseconds: 600))
                      .scale(delay: const Duration(milliseconds: 200)),
                      
                      const SizedBox(height: 24),
                      
                      Text(
                        'Selected Plan',
                        style: theme.textTheme.titleLarge,
                      )
                      .animate()
                      .fadeIn(delay: const Duration(milliseconds: 400)),
                      
                      const SizedBox(height: 8),
                      
                      Text(
                        plan.toUpperCase(),
                        style: theme.textTheme.headlineMedium?.copyWith(
                          color: theme.primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                      .animate()
                      .fadeIn(delay: const Duration(milliseconds: 600)),
                      
                      const SizedBox(height: 24),
                      
                      Text(
                        'Amount to Pay',
                        style: theme.textTheme.titleMedium,
                      )
                      .animate()
                      .fadeIn(delay: const Duration(milliseconds: 800)),
                      
                      const SizedBox(height: 8),
                      
                      Text(
                        '₹${amount.toStringAsFixed(2)}',
                        style: theme.textTheme.headlineLarge?.copyWith(
                          color: theme.primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                      .animate()
                      .fadeIn(delay: const Duration(milliseconds: 1000)),
                    ],
                  ),
                ),
              )
              .animate()
              .fadeIn(delay: const Duration(milliseconds: 200))
              .slideY(begin: 0.3, end: 0),
              
              const SizedBox(height: 32),
              
              // Payment Methods
              Text(
                'Select Payment Method',
                style: theme.textTheme.titleLarge,
              )
              .animate()
              .fadeIn(delay: const Duration(milliseconds: 1200)),
              
              const SizedBox(height: 16),
              
              // Payment Method Cards
              _buildPaymentMethodCard(
                'Credit/Debit Card',
                Icons.credit_card,
                theme,
              )
              .animate()
              .fadeIn(delay: const Duration(milliseconds: 1400))
              .slideX(begin: -0.2, end: 0),
              
              const SizedBox(height: 12),
              
              _buildPaymentMethodCard(
                'UPI',
                Icons.payment,
                theme,
              )
              .animate()
              .fadeIn(delay: const Duration(milliseconds: 1600))
              .slideX(begin: -0.2, end: 0),
              
              const SizedBox(height: 12),
              
              _buildPaymentMethodCard(
                'Net Banking',
                Icons.account_balance,
                theme,
              )
              .animate()
              .fadeIn(delay: const Duration(milliseconds: 1800))
              .slideX(begin: -0.2, end: 0),
              
              const SizedBox(height: 32),
              
              // Pay Button
              ElevatedButton(
                onPressed: _isLoading ? null : _processPayment,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 56),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: _isLoading
                    ? const CircularProgressIndicator()
                    : const Text(
                        'Pay Now',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              )
              .animate()
              .fadeIn(delay: const Duration(milliseconds: 2000))
              .slideY(begin: 0.3, end: 0),
              
              const SizedBox(height: 16),
              
              // Cancel Button
              TextButton(
                onPressed: _isLoading ? null : () {
                  Navigator.pop(context);
                },
                child: Text(
                  'Cancel',
                  style: TextStyle(
                    color: theme.primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
              .animate()
              .fadeIn(delay: const Duration(milliseconds: 2200)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPaymentMethodCard(
    String title,
    IconData icon,
    ThemeData theme,
  ) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Icon(
          icon,
          color: theme.primaryColor,
        ),
        title: Text(title),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () {
          // TODO: Implement payment method selection
        },
      ),
    );
  }

  Future<void> _processPayment() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // TODO: Implement actual payment processing
      await Future.delayed(const Duration(seconds: 2)); // Simulated payment processing
      
      if (!mounted) return;
      
      setState(() {
        _isPaymentSuccessful = true;
      });

      // Show success dialog
      await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          title: const Text('Payment Successful'),
          content: const Text('Your account has been activated successfully.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close dialog
                Navigator.pushReplacementNamed(context, '/home');
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    } catch (e) {
      if (!mounted) return;
      
      // Show error dialog
      await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Payment Failed'),
          content: Text(e.toString()),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close dialog
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
} 