import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:infinityjobs_app/core/config/config.dart';
import 'package:infinityjobs_app/core/widgetss/icon_row_widget.dart';
import 'package:infinityjobs_app/models/search_query_response.dart';
import 'package:infinityjobs_app/screens/job_details_screen.dart';
import 'package:infinityjobs_app/services/next_screen.dart';
import 'package:infinityjobs_app/utilities/color_constant.dart';
import 'package:infinityjobs_app/utilities/const.dart';
import 'package:infinityjobs_app/utilities/text_styles.dart';

class JobCardWidget extends StatelessWidget {
  final SearchQueryResponseData searchqueryResponseData;

  const JobCardWidget({Key? key, required this.searchqueryResponseData})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    String text = searchqueryResponseData.button1Title!;
    int index = text.indexOf("on");
    String? source = text.substring(index + "on".length).trim();
    return InkWell(
      onTap: () {
        nextScreen(context, JobDetailsScreen(searchData: searchqueryResponseData));
      },
      child: Card(
        color: Colors.white,
        elevation: 2,
        margin: EdgeInsets.all(5),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(10.0),
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
                      imageUrl: searchqueryResponseData.logo ?? Config().defaultComanyImage,
                      fit: BoxFit.fill,
                      filterQuality: FilterQuality.high,
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
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width / 1.7, // Set width according to your UI constraints
                        child: Text(
                          searchqueryResponseData.title!,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: KTextStyle.titleTextStyle,
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width / 1.7,
                        child: Text(searchqueryResponseData.company!,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          style: KTextStyle.companyTextStyle,
                           ),
                      ),
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
                  IconRowWidget(
                    icon: FontAwesomeIcons.locationDot,
                    text: searchqueryResponseData.companyLocation!,
                  ),
                  searchqueryResponseData.jobPosted  != null
                  ? IconRowWidget(
                    icon: FontAwesomeIcons.calendarDays,
                    text:  searchqueryResponseData.jobPosted ?? "",
                  ) : Container()
                ],
              ),
              SizedBox(
                height: 5.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  MaterialButton(
                    color: ColorConstant.AppBluecolor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                    ),
                    onPressed: () {
                      nextScreen(context,  JobDetailsScreen(searchData: searchqueryResponseData));
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Text("Apply",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: ConstClass.titleTextSize)),
                    ),
                  ),
                  IconRowWidget(
                    icon: FontAwesomeIcons.globe,
                    text:  source,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
