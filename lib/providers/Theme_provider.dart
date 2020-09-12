//created by Suthura


import 'package:flutter/material.dart';

class ThemeProvider with ChangeNotifier {
  bool isLightTheme;

  ThemeProvider({this.isLightTheme});

  ThemeData get getThemeData => isLightTheme ? lightTheme : darkTheme;

  set setThemeData(bool val) {
    if (val) {
      isLightTheme = true;
    } else {
      isLightTheme = false;
    }
    notifyListeners();
  }
}

final darkTheme = ThemeData(



    primaryColor: Color(0xFF000000),
    brightness: Brightness.dark,
    backgroundColor: Colors.black,
    accentColor: Colors.white,
    accentIconTheme: IconThemeData(color: Colors.white),
    dividerColor: Colors.white10,
    cardColor: Colors.black26,
    bottomAppBarColor: Colors.black12);

final lightTheme = ThemeData(
    backgroundColor: Colors.white,
    dividerColor: Colors.grey.shade300,
    accentIconTheme: IconThemeData(color: Colors.black),

    primaryColor: Colors.white,
    brightness: Brightness.light,
    accentColor: Colors.grey.shade300,
    cardColor: Colors.blueGrey.shade50,
    bottomAppBarColor: Colors.blue.shade300);
