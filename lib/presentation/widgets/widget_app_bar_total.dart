import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:locationprojectflutter/core/constants/constants_colors.dart';

class WidgetAppBarTotal extends StatelessWidget implements PreferredSizeWidget {
  static final WidgetAppBarTotal _singleton = WidgetAppBarTotal.internal();

  factory WidgetAppBarTotal() => _singleton;

  WidgetAppBarTotal.internal();

  @override
  final Size preferredSize = Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      iconTheme: IconThemeData(color: ConstantsColors.LIGHT_BLUE),
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
}
