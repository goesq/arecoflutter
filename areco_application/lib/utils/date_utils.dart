import 'package:intl/intl.dart';

String formatDate(DateTime date) {
  return DateFormat('dd/MM/yyyy').format(date);
}

String formatDateShortRange(DateTime start, DateTime end) {
  final df = DateFormat('dd/MM');
  return '${df.format(start)} → ${df.format(end)}';
}
