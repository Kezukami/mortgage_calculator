/// Holds the inputs and payment calculations for a mortgage.
class Mortgage {
  Mortgage({
    this.amount = 100000.0,
    this.years = 30,
    this.rate = 0.035,
  });

  final double amount;
  final int years;

  /// Annual interest rate stored as a decimal (3.5% is 0.035).
  final double rate;

  double get monthlyPayment {
    final monthCount = years * 12;
    if (amount <= 0 || monthCount <= 0) return 0;

    final monthlyRate = rate / 12;
    if (monthlyRate == 0) return amount / monthCount;

    final discountFactor = (1 + monthlyRate).pow(-monthCount);
    return amount * monthlyRate / (1 - discountFactor);
  }

  double get totalPayment => monthlyPayment * years * 12;

  String get formattedAmount => _money(amount);
  String get formattedMonthlyPayment => _money(monthlyPayment);
  String get formattedTotalPayment => _money(totalPayment);
  String get formattedRate => '${(rate * 100).toStringAsFixed(2)}%';

  static String _money(double value) {
    final pieces = value.toStringAsFixed(2).split('.');
    final digits = pieces.first;
    final grouped = StringBuffer();
    for (var index = 0; index < digits.length; index++) {
      if (index > 0 && (digits.length - index) % 3 == 0) {
        grouped.write(',');
      }
      grouped.write(digits[index]);
    }
    return '\$${grouped.toString()}.${pieces.last}';
  }
}

extension on double {
  double pow(int exponent) {
    var result = 1.0;
    for (var i = 0; i < exponent.abs(); i++) {
      result *= this;
    }
    return exponent < 0 ? 1 / result : result;
  }
}
