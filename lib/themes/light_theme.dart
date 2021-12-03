import 'package:flutter/material.dart';

ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  scaffoldBackgroundColor: Colors.white,
  primaryColor: Colors.white,
  backgroundColor: Colors.white,
  iconTheme: IconThemeData(color: Colors.black),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    backgroundColor: Colors.white,
    unselectedItemColor: Colors.black,
    selectedItemColor: Colors.black,
    elevation: 0,
  ),
  bottomSheetTheme: BottomSheetThemeData(backgroundColor: Colors.black12),
  highlightColor: Colors.transparent,
  splashColor: Colors.black12,
  appBarTheme: AppBarTheme(
    color: Colors.white,
    elevation: 0,
    iconTheme: IconThemeData(color: Colors.black),
    toolbarTextStyle: TextTheme(
      headline6: TextStyle(
        color: Colors.black,
        fontSize: 20,
      ),
    ).bodyText2,
    titleTextStyle: TextTheme(
      headline6: TextStyle(
        color: Colors.black,
        fontSize: 20,
      ),
    ).headline6,
  ),
);
