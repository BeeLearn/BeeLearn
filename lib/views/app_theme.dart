import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static final ThemeData light = ThemeData.light(useMaterial3: true).copyWith(
    textTheme: GoogleFonts.albertSansTextTheme(),
  );
  static final ThemeData dark = ThemeData.dark(useMaterial3: true).copyWith(
    textTheme: GoogleFonts.albertSansTextTheme(
      ThemeData.dark(useMaterial3: true).textTheme,
    ),
  );
}
