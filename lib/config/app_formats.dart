import 'package:intl/intl.dart';

class AppFormats {
  static DateFormat hourFormat = DateFormat('hh:mm:ss');

  static DateTime msFormat({required int ms}) {
    return DateTime.fromMillisecondsSinceEpoch(ms);
  }

  static String commaFormat(String value) {
    return NumberFormat("#,##0.00").format(double.parse(value));
  }
}
