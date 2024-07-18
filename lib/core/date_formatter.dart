import "package:intl/date_symbol_data_local.dart";
import "package:intl/intl.dart";

String formatDate(DateTime date, String languageCode) {
  initializeDateFormatting(languageCode, null);
  return DateFormat(
    "dd MMMM yyyy",
    languageCode,
  ).format(date);
}
