import 'package:flutter/material.dart';

/// Centralized color/gradient choices per page to keep UI lively
class AppPalette {
  // Home (existing)
  static const List<Color> homeGradient = [
    Color(0xFF667EEA), // indigo
    Color(0xFF764BA2), // purple
  ];

  // Eksepsi (form + header)
  static const List<Color> eksepsiGradient = [
    Color(0xFF06B6D4), // cyan-500
    Color(0xFF3B82F6), // blue-500
  ];

  // Semua Data Cuti
  static const List<Color> cutiAllGradient = [
    Color(0xFF4FACFE), // light blue
    Color(0xFF00D2FF), // cyan
  ];

  // Semua Data Eksepsi
  static const List<Color> eksepsiAllGradient = [
    Color(0xFFA78BFA), // violet-400
    Color(0xFF6366F1), // indigo-500
  ];

  // Data Insentif
  static const List<Color> insentifGradient = [
    Color(0xFF22C55E), // green-500
    Color(0xFF16A34A), // green-600
  ];

  // Update Checker
  static const List<Color> updateGradient = [
    Color(0xFFF6AD55), // orange-400
    Color(0xFFED8936), // orange-500
  ];
}
