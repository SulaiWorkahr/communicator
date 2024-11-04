import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/base_controller.dart';

class AppColors {
  bool darkTheme = false;

  BaseController baseCtrl = Get.put(BaseController());
  // _MyAppState() {
  //   print('baseCtrl ${baseCtrl.isDarkModeEnabled.value}');
  //   baseCtrl.isDarkModeEnabled.listen((value) {
  //     refresh();
  //   });
  // }
  AppColors() {
    // print('darkTheme $darkTheme');
    baseCtrl.isDarkModeEnabled.listen((value) {
      changeColors();
    });
  }

  changeColors() {
    if (darkTheme == true) {
      dark = Colors.white;
    } else {
      dark = Colors.black;
    }
  }

  static const Color lightBlue = Color(0xFF1353CE);
  static const Color darkBlue = Color(0xFF03477E);
  static const Color shadowBlue = Color(0xFFA4BFF2);

  static const Color primary = Color(0xFF003988);
  static const Color primaryLight = Color(0xFF1353CE);
  static const Color primaryDark = Color(0xFF003988);

  static const Color secondary = Color(0xFFFFA726);
  static const Color secondaryLight = Color(0xFFFFF263);
  static const Color secondaryDark = Color(0xFFFF6F00);

  static const Color warning = Color(0xFFFFA726);
  static const Color warningDark = Color(0xFF9A6B00);

  static const Color danger = Color(0xFFFF5252);
  static const Color success = Color(0xFF4CAF50);
  static const Color successDark = Color(0xFF007645);
  static const Color info = Color(0xFF2196F3);
  static const Color background = Color(0xFFEFEFEF);
  static const Color light = Colors.white;

  static const Color grey = Color(0xFF9E9E9E);
  static const Color grey1 = Color(0xFF808181);
  static const Color lightGrey = Color(0xFFF6F6F6);
  static const Color lightGrey2 = Color(0xFFEFEFEF);
  static const Color borderGrey = Color(0xFFC2C2C2);
  static const Color lightGrey11 = Color(0xFFEAEAEA);
  static const Color iconBlue = Color(0xFF788EB7);
  static const Color lightBlack = Color(0xFF58585B);

   static const Color lightBlue1 = Color(0xFFE5F3F9);
   static const Color darkBlue1 = Color(0xFF1968F8);

   static const Color darkBlue2 = Color(0xFF002250);
   static const Color shadowBlue1 = Color(0xFF8AB4FF);

   static const Color darkBlue3 = Color(0xFF022B57);

   static const Color lightGreen = Color(0xFF8DE885);

   static const Color shadowGrey = Color(0xFFB4C0CD);
   static const Color darkGrey = Color(0xFF696A6A);
   static const Color darkRed = Color(0xFFFC0005);
   static const Color green = Color(0xFF34CD27);

   static const Color lightRed = Color(0xFFFF8989);








   



   

 


  static Color dark = Colors.black;
  static const Color pink = Colors.pink;

  static ColorScheme myColorScheme = ColorScheme(
    primary: primary,
    // primary: const Color(0x0005233b),
    secondary: primaryLight,
    surface: light,
    background: light,
    // background: Colors.grey.shade200,
    // outline: Colors.grey.shade400,
    error: Colors.red,
    onPrimary: const Color(0x0005233b),
    onSecondary: light,
    onSurface: Colors.black,
    onBackground: Colors.black,
    onError: light,
    brightness: Brightness.light,

    // surfaceTint: Color(0xff6A707C) // grey,
    // surfaceTint: colorCodeToVal('B2B2B2') // grey,
  );
}

// import 'package:flutter/material.dart';

// class AppColors {
//   static final ColorScheme lightColorScheme = const ColorScheme.light(
//     primary: Color(0xFF336699),
//     primaryVariant: Color(0xFF0D47A1),
//     secondary: Color(0xFFFFA726),
//     secondaryVariant: Color(0xFFFF6F00),
//     surface: Colors.white,
//     background: Color(0xFFEFEFEF),
//     error: Color(0xFFFF5252),
//     onPrimary: Colors.white,
//     onSecondary: Colors.black,
//     onSurface: Colors.black,
//     onBackground: Colors.black,
//     onError: Colors.white,
//     brightness: Brightness.light,
//   );

//   static final ColorScheme darkColorScheme = ColorScheme.dark(
//     primary: Color(0xFF336699),
//     primaryVariant: Color(0xFF0D47A1),
//     secondary: Color(0xFFFFA726),
//     secondaryVariant: Color(0xFFFF6F00),
//     surface: Color(0xFF1E1E1E),
//     background: Color(0xFF121212),
//     error: Color(0xFFFF5252),
//     onPrimary: Colors.white,
//     onSecondary: Colors.black,
//     onSurface: Colors.white,
//     onBackground: Colors.white,
//     onError: Colors.white,
//     brightness: Brightness.dark,
//   );

//   static final ThemeData lightTheme = ThemeData.from(
//     colorScheme: lightColorScheme,
//     textTheme: TextTheme(
//       headline6: TextStyle(color: Colors.black),
//       bodyText2: TextStyle(color: Colors.black),
//     ),
//     // define other theme properties
//   );

//   static final ThemeData darkTheme = ThemeData.from(
//     colorScheme: darkColorScheme,
//     textTheme: TextTheme(
//       headline6: TextStyle(color: Colors.white),
//       bodyText2: TextStyle(color: Colors.white),
//     ),
//     // define other theme properties
//   );
// }
