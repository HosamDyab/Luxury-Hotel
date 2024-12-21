import 'package:flutter/material.dart';

class PaymentMethod {
  final String id;
  final String cardNumber;
  final String cardHolder;
  final String expiryDate;
  final String cardType;
  final bool isDefault;

  PaymentMethod({
    required this.id,
    required this.cardNumber,
    required this.cardHolder,
    required this.expiryDate,
    required this.cardType,
    this.isDefault = false,
  });

  PaymentMethod copyWith({
    String? id,
    String? cardNumber,
    String? cardHolder,
    String? expiryDate,
    String? cardType,
    bool? isDefault,
  }) {
    return PaymentMethod(
      id: id ?? this.id,
      cardNumber: cardNumber ?? this.cardNumber,
      cardHolder: cardHolder ?? this.cardHolder,
      expiryDate: expiryDate ?? this.expiryDate,
      cardType: cardType ?? this.cardType,
      isDefault: isDefault ?? this.isDefault,
    );
  }
}

class PaymentProvider extends ChangeNotifier {
  List<PaymentMethod> _paymentMethods = [
    PaymentMethod(
      id: '1',
      cardNumber: '**** **** **** 1234',
      cardHolder: 'Hosam Dyb',
      expiryDate: '12/25',
      cardType: 'Visa',
      isDefault: true,
    ),
    PaymentMethod(
      id: '2',
      cardNumber: '**** **** **** 5678',
      cardHolder: 'Hosam Dyb',
      expiryDate: '09/24',
      cardType: 'Mastercard',
    ),
  ];

  List<PaymentMethod> get paymentMethods => _paymentMethods;

  PaymentMethod? get defaultPaymentMethod {
    try {
      return _paymentMethods.firstWhere((method) => method.isDefault);
    } catch (e) {
      return null;
    }
  }

  void addPaymentMethod(PaymentMethod method) {
    if (_paymentMethods.isEmpty) {
      _paymentMethods.add(method.copyWith(isDefault: true));
    } else {
      _paymentMethods.add(method);
    }
    notifyListeners();
  }

  void removePaymentMethod(String id) {
    final removedMethod =
        _paymentMethods.firstWhere((method) => method.id == id);
    _paymentMethods.removeWhere((method) => method.id == id);

    // If we removed the default payment method, set a new default
    if (removedMethod.isDefault && _paymentMethods.isNotEmpty) {
      _paymentMethods[0] = _paymentMethods[0].copyWith(isDefault: true);
    }

    notifyListeners();
  }

  void setDefaultPaymentMethod(String id) {
    _paymentMethods = _paymentMethods.map((method) {
      if (method.id == id) {
        return method.copyWith(isDefault: true);
      }
      return method.copyWith(isDefault: false);
    }).toList();

    notifyListeners();
  }
}
