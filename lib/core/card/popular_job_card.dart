import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:infinityjobs_app/models/search_query_response.dart';
import 'package:infinityjobs_app/utilities/color_constant.dart';
import 'package:infinityjobs_app/utilities/const.dart';

class PopularJobCard extends StatelessWidget {
  PopularJobCard( {super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {

      },
      child: Card(
        color: Colors.white,
        elevation: 2,
        margin: EdgeInsets.all(0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                children: [
                  SizedBox(
                    height: 60,
                    width: 80,
                    child: CachedNetworkImage(
                      imageUrl: "https://i.postimg.cc/J0w5vyP7/download.png",
                      fit: BoxFit.fill,
                      placeholder: (context, url) =>
                          Container(color: Colors.grey[300]),
                      errorWidget: (context, url, error) =>
                          Container(
                            color: Colors.grey[300],
                            child: Icon(Icons.error),
                          ),
                    ),
                  ),
                  SizedBox(
                    width: 10.0,
                  ),
                const  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('',
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            letterSpacing: -0.6,
                            wordSpacing: 1),
                      ),
                      Text("NTT Data Business Solution",
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              letterSpacing: -0.6,
                              color: ColorConstant.AppBluecolor,
                              fontSize: 14)),
                    ],
                  ),
                ],
              ),
              SizedBox(
                height: 5.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  RichText(
                    text: TextSpan(
                      children: [
                        WidgetSpan(
                          child: FaIcon(FontAwesomeIcons.locationDot,
                              size: 20,
                              color: ColorConstant.AppGreencolor),
                        ),
                        TextSpan(
                            text:" India",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                letterSpacing: -0.6,
                                color: ColorConstant.blackColor,
                                fontSize: 16)
                        ),
                      ],
                    ),
                  ),

                  RichText(
                    text: TextSpan(
                      children: [
                        WidgetSpan(
                          child:  FaIcon(FontAwesomeIcons.calendarDays,
                              size: 20,
                              color: ColorConstant.AppGreencolor),
                        ),
                        TextSpan(
                            text: " 1 days ago",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                letterSpacing: -0.6,
                                color: ColorConstant.blackColor,
                                fontSize: 16)
                        ),
                      ],
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 5.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  MaterialButton(
                    color: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                    ),
                    onPressed: () {
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Text("Apply",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: ConstClass.titleTextSize)),
                    ),
                  ),
                  RichText(
                    text: TextSpan(
                      children: [
                        WidgetSpan(
                          child: FaIcon(FontAwesomeIcons.globe,
                              size: 20,
                              color: ColorConstant.AppGreencolor),
                        ),
                        TextSpan(
                            text: "  LinkedIn",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                letterSpacing: -0.6,
                                color: ColorConstant.blackColor,
                                fontSize: 16)
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
