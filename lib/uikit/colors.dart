import 'dart:ui';

/// The color palette used in the app.
/// Has all colors from the Figma design
abstract class ColorPalette {
  // -----------------------------
  // Figma design light theme
  // -----------------------------

  // Figma light theme first row colors
  static const Color lightLabelPrimary = Color(0xFF000000);
  static const Color lightLabelSecondary = Color(0x99000000);
  static const Color lightLabelTertiary = Color(0x4D000000);
  static const Color lightLabelDisable = Color(0x26000000);

  // Figma light theme second row colors
  static const Color lightColorRed = Color(0xFFFF3B30);
  static const Color lightColorGreen = Color(0xFF34C759);
  static const Color lightColorBlue = Color(0xFF007AFF);
  static const Color lightColorGray = Color(0xFF8E8E93);
  static const Color lightColorGrayLight = Color(0xFFD1D1D6);
  static const Color lightColorWhite = Color(0xFFFFFFFF);

  // Figma light theme third row colors
  static const Color ligthBackPrimary = Color(0xFFF7F6F2);
  static const Color lightBackSecondary = Color(0xFFFFFFFF);
  static const Color lightSupportSeparator = Color(0x33000000);
  static const Color lightSupportOverlay = Color(0x0F000000);
  static const Color lightBackElevated = Color(0xFFFFFFFF);

  // -----------------------------
  // Figma design dark theme
  // -----------------------------

  // Figma dark theme first row colors
  static const Color darkSupportSeparator = Color(0x33FFFFFF);
  static const Color darkSupportOverlay = Color(0x52000000);

  // Figma dark theme second row colors
  static const Color darkLabelPrimary = Color(0xFFFFFFFF);
  static const Color darkLabelSecondary = Color(0x99FFFFFF);
  static const Color darkLabelTertiary = Color(0x66FFFFFF);
  static const Color darkLabelDisable = Color(0x26FFFFFF);

  // Figma dark theme third row colors
  static const Color darkColorRed = Color(0xFFFF453A);
  static const Color darkColorGreen = Color(0xFF32D74B);
  static const Color darkColorBlue = Color(0xFF0A84FF);
  static const Color darkColorGray = Color(0xFF8E8E93);
  static const Color darkColorGrayLight = Color(0xAA48484A);
  static const Color darkColorWhite = Color(0xFFFFFFFF);

  // Figma dark theme fourth row colors
  static const Color darkBackPrimary = Color(0xFF161618);
  static const Color darkBackSecondary = Color(0xFF252528);
  static const Color darkBackElevated = Color(0xFF3C3C3F);
}
