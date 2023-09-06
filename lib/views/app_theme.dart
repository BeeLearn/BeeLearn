import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const Map<int, Color> emerald = {
    200: Color(0xFFa7f3d0),
    300: Color(0xFF6ee7b7),
    400: Color(0xFF34d399),
    500: Color(0xFF10b981),
  };
  static final ThemeData light = ThemeData.light(useMaterial3: true).copyWith(
    textTheme: GoogleFonts.latoTextTheme(),
  );
  static final ThemeData dark = ThemeData.dark(useMaterial3: true).copyWith(
    textTheme: GoogleFonts.latoTextTheme(
      ThemeData.dark(useMaterial3: true).textTheme,
    ),
  );
}
