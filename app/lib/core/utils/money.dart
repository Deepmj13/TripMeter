import 'package:intl/intl.dart';

/// Formats an integer minor amount for display. Amounts are never stored as
/// doubles; conversion only happens at the formatting boundary.
String formatMoney(int amountMinor, String currency, int exponent) {
  final divisor = _pow10(exponent);
  final formatter = NumberFormat.currency(
    name: currency,
    symbol: currency == 'INR' ? '\u20B9' : null,
    decimalDigits: exponent,
  );
  return formatter.format(amountMinor / divisor);
}

String formatMoneyShort(int amountMinor, String currency, int exponent) {
  final divisor = _pow10(exponent);
  return '${currency == 'INR' ? '\u20B9' : '$currency '}${(amountMinor / divisor).toStringAsFixed(exponent)}';
}

int _pow10(int exponent) {
  var result = 1;
  for (var index = 0; index < exponent; index += 1) {
    result *= 10;
  }
  return result;
}

/// Parses a user-entered major amount (for example "1250.50") into integer
/// minor units without floating-point arithmetic.
int? parseMajorToMinor(String input, int exponent) {
  final normalized = input.trim().replaceAll(',', '').replaceAll('\u20B9', '');
  if (normalized.isEmpty) return null;
  final pattern = RegExp(r'^\d+(\.\d{0,' + exponent.toString() + r'})?$');
  if (!pattern.hasMatch(normalized)) return null;

  final parts = normalized.split('.');
  final whole = int.tryParse(parts[0]);
  if (whole == null) return null;
  var fraction = parts.length > 1 ? parts[1] : '';
  while (fraction.length < exponent) {
    fraction += '0';
  }
  final fractionValue = fraction.isEmpty ? 0 : int.tryParse(fraction);
  if (fractionValue == null) return null;
  return whole * _pow10(exponent) + fractionValue;
}

String minorToMajorInput(int amountMinor, int exponent) {
  final divisor = _pow10(exponent);
  final whole = amountMinor ~/ divisor;
  final fraction = amountMinor % divisor;
  if (exponent == 0) return whole.toString();
  return '$whole.${fraction.toString().padLeft(exponent, '0')}';
}

/// Deterministic equal split. Sorted participant IDs receive the remainder so
/// a retry always produces the same allocation.
Map<String, int> allocateEqualSplit(int amountMinor, Iterable<String> memberIds) {
  final ordered = memberIds.toSet().toList()..sort();
  if (ordered.isEmpty) return {};
  final base = amountMinor ~/ ordered.length;
  final remainder = amountMinor % ordered.length;
  return {
    for (var index = 0; index < ordered.length; index += 1)
      ordered[index]: base + (index < remainder ? 1 : 0),
  };
}
