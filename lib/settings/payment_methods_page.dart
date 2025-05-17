import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class PaymentMethodsPage extends StatefulWidget {
  const PaymentMethodsPage({super.key});

  @override
  State<PaymentMethodsPage> createState() => _PaymentMethodsPageState();
}

class _PaymentMethodsPageState extends State<PaymentMethodsPage> {
  // Mock data - Replace with actual data from API
  final List<Map<String, dynamic>> paymentMethods = [
    {
      'type': 'Bank Account',
      'details': 'HDFC Bank - XXXX1234',
      'isDefault': true,
      'icon': Icons.account_balance,
      'isEditable': false,
    },
    {
      'type': 'UPI',
      'details': 'user@upi',
      'isDefault': false,
      'icon': Icons.payment,
      'isEditable': false,
    },
    {
      'type': 'Credit Card',
      'details': 'XXXX-XXXX-XXXX-4321',
      'isDefault': false,
      'icon': Icons.credit_card,
      'isEditable': false,
    },
  ];

  void _showAddPaymentMethodDialog(BuildContext context) {
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
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Add Payment Method',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),
              _buildPaymentMethodOption(
                context,
                Icons.account_balance,
                'Bank Account',
                'Link your bank account',
                () {
                  Navigator.pop(context);
                  _showPaymentMethodSetup(context, 'Bank Account');
                },
              ),
              const SizedBox(height: 16),
              _buildPaymentMethodOption(
                context,
                Icons.payment,
                'UPI',
                'Add UPI ID',
                () {
                  Navigator.pop(context);
                  _showPaymentMethodSetup(context, 'UPI');
                },
              ),
              const SizedBox(height: 16),
              _buildPaymentMethodOption(
                context,
                Icons.credit_card,
                'Credit/Debit Card',
                'Add card details',
                () {
                  Navigator.pop(context);
                  _showPaymentMethodSetup(context, 'Credit Card');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showPaymentMethodSetup(BuildContext context, String type) {
    final formKey = GlobalKey<FormState>();
    final detailsController = TextEditingController();

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
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Add $type',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 24),
                TextFormField(
                  controller: detailsController,
                  decoration: InputDecoration(
                    labelText: type == 'UPI' ? 'UPI ID' : 'Account Details',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter details';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        setState(() {
                          paymentMethods.add({
                            'type': type,
                            'details': detailsController.text,
                            'isDefault': paymentMethods.isEmpty,
                            'icon': type == 'Bank Account'
                                ? Icons.account_balance
                                : type == 'UPI'
                                    ? Icons.payment
                                    : Icons.credit_card,
                            'isEditable': true,
                          });
                        });
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Payment method added successfully!'),
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Save',
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

  void _showPaymentMethodOptions(BuildContext context, Map<String, dynamic> method) {
    if (!method['isEditable']) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('This payment method cannot be edited'),
        ),
      );
      return;
    }

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.star),
              title: const Text('Set as Default'),
              onTap: () {
                setState(() {
                  for (var m in paymentMethods) {
                    m['isDefault'] = m == method;
                  }
                });
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Default payment method updated'),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete, color: Colors.red),
              title: const Text('Remove', style: TextStyle(color: Colors.red)),
              onTap: () {
                setState(() {
                  paymentMethods.remove(method);
                });
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Payment method removed'),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment Methods'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Add New Payment Method Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () => _showAddPaymentMethodDialog(context),
                  icon: const Icon(Icons.add),
                  label: const Text('Add New Payment Method'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ).animate().fadeIn().slideY(begin: 0.2, end: 0),

              const SizedBox(height: 32),

              // Payment Methods List
              Text(
                'Your Payment Methods',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ).animate().fadeIn(delay: const Duration(milliseconds: 200))
                .slideY(begin: 0.2, end: 0),
              const SizedBox(height: 16),
              ...paymentMethods.asMap().entries.map((entry) {
                final index = entry.key;
                final method = entry.value;
                return Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: theme.primaryColor.withOpacity(0.1),
                      child: Icon(
                        method['icon'] as IconData,
                        color: theme.primaryColor,
                      ),
                    ),
                    title: Text(method['type'] as String),
                    subtitle: Text(method['details'] as String),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (method['isDefault'] as bool)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.green.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              'Default',
                              style: TextStyle(
                                color: Colors.green,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        IconButton(
                          icon: const Icon(Icons.more_vert),
                          onPressed: () => _showPaymentMethodOptions(context, method),
                        ),
                      ],
                    ),
                  ),
                ).animate().fadeIn(
                  delay: Duration(milliseconds: 400 + (index * 100)),
                ).slideX(begin: 0.2, end: 0);
              }).toList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPaymentMethodOption(
    BuildContext context,
    IconData icon,
    String title,
    String subtitle,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.withOpacity(0.2)),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
              child: Icon(
                icon,
                color: Theme.of(context).primaryColor,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right),
          ],
        ),
      ),
    );
  }
} 