import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io';
import 'package:locationprojectflutter/core/constants/constants_colors.dart';
import 'package:simple_image_crop/simple_image_crop.dart';

class PageSimpleImageCrop extends StatelessWidget {
  final File image;

  const PageSimpleImageCrop({Key key, @required this.image}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _cropKey = GlobalKey<ImgCropState>();
    return Scaffold(
      appBar: _appBar(context),
      body: _body(_cropKey),
      floatingActionButton: _floatingActionButton(context, _cropKey),
    );
  }

  PreferredSizeWidget _appBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.indigoAccent,
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

  Widget _body(var cropKey) {
    return image != null
        ? Center(
            child: ImgCrop(
              key: cropKey,
              maximumScale: 3,
              image: FileImage(image),
            ),
          )
        : Container(
            child: const Center(
              child: Text('Click on the return button'),
            ),
          );
  }

  FloatingActionButton _floatingActionButton(
      BuildContext context, var cropKey) {
    return FloatingActionButton(
      onPressed: () async {
        final crop = cropKey.currentState;
        final croppedFile = await crop.cropCompleted(
          image,
          pictureQuality: 600,
        );
        Navigator.pop(context, croppedFile);
      },
      child: const Text('Crop'),
    );
  }
}
