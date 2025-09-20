import 'package:intl/intl.dart';

String formatDateBydMMMYYYY(DateTime date) {
  return DateFormat('dd MMM, yyyy').format(date);
}