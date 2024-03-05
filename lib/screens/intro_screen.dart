import 'package:flutter/material.dart';
import 'package:infinityjobs_app/core/config/config.dart';
import 'package:infinityjobs_app/utilities/color_constant.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

class IntroScreen extends StatefulWidget {
  final Function(bool) onIntroComplete;

  IntroScreen(this.onIntroComplete);

  @override
  _IntroScreenState createState() => _IntroScreenState();
}


class _IntroScreenState extends State<IntroScreen> {
  int _currentPage = 0;
  final PageController _pageController = PageController(initialPage: 0);

  final List<Map<String, String>> _introData = [
    {
      'image': Config().introJson1,
      'title': 'Find Your Dream Job',
      'subtitle': 'Explore thousands of job opportunities from various industries and locations.',
    },
    {
      'image': Config().introJson2,
      'title': 'Get Personalized Recommendations',
      'subtitle': 'Receive personalized job recommendations based on your skills and preferences.',
    },
    {
      'image': Config().introJson3,
      'title': 'Start Your Journey',
      'subtitle': 'Apply to your dream jobs effortlessly and begin your career journey today.',
    },
  ];

  void completeIntro(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('introShown', true);
    widget.onIntroComplete(true);
  }



  void _next() {
    if (_currentPage < _introData.length - 1) {
      _pageController.nextPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.ease,
      );
    } else {
      completeIntro(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: _introData.length,
            onPageChanged: (int page) {
              setState(() {
                _currentPage = page;
              });
            },
            itemBuilder: (context, index) {
              return IntroPage(
                image: _introData[index]['image']!,
                title: _introData[index]['title']!,
                subtitle: _introData[index]['subtitle']!,
              );
            },
          ),
          Positioned(
            bottom: 20.0,
            left: 0,
            right: 0,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _currentPage != _introData.length - 1
                      ? ElevatedButton(
                    onPressed: () {
                      completeIntro(context);
                    },
                    child: Text('Skip',style: TextStyle(color: ColorConstant.AppBluecolor),),
                  )
                      : SizedBox(), // Hide skip button on the last page
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: List.generate(
                      _introData.length,
                          (index) => Container(
                        margin: EdgeInsets.symmetric(horizontal: 2),
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _currentPage == index
                              ? ColorConstant.AppGreencolor
                              : ColorConstant.AppBluecolor,
                        ),
                      ),
                    ),
                  ),
                  _currentPage != _introData.length - 1
                      ? ElevatedButton(
                    onPressed: _next,
                    child: Text('Next',style: TextStyle(color: ColorConstant.AppBluecolor),),
                  )
                      : ElevatedButton(
                    onPressed: _next,
                    child: Text('Done',style: TextStyle(color: ColorConstant.AppBluecolor)),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class IntroPage extends StatelessWidget {
  final String image;
  final String title;
  final String subtitle;

  const IntroPage({
    required this.image,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Lottie.asset(image),
        SizedBox(height: 20),
        Text(
          title,
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 5),
        Divider(
          color: ColorConstant.AppGreencolor,
          thickness: 2,
          height: 1,
          indent: 50,
          endIndent: 50,
        ),
        SizedBox(height: 5),
        Text(
          subtitle,
          style: TextStyle(fontSize: 16,color: ColorConstant.AppBluecolor),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
