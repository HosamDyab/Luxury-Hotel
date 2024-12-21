import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Colors
  static const Color primaryGold = Color.fromARGB(225, 217, 163, 27);
  static const Color secondaryGold = Color(0xFFCFB53B);
  static const Color darkBlack = Color(0xFF1A1A1A);
  static const Color softBlack = Color(0xFF2A2A2A);
  static const Color white = Color(0xFFFFFFFF);
  static const Color grey = Color(0xFF9E9E9E);
  static const Color lightGrey = Color(0xFFF5F5F5);
  static const Color error = Color(0xFFD32F2F);
  static const Color success = Color(0xFF388E3C);

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primaryGold, secondaryGold],
  );

  static ThemeData get theme => ThemeData(
        useMaterial3: true,
        colorScheme: const ColorScheme.light(
          primary: primaryGold,
          secondary: secondaryGold,
          surface: white,
          error: error,
          onPrimary: white,
          onSecondary: darkBlack,
          onSurface: darkBlack,
          onError: white,
          brightness: Brightness.light,
        ),
        textTheme: GoogleFonts.poppinsTextTheme().copyWith(
          displayLarge: const TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: darkBlack,
          ),
          displayMedium: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w600,
            color: darkBlack,
          ),
          displaySmall: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: darkBlack,
          ),
          headlineMedium: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: darkBlack,
          ),
          titleLarge: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: darkBlack,
          ),
          titleMedium: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: darkBlack,
          ),
          bodyLarge: const TextStyle(
            fontSize: 16,
            color: darkBlack,
          ),
          bodyMedium: const TextStyle(
            fontSize: 14,
            color: darkBlack,
          ),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: white,
          elevation: 0,
          centerTitle: true,
          iconTheme: IconThemeData(color: darkBlack),
          titleTextStyle: TextStyle(
            color: darkBlack,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        scaffoldBackgroundColor: white,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryGold,
            foregroundColor: white,
            elevation: 0,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            textStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: primaryGold,
            side: const BorderSide(color: primaryGold),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            textStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: primaryGold,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            textStyle: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: lightGrey,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: primaryGold),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: error),
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          hintStyle: const TextStyle(color: grey),
        ),
        cardTheme: CardTheme(
          color: white,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          shadowColor: darkBlack.withOpacity(0.1),
        ),
        chipTheme: ChipThemeData(
          backgroundColor: lightGrey,
          labelStyle: const TextStyle(color: darkBlack),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: white,
          selectedItemColor: primaryGold,
          unselectedItemColor: grey,
          type: BottomNavigationBarType.fixed,
          elevation: 8,
        ),
        bottomSheetTheme: const BottomSheetThemeData(
          backgroundColor: white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
        ),
        dividerTheme: DividerThemeData(
          color: grey.withOpacity(0.2),
          thickness: 1,
          space: 1,
        ),
        snackBarTheme: SnackBarThemeData(
          backgroundColor: darkBlack,
          contentTextStyle: const TextStyle(color: white),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          behavior: SnackBarBehavior.floating,
        ),
      );

  static ThemeData get darkTheme => theme.copyWith(
        colorScheme: const ColorScheme.dark(
          primary: primaryGold,
          secondary: secondaryGold,
          surface: darkBlack,
          error: error,
          onPrimary: darkBlack,
          onSecondary: white,
          onSurface: white,
          onError: white,
          brightness: Brightness.dark,
        ),
        scaffoldBackgroundColor: darkBlack,
        appBarTheme: const AppBarTheme(
          backgroundColor: darkBlack,
          iconTheme: IconThemeData(color: white),
          titleTextStyle: TextStyle(
            color: white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        textTheme: theme.textTheme.apply(
          bodyColor: white,
          displayColor: white,
        ),
        cardTheme: theme.cardTheme.copyWith(
          color: softBlack,
        ),
        bottomNavigationBarTheme: theme.bottomNavigationBarTheme.copyWith(
          backgroundColor: softBlack,
        ),
        bottomSheetTheme: theme.bottomSheetTheme.copyWith(
          backgroundColor: softBlack,
        ),
        inputDecorationTheme: theme.inputDecorationTheme.copyWith(
          fillColor: softBlack,
          hintStyle: const TextStyle(color: grey),
        ),
      );
}
