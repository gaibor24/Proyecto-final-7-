// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

class AppColors {
  static Color hexToColor(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  static Color primary = hexToColor('4CAF50');
  static Color card = const Color(0xFFD6E4EF);
  static Color grey = hexToColor('9A9A9A');
  static Color grisBorder = const Color(0xFFD8D8D8);
  static Color grisSuave = hexToColor('E5E5E5').withOpacity(0.3);
}
