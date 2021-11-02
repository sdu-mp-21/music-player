import 'package:flutter/material.dart';

ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  scaffoldBackgroundColor: Colors.black,
  backgroundColor: Colors.black,
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    backgroundColor: Colors.white12,
    unselectedItemColor: Colors.white,
    selectedItemColor: Colors.white,
    elevation: 0,
  ),
  highlightColor: Colors.transparent,
  splashColor: Colors.white12,
  bottomSheetTheme: BottomSheetThemeData(backgroundColor: Colors.white12),
  appBarTheme: AppBarTheme(
    color: Colors.black,
    elevation: 0,
    toolbarTextStyle: TextTheme(
      headline6: TextStyle(
        color: Colors.white,
        fontSize: 20,
      ),
    ).bodyText2,
    titleTextStyle: TextTheme(
      headline6: TextStyle(
        color: Colors.white,
        fontSize: 20,
      ),
    ).headline6,
  ),
);
