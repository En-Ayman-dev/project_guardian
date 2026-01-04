// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Brand Colors
  static const Color primaryColor = Color(0xFF1A73E8); // Professional Blue
  static const Color secondaryColor = Color(0xFF34A853); // Growth Green (Accounting)
  static const Color errorColor = Color(0xFFD32F2F);
  static const Color scaffoldBackground = Color(0xFFF5F7FA); // Light Grey for reduced eye strain

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        primary: primaryColor,
        secondary: secondaryColor,
        error: errorColor,
        background: scaffoldBackground,
        surface: Colors.white,
      ),
      scaffoldBackgroundColor: scaffoldBackground,
      
      // Text Theme
      textTheme: GoogleFonts.cairoTextTheme().copyWith(
        displayLarge: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black87),
        bodyLarge: const TextStyle(fontSize: 16, color: Colors.black87),
        bodyMedium: const TextStyle(fontSize: 14, color: Colors.black54),
      ),

      // Input Decoration (Text Fields)
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.grey, width: 0.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: primaryColor, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),

      // Button Theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 50),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}