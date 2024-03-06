import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math';

class WatchAdsScreen extends StatefulWidget {
  @override
  _WatchAdsScreenState createState() => _WatchAdsScreenState();
}

class _WatchAdsScreenState extends State<WatchAdsScreen> {
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
      points += (prefs.getInt('points') ?? 20); // Add to existing points
    });
  }


  _savePoints(int points) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('points', points);
  }

  void _loadAd() {
    RewardedAd.load(
        adUnitId: "",
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


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Earn Points'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Watch Ads Here'),

            // ElevatedButton(
            //   onPressed: () {
            //     _watchAdsCompleted(context);
            //   },
            //   child: Text('Watch Ads Completed'),
            // ),
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
            Visibility(
              visible: _showWatchVideoButton,
              child: TextButton(
                onPressed: () {
                  _watchAdsCompleted(context);
                },
                child: const Text('Watch video for additional 2 coins'),
              ),
            ),
            Text(
              'Points: $points',
              style: TextStyle(fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }

  void _watchAdsCompleted(BuildContext context) async {
    setState(() => _showWatchVideoButton = false);
    _rewardedAd?.show(onUserEarnedReward:
        (AdWithoutView ad, RewardItem rewardItem) async {
      // ignore: avoid_print
      print('Reward amount: ${rewardItem.amount}');
      setState(() => points += 2 );
      await _savePoints(points);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Points increased by 2!'),
        ),
      );
      Navigator.pop(context);
    });
    // setState(() {
    //   points += 2; // Assuming user earns 10 points for watching ads
    // });
    // Return to the previous screen
  }
}





class PointSystem extends StatefulWidget {
  @override
  _PointSystemState createState() => _PointSystemState();
}

class _PointSystemState extends State<PointSystem> {
  int points = 20;
  int maxPoints = 100;

  @override
  void initState() {
    super.initState();
    _loadPoints();
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

  void decreasePoints() {
    setState(() {
      if (points > 0) {
        points--;
        _savePoints(points);
      }
    });
  }

  void watchAds(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => WatchAdsScreen(),
      ),
    ).then((_) {
      _loadPoints(); // Reload points when returning from WatchAdsScreen
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Point System'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Points: $points',
                style: TextStyle(fontSize: 24),
              ),
              SizedBox(height: 20),
              // if (points == 0)
              //   Text(
              //     'You don\'t have any points. Watch ads to earn points!',
              //     textAlign: TextAlign.center,
              //   )
              // else
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AnotherPage(),
                    ),
                  ).then((_) {
                    _loadPoints(); // Reload points when returning from WatchAdsScreen
                  });
                },
                child: Text('View Another Page (Decrease Points)'),
              ),
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
              SizedBox(height: 20),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            watchAds(context);
          },
          tooltip: 'Watch Ads',
          child: Icon(Icons.ad_units),
        ),
      ),
    );
  }

}




class MyPainter extends CustomPainter {
  Color? lineColor;
  Color? completeColor;
  double? completePercent;
  double? width;

  MyPainter({this.lineColor, this.completeColor, this.completePercent, this.width});

  @override
  void paint(Canvas canvas, Size size) {
    Paint line = Paint()
      ..color = lineColor!
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..strokeWidth = width!;

    Offset center = Offset(size.width / 2, size.height / 2);
    double radius = min(size.width / 2, size.height / 2);

    canvas.drawCircle(center, radius, line);

    double arcAngle = 2 * pi * (completePercent ?? 1);
    canvas.drawArc(Rect.fromCircle(center: center, radius: radius), -pi / 2, arcAngle, false, line..color = completeColor!);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}



class AnotherPage extends StatefulWidget {
  @override
  _AnotherPageState createState() => _AnotherPageState();
}

class _AnotherPageState extends State<AnotherPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Another Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Welcome to another page!'),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _decreasePoints();
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
}


