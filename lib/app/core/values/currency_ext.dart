import 'package:intl/intl.dart';

extension CurrencyFormatter on num {
  /// Converts a number to a comma-separated currency string with 2 decimal places.
  /// Example: 1234567.89 -> ৳1,234,567.89
  String get toCurrency {
    final formatter = NumberFormat.currency(
      locale: 'en_US',
      symbol: '৳',
      decimalDigits: 2,
    );
    return formatter.format(this);
  }

  /// Converts a number to a comma-separated currency string with 0 decimal places.
  /// Example: 1234567 -> ৳1,234,567
  String get toCurrencyCompact {
    final formatter = NumberFormat.currency(
      locale: 'en_US',
      symbol: '৳',
      decimalDigits: 0,
    );
    return formatter.format(this);
  }
}
