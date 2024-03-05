import 'package:flutter/material.dart';
import 'package:infinityjobs_app/screens/find_jobs_screen.dart';
import 'package:infinityjobs_app/services/next_screen.dart';


class CustomFormFieldFilter extends StatelessWidget {
  final String hintText;
  final bool obsecureText;
  final Widget suffixIcon;
  final Widget prefixIcon;
  final TextInputType textInputType;
  final TextInputAction textInputAction;
  final int maxLines;

  const CustomFormFieldFilter(
      {Key? key,
      required this.hintText,
      required this.obsecureText,
      required this.suffixIcon,
        required this.prefixIcon,
      required this.textInputType,
      required this.textInputAction,
      required this.maxLines})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(left: 20, right: 10),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: TextField(
              onTap: (){
                nextScreen(context, FindJobsScreen(isBottomNavVisible: true,));
              },
              maxLines: maxLines,
              readOnly: true,
            //  controller: controller,
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
