import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:ui';
import 'package:auto_animated/auto_animated.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:locationprojectflutter/core/constants/constants_colors.dart';
import 'package:locationprojectflutter/presentation/utils/shower_pages.dart';
import 'package:locationprojectflutter/presentation/state_management/provider/provider_favorite_places.dart';
import 'package:locationprojectflutter/presentation/utils/responsive_screen.dart';
import 'package:latlong/latlong.dart' as dis;
import 'package:provider/provider.dart';

class PageFavoritePlaces extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<ProviderFavoritePlaces>(
      builder: (context, results, child) {
        return PageFavoritePlacesProv();
      },
    );
  }
}

class PageFavoritePlacesProv extends StatefulWidget {
  @override
  _PageFavoritePlacesProvState createState() => _PageFavoritePlacesProvState();
}

class _PageFavoritePlacesProvState extends State<PageFavoritePlacesProv> {
  ProviderFavoritePlaces _provider;

  @override
  void initState() {
    super.initState();

    _provider = Provider.of<ProviderFavoritePlaces>(context, listen: false);

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _provider.isCheckingBottomSheet(false);
      _provider.getItems();
    });
  }

  @override
  Widget build(BuildContext context) {
    _provider.userLocation(context);
    return Scaffold(
      appBar: _appBar(),
      body: _body(),
    );
  }

  PreferredSizeWidget _appBar() {
    return AppBar(
      backgroundColor: Colors.indigoAccent,
      actions: <Widget>[
        IconButton(
          icon: const Icon(Icons.delete_forever),
          color: ConstantsColors.LIGHT_BLUE,
          onPressed: () => _provider.deleteData(),
        ),
      ],
      leading: IconButton(
        icon: Icon(
          Icons.navigate_before,
          color: ConstantsColors.LIGHT_BLUE,
          size: 40,
        ),
        onPressed: () => Navigator.of(context).pop(),
      ),
    );
  }

  Widget _body() {
    return Stack(
      children: [
        _listViewData(),
        _loading(),
      ],
    );
  }

  Widget _listViewData() {
    return Column(
      children: <Widget>[
        _provider.resultsSqflGet.length == 0
            ? const Align(
                alignment: Alignment.center,
                child: Text(
                  'No Favorite Places',
                  style: TextStyle(
                    color: Colors.deepPurpleAccent,
                    fontSize: 30,
                  ),
                ),
              )
            : Expanded(
                child: LiveList(
                  showItemInterval: const Duration(milliseconds: 50),
                  showItemDuration: const Duration(milliseconds: 50),
                  reAnimateOnVisibility: true,
                  scrollDirection: Axis.vertical,
                  itemCount: _provider.resultsSqflGet.length,
                  itemBuilder: _buildAnimatedItem,
                  separatorBuilder: (context, i) {
                    return SizedBox(
                      height: ResponsiveScreen().heightMediaQuery(context, 5),
                      width: double.infinity,
                      child: const DecoratedBox(
                        decoration: BoxDecoration(color: Colors.white),
                      ),
                    );
                  },
                ),
              ),
      ],
    );
  }

  Widget _loading() {
    return _provider.isCheckingBottomSheetGet == true
        ? Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: ResponsiveScreen().widthMediaQuery(context, 5),
                sigmaY: ResponsiveScreen().widthMediaQuery(context, 5),
              ),
              child: Container(
                color: Colors.black.withOpacity(0),
              ),
            ),
          )
        : Container();
  }

  Widget _buildAnimatedItem(
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
            begin: const Offset(0, -0.1),
            end: Offset.zero,
          ).animate(animation),
          child: _childLiveList(index),
        ),
      );

  Widget _childLiveList(int index) {
    final dis.Distance _distance = dis.Distance();
    final double _meter = _distance(
      dis.LatLng(_provider.userLocationGet.latitude,
          _provider.userLocationGet.longitude),
      dis.LatLng(_provider.resultsSqflGet[index].lat,
          _provider.resultsSqflGet[index].lng),
    );
    return Slidable(
      key: UniqueKey(),
      actionPane: const SlidableDrawerActionPane(),
      actionExtentRatio: 0.10,
      secondaryActions: <Widget>[
        IconSlideAction(
          color: Colors.orange,
          icon: Icons.edit,
          onTap: () => {
            _provider.isCheckingBottomSheet(true),
            _provider.newTaskModalBottomSheet(context, index),
          },
        ),
        IconSlideAction(
          color: Colors.greenAccent,
          icon: Icons.directions,
          onTap: () => {
            ShowerPages.pushPageMapList(
              context,
              _provider.resultsSqflGet[index].name,
              _provider.resultsSqflGet[index].vicinity,
              _provider.resultsSqflGet[index].lat,
              _provider.resultsSqflGet[index].lng,
            ),
          },
        ),
        IconSlideAction(
          color: Colors.blueGrey,
          icon: Icons.share,
          onTap: () => {
            _provider.shareContent(
              _provider.resultsSqflGet[index].name,
              _provider.resultsSqflGet[index].vicinity,
              _provider.resultsSqflGet[index].lat,
              _provider.resultsSqflGet[index].lng,
              _provider.resultsSqflGet[index].photo,
              context,
            )
          },
        ),
      ],
      actions: [
        IconSlideAction(
          color: Colors.red,
          icon: Icons.delete,
          onTap: () =>
              _provider.deleteItem(_provider.resultsSqflGet[index], index),
        ),
      ],
      dismissal: SlidableDismissal(
        child: const SlidableDrawerDismissal(),
        dismissThresholds: <SlideActionType, double>{
          SlideActionType.secondary: 1.0
        },
        onDismissed: (actionType) {
          _provider.deleteItem(_provider.resultsSqflGet[index], index);
        },
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Container(
          child: Stack(
            children: <Widget>[
              Column(
                children: <Widget>[
                  CachedNetworkImage(
                    fit: BoxFit.fill,
                    height: ResponsiveScreen().heightMediaQuery(context, 150),
                    width: double.infinity,
                    imageUrl: _provider.resultsSqflGet[index].photo.isNotEmpty
                        ? "https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference=" +
                            _provider.resultsSqflGet[index].photo +
                            "&key=${_provider.API_KEYGet}"
                        : "https://upload.wikimedia.org/wikipedia/commons/7/75/No_image_available.png",
                    placeholder: (context, url) =>
                        const CircularProgressIndicator(),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                  ),
                ],
              ),
              Container(
                height: ResponsiveScreen().heightMediaQuery(context, 150),
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      ConstantsColors.GRAY,
                      ConstantsColors.TRANSPARENT,
                      ConstantsColors.TRANSPARENT,
                      ConstantsColors.GRAY,
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(
                    ResponsiveScreen().widthMediaQuery(context, 4)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    _textList(
                        _provider.resultsSqflGet[index].name, 17.0, 0xffE9FFFF),
                    _textList(_provider.resultsSqflGet[index].vicinity, 15.0,
                        0xFFFFFFFF),
                    _textList(
                        _provider.calculateDistance(_meter), 15.0, 0xFFFFFFFF),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _textList(String text, double fontSize, int color) {
    return Text(
      text,
      style: TextStyle(
        shadows: <Shadow>[
          Shadow(
            offset: Offset(ResponsiveScreen().widthMediaQuery(context, 1),
                ResponsiveScreen().widthMediaQuery(context, 1)),
            blurRadius: ResponsiveScreen().widthMediaQuery(context, 1),
            color: ConstantsColors.GRAY,
          ),
          Shadow(
            offset: Offset(ResponsiveScreen().widthMediaQuery(context, 1),
                ResponsiveScreen().widthMediaQuery(context, 1)),
            blurRadius: ResponsiveScreen().widthMediaQuery(context, 1),
            color: ConstantsColors.GRAY,
          ),
        ],
        fontSize: fontSize,
        color: Color(color),
      ),
    );
  }
}
