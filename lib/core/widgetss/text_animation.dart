import 'dart:async';
import 'package:flutter/material.dart';
import 'package:infinityjobs_app/utilities/text_styles.dart';
import 'package:lottie/lottie.dart';


class TextAnimationWidget extends StatefulWidget {
  @override
  _TextAnimationWidgetState createState() => _TextAnimationWidgetState();
}

class _TextAnimationWidgetState extends State<TextAnimationWidget> {
  int _currentIndex = 0;
  List<String> _texts = [
    "Success is not the key to happiness. Happiness is the key to success.",
    "The only way to do great work is to love what you do.",
    "Believe you can and you're halfway there.",
    "Opportunities don't happen, you create them.",
    "Your time is limited, don't waste it living someone else's life."
  ];

  @override
  void initState() {
    super.initState();
    Timer.periodic(Duration(seconds: 3), (Timer timer) {
      setState(() {
        _currentIndex = (_currentIndex + 1) % _texts.length;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Lottie.asset('assets/jsons/searching.json'),
        AnimatedSwitcher(
          duration: Duration(milliseconds: 500),
          child: FadeTransition(
            key: ValueKey<String>(_texts[_currentIndex]),
            opacity: AlwaysStoppedAnimation(1.0),
            child: Text(
              _texts[_currentIndex],
              style: KTextStyle.detailsTextStyle,
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ],
    );
  }
}
