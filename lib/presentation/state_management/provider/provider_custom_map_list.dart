import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:locationprojectflutter/data/models/model_stream_location/user_location.dart';
import 'package:locationprojectflutter/presentation/widgets/widget_add_edit_favorite_places.dart';
import 'package:provider/provider.dart';

class ProviderCustomMapList extends ChangeNotifier {
  List<Marker> _markers = <Marker>[];
  bool _isCheckingBottomSheet = false;
  MapCreatedCallback _onMapCreated;
  UserLocation _userLocation;
  LatLng _currentLocation;

  List<Marker> get markersGet => _markers;

  bool get isCheckingBottomSheetGet => _isCheckingBottomSheet;

  MapCreatedCallback get onMapCreatedGet => _onMapCreated;

  LatLng get currentLocationGet => _currentLocation;

  void clearMarkers() {
    _markers.clear();
    notifyListeners();
  }

  void isCheckingBottomSheet(bool isCheckingBottomSheet) {
    _isCheckingBottomSheet = isCheckingBottomSheet;
    notifyListeners();
  }

  void userLocation(BuildContext context) {
    _userLocation = Provider.of<UserLocation>(context);
  }

  void currentLocation() {
    _currentLocation = LatLng(_userLocation.latitude, _userLocation.longitude);
  }

  void addMarker(LatLng latLong, BuildContext context) {
    clearMarkers();
    markersGet.add(
      Marker(
        markerId: MarkerId(latLong.toString()),
        position: latLong,
        onTap: () => {
          isCheckingBottomSheet(true),
          _newTaskModalBottomSheet(context, latLong),
        },
        icon:
            BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueMagenta),
      ),
    );
  }

  void _newTaskModalBottomSheet(BuildContext context, LatLng point) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () {
            isCheckingBottomSheet(false);

            Navigator.pop(context, false);

            return Future.value(false);
          },
          child: StatefulBuilder(
            builder: (BuildContext context,
                void Function(void Function()) setState) {
              return Container(
                child: ListView(
                  children: [
                    WidgetAddEditFavoritePlaces(
                      latList: point.latitude,
                      lngList: point.longitude,
                      photoList: "",
                      edit: false,
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }
}
