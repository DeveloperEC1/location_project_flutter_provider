import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:locationprojectflutter/presentation/state_management/provider/provider_map_list.dart';
import 'package:locationprojectflutter/presentation/widgets/widget_app_bar_total.dart';
import 'package:provider/provider.dart';
import 'package:locationprojectflutter/core/constants/constants_colors.dart';

class PageMapList extends StatelessWidget {
  final double latList, lngList;
  final String nameList, vicinityList;

  const PageMapList(
      {Key key,
      @required this.latList,
      @required this.lngList,
      @required this.nameList,
      @required this.vicinityList})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ProviderMapList>(
      builder: (context, results, child) {
        return PageMapListProv(
          latList: latList,
          lngList: lngList,
          nameList: nameList,
          vicinityList: vicinityList,
        );
      },
    );
  }
}

class PageMapListProv extends StatefulWidget {
  final double latList, lngList;
  final String nameList, vicinityList;

  const PageMapListProv(
      {Key key, this.nameList, this.vicinityList, this.latList, this.lngList})
      : super(key: key);

  @override
  _PageMapListProvState createState() => _PageMapListProvState();
}

class _PageMapListProvState extends State<PageMapListProv> {
  ProviderMapList _provider;

  @override
  void initState() {
    super.initState();

    _provider = Provider.of<ProviderMapList>(context, listen: false);

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _provider.initGetSharedPrefs();
      _provider.initMarker(widget.nameList, widget.vicinityList, widget.latList,
          widget.lngList, context);
      _provider.initGeofence(widget.latList, widget.lngList, widget.nameList);
      _provider.initPlatformState(widget.nameList);
      _provider.initNotifications();
      _provider.isSearching(false);
    });
  }

  @override
  Widget build(BuildContext context) {
    _provider.userLocation(context);
    _provider.currentLocation();
    return Scaffold(
      appBar: WidgetAppBarTotal(),
      body: _body(),
      floatingActionButton: _floatingActionButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _body() {
    return Stack(
      children: [
        _googleMap(_provider.currentLocationGet),
        if (_provider.isSearchingGet) _loading(),
      ],
    );
  }

  Widget _googleMap(LatLng _currentLocation) {
    return GoogleMap(
      onMapCreated: _provider.onMapCreatedGet,
      initialCameraPosition: CameraPosition(
        target: _currentLocation,
        zoom: 10.0,
      ),
      markers: Set<Marker>.of(_provider.markersGet),
      myLocationEnabled: true,
      myLocationButtonEnabled: true,
      zoomGesturesEnabled: true,
      circles: Set.from([
        Circle(
          circleId: CircleId(
            _currentLocation.toString(),
          ),
          center: _currentLocation,
          fillColor: ConstantsColors.LIGHT_PURPLE,
          strokeColor: ConstantsColors.LIGHT_PURPLE,
          radius: _provider.valueRadiusGet,
        ),
      ]),
      mapType: MapType.normal,
    );
  }

  Widget _loading() {
    return Container(
      decoration: BoxDecoration(
        color: ConstantsColors.DARK_GRAY2,
      ),
      child: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  FloatingActionButton _floatingActionButton() {
    return FloatingActionButton.extended(
      onPressed: () {
        _provider.searchNearbyList(context);
      },
      label: const Text('Show Nearby Places'),
      icon: const Icon(Icons.place),
    );
  }
}
