import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:infinityjobs_app/screens/home_screen.dart';
import 'package:infinityjobs_app/screens/intro_screen.dart';
import 'package:infinityjobs_app/screens/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthenticationWrapper extends StatefulWidget {
  @override
  _AuthenticationWrapperState createState() => _AuthenticationWrapperState();
}

class _AuthenticationWrapperState extends State<AuthenticationWrapper> {
  bool _isLoggedIn = false;
  bool _introShown = false;
  String? baseUrl;
  @override
  void initState() {
    super.initState();
    checkIntroStatus();
    checkLoginStatus();
    fetchBaseUrl();
  }

  Future<void> fetchBaseUrl() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? storedUrl = prefs.getString('baseUrl');
    if (storedUrl != null) {
      setState(() {
        baseUrl = storedUrl;
      });
    } else {
      FirebaseFirestore.instance.collection('config').doc('config_url').get().then((doc) {
        if (doc.exists) {
          setState(() {
            baseUrl = doc['base_url'];
          });
          prefs.setString('baseUrl', baseUrl!);
          print("base url check");
          print(baseUrl);
        } else {
          print("base url not check");
          // Handle if document doesn't exist
        }
      }).catchError((error) {
        // Handle errors
      });
    }
  }

  Future<void> checkIntroStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _introShown = prefs.getBool('introShown') ?? false;
    });
  }

  Future<void> checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    });
  }

  void setLoggedIn(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isLoggedIn', value);
    setState(() {
      _isLoggedIn = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _introShown
        ? _isLoggedIn
        ? HomeScreen()
        : LoginScreen(setLoggedIn)
        : IntroScreen((value) {
      setState(() {
        _introShown = value;
      });
    });
  }
}

