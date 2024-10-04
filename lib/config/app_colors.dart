import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Colors.green;
  static Color secondary = Colors.greenAccent[400]!;
  static Color mainGridLineColor = Colors.orange[400]!;
  static Color contentColorCyan = Colors.cyan[400]!;
  static Color contentColorBlue = Colors.blue[400]!;

  static List<Color> gradientColors = [
    AppColors.contentColorCyan,
    AppColors.contentColorBlue,
  ];
}
