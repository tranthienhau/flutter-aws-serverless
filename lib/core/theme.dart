import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// "Modern Ethos" design system - generated in Google Stitch, ported to Flutter.
/// Corporate / refined-minimal aesthetic: vibrant lavender primary, Manrope type,
/// soft-focus shadows, rounded card architecture on a cool neutral surface.
class AppColors {
  static const primary = Color(0xFF493EE5);
  static const primaryContainer = Color(0xFF635BFF);
  static const onPrimary = Color(0xFFFFFFFF);
  static const onPrimaryContainer = Color(0xFFFEFAFF);

  static const background = Color(0xFFF8F9FA);
  static const surface = Color(0xFFF8F9FA);
  static const surfaceLowest = Color(0xFFFFFFFF);
  static const surfaceLow = Color(0xFFF3F4F5);
  static const surfaceHigh = Color(0xFFE7E8E9);
  static const surfaceHighest = Color(0xFFE1E3E4);
  static const surfaceVariant = Color(0xFFE1E3E4);

  static const onSurface = Color(0xFF191C1D);
  static const onSurfaceVariant = Color(0xFF464555);
  static const outline = Color(0xFF777587);
  static const outlineVariant = Color(0xFFC7C4D8);

  static const secondaryContainer = Color(0xFFE4E0EF);
  static const onSecondaryContainer = Color(0xFF65636F);
  static const tertiary = Color(0xFF555B63);

  static const primaryFixed = Color(0xFFE2DFFF);
  static const primaryFixedDim = Color(0xFFC3C0FF);
  static const secondaryFixed = Color(0xFFE4E0EF);
  static const tertiaryFixed = Color(0xFFDDE3EC);
  static const onPrimaryFixedVariant = Color(0xFF321ED2);
  static const onSecondaryFixedVariant = Color(0xFF474551);

  static const error = Color(0xFFBA1A1A);
  static const errorContainer = Color(0xFFFFDAD6);

  static const inverseSurface = Color(0xFF2E3132);
  static const inverseOnSurface = Color(0xFFF0F1F2);
}

/// Soft-focus ambient shadow with a primary tint (per the design system).
const kSoftShadow = [
  BoxShadow(color: Color(0x14635BFF), blurRadius: 24, offset: Offset(0, 8)),
];

TextStyle _m(double size, FontWeight w, {double? height, double? spacing, Color? color}) =>
    GoogleFonts.manrope(
      fontSize: size,
      fontWeight: w,
      height: height == null ? null : height / size,
      letterSpacing: spacing,
      color: color ?? AppColors.onSurface,
    );

class AppText {
  static TextStyle get headlineLg => _m(32, FontWeight.w700, height: 40, spacing: -0.6);
  static TextStyle get headlineLgMobile => _m(24, FontWeight.w700, height: 32, spacing: -0.24);
  static TextStyle get headlineMd => _m(20, FontWeight.w600, height: 28);
  static TextStyle get bodyLg => _m(16, FontWeight.w400, height: 24);
  static TextStyle get bodyLgBold => _m(16, FontWeight.w700, height: 24);
  static TextStyle get bodySm => _m(14, FontWeight.w400, height: 20, color: AppColors.onSurfaceVariant);
  static TextStyle labelCaps({Color? color}) => GoogleFonts.hankenGrotesk(
        fontSize: 12,
        fontWeight: FontWeight.w700,
        height: 16 / 12,
        letterSpacing: 0.6,
        color: color ?? AppColors.onSurfaceVariant,
      );
  static TextStyle labelSm({Color? color}) => GoogleFonts.hankenGrotesk(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        height: 16 / 12,
        color: color ?? AppColors.onSurfaceVariant,
      );
}

ThemeData buildAppTheme() {
  final scheme = const ColorScheme.light(
    primary: AppColors.primary,
    onPrimary: AppColors.onPrimary,
    primaryContainer: AppColors.primaryContainer,
    onPrimaryContainer: AppColors.onPrimaryContainer,
    secondaryContainer: AppColors.secondaryContainer,
    onSecondaryContainer: AppColors.onSecondaryContainer,
    surface: AppColors.surface,
    onSurface: AppColors.onSurface,
    error: AppColors.error,
  );
  return ThemeData(
    useMaterial3: true,
    colorScheme: scheme,
    scaffoldBackgroundColor: AppColors.background,
    textTheme: GoogleFonts.manropeTextTheme(),
    splashColor: AppColors.primary.withOpacity(0.06),
    highlightColor: Colors.transparent,
  );
}
