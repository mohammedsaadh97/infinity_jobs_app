import 'package:flutter/material.dart';
import 'package:infinityjobs_app/utilities/color_constant.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showBackButton;
  final Function()? onBackPressed;
  final bool showShareButton;
  final Function()? onSharePressed;

  const CustomAppBar({
    Key? key,
    required this.title,
    this.showBackButton = true,
    this.onBackPressed,
    this.showShareButton = false,
    this.onSharePressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: showBackButton
          ? IconButton(
            icon: Icon(Icons.arrow_back_ios,color: ColorConstant.AppBluecolor,),
            onPressed: onBackPressed ?? () => Navigator.of(context).pop(),
          )
          : null,
      title: Text(title),
      centerTitle: true,
      actions: showShareButton
          ? <Widget>[
        IconButton(
          icon: Icon(Icons.share,color: ColorConstant.AppBluecolor,),
          onPressed: onSharePressed,
        ),
      ]
          : null,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(40);
}
