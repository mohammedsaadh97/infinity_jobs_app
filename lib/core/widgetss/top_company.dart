import 'package:flutter/material.dart';
import 'package:infinityjobs_app/core/config/config.dart';
import 'package:infinityjobs_app/core/widgetss/custom_settings_row.dart';
import 'package:infinityjobs_app/screens/search_result_screen.dart';
import 'package:infinityjobs_app/services/next_screen.dart';
import 'package:infinityjobs_app/utilities/color_constant.dart';
import 'package:infinityjobs_app/utilities/text_styles.dart';

class TopCompanies extends StatelessWidget {
  final bool isBottomNavVisible;
  TopCompanies({this.isBottomNavVisible = true,super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const CustomSettingsRow(
          title: 'Top Companies',
          color:ColorConstant.AppGreencolor,
        ),
        isBottomNavVisible == false
        ? SizedBox(height: 10.0,) : Container(),
        isBottomNavVisible == true
        ? ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: Config().companies.length,
          scrollDirection: Axis.vertical,
          itemBuilder: (context, index) {
            return VerticalViewWidget(context,index);
        },) :
        SizedBox(
          height: 150,
          child: ListView.builder(
            itemCount: Config().companies.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              return HorizontalViewWidget(context,index);
          },),
        ),
      ],
    );
  }

  Widget HorizontalViewWidget(BuildContext context, int index){
    return Padding(
      padding: const EdgeInsets.only(left: 8.0),
      child: Container(
        width: 140,
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(10),
        ),
        padding: EdgeInsets.all(0.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.network(
              Config().companies[index].imageUrl,
              height: 40,
              width: 40,
              fit: BoxFit.fill,
            ),
            const SizedBox(height: 5),
            Text(
              Config().companies[index].name,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: ColorConstant.AppBluecolor,
                fontSize: 12,
                fontWeight: FontWeight.normal,
              ),
            ),
            SizedBox(height: 5),
            ElevatedButton(
              onPressed: () {
                nextScreen(context,  SearchResultScreen(Config().companies[index].name,Config().companies[index].name,"India",2));
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: ColorConstant.AppBluecolor,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10), // Adjust padding for the button size
              ),
              child: const Text(
                'View Jobs',
                style: TextStyle(
                  color: ColorConstant.whiteshade,
                  fontSize: 12, // Adjust the font size to make the button smaller
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget VerticalViewWidget(BuildContext context, int index){
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: InkWell(
        onTap: (){
          nextScreen(
              context,
              SearchResultScreen(Config().companies[index].name,Config().companies[index].name,"India", 2));
        },
        child: Container(
          width: 140,
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(10),
          ),
          padding: EdgeInsets.all(8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Image.network(
                Config().companies[index].imageUrl,
                height: 40,
                width: 40,
                fit: BoxFit.fill,
              ),
              SizedBox(width: 8),
              Text(
                Config().companies[index].name,
                textAlign: TextAlign.start,
                  style: KTextStyle.IconRowDetailsTextStyle,
              ),

              Spacer(),
              Icon(Icons.arrow_forward_ios,color: ColorConstant.AppBluecolor,)
            ],
          ),
        ),
      ),
    );

  }

}
