import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProviderListSettings extends ChangeNotifier {
  SharedPreferences _sharedPrefs;
  String _valueOpen;
  double _valueRadius, _valueGeofence;

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

  void initGetSharedPrefs() {
    SharedPreferences.getInstance().then(
      (prefs) {
        sharedPref(prefs);

        valueOpen(sharedGet.getString('open') ?? '');

        valueOpenGet == '&opennow=true'
            ? valueOpen('Open')
            : valueOpenGet == ''
                ? valueOpen('All(Open + Close)')
                : valueOpen('All(Open + Close)');

        valueRadius(sharedGet.getDouble('rangeRadius') ?? 5000.0);

        valueGeofence(sharedGet.getDouble('rangeGeofence') ?? 500.0);
      },
    );
  }

  void addOpenToSF(String value) async {
    if (value == 'Open') {
      sharedGet.setString('open', '&opennow=true');
    } else if (value == 'All(Open + Close)') {
      sharedGet.setString('open', '');
    }
  }

  void addRadiusSearchToSF(double value) async {
    sharedGet.setDouble('rangeRadius', value);
  }

  void addGeofenceToSF(double value) async {
    sharedGet.setDouble('rangeGeofence', value);
  }
}
