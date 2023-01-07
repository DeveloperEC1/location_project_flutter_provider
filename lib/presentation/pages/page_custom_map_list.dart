import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:ui';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:locationprojectflutter/presentation/state_management/provider/provider_custom_map_list.dart';
import 'package:locationprojectflutter/presentation/utils/responsive_screen.dart';
import 'package:locationprojectflutter/presentation/widgets/widget_app_bar_total.dart';
import 'package:provider/provider.dart';

class PageCustomMapList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<ProviderCustomMapList>(
      builder: (context, results, child) {
        return PageCustomMapListProv();
      },
    );
  }
}

class PageCustomMapListProv extends StatefulWidget {
  @override
  _PageCustomMapListProvState createState() => _PageCustomMapListProvState();
}

class _PageCustomMapListProvState extends State<PageCustomMapListProv> {
  ProviderCustomMapList _provider;

  @override
  void initState() {
    super.initState();

    _provider = Provider.of<ProviderCustomMapList>(context, listen: false);

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _provider.isCheckingBottomSheet(false);
      _provider.clearMarkers();
    });
  }

  @override
  Widget build(BuildContext context) {
    _provider.userLocation(context);
    _provider.currentLocation();
    return Scaffold(
      appBar: WidgetAppBarTotal(),
      body: _body(),
    );
  }

  Widget _body() {
    return Stack(
      children: [
        _googleMap(),
        _blur(),
      ],
    );
  }

  Widget _googleMap() {
    return GoogleMap(
      onMapCreated: _provider.onMapCreatedGet,
      initialCameraPosition: CameraPosition(
        target: _provider.currentLocationGet,
        zoom: 10.0,
      ),
      markers: Set<Marker>.of(_provider.markersGet),
      myLocationEnabled: true,
      myLocationButtonEnabled: true,
      zoomGesturesEnabled: true,
      mapType: MapType.normal,
      onTap: (latLong) {
        _provider.addMarker(latLong, context);
      },
    );
  }

  Widget _blur() {
    return _provider.isCheckingBottomSheetGet == true
        ? Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: ResponsiveScreen().widthMediaQuery(context, 5),
                sigmaY: ResponsiveScreen().widthMediaQuery(context, 5),
              ),
              child: Container(color: Colors.black.withOpacity(0)),
            ),
          )
        : Container();
  }
}
