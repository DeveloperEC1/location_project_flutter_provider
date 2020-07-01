import 'dart:async';
import 'package:auto_animated/auto_animated.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_instagram_stories/flutter_instagram_stories.dart';
import 'package:flutter_instagram_stories/settings.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:latlong/latlong.dart' as dis;
import 'package:locationprojectflutter/core/constants/constants.dart';
import 'package:locationprojectflutter/data/models/model_googleapis/results.dart';
import 'package:locationprojectflutter/data/models/model_stream_location/user_location.dart';
import 'package:locationprojectflutter/data/repositories_impl/location_repo_impl.dart';
import 'package:locationprojectflutter/presentation/widgets/drawer_total.dart';
import 'package:locationprojectflutter/presentation/utils/responsive_screen.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math';
import 'add_or_edit_data_favorites.dart';
import 'map_list.dart';

//import 'package:flutter_mobx/flutter_mobx.dart';
//import 'package:locationprojectflutter/presentation/state_management/mobx/results_data_mobx.dart';

class ListMap extends StatefulWidget {
  ListMap({Key key}) : super(key: key);

  @override
  _ListMapState createState() => _ListMapState();
}

class _ListMapState extends State<ListMap> {
  List<Results> _places = List();
  bool _searching = true, _activeSearch = false, _activeNav = false;
  double _valueRadius;
  String _open;
  SharedPreferences _sharedPrefs;
  var _userLocation;
  String _API_KEY = Constants.API_KEY;
  LocationRepoImpl _locationRepoImpl = LocationRepoImpl();
  final _formKeySearch = GlobalKey<FormState>();
  final _controllerSearch = TextEditingController();
  final _databaseReference = Firestore.instance;

//  ResultsDataMobXStore _dataMobx = ResultsDataMobXStore(); // MobX

  @override
  void initState() {
    super.initState();

    _initGetSharedPrefs();
  }

  PreferredSizeWidget _appBar() {
    if (_activeSearch) {
      return AppBar(
        backgroundColor: Color(0xFF1E2538),
        title: Form(
          key: _formKeySearch,
          child: Row(
            children: <Widget>[
              Flexible(
                child: TextFormField(
                  decoration: InputDecoration(
                    hintText: 'Search a place...',
                    hintStyle: TextStyle(color: Colors.grey),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                          color: Colors.white,
                          width: 1.0,
                          style: BorderStyle.solid),
                    ),
                  ),
                  controller: _controllerSearch,
                  style: TextStyle(color: Colors.white),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter some text';
                    } else {
                      return null;
                    }
                  },
                ),
              ),
              IconButton(
                icon: Icon(Icons.search),
                color: Color(0xFFE9FFFF),
                onPressed: () {
                  if (_formKeySearch.currentState.validate()) {
                    _searchNearbyTotal(true, "", _controllerSearch.text);
                  }
                },
              ),
            ],
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.close),
            color: Color(0xFFE9FFFF),
            onPressed: () => setState(() => _activeSearch = false),
          )
        ],
      );
    } else {
      return AppBar(
        backgroundColor: Colors.black,
        title: Text(
          'Lovely Favorite Places',
          style: TextStyle(color: Color(0xFFE9FFFF)),
        ),
        iconTheme: IconThemeData(
          color: Color(0xFFE9FFFF),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            color: Color(0xFFE9FFFF),
            onPressed: () => setState(() => _activeSearch = true),
          ),
          IconButton(
            icon: Icon(Icons.navigation),
            color: Color(0xFFE9FFFF),
            onPressed: () => _searchNearbyTotal(true, "", ""),
          ),
        ],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    _userLocation = Provider.of<UserLocation>(context);
    _searchNearbyTotal(_searching, "", "");
    return Scaffold(
      appBar: _appBar(),
      body: Container(
        child: Stack(
          children: [
            Column(
              children: <Widget>[
                FlutterInstagramStories(
                  collectionDbName: 'stories',
                  showTitleOnIcon: true,
                  iconTextStyle: TextStyle(
                    shadows: <Shadow>[
                      Shadow(
                        offset: Offset(1.0, 1.0),
                        blurRadius: 1.0,
                        color: Color(0xAA000000),
                      ),
                    ],
                    fontSize: 6,
                    color: Colors.white,
                  ),
                  iconImageBorderRadius: BorderRadius.circular(30),
                  iconBoxDecoration: BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(30),
                    ),
                    color: Color(0xFFffffff),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0xff333333),
                        blurRadius: 10.0,
                        offset: Offset(
                          0.0,
                          4.0,
                        ),
                      ),
                    ],
                  ),
                  iconWidth: ResponsiveScreen().widthMediaQuery(context, 50),
                  iconHeight: ResponsiveScreen().heightMediaQuery(context, 50),
                  imageStoryDuration: 7,
                  progressPosition: ProgressPosition.top,
                  repeat: true,
                  inline: false,
                  languageCode: 'en',
                  backgroundColorBetweenStories: Colors.black,
                  closeButtonIcon: Icon(
                    Icons.close,
                    color: Colors.white,
                    size: 28.0,
                  ),
                  closeButtonBackgroundColor: Color(0x11000000),
                  sortingOrderDesc: true,
                  lastIconHighlight: true,
                  lastIconHighlightColor: Colors.deepOrange,
                  lastIconHighlightRadius: const Radius.circular(30),
                ),
                SizedBox(
                  height: ResponsiveScreen().heightMediaQuery(context, 1),
                  width: double.infinity,
                  child: const DecoratedBox(
                    decoration: const BoxDecoration(color: Colors.grey),
                  ),
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: <Widget>[
                      _btnType('Banks', 'bank'),
                      _btnType('Bars', 'bar|night_club'),
                      _btnType('Beauty', 'beauty_salon|hair_care'),
                      _btnType('Books', 'book_store|library'),
                      _btnType('Bus stations', 'bus_station'),
                      _btnType(
                          'Cars', 'car_dealer|car_rental|car_repair|car_wash'),
                      _btnType('Clothing', 'clothing_store'),
                      _btnType('Doctors', 'doctor'),
                      _btnType('Gas stations', 'gas_station'),
                      _btnType('Gym', 'gym'),
                      _btnType('Jewelries', 'jewelry_store'),
                      _btnType('Parks', 'park|amusement_park|parking|rv_park'),
                      _btnType('Restaurants', 'food|restaurant|cafe|bakery'),
                      _btnType('School', 'school'),
                      _btnType('Spa', 'spa'),
                    ],
                  ),
                ),
                _searching
                    ? CircularProgressIndicator()
                    : _places.length == 0
                        ? Text(
                            'No Places',
                            style: TextStyle(
                              color: Colors.deepPurpleAccent,
                              fontSize: 30,
                            ),
                          )
                        : Expanded(
//                            child: Observer(builder: (_) {
                            child: LiveList(
                              showItemInterval: Duration(milliseconds: 50),
                              showItemDuration: Duration(milliseconds: 50),
                              reAnimateOnVisibility: true,
                              scrollDirection: Axis.vertical,
                              itemCount: _places.length,
                              itemBuilder: buildAnimatedItem,
                              separatorBuilder: (context, i) {
                                return SizedBox(
                                  height: ResponsiveScreen()
                                      .heightMediaQuery(context, 5),
                                  width: double.infinity,
                                  child: const DecoratedBox(
                                    decoration: const BoxDecoration(
                                        color: Colors.white),
                                  ),
                                );
                              },
                            ),
//                        },
                          ),
              ],
            ),
            if (_activeNav)
              Container(
                decoration: BoxDecoration(
                  color: Color(0x80000000),
                ),
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
          ],
        ),
      ),
      drawer: DrawerTotal(),
    );
  }

  Widget buildAnimatedItem(
    BuildContext context,
    int index,
    Animation<double> animation,
  ) =>
      FadeTransition(
        opacity: Tween<double>(
          begin: 0,
          end: 1,
        ).animate(animation),
        child: SlideTransition(
          position: Tween<Offset>(
            begin: Offset(0, -0.1),
            end: Offset.zero,
          ).animate(animation),
          child: _childLiveList(index),
        ),
      );

  Widget _childLiveList(int index) {
    final dis.Distance _distance = dis.Distance();
    final double _meter = _distance(
      dis.LatLng(_userLocation.latitude, _userLocation.longitude),
      dis.LatLng(_places[index].geometry.location.lat,
          _places[index].geometry.location.lng),
    );
    return Slidable(
      key: UniqueKey(),
      actionPane: SlidableDrawerActionPane(),
      actionExtentRatio: 0.10,
      secondaryActions: <Widget>[
        IconSlideAction(
          color: Colors.green,
          icon: Icons.add,
          onTap: () => {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddOrEditDataFavorites(
                  nameList: _places[index].name,
                  addressList: _places[index].vicinity,
                  latList: _places[index].geometry.location.lat,
                  lngList: _places[index].geometry.location.lng,
                  photoList: _places[index].photos.isNotEmpty
                      ? _places[index].photos[0].photo_reference
                      : "",
                  edit: false,
                ),
              ),
            ),
          },
        ),
        IconSlideAction(
          color: Colors.greenAccent,
          icon: Icons.directions,
          onTap: () => {
            _createNavPlace(index),
          },
        ),
        IconSlideAction(
          color: Colors.blueGrey,
          icon: Icons.share,
          onTap: () => {
            _shareContent(
                _places[index].name,
                _places[index].vicinity,
                _places[index].geometry.location.lat,
                _places[index].geometry.location.lng,
                _places[index].photos[0].photo_reference)
          },
        ),
      ],
      child: Container(
        color: Colors.grey,
        child: Stack(
          children: <Widget>[
            CachedNetworkImage(
              fit: BoxFit.fill,
              height: ResponsiveScreen().heightMediaQuery(context, 150),
              width: double.infinity,
              imageUrl: _places[index].photos.isNotEmpty
                  ? "https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference=" +
                      _places[index].photos[0].photo_reference +
                      "&key=$_API_KEY"
                  : "https://upload.wikimedia.org/wikipedia/commons/7/75/No_image_available.png",
              placeholder: (context, url) => const CircularProgressIndicator(),
              errorWidget: (context, url, error) => const Icon(Icons.error),
            ),
            Container(
              height: ResponsiveScreen().heightMediaQuery(context, 150),
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    const Color(0xAA000000),
                    const Color(0x00000000),
                    const Color(0x00000000),
                    const Color(0xAA000000),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  _textListView(_places[index].name, 17.0, 0xffE9FFFF),
                  _textListView(_places[index].vicinity, 15.0, 0xFFFFFFFF),
                  Row(
                    children: [
                      _textListView(
                          _calculateDistance(_meter), 15.0, 0xFFFFFFFF),
                      SizedBox(
                        width: ResponsiveScreen().widthMediaQuery(context, 20),
                      ),
                      _textListView(
                          _places[index].opening_hours != null
                              ? _places[index].opening_hours.open_now == true
                                  ? 'Open'
                                  : _places[index].opening_hours.open_now ==
                                          false
                                      ? 'Close'
                                      : 'No info'
                              : "No info",
                          15.0,
                          0xFFFFEA54),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _createNavPlace(int index) async {
    setState(() {
      _activeNav = true;
    });

    int count;

    var document =
        _databaseReference.collection('places').document(_places[index].id);
    document.get().then(
      (document) {
        if (document.exists) {
          setState(() {
            count = document['count'];
          });
        }
      },
    ).then(
      (value) => _addToFirebase(index, count),
    );
  }

  void _addToFirebase(int index, int count) async {
    DateTime now = DateTime.now();

    Map<String, dynamic> dataFile = Map();
    dataFile["filetype"] = 'image';
    dataFile["url"] = {
      'en': _places[index].photos.isNotEmpty
          ? "https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference=" +
              _places[index].photos[0].photo_reference +
              "&key=$_API_KEY"
          : "https://upload.wikimedia.org/wikipedia/commons/7/75/No_image_available.png",
    };

    var listFile = List<Map<String, dynamic>>();
    listFile.add(dataFile);

    await _databaseReference
        .collection("stories")
        .document(_places[index].id)
        .setData(
          {
            "date": now,
            "file": listFile,
            "previewImage": _places[index].photos.isNotEmpty
                ? "https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference=" +
                    _places[index].photos[0].photo_reference +
                    "&key=$_API_KEY"
                : "https://upload.wikimedia.org/wikipedia/commons/7/75/No_image_available.png",
            "previewTitle": {'en': _places[index].name},
          },
        )
        .then(
          (result) async => {
            await _databaseReference
                .collection("places")
                .document(_places[index].id)
                .setData(
              {
                "date": now,
                'idLive': _places[index].id,
                'count': count != null ? count + 1 : 1,
                "name": _places[index].name,
                "vicinity": _places[index].vicinity,
                "lat": _places[index].geometry.location.lat,
                "lng": _places[index].geometry.location.lng,
                "photo": _places[index].photos.isNotEmpty
                    ? _places[index].photos[0].photo_reference
                    : "",
              },
            ).then(
              (result) => {
                setState(() {
                  _activeNav = false;
                  print(_activeNav);
                }),
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MapList(
                      nameList: _places[index].name,
                      vicinityList: _places[index].vicinity,
                      latList: _places[index].geometry.location.lat,
                      lngList: _places[index].geometry.location.lng,
                    ),
                  ),
                ),
              },
            )
          },
        )
        .catchError(
          (err) => print(err),
        );
  }

  String _calculateDistance(double _meter) {
    String _myMeters;
    if (_meter < 1000.0) {
      _myMeters = 'Meters: ' + (_meter.round()).toString();
    } else {
      _myMeters =
          'KM: ' + (_meter.round() / 1000.0).toStringAsFixed(2).toString();
    }
    return _myMeters;
  }

  void _initGetSharedPrefs() {
    SharedPreferences.getInstance().then(
      (prefs) {
        setState(() => _sharedPrefs = prefs);
        _valueRadius = _sharedPrefs.getDouble('rangeRadius') ?? 5000.0;
        _open = _sharedPrefs.getString('open') ?? '';
      },
    );
  }

  Widget _btnType(String name, String type) {
    return Row(
      children: <Widget>[
        SizedBox(
          width: ResponsiveScreen().widthMediaQuery(context, 5),
        ),
        RaisedButton(
          padding: EdgeInsets.all(0.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(80.0),
          ),
          onPressed: () => _searchNearbyTotal(true, type, ""),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: <Color>[
                  Color(0xFF5e7974),
                  Color(0xFF6494ED),
                ],
              ),
              borderRadius: BorderRadius.all(
                Radius.circular(80.0),
              ),
            ),
            padding: EdgeInsets.fromLTRB(30, 10, 30, 10),
            child: Text(
              name,
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
        SizedBox(
          width: ResponsiveScreen().widthMediaQuery(context, 5),
        ),
      ],
    );
  }

  Widget _textListView(String text, double fontSize, int color) {
    return Text(
      text,
      style: TextStyle(
        shadows: <Shadow>[
          Shadow(
            offset: Offset(1.0, 1.0),
            blurRadius: 1.0,
            color: Color(0xAA000000),
          ),
        ],
        fontSize: fontSize,
        color: Color(color),
      ),
    );
  }

  void _searchNearbyTotal(bool isSearching, String type, String text) {
    _searchNearby(isSearching, type, text).then(
      (value) => _sortSearchNearby(value),
    );
  }

  Future _searchNearby(bool isSearching, String type, String text) async {
    if (isSearching) {
      _places = await _locationRepoImpl.getLocationJson(_userLocation.latitude,
          _userLocation.longitude, _open, type, _valueRadius.round(), text);
//      _places = await _dataMobx.getSearchNearby(_userLocation.latitude,
//          _userLocation.longitude, _open, type, _valueRadius.round(), text); // MobX
      setState(() {
        _searching = false;
        print(_searching);
      });
    }
    return _places;
  }

  void _sortSearchNearby(List<Results> _places) {
    _places.sort(
      (a, b) => sqrt(
        pow(a.geometry.location.lat - _userLocation.latitude, 2) +
            pow(a.geometry.location.lng - _userLocation.longitude, 2),
      ).compareTo(
        sqrt(
          pow(b.geometry.location.lat - _userLocation.latitude, 2) +
              pow(b.geometry.location.lng - _userLocation.longitude, 2),
        ),
      ),
    );
  }

  void _shareContent(
      String name, String vicinity, double lat, double lng, String photo) {
    final RenderBox box = context.findRenderObject();
    Share.share(
        'Name: $name' +
            '\n' +
            'Vicinity: $vicinity' +
            '\n' +
            'Latitude: $lat' +
            '\n' +
            'Longitude: $lng' +
            '\n' +
            'Photo: $photo',
        sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
  }
}
