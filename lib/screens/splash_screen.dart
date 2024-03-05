import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:infinityjobs_app/screens/profile_screen.dart';
import 'package:infinityjobs_app/services/authentication_wrapper.dart';
import 'package:infinityjobs_app/utilities/image_constant.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreenView extends StatefulWidget {
  @override
  _SplashScreenViewState createState() => _SplashScreenViewState();
}

class _SplashScreenViewState extends State<SplashScreenView> {


  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 3), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => AuthenticationWrapper()),
      );
    });

  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Container(
          height: 200,
            width: 200,
            child: Image.asset(ImageConstants.appLogo)), // Replace 'logo.png' with your image asset path
      ),
    );
  }
}
