import 'package:flutter/material.dart';

class PaymentMethodsScreen extends StatelessWidget {
  const PaymentMethodsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment Methods'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          buildPaymentMethodCard(
            context,
            'Credit/Debit Cards',
            Icons.credit_card,
            () => showAddCardDialog(context),
          ),
          const SizedBox(height: 16),
          buildPaymentMethodCard(
            context,
            'PayPal',
            Icons.payment,
            () => showPayPalDialog(context),
          ),
          const SizedBox(height: 16),
          buildPaymentMethodCard(
            context,
            'Bank Transfer',
            Icons.account_balance,
            () => showBankTransferDialog(context),
          ),
        ],
      ),
    );
  }

  Widget buildPaymentMethodCard(
    BuildContext context,
    String title,
    IconData icon,
    VoidCallback onTap,
  ) {
    return Card(
      elevation: 2,
      child: ListTile(
        leading: Icon(icon, color: Theme.of(context).primaryColor),
        title: Text(title),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: onTap,
      ),
    );
  }

  void showAddCardDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        final cardNumberController = TextEditingController();
        final expiryDateController = TextEditingController();
        final cvvController = TextEditingController();

        return AlertDialog(
          title: const Text('Add Credit/Debit Card'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: cardNumberController,
                  decoration: const InputDecoration(labelText: 'Card Number'),
                ),
                TextField(
                  controller: expiryDateController,
                  decoration: const InputDecoration(labelText: 'Expiry Date (MM/YY)'),
                ),
                TextField(
                  controller: cvvController,
                  decoration: const InputDecoration(labelText: 'CVV'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                // Validate and add card logic here
                // Show success message
                Navigator.of(context).pop();
              },
              child: const Text('Add Card'),
            ),
          ],
        );
      },
    );
  }

  void showEditCardDialog(BuildContext context, String cardNumber, String expiryDate, String cvv) {
    final cardNumberController = TextEditingController(text: cardNumber);
    final expiryDateController = TextEditingController(text: expiryDate);
    final cvvController = TextEditingController(text: cvv);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Credit/Debit Card'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: cardNumberController,
                  decoration: const InputDecoration(labelText: 'Card Number'),
                ),
                TextField(
                  controller: expiryDateController,
                  decoration: const InputDecoration(labelText: 'Expiry Date (MM/YY)'),
                ),
                TextField(
                  controller: cvvController,
                  decoration: const InputDecoration(labelText: 'CVV'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                // Validate and edit card logic here
                // Show success message
                Navigator.of(context).pop();
              },
              child: const Text('Save Changes'),
            ),
          ],
        );
      },
    );
  }

  void showPayPalDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Connect PayPal'),
        content: const Text('Redirect to PayPal for connection...'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Connect'),
          ),
        ],
      ),
    );
  }

  void showBankTransferDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Bank Transfer Details'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Bank: Luxury Hotel Bank'),
            Text('Account Number: XXXX-XXXX-XXXX'),
            Text('SWIFT: LXHBXXXX'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void deletePaymentMethod(BuildContext context, String methodId) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Deletion'),
        content: const Text('Are you sure you want to delete this payment method?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Yes'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      // Logic to delete the payment method goes here
      // Show success message
    }
  }
}
