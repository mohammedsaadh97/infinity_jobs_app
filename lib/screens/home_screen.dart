import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:infinityjobs_app/core/config/config.dart';
import 'package:infinityjobs_app/core/widgetss/checkinternetconnection.dart';
import 'package:infinityjobs_app/core/widgetss/no_internet_dailog.dart';
import 'package:infinityjobs_app/screens/find_jobs_screen.dart';
import 'package:infinityjobs_app/screens/home.dart';
import 'package:infinityjobs_app/screens/my_profile_screen.dart';
import 'package:infinityjobs_app/screens/search_screen.dart';
import 'package:infinityjobs_app/utilities/color_constant.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late SharedPreferences _prefs;
  late String _userId;
  late String _name;
  late String _gender;
  late String _mobile;
  late String _jobTitle;
  late String _location;
  late String _profileImage;

  @override
  void initState() {
    super.initState();
    checkForUpdate();
    _loadProfileData();
    _checkConnection();
  }

  Future<String> getCurrentVersion() async {
    final PackageInfo info = await PackageInfo.fromPlatform();
    return info.version;
  }

  Future<String> fetchLatestVersion() async {
    var document = FirebaseFirestore.instance.collection('config').doc('upgrade_app');
    var snapshot = await document.get();
    if (snapshot.exists && snapshot.data()!.containsKey('latest_version')) {
      return snapshot.data()!['latest_version'];
    } else {
      throw Exception('Latest version not found in Firestore');
    }
  }
  void checkForUpdate() async {
    try {
      String currentVersion = await getCurrentVersion();
      String latestVersion = await fetchLatestVersion();

      if (shouldPromptUpdate(currentVersion, latestVersion)) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          showUpdateAlert(context);
        });
      }
    } catch (e) {
      // Handle exception by showing error or a default update popup
      print(e); // Consider logging the error
    }
  }
  bool shouldPromptUpdate(String currentVersion, String latestVersion) {
    List<String> currentSplit = currentVersion.split('.');
    List<String> latestSplit = latestVersion.split('.');
    for (int i = 0; i < currentSplit.length; i++) {
      int currentNumber = int.parse(currentSplit[i]);
      int latestNumber = int.parse(latestSplit[i]);
      if (latestNumber > currentNumber) {
        return true;
      } else if (latestNumber < currentNumber) {
        return false;
      }
    }
    return false;
  }

  void showUpdateAlert(BuildContext context) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return PopScope(
          canPop: false,
          child: AlertDialog(
            title: Text('Update Available'),
            content: Text('An updated version of the app is now available. Please update to unlock premium top-tier jobs and many other exciting features.'),
            actions: <Widget>[
              ElevatedButton(
                onPressed: () {
                  _launchAppOnPlayStore();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorConstant.AppBluecolor,
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10), // Adjust padding for the button size
                ),
                child: const Text(
                  'Update Now',
                  style: TextStyle(
                    color: ColorConstant.whiteshade,
                    fontSize: 12, // Adjust the font size to make the button smaller
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }
  void _launchAppOnPlayStore() async {
    final Uri uri = Uri.parse(Config().playStoreLink);

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not launch $uri';
    }

  }


  Future<void> _checkConnection() async {
    if (!await checkInternetConnection()) {
      DialogUtils.showConnectionDialog(context);
    }
  }

  Future<void> _loadProfileData() async {
    _prefs = await SharedPreferences.getInstance();
    setState(() {
      _userId = _prefs.getString('userId') ?? '';
      _name = _prefs.getString('name') ?? '';
      _gender = _prefs.getString('gender') ?? '';
      _mobile = _prefs.getString('mobile') ?? '';
      _jobTitle = _prefs.getString('jobTitle') ?? '';
      _location = _prefs.getString('location') ?? '';
      _profileImage = _prefs.getString('profileImage') ?? '';
    });
  }
  int selectedpage =0;
  final _pageNo = [Home() , FindJobsScreen(isBottomNavVisible: false),SearchScreen() , MyProfileScreen()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: ConvexAppBar(
        backgroundColor: ColorConstant.AppBluecolor,
        style: TabStyle.flip,
        items: [
          TabItem(icon: Icons.home, title: 'Home'),
          TabItem(icon: Icons.manage_search, title: 'Search'),
          TabItem(icon: Icons.data_saver_off, title: 'My jobs'),
          TabItem(icon: Icons.person, title: 'Profile'),
        ],
        initialActiveIndex: selectedpage,
        onTap: (int index){
          setState(() {
            selectedpage = index;
          });
        },
      ),

      body:  _pageNo[selectedpage],
    );
  }
}
