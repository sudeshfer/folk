import 'package:flutter/foundation.dart';

class DateProvider with ChangeNotifier{

  String _dateText = '00:00:00';
  String _playerText = '00:00:00';


  String get playerText => _playerText;

  set playerText(String value) {
    _playerText = value;
    notifyListeners();
  }

  String get dateText => _dateText;

  set dateText(String value) {
    _dateText = value;
    notifyListeners();
  }


}