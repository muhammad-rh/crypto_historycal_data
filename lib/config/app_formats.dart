import 'package:code_challenge/config/app_colors.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

class AppFormats {
  static DateFormat hourFormat = DateFormat('hh:mm:ss');
  static DateFormat minuteFormat = DateFormat('mm:ss');

  static DateTime msFormat({required int ms}) {
    return DateTime.fromMillisecondsSinceEpoch(ms);
  }

  static String commaFormat(String value) {
    return NumberFormat("#,##0.00").format(double.parse(value));
  }

  static String addStrings(String value1, String value2) {
    double number1 = double.parse(value1);
    double number2 = double.parse(value2);

    double result = number1 + number2;

    return result.toString();
  }

  static Color upDownColorFormat(String value) {
    switch (isNeg(value)) {
      case true:
        return AppColors.red;
      default:
        return AppColors.green;
    }
  }

  static String addPlusSign(String value) {
    switch (isNeg(value)) {
      case true:
        return value;
      default:
        return '+$value';
    }
  }

  static bool isNeg(String value) {
    if (value[0] == '-') {
      return true;
    } else {
      return false;
    }
  }
}
