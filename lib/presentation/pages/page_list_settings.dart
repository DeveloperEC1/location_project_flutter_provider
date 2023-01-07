import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:grouped_buttons/grouped_buttons.dart';
import 'package:locationprojectflutter/presentation/state_management/provider/provider_list_settings.dart';
import 'package:locationprojectflutter/presentation/utils/shower_pages.dart';
import 'package:locationprojectflutter/presentation/utils/utils_app.dart';
import 'package:locationprojectflutter/presentation/widgets/widget_app_bar_total.dart';
import 'package:provider/provider.dart';

class PageListSettings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<ProviderListSettings>(
      builder: (context, results, child) {
        return PageChatSettingsProv();
      },
    );
  }
}

class PageChatSettingsProv extends StatefulWidget {
  @override
  _PageChatSettingsProvState createState() => _PageChatSettingsProvState();
}

class _PageChatSettingsProvState extends State<PageChatSettingsProv> {
  ProviderListSettings _provider;

  @override
  void initState() {
    super.initState();

    _provider = Provider.of<ProviderListSettings>(context, listen: false);

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _provider.initGetSharedPrefs();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey,
      appBar: WidgetAppBarTotal(),
      body: _body(context),
    );
  }

  Widget _body(BuildContext context) {
    return Container(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            _openPlaces(),
            UtilsApp.dividerHeight(context, 20),
            _radiusSearch(),
            _radiusGeofence(),
            UtilsApp.dividerHeight(context, 100),
            _buttonSave(),
          ],
        ),
      ),
    );
  }

  Widget _openPlaces() {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              "Open Places",
              style: TextStyle(color: Colors.greenAccent),
            ),
            UtilsApp.dividerWidth(context, 5),
            const Icon(
              Icons.open_with,
              color: Colors.greenAccent,
              size: 40,
            ),
          ],
        ),
        RadioButtonGroup(
          labels: [
            'Open',
            'All(Open + Close)',
          ],
          picked: _provider.valueOpenGet,
          labelStyle: const TextStyle(color: Colors.indigo),
          activeColor: Colors.greenAccent,
          onSelected: (String label) => {
            _provider.valueOpen(label),
          },
        ),
      ],
    );
  }

  Widget _radiusSearch() {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              "Radius Search",
              style: TextStyle(color: Colors.greenAccent),
            ),
            UtilsApp.dividerWidth(context, 5),
            const Icon(
              Icons.my_location,
              color: Colors.greenAccent,
              size: 40,
            ),
          ],
        ),
        Slider(
          value: _provider.valueRadiusGet,
          min: 0.0,
          max: 50000.0,
          divisions: 50000,
          activeColor: Colors.indigo,
          inactiveColor: Colors.grey,
          label: _provider.valueRadiusGet.round().toString(),
          onChanged: (double newValue) {
            _provider.valueRadius(newValue);
          },
          semanticFormatterCallback: (double newValue) {
            return '${newValue.round()}';
          },
        ),
      ],
    );
  }

  Widget _radiusGeofence() {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              "Radius Geofence",
              style: TextStyle(color: Colors.greenAccent),
            ),
            UtilsApp.dividerWidth(context, 5),
            const Icon(
              Icons.location_searching,
              color: Colors.greenAccent,
              size: 40,
            ),
          ],
        ),
        Slider(
          value: _provider.valueGeofenceGet,
          min: 500.0,
          max: 1000.0,
          divisions: 500,
          activeColor: Colors.indigo,
          inactiveColor: Colors.grey,
          label: _provider.valueGeofenceGet.round().toString(),
          onChanged: (double newValue) {
            _provider.valueGeofence(newValue);
          },
          semanticFormatterCallback: (double newValue) {
            return '${newValue.round()}';
          },
        ),
      ],
    );
  }

  Widget _buttonSave() {
    return RaisedButton(
      child: const Text('Save'),
      color: Colors.greenAccent,
      onPressed: () => {
        _provider.addOpenToSF(_provider.valueOpenGet),
        _provider.addRadiusSearchToSF(_provider.valueRadiusGet),
        _provider.addGeofenceToSF(_provider.valueGeofenceGet),
        ShowerPages.pushRemoveReplacementPageListMap(context),
      },
    );
  }
}
