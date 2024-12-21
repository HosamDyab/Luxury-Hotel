import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../theme/app_theme.dart';
import '../../providers/payment_provider.dart';

class PaymentMethodsScreen extends StatelessWidget {
  const PaymentMethodsScreen({super.key});

  Widget _buildPaymentMethodCard(BuildContext context, PaymentMethod method) {
    final paymentProvider =
        Provider.of<PaymentProvider>(context, listen: false);

    return Card(
      color: AppTheme.softBlack,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(
          color: method.isDefault ? AppTheme.primaryGold : Colors.grey,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      method.cardType.toLowerCase() == 'visa'
                          ? Icons.credit_card
                          : Icons.credit_card,
                      color: AppTheme.primaryGold,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      method.cardType,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                PopupMenuButton<String>(
                  color: AppTheme.darkBlack,
                  icon: const Icon(
                    Icons.more_vert,
                    color: AppTheme.primaryGold,
                  ),
                  onSelected: (value) {
                    if (value == 'default') {
                      paymentProvider.setDefaultPaymentMethod(method.id);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Default payment method updated'),
                          backgroundColor: AppTheme.darkBlack,
                        ),
                      );
                    } else if (value == 'remove') {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          backgroundColor: AppTheme.softBlack,
                          title: const Text(
                            'Remove Payment Method',
                            style: TextStyle(color: Colors.white),
                          ),
                          content: Text(
                            'Are you sure you want to remove ${method.cardType} ending in ${method.cardNumber.substring(method.cardNumber.length - 4)}?',
                            style: const TextStyle(color: Colors.white70),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                                paymentProvider.removePaymentMethod(method.id);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Payment method removed'),
                                    backgroundColor: AppTheme.darkBlack,
                                  ),
                                );
                              },
                              child: const Text(
                                'Remove',
                                style: TextStyle(color: Colors.red),
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                  },
                  itemBuilder: (context) => [
                    if (!method.isDefault)
                      const PopupMenuItem(
                        value: 'default',
                        child: Text(
                          'Set as Default',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    const PopupMenuItem(
                      value: 'remove',
                      child: Text(
                        'Remove',
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              method.cardNumber,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  method.cardHolder.toUpperCase(),
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
                Text(
                  'Expires ${method.expiryDate}',
                  style: const TextStyle(
                    color: Color.fromARGB(179, 0, 0, 0),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            if (method.isDefault) ...[
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: AppTheme.primaryGold.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: AppTheme.primaryGold),
                ),
                child: const Text(
                  'Default',
                  style: TextStyle(
                    color: AppTheme.primaryGold,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment Methods'),
      ),
      body: Consumer<PaymentProvider>(
        builder: (context, paymentProvider, child) {
          final paymentMethods = paymentProvider.paymentMethods;

          return paymentMethods.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.credit_card,
                        size: 64,
                        color: Colors.white24,
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'No payment methods added',
                        style: TextStyle(
                          color: Color.fromARGB(179, 0, 0, 0),
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton.icon(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Add payment method coming soon'),
                              backgroundColor: AppTheme.darkBlack,
                            ),
                          );
                        },
                        icon: const Icon(Icons.add),
                        label: const Text('Add Payment Method'),
                      ),
                    ],
                  ),
                )
              : ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    ...paymentMethods.map(
                      (method) => Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: _buildPaymentMethodCard(context, method),
                      ),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Add payment method coming soon'),
                              backgroundColor: AppTheme.darkBlack,
                            ),
                          );
                        },
                        icon: const Icon(Icons.add),
                        label: const Text('Add Payment Method'),
                      ),
                    ),
                  ],
                );
        },
      ),
    );
  }
}
