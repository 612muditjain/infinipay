import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class WalletPage extends StatefulWidget {
  const WalletPage({super.key});

  @override
  State<WalletPage> createState() => _WalletPageState();
}

class _WalletPageState extends State<WalletPage> with SingleTickerProviderStateMixin {
  bool _isCardFlipped = false;
  late AnimationController _cardController;
  late Animation<double> _cardAnimation;

  // Mock user account data
  final userAccount = {
    'type': 'gold', // gold, silver, platinum, free
    'balance': 500.0,
    'bankDetails': {
      'accountNumber': '1234567890',
      'accountHolder': 'John Doe',
      'bankName': 'HDFC Bank',
      'ifscCode': 'HDFC0001234',
    }
  };

  // Account type limits and tax rates
  final accountTypes = {
    'gold': {'min': 300, 'tax': 0.07},
    'silver': {'min': 200, 'tax': 0.07},
    'platinum': {'min': 250, 'tax': 0.07},
    'diamond': {'min': 500, 'tax': 0.05},
    'free': {'min': 100, 'tax': 0.50},
  };

  // Add TextEditingController for withdrawal amount
  final TextEditingController _withdrawalController = TextEditingController();

  // Add card theme data
  final Map<String, Map<String, dynamic>> cardThemes = {
    'silver': {
      'gradient': [Colors.grey.shade400, Colors.grey.shade600],
      'icon': Icons.credit_card,
      'iconColor': Colors.grey.shade300,
      'chipColor': Colors.grey.shade800,
      'chipLines': Colors.grey.shade600,
    },
    'gold': {
      'gradient': [Colors.amber.shade700, Colors.amber.shade900],
      'icon': Icons.credit_card,
      'iconColor': Colors.amber.shade300,
      'chipColor': Colors.amber.shade900,
      'chipLines': Colors.amber.shade700,
    },
    'platinum': {
      'gradient': [Colors.blueGrey.shade700, Colors.blueGrey.shade900],
      'icon': Icons.credit_card,
      'iconColor': Colors.blueGrey.shade300,
      'chipColor': Colors.blueGrey.shade900,
      'chipLines': Colors.blueGrey.shade700,
    },
    'diamond': {
      'gradient': [Colors.blue.shade700, Colors.blue.shade900],
      'icon': Icons.credit_card,
      'iconColor': Colors.blue.shade300,
      'chipColor': Colors.blue.shade900,
      'chipLines': Colors.blue.shade700,
    },
  };

  @override
  void initState() {
    super.initState();
    _cardController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _cardAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _cardController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _cardController.dispose();
    _withdrawalController.dispose();
    super.dispose();
  }

  void _flipCard() {
    if (_isCardFlipped) {
      _cardController.reverse();
    } else {
      _cardController.forward();
    }
    _isCardFlipped = !_isCardFlipped;
  }

  void _showWithdrawalProcess(BuildContext context, Map<String, dynamic> redeemData) {
    final theme = Theme.of(context);
    final taxAmount = redeemData['amount'] * accountTypes[userAccount['type']]!['tax']!;
    final finalAmount = redeemData['amount'] - taxAmount;
    final paymentId = 'PAY${DateTime.now().millisecondsSinceEpoch}';

    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Success Icon
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_circle,
                  color: Colors.green,
                  size: 50,
                ),
              ).animate()
                .scale(duration: const Duration(milliseconds: 500))
                .fadeIn(),

              const SizedBox(height: 24),

              // Payment ID
              _buildDetailRow(
                'Payment ID',
                paymentId,
                theme,
              ).animate()
                .fadeIn(delay: const Duration(milliseconds: 200))
                .slideX(begin: 0.2, end: 0),

              const SizedBox(height: 16),

              // Amount Details
              _buildDetailRow(
                'Amount',
                '₹${redeemData['amount'].toStringAsFixed(2)}',
                theme,
              ).animate()
                .fadeIn(delay: const Duration(milliseconds: 300))
                .slideX(begin: 0.2, end: 0),

              _buildDetailRow(
                'Tax (${(accountTypes[userAccount['type']]!['tax']! * 100).toInt()}%)',
                '₹${taxAmount.toStringAsFixed(2)}',
                theme,
              ).animate()
                .fadeIn(delay: const Duration(milliseconds: 400))
                .slideX(begin: 0.2, end: 0),

              _buildDetailRow(
                'Final Amount',
                '₹${finalAmount.toStringAsFixed(2)}',
                theme,
                isBold: true,
              ).animate()
                .fadeIn(delay: const Duration(milliseconds: 500))
                .slideX(begin: 0.2, end: 0),

              const SizedBox(height: 16),

              // Date and Time
              _buildDetailRow(
                'Date & Time',
                DateTime.now().toString().substring(0, 19),
                theme,
              ).animate()
                .fadeIn(delay: const Duration(milliseconds: 600))
                .slideX(begin: 0.2, end: 0),

              const SizedBox(height: 24),

              // Close Button
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.primaryColor,
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Close'),
              ).animate()
                .fadeIn(delay: const Duration(milliseconds: 700))
                .slideY(begin: 0.2, end: 0),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, ThemeData theme, {bool isBold = false, Color? valueColor}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: Colors.grey,
          ),
        ),
        Text(
          value,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            color: valueColor,
          ),
        ),
      ],
    );
  }

  void _showRedeemDialog(BuildContext context) {
    final theme = Theme.of(context);
    final accountType = userAccount['type'] as String;
    final min = accountTypes[accountType]!['min']!;
    final tax = accountTypes[accountType]!['tax']!;
    final maxBalance = userAccount['balance'] as double;

    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Account Type and Limit
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: theme.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.account_circle,
                      color: theme.primaryColor,
                      size: 32,
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${accountType.toUpperCase()} Account',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Min: ₹$min | Available: ₹${maxBalance.toStringAsFixed(2)}',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ).animate()
                .fadeIn(duration: const Duration(milliseconds: 300))
                .slideY(begin: -0.2, end: 0),

              const SizedBox(height: 24),

              // Withdrawal Amount Input
              TextField(
                controller: _withdrawalController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Enter Amount',
                  hintText: 'Min: ₹$min | Available: ₹${maxBalance.toStringAsFixed(2)}',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixText: '₹',
                ),
              ).animate()
                .fadeIn(delay: const Duration(milliseconds: 400))
                .slideY(begin: 0.2, end: 0),

              const SizedBox(height: 16),

              // Tax Information
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: Colors.orange,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Tax: ${(tax * 100).toInt()}% will be deducted',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: Colors.orange,
                        ),
                      ),
                    ),
                  ],
                ),
              ).animate()
                .fadeIn(delay: const Duration(milliseconds: 500))
                .slideY(begin: 0.2, end: 0),

              const SizedBox(height: 24),

              // Withdraw Button
              ElevatedButton(
                onPressed: () {
                  final amount = double.tryParse(_withdrawalController.text) ?? 0.0;
                  if (amount >= min && amount <= maxBalance) {
                    Navigator.pop(context);
                    _showWithdrawalProcess(context, {
                      'amount': amount,
                    });
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Please enter a valid amount between ₹$min and ₹${maxBalance.toStringAsFixed(2)}'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.primaryColor,
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Withdraw'),
              ).animate()
                .fadeIn(delay: const Duration(milliseconds: 600))
                .slideY(begin: 0.2, end: 0),
            ],
          ),
        ),
      ),
    );
  }

  void _showTransactionDetails(BuildContext context, Map<String, dynamic> transaction) {
    final theme = Theme.of(context);
    
    // Determine transaction status with more options
    String status = 'Completed';
    Color statusColor = Colors.green;
    IconData statusIcon = Icons.check_circle;
    String statusMessage = 'Transaction completed successfully';
    
    switch (transaction['status']?.toLowerCase() ?? 'completed') {
      case 'processing':
        status = 'Processing';
        statusColor = Colors.orange;
        statusIcon = Icons.pending_actions;
        statusMessage = 'Your transaction is being processed';
        break;
      case 'failed':
        status = 'Failed';
        statusColor = Colors.red;
        statusIcon = Icons.error_outline;
        statusMessage = 'Transaction could not be completed';
        break;
      case 'completed':
      default:
        status = 'Completed';
        statusColor = Colors.green;
        statusIcon = Icons.check_circle;
        statusMessage = 'Transaction completed successfully';
        break;
    }

    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header with close button
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Transaction Details',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                      style: IconButton.styleFrom(
                        backgroundColor: theme.primaryColor.withOpacity(0.1),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Amount Display with Simple Coin Style
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: theme.primaryColor.withOpacity(0.1),
                    border: Border.all(
                      color: theme.primaryColor.withOpacity(0.3),
                      width: 2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: theme.primaryColor.withOpacity(0.2),
                        blurRadius: 10,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.currency_rupee,
                        color: theme.primaryColor,
                        size: 32,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${transaction['type'] == 'credit' ? '+' : '-'}₹${transaction['amount'].toStringAsFixed(2)}',
                        style: theme.textTheme.titleLarge?.copyWith(
                          color: transaction['type'] == 'credit' ? Colors.green : Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ).animate()
                  .fadeIn(duration: const Duration(milliseconds: 300))
                  .scale(begin: const Offset(0.8, 0.8), end: const Offset(1, 1)),

                const SizedBox(height: 16),
                // Transaction Description
                Text(
                  transaction['description'],
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: Colors.grey[800],
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ).animate()
                  .fadeIn(delay: const Duration(milliseconds: 400))
                  .slideY(begin: 0.2, end: 0),

                const SizedBox(height: 24),

                // Transaction Status with Enhanced Styling
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: statusColor.withOpacity(0.3),
                    ),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            statusIcon,
                            color: statusColor,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            status,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: statusColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        statusMessage,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: statusColor.withOpacity(0.8),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ).animate()
                  .fadeIn(delay: const Duration(milliseconds: 500))
                  .slideY(begin: 0.2, end: 0),

                const SizedBox(height: 24),

                // Transaction Details with Enhanced Styling
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: theme.primaryColor.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: theme.primaryColor.withOpacity(0.1),
                    ),
                  ),
                  child: Column(
                    children: [
                      _buildDetailRow(
                        'Transaction ID',
                        transaction['transactionId'] ?? 'Not Available',
                        theme,
                      ),
                      const Divider(height: 24),
                      _buildDetailRow(
                        'Date & Time',
                        transaction['date'],
                        theme,
                      ),
                      if (transaction['type'] == 'debit') ...[
                        const Divider(height: 24),
                        _buildDetailRow(
                          'UPI ID',
                          transaction['upiId'] ?? 'Not Available',
                          theme,
                        ),
                      ],
                    ],
                  ),
                ).animate()
                  .fadeIn(delay: const Duration(milliseconds: 600))
                  .slideY(begin: 0.2, end: 0),

                const SizedBox(height: 24),

                // Withdrawal Details (only for debit transactions)
                if (transaction['type'] == 'debit')
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.amber.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Colors.amber.withOpacity(0.3),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.info_outline,
                              color: Colors.amber,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Withdrawal Details',
                              style: theme.textTheme.titleSmall?.copyWith(
                                color: Colors.amber[800],
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        _buildDetailRow(
                          'Bank Account',
                          transaction['bankAccount'] ?? 'Not Available',
                          theme,
                        ),
                        const SizedBox(height: 8),
                        _buildDetailRow(
                          'IFSC Code',
                          transaction['ifscCode'] ?? 'Not Available',
                          theme,
                        ),
                      ],
                    ),
                  ).animate()
                    .fadeIn(delay: const Duration(milliseconds: 700))
                    .slideY(begin: 0.2, end: 0),

                const SizedBox(height: 24),

                // Close Button with Enhanced Styling
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 2,
                  ),
                  child: const Text('Close'),
                ).animate()
                  .fadeIn(delay: const Duration(milliseconds: 800))
                  .slideY(begin: 0.2, end: 0),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Update the _buildRecentTransactions method to include onTap
  Widget _buildRecentTransactions(BuildContext context, List<Map<String, dynamic>> transactions) {
    final theme = Theme.of(context);
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Text(
            'Recent Transactions',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        ...transactions.asMap().entries.map((entry) {
          final index = entry.key;
          final transaction = entry.value;
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: isDarkMode ? Colors.grey[900] : Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: isDarkMode 
                    ? Colors.black.withOpacity(0.3)
                    : Colors.grey.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ListTile(
              onTap: () => _showTransactionDetails(context, transaction),
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: transaction['type'] == 'credit' 
                    ? Colors.green.withOpacity(isDarkMode ? 0.2 : 0.1)
                    : Colors.red.withOpacity(isDarkMode ? 0.2 : 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  transaction['type'] == 'credit' 
                    ? Icons.add_circle_outline
                    : Icons.remove_circle_outline,
                  color: transaction['type'] == 'credit' 
                    ? Colors.green
                    : Colors.red,
                ),
              ),
              title: Text(
                transaction['description'],
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                  color: isDarkMode ? Colors.white : Colors.black87,
                ),
              ),
              subtitle: Text(
                transaction['date'],
                style: theme.textTheme.bodySmall?.copyWith(
                  color: isDarkMode ? Colors.grey[400] : Colors.grey,
                ),
              ),
              trailing: Text(
                '${transaction['type'] == 'credit' ? '+' : '-'}₹${transaction['amount'].toStringAsFixed(2)}',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: transaction['type'] == 'credit' 
                    ? Colors.green
                    : Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ).animate()
            .fadeIn(delay: Duration(milliseconds: 100 * index))
            .slideX(begin: 0.2, end: 0);
        }).toList(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final userType = userAccount['type'] as String;
    final cardTheme = cardThemes[userType] ?? cardThemes['silver']!;
    
    // Mock card data
    final cardData = {
      'cardNumber': '4532 1234 5678 7895',
      'expiryDate': '12/25',
      'cvv': '123',
      'cardHolder': 'JOHN DOE',
      'balance': '₹${(userAccount['balance'] as num).toStringAsFixed(2)}',
    };

    // Update the mock transaction data to include more details
    final transactions = [
      {
        'type': 'credit',
        'amount': 2.00,
        'description': 'Daily Tasks Completed',
        'date': '2024-03-20 14:30',
        'transactionId': 'TXN123456789',
      },
      {
        'type': 'credit',
        'amount': 1.50,
        'description': 'Memory Match Game',
        'date': '2024-03-20 13:15',
        'transactionId': 'TXN123456788',
      },
      {
        'type': 'debit',
        'amount': 5.00,
        'description': 'Amazon Gift Card',
        'date': '2024-03-19 16:45',
        'transactionId': 'TXN123456787',
        'upiId': 'user@upi',
        'bankAccount': 'HDFC Bank - 1234',
        'ifscCode': 'HDFC0001234',
      },
      {
        'type': 'credit',
        'amount': 0.80,
        'description': 'Video Rewards',
        'date': '2024-03-19 10:20',
        'transactionId': 'TXN123456786',
      },
    ];

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Digital Card
                GestureDetector(
                  onTap: _flipCard,
                  child: AnimatedBuilder(
                    animation: _cardAnimation,
                    builder: (context, child) {
                      final transform = Matrix4.identity()
                        ..setEntry(3, 2, 0.001)
                        ..rotateY(3.14159 * _cardAnimation.value);
                      return Transform(
                        transform: transform,
                        alignment: Alignment.center,
                        child: Container(
                          height: 220,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: cardTheme['gradient'] as List<Color>,
                            ),
                            borderRadius: BorderRadius.circular(24),
                            boxShadow: [
                              BoxShadow(
                                color: (cardTheme['gradient'] as List<Color>)[0].withOpacity(0.3),
                                blurRadius: 20,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          child: Stack(
                            children: [
                              // Front of card
                              if (_cardAnimation.value < 0.5) ...[
                                // Card Chip
                                Positioned(
                                  left: 24,
                                  top: 24,
                                  child: Container(
                                    width: 50,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      color: cardTheme['chipColor'] as Color,
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Stack(
                                      children: [
                                        // Chip lines
                                        Positioned(
                                          left: 8,
                                          top: 8,
                                          child: Container(
                                            width: 34,
                                            height: 24,
                                            decoration: BoxDecoration(
                                              color: cardTheme['chipLines'] as Color,
                                              borderRadius: BorderRadius.circular(2),
                                            ),
                                          ),
                                        ),
                                        // Contactless symbol
                                        Positioned(
                                          right: 8,
                                          bottom: 8,
                                          child: Icon(
                                            Icons.wifi,
                                            color: Colors.white.withOpacity(0.7),
                                            size: 16,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                // Membership Badge
                                Positioned(
                                  right: 24,
                                  top: 24,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        if (userType == 'diamond')
                                          Icon(
                                            Icons.diamond,
                                            color: Colors.white,
                                            size: 16,
                                          ),
                                        if (userType == 'diamond')
                                          const SizedBox(width: 4),
                                        Text(
                                          userType.toUpperCase(),
                                          style: theme.textTheme.bodySmall?.copyWith(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                // Card Details
                                Padding(
                                  padding: const EdgeInsets.all(24),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(height: 60),
                                      // Card Number
                                      Text(
                                        cardData['cardNumber']!,
                                        style: theme.textTheme.bodyLarge?.copyWith(
                                          color: Colors.white,
                                          letterSpacing: 1.5,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ).animate()
                                        .fadeIn(delay: const Duration(milliseconds: 200))
                                        .slideX(begin: -0.2, end: 0),
                                      const SizedBox(height: 12),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          // Card Holder Name
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'CARD HOLDER',
                                                style: theme.textTheme.bodySmall?.copyWith(
                                                  color: Colors.white.withOpacity(0.7),
                                                  fontSize: 8,
                                                ),
                                              ),
                                              Text(
                                                cardData['cardHolder']!,
                                                style: theme.textTheme.bodySmall?.copyWith(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                          // Expiry Date
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'EXPIRES',
                                                style: theme.textTheme.bodySmall?.copyWith(
                                                  color: Colors.white.withOpacity(0.7),
                                                  fontSize: 8,
                                                ),
                                              ),
                                              Text(
                                                cardData['expiryDate']!,
                                                style: theme.textTheme.bodySmall?.copyWith(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ).animate()
                                        .fadeIn(delay: const Duration(milliseconds: 400))
                                        .slideY(begin: 0.2, end: 0),
                                      const Spacer(),
                                      // Balance
                                      Text(
                                        'Available Balance',
                                        style: theme.textTheme.bodySmall?.copyWith(
                                          color: Colors.white.withOpacity(0.8),
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        cardData['balance']!,
                                        style: theme.textTheme.titleMedium?.copyWith(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ).animate()
                                        .fadeIn(delay: const Duration(milliseconds: 600))
                                        .scale(begin: const Offset(0.8, 0.8), end: const Offset(1, 1)),
                                    ],
                                  ),
                                ),
                              ] else ...[
                                // Back of card
                                Transform(
                                  transform: Matrix4.identity()..rotateY(3.14159),
                                  alignment: Alignment.center,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                        colors: cardTheme['gradient'] as List<Color>,
                                      ),
                                      borderRadius: BorderRadius.circular(24),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(24),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          const SizedBox(height: 20),
                                          Container(
                                            height: 40,
                                            color: Colors.black,
                                          ),
                                          const SizedBox(height: 20),
                                          Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.circular(8),
                                            ),
                                            child: Row(
                                              children: [
                                                Text(
                                                  'CVV: ',
                                                  style: theme.textTheme.titleMedium?.copyWith(
                                                    color: Colors.black87,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                Text(
                                                  cardData['cvv']!,
                                                  style: theme.textTheme.titleMedium?.copyWith(
                                                    color: Colors.black87,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          const Spacer(),
                                          Center(
                                            child: Text(
                                              'Tap to flip back',
                                              style: theme.textTheme.bodyMedium?.copyWith(
                                                color: Colors.white70,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ).animate()
                  .fadeIn(duration: const Duration(milliseconds: 600))
                  .slideY(begin: 0.3, end: 0),

                const SizedBox(height: 32),

                // Redeem Button
                ElevatedButton.icon(
                  onPressed: () => _showRedeemDialog(context),
                  icon: const Icon(Icons.card_giftcard),
                  label: const Text('Redeem Rewards'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.primaryColor,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ).animate()
                  .fadeIn(delay: const Duration(milliseconds: 200))
                  .slideY(begin: 0.2, end: 0),

                const SizedBox(height: 32),

                // Account Type Info
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: theme.primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.account_circle,
                        color: theme.primaryColor,
                        size: 32,
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${userAccount['type'].toString().toUpperCase()} Account',
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'Min Withdrawal: ₹${accountTypes[userAccount['type']]!['min']}',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ).animate()
                  .fadeIn(delay: const Duration(milliseconds: 400))
                  .slideY(begin: 0.2, end: 0),

                // Add Recent Transactions
                _buildRecentTransactions(context, transactions).animate()
                  .fadeIn(delay: const Duration(milliseconds: 600))
                  .slideY(begin: 0.2, end: 0),

                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
} 