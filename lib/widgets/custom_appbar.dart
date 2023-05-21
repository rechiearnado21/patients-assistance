import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomAppBar extends StatelessWidget with PreferredSizeWidget {
  const CustomAppBar(
      {Key? key,
      this.statusBarColor,
      this.title,
      this.bottom,
      this.height = 60.0,
      this.elevation = 0.0,
      this.leading,
      this.automaticallyImplyLeading = true,
      this.statusBarIconBrightness})
      : super(key: key);

  final Color? statusBarColor;
  final Widget? title;
  final PreferredSizeWidget? bottom;
  final double height;
  final double elevation;
  final Widget? leading;
  final bool automaticallyImplyLeading;
  final Brightness? statusBarIconBrightness;

  @override
  Widget build(BuildContext context) {
    return AppBar(
        title: title,
        centerTitle: true,
        automaticallyImplyLeading: automaticallyImplyLeading,
        leading: leading,
        backgroundColor:
            statusBarColor ?? Theme.of(context).scaffoldBackgroundColor,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor:
              statusBarColor ?? Theme.of(context).scaffoldBackgroundColor,
          statusBarIconBrightness: statusBarIconBrightness ?? Brightness.dark,
        ),
        elevation: elevation,
        bottom: bottom);
  }

  @override
  Size get preferredSize => Size.fromHeight(height);
}
