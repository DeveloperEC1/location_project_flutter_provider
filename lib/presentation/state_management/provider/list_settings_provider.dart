import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ListSettingsProvider extends ChangeNotifier {
  String _valueOpen;
  double _valueRadius, _valueGeofence;
  SharedPreferences _sharedPrefs;

  SharedPreferences get sharedGet => _sharedPrefs;

  String get valueOpenGet => _valueOpen;

  double get valueRadiusGet => _valueRadius;

  double get valueGeofenceGet => _valueGeofence;

  void sharedPref(SharedPreferences sharedPrefs) {
    _sharedPrefs = sharedPrefs;
    notifyListeners();
  }

  void valueOpen(String valueOpen) {
    _valueOpen = valueOpen;
    notifyListeners();
  }

  void valueRadius(double valueRadius) {
    _valueRadius = valueRadius;
    notifyListeners();
  }

  void valueGeofence(double valueGeofence) {
    _valueGeofence = valueGeofence;
    notifyListeners();
  }
}
