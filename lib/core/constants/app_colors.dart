import 'package:flutter/material.dart';

class AppColors {
  // Primary Palette (Medical Teal & Ocean Blue)
  static const Color primary = Color(0xFF0F766E); // Deep Teal
  static const Color primaryLight = Color(0xFF14B8A6); // Mint Teal
  static const Color primaryDark = Color(0xFF115E59);
  
  static const Color secondary = Color(0xFF0284C7); // Sky Blue
  static const Color secondaryLight = Color(0xFF38BDF8);
  static const Color accent = Color(0xFF6366F1); // Indigo Accent

  // Status & Diagnosis Colors
  static const Color success = Color(0xFF10B981); // Emerald Green (Normal)
  static const Color warning = Color(0xFFF59E0B); // Amber (Anomali / Ringan)
  static const Color error = Color(0xFFEF4444); // Coral Red (Defisiensi Berat)
  static const Color info = Color(0xFF3B82F6); // Blue

  // Ishihara Simulation Specific Colors
  static const Color protanColor = Color(0xFFDC2626); // Red Deficiency
  static const Color deutanColor = Color(0xFF16A34A); // Green Deficiency
  static const Color tritanColor = Color(0xFF2563EB); // Blue Deficiency
  static const Color monoColor = Color(0xFF64748B); // Total Deficiency

  // Neutral Backgrounds & Surfaces (Light)
  static const Color bgLight = Color(0xFFF8FAFC);
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color cardLight = Color(0xFFFFFFFF);
  static const Color textPrimaryLight = Color(0xFF0F172A);
  static const Color textSecondaryLight = Color(0xFF64748B);
  static const Color borderLight = Color(0xFFE2E8F0);

  // Neutral Backgrounds & Surfaces (Dark)
  static const Color bgDark = Color(0xFF090D16);
  static const Color surfaceDark = Color(0xFF111827);
  static const Color cardDark = Color(0xFF1E293B);
  static const Color textPrimaryDark = Color(0xFFF8FAFC);
  static const Color textSecondaryDark = Color(0xFF94A3B8);
  static const Color borderDark = Color(0xFF334155);
}
