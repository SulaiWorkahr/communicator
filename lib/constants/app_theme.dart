import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_fonts.dart';

class AppTheme {
  // static final ThemeData lightTheme = ThemeData(
  //   brightness: Brightness.light,
  //   primaryColor: AppColors.primary,
  //   accentColor: AppColors.secondary,
  //   backgroundColor: AppColors.background,
  //   errorColor: AppColors.danger,
  //   textTheme: TextTheme(
  //     headline1: AppFonts.headline1,
  //     headline2: AppFonts.headline2,
  //     bodyText1: AppFonts.body,
  //     bodyText2: AppFonts.body,
  //   ),
  // );

  static final ThemeData lightTheme = ThemeData(
      // fontFamily: 'Poppins',
      brightness: Brightness.light,
      primaryColor: AppColors.primary,
      colorScheme: AppColors.myColorScheme,
      inputDecorationTheme: const InputDecorationTheme(
        prefixStyle: TextStyle(
            color: AppColors.primary), // Set the global icon color here
      ),
      scaffoldBackgroundColor: AppColors.light,
      appBarTheme: AppBarTheme(
        foregroundColor:
            AppColors.dark, // Set your desired foregroundColor globally
      ),
      //  textButtonTheme: TextButtonThemeData(
      //       style: TextButton.styleFrom(
      //         foregroundColor:AppColors.light, // Set text color to white
      //       ),
      //     ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          // backgroundColor: MaterialStateProperty.all<Color>(Colors.black,), //button color
          foregroundColor: MaterialStateProperty.all<Color>(
            AppColors.light,
          ), //text (and icon)
        ),
      ),
      cardTheme: CardTheme(
        surfaceTintColor: AppColors.light,
        color: AppColors.light,
      ),
      // dialogBackgroundColor: AppColors.light,
      dialogTheme: DialogTheme(
        surfaceTintColor: AppColors.light),
      popupMenuTheme: PopupMenuThemeData(
        surfaceTintColor: AppColors.light
        
        )
      // other properties
      );

  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: AppColors.light,

    // other properties
  );
}
