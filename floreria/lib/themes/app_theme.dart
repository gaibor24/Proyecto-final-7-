import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../colors/app_colors.dart';

class AppTheme {
  static const double _radius = 12;
  static const double _elevation = 3;
  static const double _iconSize = 20;

  static ThemeData get light => AppTheme._baseTheme(
    brightness: Brightness.light,
    primaryColor: AppColors.primary,
    scaffoldColor: Colors.white,
    cardColor: AppColors.card,
    shadowColor: Colors.black12,
    textColor: Colors.black,
    iconColor: Colors.black87,
  );

  static ThemeData get dark => AppTheme._baseTheme(
    brightness: Brightness.dark,
    primaryColor: AppColors.primary,
    scaffoldColor: Colors.black,
    cardColor: AppColors.card,
    shadowColor: Colors.black45,
    textColor: Colors.white,
    iconColor: Colors.white70,
  );

  static ThemeData _baseTheme({
    required Brightness brightness,
    required Color primaryColor,
    required Color scaffoldColor,
    required Color cardColor,
    required Color shadowColor,
    required Color textColor,
    required Color iconColor,
  }) {
    return ThemeData(
      brightness: brightness,
      primaryColor: primaryColor,
      scaffoldBackgroundColor: scaffoldColor,
      cardColor: cardColor,
      shadowColor: shadowColor,

      appBarTheme: AppBarTheme(
        backgroundColor: scaffoldColor,
        elevation: _elevation,
        shadowColor: shadowColor,
        centerTitle: true,
        iconTheme: IconThemeData(color: iconColor, size: _iconSize),
        actionsIconTheme: IconThemeData(color: iconColor, size: _iconSize),
        surfaceTintColor: scaffoldColor,
        titleTextStyle: GoogleFonts.nunito(
          color: textColor,
          fontWeight: FontWeight.w800,
          fontSize: 17,
        ),
      ),

      drawerTheme: DrawerThemeData(
        backgroundColor: scaffoldColor,
        elevation: _elevation,
        surfaceTintColor: scaffoldColor,
        shadowColor: shadowColor,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.horizontal(
            right: Radius.circular(_radius),
          ),
        ),
      ),

      snackBarTheme: SnackBarThemeData(
        backgroundColor: scaffoldColor,
        behavior: SnackBarBehavior.floating,
        elevation: _elevation,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(_radius),
        ),
      ),

      progressIndicatorTheme: ProgressIndicatorThemeData(color: primaryColor),

      dialogTheme: DialogThemeData(
        backgroundColor: scaffoldColor,
        surfaceTintColor: scaffoldColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(_radius),
        ),
        shadowColor: shadowColor,
      ),

      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: scaffoldColor,
        clipBehavior: Clip.antiAlias,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(_radius)),
        ),
        elevation: _elevation,
        shadowColor: shadowColor,
        surfaceTintColor: scaffoldColor,
        modalBackgroundColor: scaffoldColor,
      ),

      textTheme: TextTheme(
        labelMedium: GoogleFonts.nunito(
          color: textColor,
          fontWeight: FontWeight.w500,
          fontSize: 14,
        ),
        titleLarge: GoogleFonts.nunito(
          color: textColor,
          fontWeight: FontWeight.w800,
          fontSize: 30,
        ),
        titleMedium: GoogleFonts.nunito(
          color: textColor,
          fontWeight: FontWeight.bold,
          fontSize: 22,
        ),
        titleSmall: GoogleFonts.nunito(
          color: textColor,
          fontWeight: FontWeight.w500,
          fontSize: 18,
        ),
        bodyLarge: GoogleFonts.nunito(
          color: textColor,
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
        bodyMedium: GoogleFonts.nunito(
          color: textColor,
          fontWeight: FontWeight.w600,
          fontSize: 14,
        ),
        bodySmall: GoogleFonts.nunito(
          color: textColor,
          fontWeight: FontWeight.w500,
          fontSize: 12,
        ),
      ),

      popupMenuTheme: PopupMenuThemeData(
        iconSize: _iconSize,
        iconColor: iconColor,
        color: scaffoldColor,
        elevation: _elevation,
        shadowColor: shadowColor,
        surfaceTintColor: scaffoldColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(_radius),
        ),
        textStyle: GoogleFonts.nunito(
          color: textColor,
          fontWeight: FontWeight.w600,
          fontSize: 14,
        ),
      ),

      iconTheme: IconThemeData(color: iconColor, size: _iconSize),

      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: scaffoldColor,
        elevation: _elevation,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: primaryColor,
        unselectedItemColor: Colors.grey,
        selectedIconTheme: IconThemeData(color: primaryColor, size: _iconSize),
        unselectedIconTheme: IconThemeData(
          color: Colors.grey,
          size: _iconSize * 0.9,
        ),
        selectedLabelStyle: GoogleFonts.nunito(
          color: primaryColor,
          fontWeight: FontWeight.w600,
          fontSize: 14,
        ),
        unselectedLabelStyle: GoogleFonts.nunito(
          color: Colors.grey,
          fontWeight: FontWeight.w400,
          fontSize: 12,
        ),
      ),
    );
  }
}
