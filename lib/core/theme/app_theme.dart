import 'package:flutter/material.dart';

import '../core.dart';

ThemeData appTheme = ThemeData(
    useMaterial3: false,
    fontFamily: 'Almarai',
    appBarTheme: const AppBarTheme(
      iconTheme: IconThemeData(color: primaryColor),
      color: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: TextStyle(
          color: Color.fromRGBO(0, 0, 0, 1),
          fontSize: 20,
          fontWeight: FontWeight.bold,
          fontFamily: 'Almarai'),
    ),
    colorScheme: ThemeData.light()
        .colorScheme
        .copyWith(primary: primaryColor, secondary: secondryColor),
    //scaffoldBackgroundColor: Colors.white,
    radioTheme: RadioThemeData(
        fillColor: MaterialStateProperty.all<Color>(primaryColor)),
    floatingActionButtonTheme:
        const FloatingActionButtonThemeData(backgroundColor: primaryColor),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        fixedSize: const Size(500, 50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        backgroundColor: primaryColor,
        elevation: 0,
        textStyle: ThemeData.light().textTheme.titleMedium!.copyWith(
            fontFamily: 'Almarai', fontWeight: FontWeight.bold, fontSize: 18),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        fixedSize: const Size(500, 50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        elevation: 0,
        textStyle: ThemeData.light().textTheme.titleMedium!.copyWith(
            fontFamily: 'Almarai', fontWeight: FontWeight.bold, fontSize: 18),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
      contentPadding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      fillColor: Colors.white,
      filled: true,
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: primaryColor),
      ),
      border: OutlineInputBorder(
        borderSide: const BorderSide(color: primaryColor),
        borderRadius: BorderRadius.circular(10),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: primaryColor),
        borderRadius: BorderRadius.circular(10),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.red),
        borderRadius: BorderRadius.circular(10),
      ),
    ),
    tabBarTheme: const TabBarTheme(
      labelStyle: TextStyle(fontFamily: 'Almarai', fontWeight: FontWeight.bold),
      labelColor: Colors.black,
    ));
