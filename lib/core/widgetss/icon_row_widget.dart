import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:infinityjobs_app/utilities/color_constant.dart';
import 'package:infinityjobs_app/utilities/text_styles.dart';

class IconRowWidget extends StatelessWidget {
  final IconData icon;
  final String text;

  const IconRowWidget({
    Key? key,
    required this.icon,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        FaIcon(
          icon,
          size: 20,
          color: ColorConstant.AppGreencolor,
        ),
        SizedBox(width: 8), // Add space between icon and text
        Text(
          text,
          style: KTextStyle.IconRowTextStyle,
        ),
      ],
    );
  }
}
