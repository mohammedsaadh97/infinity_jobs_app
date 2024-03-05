import 'package:flutter/material.dart';
import 'package:infinityjobs_app/utilities/text_styles.dart';

class CustomSettingsRow extends StatelessWidget {
  final String title;
  final Color color;

  const CustomSettingsRow({
    Key? key,
    required this.title,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Container(
          height: 28,
          width: 4,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        const SizedBox(
          width: 6,
        ),
        Text(
          title,
          style: KTextStyle.HeadingTextStyle,
        ),
      ],
    );
  }
}
