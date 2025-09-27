import 'package:intl/intl.dart';

class StringsUtils {
  static String moneyFormat(double value) {
    final formatter = NumberFormat.currency(
      locale: 'en_US',
      symbol: '\$',
      decimalDigits: 2,
    );
    return '${formatter.format(value)} USD';
  }

  static String formatToDayMonth(String dateString) {
    final dateUtc = DateTime.parse(dateString).toUtc();
    final dateLocal = dateUtc.toLocal();

    final formatter = DateFormat("EEEE d MMMM", "es_ES");
    return formatter.format(dateLocal);
  }

  static String formatToHour(String dateString) {
    final dateUtc = DateTime.parse(dateString).toUtc();
    final dateLocal = dateUtc.toLocal();

    final formatter = DateFormat("hh:mm a", "es_ES");
    return formatter.format(dateLocal);
  }
}
