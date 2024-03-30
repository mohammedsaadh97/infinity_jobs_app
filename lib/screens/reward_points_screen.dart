import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:infinityjobs_app/core/config/config.dart';
import 'package:infinityjobs_app/core/widgetss/SnackBarHelper.dart';
import 'package:infinityjobs_app/core/widgetss/custom_appbar_widget.dart';
import 'package:infinityjobs_app/core/widgetss/custom_painter_widget.dart';
import 'package:infinityjobs_app/core/widgetss/custom_settings_row.dart';
import 'package:infinityjobs_app/utilities/color_constant.dart';
import 'package:infinityjobs_app/utilities/text_styles.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RewardPointsScreen extends StatefulWidget {
  const RewardPointsScreen({super.key});

  @override
  State<RewardPointsScreen> createState() => _RewardPointsScreenState();
}

class _RewardPointsScreenState extends State<RewardPointsScreen> {

  int points = 0;
  var _showWatchVideoButton = false;
  RewardedAd? _rewardedAd;
  int maxPoints = 100;

  @override
  void initState() {
    super.initState();
    _loadPoints();
    _loadAd();
  }

  _loadPoints() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      points = (prefs.getInt('points') ?? 20);
    });
  }

  _savePoints(int points) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('points', points);
  }

  void _loadAd() {
    RewardedAd.load(
        adUnitId: "ca-app-pub-9359300919229462/2568715134",
        request: const AdRequest(),
        rewardedAdLoadCallback: RewardedAdLoadCallback(onAdLoaded: (ad) {
          ad.fullScreenContentCallback = FullScreenContentCallback(
            // Called when the ad showed the full screen content.
            onAdShowedFullScreenContent: (ad) {},
            // Called when an impression occurs on the ad.
            onAdImpression: (ad) {},
            // Called when the ad failed to show full screen content.
            onAdFailedToShowFullScreenContent: (ad, err) {
              ad.dispose();
            },
            // Called when the ad dismissed full screen content.
            onAdDismissedFullScreenContent: (ad) {
              ad.dispose();
            },
            // Called when a click is recorded for an ad.
            onAdClicked: (ad) {},
          );

          // Keep a reference to the ad so you can show it later.
          _rewardedAd = ad;
          setState(() {
            _showWatchVideoButton = true;
          });
        }, onAdFailedToLoad: (LoadAdError error) {
          // ignore: avoid_print
          print('RewardedAd failed to load: $error');
        }));
  }


  void _watchAdsCompleted(BuildContext context) async {
    setState(() => _showWatchVideoButton = false);
    _rewardedAd?.show(onUserEarnedReward:
        (AdWithoutView ad, RewardItem rewardItem) async {
      print('Reward amount: ${rewardItem.amount}');
      setState(() => points += 2 );
      await _savePoints(points);
      SnackBarHelper.showSucessSnackBar(
          context, "Points increased by 2!");
    });
    _loadAd();

  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "My Points",
        onBackPressed: () {
          Navigator.of(context).pop();
          // Add functionality for back button press
        },
        showShareButton: false,
        onSharePressed: () {
          // Add functionality for share button press
        },
      ),
      body: ListView(
        padding: EdgeInsets.all(8.0),
        children: <Widget>[
          SizedBox(height: 20),
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 100,
                height: 100,
                child: CustomPaint(
                  foregroundPainter: MyPainter(
                    lineColor: Colors.grey,
                    completeColor:  points / maxPoints <= 0.89 ? Colors.green : Colors.grey,
                    completePercent:  points / maxPoints,
                    width: 8.0,
                  ),
                  child: Center(
                    child: Text(
                      '$points/$maxPoints',
                      style: TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 30.0,),
          _showWatchVideoButton
          ? SizedBox(
            height: 48.0,
            child: Container(
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(
                    Radius.circular(8.0),
                  ),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.grey,
                        offset: Offset(1.0, 2.0),
                        blurRadius: 8.0,
                        spreadRadius: 2.0)
                  ]),
              child: Stack(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Container(
                          width: 48.0,
                          height: 48.0,
                          alignment: Alignment.centerLeft,
                          decoration: const BoxDecoration(
                            color: ColorConstant.AppBluecolor,
                            borderRadius: BorderRadius.all(
                              Radius.circular(8.0),
                            ),
                          ),
                          child: Align(
                              alignment: Alignment.center,
                              child: Icon(Icons.ad_units,color: ColorConstant.AppGreencolor,))),
                      Expanded(
                          child: Center(
                            child: Text("Click to Receive 2 points.",
                                style: KTextStyle.titleTextStyle),
                          )),
                    ],
                  ),
                  SizedBox.expand(
                    child: Material(
                      type: MaterialType.transparency,
                      child: InkWell(onTap: () {
                        _watchAdsCompleted(context);
                      }),
                    ),
                  ),
                ],
              ),
            ),
          )
            : Container(
              height: 200,
              child: Lottie.asset(Config().pleaseWait)),


          SizedBox(height: 40.0,),
          CustomSettingsRow(
            title: 'Point System Guidelines',
            color:ColorConstant.AppGreencolor,
          ),
          customListTile(
            icon: Icons.star,
            title: 'Initial Points',
            description: 'When a user first joins the app, they receive 20 points as a starting balance.',
          ),
          Divider(),
          customListTile(
            icon: Icons.remove_circle_outline,
            title: 'Point Deduction',
            description: 'Each time a user views a job description, 1 point is deducted from their balance.',
          ),
          Divider(),
          customListTile(
            icon: Icons.ad_units,
            title: 'Zero Balance',
            description: 'If a user\'s points balance reaches 0, ads will start to appear as they view job descriptions.',
          ),
          Divider(),
          customListTile(
            icon: Icons.visibility_off,
            title: 'Ad-Free Experience',
            description: 'Users can browse job descriptions without ads as long as they have points.',
          ),
          Divider(),
          customListTile(
            icon: Icons.video_collection,
            title: 'Watching Ads',
            description: 'Users have the option to watch ads to earn more points.',
          ),
          Divider(),
          customListTile(
            icon: Icons.double_arrow,
            title: '2X Points',
            description: 'For each ad a user watches, they receive double the points they would normally lose for viewing a job description (i.e., 2 points).',
          ),
          Divider(),
          customListTile(
            icon: Icons.refresh,
            title: 'Earning Points',
            description: 'Watching ads is the primary way to replenish points once they\'ve run out or are running low.',
          ),
          Divider(),
          customListTile(
            icon: Icons.thumb_up,
            title: 'Incentive to Watch Ads',
            description: 'The 2X points reward acts as an incentive for users to engage with ads.',
          ),
          Divider(),
          customListTile(
            icon: Icons.lock_open,
            title: 'Continuous Access',
            description: 'By watching ads, users can continue to access job descriptions ad-free.',
          ),
          Divider(),
          customListTile(
            icon: Icons.balance,
            title: 'Balance Management',
            description: 'Users must manage their points balance to maintain an ad-free experience while using the app.',
          ),
        ],
      ),
    );
  }

  Widget customListTile({required IconData icon, required String title, required String description}) {
    return ListTile(
      leading: Icon(icon,color: ColorConstant.AppBluecolor,),
      title: Text(title,style: KTextStyle.titleTextStyle,),
      subtitle: Text(description),
    );
  }
}