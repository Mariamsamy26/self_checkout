import 'package:flutter/material.dart';

// Brand Primary Colors (BluBite Tech & Retail Identity)
const Color bluBiteBlue = Color(0xFF0066FF); // Electric Royal Blue
const Color bluBiteDark = Color(0xFF071B3E); // Deep Midnight Blue
const Color bluBiteNavy = Color(0xFF0B2556);
const Color bluBiteLight = Color(0xFFEBF3FF); // Soft Tint
const Color bluBiteCyan = Color(0xFF00C2FF); // Bright Accent Cyan

// Accent & Status Colors
const Color emeraldGreen = Color(0xFF10B981);
const Color emeraldGreenLight = Color(0xFFECFDF5);
const Color coralOrange = Color(0xFFFF6A00);
const Color coralOrangeLight = Color(0xFFFFF7ED);
const Color dangerRed = Color(0xFFEF4444);
const Color dangerRedLight = Color(0xFFFEF2F2);
const Color amberWarning = Color(0xFFF59E0B);
const Color amberWarningLight = Color(0xFFFEF3C7);

// Surfaces & Backgrounds
const Color backgroundLight = Color(0xFFF8FAFD);
const Color cardSurface = Colors.white;
const Color surfaceMuted = Color(0xFFF1F5F9);
const Color borderSubtle = Color(0xFFE2E8F0);
const Color borderStrong = Color(0xFFCBD5E1);

// Typography Colors
const Color textDark = Color(0xFF0A192F);
const Color textMedium = Color(0xFF475569);
const Color textMuted = Color(0xFF94A3B8);

// Backward Compatibility Aliases
const Color goSmartBlue = bluBiteBlue;
const Color goSmartBlueDark = bluBiteNavy;
const Color goSmartBlueLight = bluBiteLight;
const Color goSmartCyan = bluBiteCyan;
const Color black = textDark;
const Color white = Colors.white;
const Color lightOrange = coralOrangeLight;
const Color textGrey = textMedium;
const Color bgColor = backgroundLight;
const Color bgDarkGrey = Color(0xFF334155);
const Color greyBorder = borderSubtle;
const Color redOrange = coralOrange;
const Color red = dangerRed;

// Premium Gradients
const LinearGradient bluBiteGradient = LinearGradient(
  colors: [Color(0xFF0052CC), Color(0xFF007BFF), Color(0xFF00C2FF)],
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
);

const LinearGradient goSmartGradient = bluBiteGradient;

const LinearGradient bluBiteDarkGradient = LinearGradient(
  colors: [Color(0xFF071B3E), Color(0xFF0E2E69)],
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
);

const LinearGradient goSmartDarkGradient = bluBiteDarkGradient;

const LinearGradient successGradient = LinearGradient(
  colors: [Color(0xFF10B981), Color(0xFF059669)],
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
);

const LinearGradient dangerGradient = LinearGradient(
  colors: [Color(0xFFEF4444), Color(0xFFDC2626)],
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
);

const LinearGradient amberGradient = LinearGradient(
  colors: [Color(0xFFF59E0B), Color(0xFFD97706)],
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
);
