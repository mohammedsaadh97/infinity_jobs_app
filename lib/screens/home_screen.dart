import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:infinityjobs_app/screens/find_jobs_screen.dart';
import 'package:infinityjobs_app/screens/home.dart';
import 'package:infinityjobs_app/screens/my_profile_screen.dart';
import 'package:infinityjobs_app/screens/search_screen.dart';
import 'package:infinityjobs_app/utilities/color_constant.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:upgrader/upgrader.dart';

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
    _loadProfileData();
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
    return UpgradeAlert(
      canDismissDialog: false,
      showIgnore: false,
      showLater: false,
      showReleaseNotes: true,

      child: Scaffold(
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
      ),
    );
  }
}
