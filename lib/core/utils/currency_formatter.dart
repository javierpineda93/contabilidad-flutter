import 'package:intl/intl.dart';

final currencyFormatter = NumberFormat.currency(
  locale: 'es_ES',
  symbol: '€',
  decimalDigits: 2,
);