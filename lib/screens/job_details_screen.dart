import 'dart:io' show Platform;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:infinityjobs_app/core/config/config.dart';
import 'package:infinityjobs_app/core/widgetss/bookmark_button.dart';
import 'package:infinityjobs_app/core/widgetss/custom_appbar_widget.dart';
import 'package:infinityjobs_app/core/widgetss/custom_settings_row.dart';
import 'package:infinityjobs_app/core/widgetss/icon_row_details_widget.dart';
import 'package:infinityjobs_app/core/widgetss/icon_row_widget.dart';
import 'package:infinityjobs_app/models/search_query_response.dart';
import 'package:infinityjobs_app/utilities/app_constant.dart';
import 'package:infinityjobs_app/utilities/color_constant.dart';
import 'package:infinityjobs_app/utilities/text_styles.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/link.dart';

const int maxFailedLoadAttempts = 3;

class JobDetailsScreen extends StatefulWidget {
  final SearchQueryResponseData searchData;
  JobDetailsScreen({required this.searchData,super.key});

  @override
  State<JobDetailsScreen> createState() => _JobDetailsScreenState();
}

class _JobDetailsScreenState extends State<JobDetailsScreen> {
  // Admob Ads -- START --

  InterstitialAd? interstitialAdAdmob;
  bool? _interstitialAdEnabled = true;
  bool? get interstitialAdEnabled => _interstitialAdEnabled;

  bool _isAdLoaded = false;
  bool get isAdLoaded => _isAdLoaded;

  void createInterstitialAdAdmob() {
    InterstitialAd.load(
        adUnitId: "ca-app-pub-9359300919229462/4970629149",
        request: AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (InterstitialAd ad) {
            print('$ad loaded');
            interstitialAdAdmob = ad;
            _isAdLoaded = true;
            showInterstitialAdAdmob();
          },
          onAdFailedToLoad: (LoadAdError error) {
            print('InterstitialAd failed to load: $error.');
            interstitialAdAdmob = null;
            _isAdLoaded = false;
          },
        ));
  }


  void showInterstitialAdAdmob() {
    if(interstitialAdAdmob != null){

      interstitialAdAdmob!.fullScreenContentCallback = FullScreenContentCallback(
        onAdShowedFullScreenContent: (InterstitialAd ad) => print('ad onAdShowedFullScreenContent.'),
        onAdDismissedFullScreenContent: (InterstitialAd ad) {
          print('$ad onAdDismissedFullScreenContent.');
          ad.dispose();
          interstitialAdAdmob = null;
          _isAdLoaded = false;
          _decreasePoints();
        },
        onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
          print('$ad onAdFailedToShowFullScreenContent: $error');
          ad.dispose();
          interstitialAdAdmob = null;
          _isAdLoaded = false;
        },
      );
      interstitialAdAdmob!.show();
      interstitialAdAdmob = null;
    }
  }

  //enbale only one
  void loadAds (){
    createInterstitialAdAdmob();  //admob
    //createInterstitialAdFb(); //fb
  }
  _decreasePoints() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int points = (prefs.getInt('points') ?? 20);

    if (points == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Points already at 0!'),
        ),
      );
      return; // No need to proceed further
    }

    points--;

    await prefs.setInt('points', points);

    if (points == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Points decreased to 0!'),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Points decreased!'),
        ),
      );
    }
  }



  @override
  void initState() {
    super.initState();
    loadAds();

  }

  void _shareApp() {
    Share.share(AppConstants.sharingText);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Job Details',
        onBackPressed: () {
          Navigator.of(context).pop();
          // Add functionality for back button press
        },
        showShareButton: true,
        onSharePressed: () {
          _shareApp();
        },
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 20.0,right: 20.0,top: 20),
          child: Column(
            children: [
              HeadWidget(context),
              SizedBox(height: 20.0,),
              ExpDetailsWidget(context),
              Divider(),
              SizedBox(height: 20.0,),
              DescriptionWidget(context),
              SizedBox(height: 20.0,),
            ],
          ),
        ),
      ),
        bottomNavigationBar:BottomWidget(context)
    );


  }
  
  Widget HeadWidget(BuildContext context, ){
    String text = widget.searchData.button1Title!;
    int index = text.indexOf("on");
    String? source = text.substring(index + "on".length).trim();
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 100,
          width: 80,
          padding: EdgeInsets.all(2),
          decoration: BoxDecoration(color: Colors.white,borderRadius: BorderRadius.all(Radius.circular(5)),
            boxShadow: [
              BoxShadow(color: ColorConstant.AppBluecolor, spreadRadius: 3),
            ],
          ),
          child: CachedNetworkImage(
            imageUrl: widget.searchData.logo ?? Config().defaultComanyImage,
            fit: BoxFit.fill,
            filterQuality: FilterQuality.high,
            //height: MediaQuery.of(context).size.height,
            placeholder: (context, url) => Container(color: Colors.grey[300]),
            errorWidget: (context, url, error) => Container(
              color: Colors.grey[300],
              child: Icon(Icons.error),
            ),
          ),
        ) ,
        SizedBox(width: 10.0,),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child:
                    Text( widget.searchData.title!,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      style :KTextStyle.titleDetailsTextStyle,
                    ),
                  )//Icon(Icons.bookmark_border, size: 28),
                ],
              ),
              Text( widget.searchData.company!,
                  style: TextStyle(color: ColorConstant.AppBluecolor,fontSize: 16,   fontWeight: FontWeight.w500,)),
              Align(
                alignment: Alignment.bottomRight,
                child:  IconRowWidget(
                  icon: FontAwesomeIcons.globe,
                  text:  source,
                ),
              ),
            ],

          ),
        ),
      ],
    );
  }

  Widget ExpDetailsWidget(BuildContext context){
    return Column(
      children: [
        IconRowDetailsWidget(
          icon: FontAwesomeIcons.locationDot,
          text:  widget.searchData.companyLocation!,
        ),
        SizedBox(height: 10.0,),
        widget.searchData.salary != null
        ? IconRowDetailsWidget(
          icon: FontAwesomeIcons.wallet,
          text:   widget.searchData.salary ?? "",
        ): Container(),
        SizedBox(height: 10.0,),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            widget.searchData.jobPosted != null
            ? IconRowDetailsWidget(
              icon: FontAwesomeIcons.businessTime,
              text:  widget.searchData.jobPosted ?? "",
            ): Container(),
            IconRowDetailsWidget(
              icon: FontAwesomeIcons.briefcase,
              text:   widget.searchData.jobType!,
            ),
          ],
        )

      ],
    );
  }

  Widget DescriptionWidget(BuildContext context){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomSettingsRow(
          title: 'Job  Description',
          color:ColorConstant.AppGreencolor,
        ),
        SizedBox(height: 10.0,),
        Text(
            widget.searchData.jobDescription!,
            style: TextStyle(
                letterSpacing: -0.6,
                color: ColorConstant.blackColor,
                fontSize: 16)
        ),
      ],
    );
  }

  Widget BottomWidget(BuildContext context){
    return  Row(
      children: [
        BookmarkButton(searchData: widget.searchData,),
          // Material(
          //   color: Colors.transparent, // Set the color to transparent to allow the ink splash to be visible
          //   child: InkWell(
          //     onTap: () async {
          //       await DatabaseHelper.insertBookmark(widget.searchData);
          //     },
          //     child: Container(
          //       height: kToolbarHeight,
          //       width: 100,
          //       child: Center(
          //           child: Icon(Icons.bookmark)
          //       ),
          //     ),
          //   ),
          // ),
        Expanded(
          child: Material(
            color: ColorConstant.AppBluecolor,
            child: InkWell(
              onTap: () {
                ApplyButton();
              },
              child: const SizedBox(
                height: kToolbarHeight,
                width: double.infinity,
                child: Center(
                  child: Text(
                    'Apply Now',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }


  ApplyButton(){
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(15.0)),
      ),
      builder: (BuildContext context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Apply On',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ),
            Link(
              uri: Uri.parse(
                  widget.searchData.button1Href!),
              target: LinkTarget.blank,
              builder: (BuildContext ctx, FollowLink? openLink) {
                return _buildBottomSheetItem(
                  icon: Icons.language,
                  color: Colors.white,
                  text:  widget.searchData.button1Title!,
                  onPressed: openLink!,
                );
              },
            ),
            Divider(),
            widget.searchData.button2Title != null
            ? Link(
              uri: Uri.parse(
                  widget.searchData.button2Href!),
              target: LinkTarget.blank,
              builder: (BuildContext ctx, FollowLink? openLink) {
                return _buildBottomSheetItem(
                  icon: Icons.language,
                  color: Colors.white,
                  text:  widget.searchData.button2Title!,
                  onPressed: openLink!,
                );
              },
            ): Container(),
            SizedBox(height: 20.0,)
          ],
        );
      },
    );
  }
    Widget _buildBottomSheetItem({
      required IconData icon,
      required Color color,
      required String text,
      required VoidCallback onPressed,
    }) {
      return GestureDetector(
        onTap: onPressed,
        child: Container(
          padding: EdgeInsets.only(left: 20,right: 20.0,top: 0,bottom: 10),
          child: Row(
            children: [
              Container(
                height: 30,
                width: 30,
                decoration: BoxDecoration(
                    color:  ColorConstant.AppBluecolor,
                    borderRadius: BorderRadius.circular(5)
                ),
                child:  Icon(
                  icon,
                  color: color,
                ),
              ),
              SizedBox(width: 10),
              Text(
                  text,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      letterSpacing: -0.6,
                      color: ColorConstant.blackshade, fontSize: 18)
              ),
            ],
          ),
        ),
      );
    }


}
