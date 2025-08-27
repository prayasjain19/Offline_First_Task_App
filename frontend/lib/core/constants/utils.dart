import 'package:flutter/material.dart';

Color strengthenColor(Color color, double factor) {
  int r = (color.red * factor).clamp(0, 255).toInt();
  int g = (color.green * factor).clamp(0, 255).toInt();
  int b = (color.blue * factor).clamp(0, 255).toInt();

  return Color.fromARGB(color.alpha, r, g, b);
}

List<DateTime> generateWeekDates(int weekOffset) {
  final today = DateTime.now();
  // 1. Find the Monday of the current week
  DateTime startOffWeek = today.subtract(Duration(days: today.weekday - 1));
  // 2. Adjust based on weekOffset (past/future weeks)
  startOffWeek = startOffWeek.add(Duration(days: weekOffset * 7));

    // 3. Generate 7 dates from that Monday to Sunday
  return List.generate(7, (index) => startOffWeek.add(Duration(days: index)));
}


//Convert a color to hex color

String rgbToHex(Color color) {
  return '${color.red.toRadixString(16).padLeft(2, '0')}${color.green.toRadixString(16).padLeft(2, '0')}${color.blue.toRadixString(16).padLeft(2, '0')}';
}

Color hexToRgb(String hex) {
  return Color(int.parse(hex, radix: 16) + 0xFF000000);
}