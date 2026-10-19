import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'mortgage.dart';

class MortgageProvider extends ChangeNotifier {
  MortgageProvider(this._preferences)
      : _mortgage = Mortgage(
          amount: _preferences.getDouble(_amountKey) ?? 100000.0,
          years: _preferences.getInt(_yearsKey) ?? 30,
          rate: _preferences.getDouble(_rateKey) ?? 0.035,
        );

  static const String _amountKey = 'loan_amount';
  static const String _yearsKey = 'loan_years';
  static const String _rateKey = 'interest_rate';

  final SharedPreferences _preferences;
  Mortgage _mortgage;

  Mortgage get mortgage => _mortgage;

  void updateMortgage(Mortgage mortgage) {
    _mortgage = mortgage;
    notifyListeners();
    unawaited(_saveMortgage());
  }

  Future<void> _saveMortgage() async {
    await _preferences.setDouble(_amountKey, _mortgage.amount);
    await _preferences.setInt(_yearsKey, _mortgage.years);
    await _preferences.setDouble(_rateKey, _mortgage.rate);
  }
}