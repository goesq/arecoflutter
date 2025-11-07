import 'package:intl/intl.dart';

/// Exemplo: 20/01/2025
String formatDate(DateTime date) {
  return DateFormat('dd/MM/yyyy').format(date);
}

/// Exemplo: 20/01 → 25/01
String formatDateShortRange(DateTime start, DateTime end) {
  final df = DateFormat('dd/MM');
  return '${df.format(start)} → ${df.format(end)}';
}
