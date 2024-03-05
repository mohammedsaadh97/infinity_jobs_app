import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  String? baseUrl;

  @override
  void initState() {
    super.initState();
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
        } else {
          // Handle if document doesn't exist
        }
      }).catchError((error) {
        // Handle errors
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
