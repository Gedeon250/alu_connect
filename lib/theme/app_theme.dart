import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ─── Colors ───────────────────────────────────────────────────────────────────
class AppColors {
  AppColors._();

  static const Color background      = Color(0xFF0D1117);
  static const Color surface         = Color(0xFF161B22);
  static const Color surfaceElevated = Color(0xFF1E2530);
  static const Color border          = Color(0xFF2D3748);
  static const Color gold            = Color(0xFFFFC107);
  static const Color textPrimary     = Color(0xFFE6EDF3);
  static const Color textSecondary   = Color(0xFF8B949E);
  static const Color textMuted       = Color(0xFF484F58);
  static const Color success         = Color(0xFF3FB950);
  static const Color error           = Color(0xFFF85149);

  // Tag background tints (used in TagChip)
  static const Color tagEvent       = Color(0xFF1F4068);
  static const Color tagOpportunity = Color(0xFF1A3A2A);
  static const Color tagCompetition = Color(0xFF3D1F1F);
}

// ─── Spacing ──────────────────────────────────────────────────────────────────
class AppSpacing {
  AppSpacing._();

  static const double xs  = 4;
  static const double sm  = 8;
  static const double md  = 16;
  static const double lg  = 24;
  static const double xl  = 32;
  static const double xxl = 48;
}

// ─── Border Radius ────────────────────────────────────────────────────────────
class AppRadius {
  AppRadius._();

  static const double sm   = 8;
  static const double md   = 12;
  static const double lg   = 16;
  static const double xl   = 24;
  static const double full = 100;
}

// ─── Text Styles (Sora font) ──────────────────────────────────────────────────
class AppTextStyles {
  AppTextStyles._();

  // 32px bold — screen titles, hero headings
  static TextStyle get displayLarge => GoogleFonts.sora(
    fontSize: 32, fontWeight: FontWeight.w700, color: AppColors.textPrimary,
  );

  // 24px bold — section headings
  static TextStyle get displayMedium => GoogleFonts.sora(
    fontSize: 24, fontWeight: FontWeight.w700, color: AppColors.textPrimary,
  );

  // 20px semibold — card titles, screen sub-headings
  static TextStyle get headingLarge => GoogleFonts.sora(
    fontSize: 20, fontWeight: FontWeight.w600, color: AppColors.textPrimary,
  );

  // 16px semibold — field labels, list item titles
  static TextStyle get headingMedium => GoogleFonts.sora(
    fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.textPrimary,
  );

  // 15px regular — body copy, descriptions
  static TextStyle get bodyLarge => GoogleFonts.sora(
    fontSize: 15, fontWeight: FontWeight.w400, color: AppColors.textPrimary,
  );

  // 13px regular — secondary/muted body copy
  static TextStyle get bodyMedium => GoogleFonts.sora(
    fontSize: 13, fontWeight: FontWeight.w400, color: AppColors.textSecondary,
  );

  // 12px medium — captions, chips, badges
  static TextStyle get labelMedium => GoogleFonts.sora(
    fontSize: 12, fontWeight: FontWeight.w500, color: AppColors.textSecondary,
  );

  // 15px semibold — button labels (background-colored text on gold buttons)
  static TextStyle get buttonText => GoogleFonts.sora(
    fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.background,
  );
}

// ─── Main Theme ───────────────────────────────────────────────────────────────
class AppTheme {
  AppTheme._();

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.background,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.gold,
        secondary: AppColors.gold,
        surface: AppColors.surface,
        error: AppColors.error,
        onPrimary: AppColors.background,
        onSecondary: AppColors.background,
        onSurface: AppColors.textPrimary,
      ),
      textTheme: GoogleFonts.soraTextTheme(ThemeData.dark().textTheme),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.background,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: AppTextStyles.headingLarge,
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.gold,
          foregroundColor: AppColors.background,
          minimumSize: const Size(double.infinity, 52),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.lg),
          ),
          textStyle: AppTextStyles.buttonText,
          elevation: 0,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.textPrimary,
          minimumSize: const Size(double.infinity, 52),
          side: const BorderSide(color: AppColors.border, width: 1.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.lg),
          ),
          textStyle: AppTextStyles.headingMedium,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surface,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.md,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: const BorderSide(color: AppColors.border, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: const BorderSide(color: AppColors.gold, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: const BorderSide(color: AppColors.error, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: const BorderSide(color: AppColors.error, width: 1.5),
        ),
        hintStyle: AppTextStyles.bodyMedium.copyWith(color: AppColors.textMuted),
        labelStyle: AppTextStyles.headingMedium,
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.surface,
        selectedItemColor: AppColors.gold,
        unselectedItemColor: AppColors.textMuted,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
      ),
      cardTheme: CardTheme(
        color: AppColors.surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.lg),
        ),
        // No margin here — each Container/Card manages its own spacing
        // to avoid the Flutter assertion 'margin.isNonNegative' crash
        // when the theme margin conflicts with constrained layouts.
        margin: EdgeInsets.zero,
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.border,
        thickness: 1,
        space: 1,
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.surfaceElevated,
        contentTextStyle: AppTextStyles.bodyLarge,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
        ),
        behavior: SnackBarBehavior.floating,
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.gold,
        foregroundColor: AppColors.background,
        elevation: 4,
      ),
    );
  }
}
