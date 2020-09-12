//created by Suthura


import 'package:flutter/foundation.dart';

class AppBarProvider with ChangeNotifier {
  int index = 0;

  int getIndex() => index;

  void setIndex(int value) {
    index = value;
    notifyListeners();
  }
}
