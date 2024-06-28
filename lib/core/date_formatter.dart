import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

String formatDate(DateTime date) {
  initializeDateFormatting('ru', null);
  return DateFormat(
    'dd MMMM yyyy',
    'ru',
  ).format(date);
}
