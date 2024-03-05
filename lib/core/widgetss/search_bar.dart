import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:infinityjobs_app/core/widgetss/SnackBarHelper.dart';
import 'package:infinityjobs_app/core/widgetss/custom_formfield_filter.dart';
import 'dart:math' as math;
import 'package:infinityjobs_app/utilities/color_constant.dart';


class SearchBarUi extends StatelessWidget {
  const SearchBarUi({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BuildSearch(context);
  }

  Widget BuildSearch(BuildContext context){
    return Row(
      children: [
        const Expanded(
          child: CustomFormFieldFilter(
            hintText: "Find your dreams job",
            obsecureText: false,
            suffixIcon: SizedBox(),
            maxLines: 1,
            textInputAction: TextInputAction.done,
            textInputType: TextInputType.none,
            prefixIcon: FaIcon(FontAwesomeIcons.search,color: ColorConstant.blackshade ),
          ),
        ),
        InkWell(
          onTap: (){
            SnackBarHelper.showSucessSnackBar(
                context,
                "Feature in progress \n  We're currently working on this feature. Stay tuned, it will be available soon!"
            );

          },
          child: Container(
            margin: const EdgeInsets.only(
                right: 0
            ),
            padding: const EdgeInsets.all(10),
            decoration: const BoxDecoration(
                color: ColorConstant.AppBluecolor,
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.all(Radius.circular(10))
            ),
            child: Transform.rotate(
              angle: 90 * math.pi / 60,
              child: FaIcon(FontAwesomeIcons.sliders,color: ColorConstant.whiteshade ),
            ),
          ),
        ),
      ],
    );
  }
}