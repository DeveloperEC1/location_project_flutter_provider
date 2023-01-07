import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:photo_view/photo_view.dart';

class PageFullPhoto extends StatelessWidget {
  final String url;

  const PageFullPhoto({Key key, @required this.url}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _body(),
    );
  }

  Widget _body() {
    return Container(
      child: PhotoView(
        imageProvider: NetworkImage(url),
      ),
    );
  }
}
