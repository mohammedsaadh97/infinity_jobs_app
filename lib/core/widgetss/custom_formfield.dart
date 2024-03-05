import 'package:flutter/material.dart';
import 'package:infinityjobs_app/utilities/text_styles.dart';


class CustomFormField extends StatelessWidget {
  final String headingText;
  final String hintText;
  final bool obsecureText;
  final Widget suffixIcon;
  final Widget prefixIcon;
  final TextInputType textInputType;
  final TextInputAction textInputAction;
  final TextEditingController controller;
  final int maxLines;
  final Function(String) onchange;

  const CustomFormField(
      {Key? key,
      required this.headingText,
      required this.hintText,
      required this.obsecureText,
      required this.suffixIcon,
        required this.prefixIcon,
      required this.textInputType,
      required this.textInputAction,
      required this.controller,
      required this.maxLines,
      required this.onchange})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(
            left: 0,
            right: 0,
            bottom: 10,
          ),
          child: Text(
            headingText,
            style: KTextStyle.textFieldHintStyle,
          ),
        ),
        Container(
          margin: const EdgeInsets.only(left: 0, right: 0),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: TextField(
              onChanged: onchange,
              maxLines: maxLines,
              controller: controller,
              textInputAction: textInputAction,
              keyboardType: textInputType,
              obscureText: obsecureText,

              decoration: InputDecoration(
                  hintText: hintText,
              //    hintStyle: KTextStyle.textFieldHintStyle,
                  border: InputBorder.none,
                  prefixIcon: Padding( padding: const EdgeInsets.fromLTRB(0, 10, 0, 0), child : prefixIcon,),
                  suffixIcon: suffixIcon),
            ),
          ),
        )
      ],
    );
  }
}
