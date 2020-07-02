import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:locationprojectflutter/core/constants/constants.dart';
import 'package:locationprojectflutter/presentation/state_management/provider/add_or_edit_data_favorites&favorites_data_provider.dart';
import 'package:locationprojectflutter/presentation/widgets/appbar_totar.dart';
import 'package:locationprojectflutter/presentation/widgets/drawer_total.dart';
import 'package:locationprojectflutter/presentation/utils/responsive_screen.dart';
import 'package:provider/provider.dart';

class AddOrEditDataFavorites extends StatelessWidget {
  final double latList, lngList;
  final String nameList, addressList, photoList;
  final bool edit;
  final int id;

  AddOrEditDataFavorites(
      {Key key,
      this.nameList,
      this.addressList,
      this.latList,
      this.lngList,
      this.photoList,
      this.edit,
      this.id})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<AddOrEditDataFavoritesAndFavoritesDataProvider>(
      builder: (context, results, child) {
        return AddOrEditDataFavoritesProv(
          nameList: nameList,
          addressList: addressList,
          latList: latList,
          lngList: lngList,
          photoList: photoList,
          edit: edit,
          id: id,
        );
      },
    );
  }
}

class AddOrEditDataFavoritesProv extends StatefulWidget {
  final double latList, lngList;
  final String nameList, addressList, photoList;
  final bool edit;
  final int id;

  AddOrEditDataFavoritesProv(
      {Key key,
      this.nameList,
      this.addressList,
      this.latList,
      this.lngList,
      this.photoList,
      this.edit,
      this.id})
      : super(key: key);

  @override
  _AddOrEditDataFavoritesProvState createState() =>
      _AddOrEditDataFavoritesProvState();
}

class _AddOrEditDataFavoritesProvState
    extends State<AddOrEditDataFavoritesProv> {
  TextEditingController _textName;
  TextEditingController _textAddress;
  TextEditingController _textLat;
  TextEditingController _textLng;
  var _provider;
  String _API_KEY = Constants.API_KEY;

  @override
  void initState() {
    super.initState();

    _provider = Provider.of<AddOrEditDataFavoritesAndFavoritesDataProvider>(
        context,
        listen: false);

    _textName = TextEditingController(text: widget.nameList);
    _textAddress = TextEditingController(text: widget.addressList);
    _textLat = TextEditingController(text: widget.latList.toString());
    _textLng = TextEditingController(text: widget.lngList.toString());
  }

  @override
  void dispose() {
    super.dispose();

    _textName.dispose();
    _textAddress.dispose();
    _textLat.dispose();
    _textLng.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      backgroundColor: Colors.grey,
      appBar: AppBarTotal(),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            width: ResponsiveScreen().widthMediaQuery(context, 300),
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: ResponsiveScreen().heightMediaQuery(context, 10),
                ),
                Row(
                  children: <Widget>[
                    RawMaterialButton(
                      onPressed: () => Navigator.pop(context),
                      elevation: 2.0,
                      fillColor: Colors.white,
                      child: Icon(
                        Icons.arrow_back,
                        size: 20.0,
                      ),
                      padding: EdgeInsets.all(10.0),
                      shape: CircleBorder(),
                    ),
                  ],
                ),
                SizedBox(
                  height: ResponsiveScreen().heightMediaQuery(context, 10),
                ),
                Text(
                  widget.edit ? 'Edit Place' : 'Add Place',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                  ),
                ),
                SizedBox(
                  height: ResponsiveScreen().heightMediaQuery(context, 20),
                ),
                Text(
                  'Name',
                  style: TextStyle(color: Colors.white),
                ),
                SizedBox(
                  height: ResponsiveScreen().heightMediaQuery(context, 2),
                ),
                _innerTextField(_textName),
                SizedBox(
                  height: ResponsiveScreen().heightMediaQuery(context, 10),
                ),
                Text(
                  'Address',
                  style: TextStyle(color: Colors.white),
                ),
                SizedBox(
                  height: ResponsiveScreen().heightMediaQuery(context, 2),
                ),
                _innerTextField(_textAddress),
                SizedBox(
                  height: ResponsiveScreen().heightMediaQuery(context, 10),
                ),
                Text(
                  'Coordinates',
                  style: TextStyle(color: Colors.white),
                ),
                SizedBox(
                  height: ResponsiveScreen().heightMediaQuery(context, 2),
                ),
                _innerTextField(_textLat),
                SizedBox(
                  height: ResponsiveScreen().heightMediaQuery(context, 2),
                ),
                _innerTextField(_textLng),
                SizedBox(
                  height: ResponsiveScreen().heightMediaQuery(context, 10),
                ),
                Text(
                  'Photo',
                  style: TextStyle(color: Colors.white),
                ),
                SizedBox(
                  height: ResponsiveScreen().heightMediaQuery(context, 2),
                ),
                CachedNetworkImage(
                  fit: BoxFit.fill,
                  height: ResponsiveScreen().heightMediaQuery(context, 75),
                  width: ResponsiveScreen().heightMediaQuery(context, 175),
                  imageUrl:
                      "https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference=" +
                          widget.photoList +
                          "&key=$_API_KEY",
                  placeholder: (context, url) =>
                      const CircularProgressIndicator(),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
                SizedBox(
                  height: ResponsiveScreen().heightMediaQuery(context, 20),
                ),
                RaisedButton(
                  padding: const EdgeInsets.all(0.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(80.0),
                  ),
                  onPressed: () => widget.edit
                      ? _provider.updateItem(
                          widget.id,
                          _textName.text,
                          _textAddress.text,
                          double.parse(_textLat.text),
                          double.parse(_textLng.text),
                          widget.photoList,
                          context,
                        )
                      : _provider.addItem(
                          _textName.text,
                          _textAddress.text,
                          double.parse(_textLat.text),
                          double.parse(_textLng.text),
                          widget.photoList,
                          context,
                        ),
                  child: Container(
                    decoration: const BoxDecoration(
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
                    padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                    child: Text(
                      widget.edit ? 'Edit Your Place' : 'Add Your Place',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      drawer: DrawerTotal(),
    );
  }

  Widget _innerTextField(TextEditingController textEditingController) {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xff778899).withOpacity(0.9189918041229248),
        border: Border.all(
          color: Color(0xff778899),
          width: 1,
        ),
        borderRadius: BorderRadius.circular(24),
      ),
      child: TextField(
        decoration: InputDecoration(
          contentPadding: EdgeInsets.all(10.0),
          border: InputBorder.none,
        ),
        style: TextStyle(color: Colors.lightGreenAccent),
        controller: textEditingController,
      ),
    );
  }
}
