import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:locationprojectflutter/core/constants/constants.dart';
import 'package:locationprojectflutter/data/database/sqflite_helper.dart';
import 'package:locationprojectflutter/data/models/models_sqlf/ResultSql.dart';
import 'package:locationprojectflutter/data/models/models_location/user_location.dart';
import 'package:locationprojectflutter/presentation/widgets/drawer_total.dart';
import 'package:locationprojectflutter/presentation/widgets/responsive_screen.dart';
import 'package:latlong/latlong.dart' as dis;
import 'package:provider/provider.dart';

import 'map_list.dart';

class FavoritesData extends StatefulWidget {
  const FavoritesData({Key key}) : super(key: key);

  @override
  _FavoritesDataState createState() => _FavoritesDataState();
}

class _FavoritesDataState extends State<FavoritesData> {
  List<ResultSql> _places = new List();
  SQFLiteHelper db = new SQFLiteHelper();
  var _userLocation;
  String _API_KEY = Constants.API_KEY;

  @override
  void initState() {
    super.initState();

    _getItems();
  }

  @override
  Widget build(BuildContext context) {
    _userLocation = Provider.of<UserLocation>(context);
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: Text('Lovely Favorite Places'),
        ),
        body: Center(
            child: Column(children: <Widget>[
          Expanded(
            child: ListView.separated(
              itemCount: _places.length,
              itemBuilder: (BuildContext context, int index) {
                final dis.Distance _distance = new dis.Distance();
                final double _meter = _distance(
                    new dis.LatLng(
                        _userLocation.latitude, _userLocation.longitude),
                    new dis.LatLng(_places[index].lat, _places[index].lng));
                return GestureDetector(
                  child: Container(
                    color: Colors.grey,
                    child: Stack(
                      children: <Widget>[
                        Column(
                          children: <Widget>[
                            SizedBox(
                              height: ResponsiveScreen()
                                  .heightMediaQuery(context, 5),
                              width: double.infinity,
                              child: const DecoratedBox(
                                decoration:
                                    const BoxDecoration(color: Colors.white),
                              ),
                            ),
                            CachedNetworkImage(
                              fit: BoxFit.fill,
                              height: ResponsiveScreen()
                                  .heightMediaQuery(context, 150),
                              width: double.infinity,
                              imageUrl: _places[index].photo.isNotEmpty
                                  ? "https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference=" +
                                      _places[index].photo +
                                      "&key=$_API_KEY"
                                  : "https://upload.wikimedia.org/wikipedia/commons/7/75/No_image_available.png",
                              placeholder: (context, url) =>
                                  const CircularProgressIndicator(),
                              errorWidget: (context, url, error) =>
                                  const Icon(Icons.error),
                            ),
                            SizedBox(
                              height: ResponsiveScreen()
                                  .heightMediaQuery(context, 5),
                              width: double.infinity,
                              child: const DecoratedBox(
                                decoration:
                                    const BoxDecoration(color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                        Container(
                          height:
                              ResponsiveScreen().heightMediaQuery(context, 160),
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
                              _textList(_places[index].name, 17.0, 0xffE9FFFF),
                              _textList(
                                  _places[index].vicinity, 15.0, 0xFFFFFFFF),
                              _textList(
                                  _calculateDistance(_meter), 15.0, 0xFFFFFFFF),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MapList(
                          nameList: _places[index].name,
                          latList: _places[index].lat,
                          lngList: _places[index].lng,
                        ),
                      )),
                  onLongPress: () => _deleteItem(_places[index], index),
                );
              },
              separatorBuilder: (BuildContext context, int index) {
                return Container(
                    height: ResponsiveScreen().heightMediaQuery(context, 10),
                    decoration: new BoxDecoration(color: Colors.grey));
              },
            ),
          ),
        ])),
        drawer: DrawerTotal().drawerImpl(context));
  }

  _calculateDistance(double _meter) {
    String _myMeters;
    if (_meter < 1000.0) {
      _myMeters = 'Meters: ' + (_meter.round()).toString();
    } else {
      _myMeters =
          'KM: ' + (_meter.round() / 1000.0).toStringAsFixed(2).toString();
    }
    return _myMeters;
  }

  _textList(String text, double fontSize, int color) {
    return Text(text,
        style: TextStyle(shadows: <Shadow>[
          Shadow(
            offset: Offset(1.0, 1.0),
            blurRadius: 1.0,
            color: Color(0xAA000000),
          ),
          Shadow(
            offset: Offset(1.0, 1.0),
            blurRadius: 1.0,
            color: Color(0xAA000000),
          ),
        ], fontSize: fontSize, color: Color(color)));
  }

  void _deleteItem(ResultSql result, int index) async {
    print(result.id);
    db.deleteResult(result.id).then((results) {
      setState(() {
        _places.removeAt(index);
      });
    });
  }

  void _getItems() async {
    db.getAllResults().then((results) {
      setState(() {
        _places.clear();
        results.forEach((result) {
          _places.add(ResultSql.fromSqlf(result));
        });
      });
    });
  }
}
