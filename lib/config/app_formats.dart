import 'package:intl/intl.dart';

class AppFormats {
  static DateFormat hourFormat = DateFormat('hh:mm:ss a');

  static DateTime msFormat({required int ms}) {
    return DateTime.fromMillisecondsSinceEpoch(ms);
  }
}
