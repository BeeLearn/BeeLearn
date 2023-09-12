import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'components/answer_code_drag_target.dart';

class AppTheme {
  static const Map<int, Color> emerald = {
    200: Color(0xFFa7f3d0),
    300: Color(0xFF6ee7b7),
    400: Color(0xFF34d399),
    500: Color(0xFF10b981),
  };

  static Color? getValidationColor(ValidationState state) {
    switch (state) {
      case ValidationState.success:
        return Colors.greenAccent;
      case ValidationState.error:
        return Colors.redAccent;
      default:
        return null;
    }
  }

  static final ThemeData light = ThemeData.light(useMaterial3: true).copyWith(
    textTheme: GoogleFonts.albertSansTextTheme(),
  );
  static final ThemeData dark = ThemeData.dark(useMaterial3: true).copyWith(
    textTheme: GoogleFonts.albertSansTextTheme(
      ThemeData.dark(useMaterial3: true).textTheme,
    ),
  );
}
