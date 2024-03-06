import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:infinityjobs_app/core/config/config.dart';
import 'package:infinityjobs_app/core/widgetss/SnackBarHelper.dart';
import 'package:infinityjobs_app/core/widgetss/checkinternetconnection.dart';
import 'package:infinityjobs_app/core/widgetss/custom_painter_widget.dart';
import 'package:infinityjobs_app/core/widgetss/custom_settings_row.dart';
import 'package:infinityjobs_app/core/widgetss/no_internet_dailog.dart';
import 'package:infinityjobs_app/screens/edit_profile_screen.dart';
import 'package:infinityjobs_app/screens/infinify_work_screen.dart';
import 'package:infinityjobs_app/screens/my_jobs_screen.dart';
import 'package:infinityjobs_app/screens/reward_points_screen.dart';
import 'package:infinityjobs_app/services/authentication_wrapper.dart';
import 'package:infinityjobs_app/services/next_screen.dart';
import 'package:infinityjobs_app/utilities/app_constant.dart';
import 'package:infinityjobs_app/utilities/color_constant.dart';
import 'package:infinityjobs_app/utilities/text_styles.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class MyProfileScreen extends StatefulWidget {
  const MyProfileScreen({super.key});

  @override
  State<MyProfileScreen> createState() => _MyProfileScreenState();
}

class _MyProfileScreenState extends State<MyProfileScreen> {
  String? _userName;
  String? _userEmail;
  String? _userJobTitle;
  String? _userImage;
  SharedPreferences? _prefs;
  String? _userId;
  int points = 20;
  int maxPoints = 100;

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
  Future<void> loadUserData() async {

    _prefs = await SharedPreferences.getInstance();
    setState(() {
      _userId = _prefs!.getString('userId') ?? '';
      _userEmail = _prefs!.getString('email') ?? '';
    });

    DocumentSnapshot<Map<String, dynamic>> snapshot =
    await FirebaseFirestore.instance.collection('users').doc(_userId).get();

    if (snapshot.exists) {
      Map<String, dynamic> userData = snapshot.data()!;
      setState(() {
        _userName = userData['name'];
        _userEmail = userData['email'];
        _userJobTitle = userData['jobTitle'];
        _userImage = userData['profileImage'];
      });
    }
  }


  @override
  void initState() {
    super.initState();
    _checkConnection();
    loadUserData();
    _loadPoints();
  }
  Future<void> _checkConnection() async {
    if (!await checkInternetConnection()) {
      DialogUtils.showConnectionDialog(context);
    }
  }



  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Stack(
          children: [
            Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              color: ColorConstant.AppBluecolor,
            ),
            Column(
              children: [
                BuildHeader(context),
              ],
            ),
            Positioned(
              top: MediaQuery.of(context).size.height * 0.10,
              bottom: MediaQuery.of(context).size.height * 0.0,
              left: 0, /// <-- fixed here
              right: 0,
              child: Container(
                height: MediaQuery.of(context).size.height * 0.9,
                width: MediaQuery.of(context).size.width,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10)
                  ),
                ),
                child: SingleChildScrollView(
                    child:HomeWidget()
                ),
              ),
            ),
          ],
        )
    );
  }

  Widget BuildHeader(BuildContext context){
    return Padding(
      padding: const EdgeInsets.only(top: 10.0,left: 20.0,right: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10), // Image border
                child: SizedBox.fromSize(
                  size: Size.fromRadius(30), // Image radius
                  child: _userImage == null
                      ? Center(child: CircularProgressIndicator()) // Display CircularProgressIndicator if _profileImage is null
                      : Image.network(_userImage!, fit: BoxFit.cover),
                ),
              ),
              const SizedBox(width: 15,),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _userName?.toUpperCase() ??
                        "Job Seeker".toUpperCase(),
                    style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight. bold,
                        color: Colors.white),
                  ),
                  SizedBox(height: 5.0,),
                  Text(
                    _userJobTitle?.toUpperCase() ??
                        "Software Developer".toUpperCase(),
                    style: TextStyle(
                        fontSize: 17.0,
                        color: Colors.grey),
                  ),
                ],
              ),
            ],
          ),
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 60,
                height: 60,
                child: InkWell(
                  onTap: (){
                    nextScreen(context, RewardPointsScreen()).then((_) {
                      _loadPoints(); // Reload points after returning from RewardPointsScreen
                    });
                    //nextScreen(context, RewardPointsScreen());
                  },
                  child: CustomPaint(
                    foregroundPainter: MyPainter(
                      lineColor: Colors.grey,
                      completeColor:  points / maxPoints <= 0.89 ? Colors.green : Colors.grey,
                      completePercent:  points / maxPoints,
                      width: 4.0,
                    ),
                    child: Center(
                      child: Text(
                        '$points/$maxPoints',
                        style: TextStyle(
                          fontSize: 12.0,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget HomeWidget(){
    return Padding(
      padding: const EdgeInsets.only(left: 20.0,right: 20.0),
      child: Column(
        children: [
          SizedBox(height: 20.0,),
          const CustomSettingsRow(
            title: 'Account Settings',
            color:ColorConstant.AppGreencolor,
          ),
          SizedBox(height: 20.0,),
          ProfileListWidget(context,Icons.mail, _userEmail ?? "",() {
            SnackBarHelper.showWarningSnackBar(
                context, "You can't change the Email");
          },),
          Divider(),
          SizedBox(height: 10.0,),
          ProfileListWidget(context,Icons.edit_note,"Edit Profile",() {
            nextScreen(context, EditProfileScreen(_userId!,_userEmail!));
          },),
          Divider(),
          SizedBox(height: 10.0,),
          ProfileListWidget(context,Icons.ads_click,"My Points",() {
            nextScreen(context, RewardPointsScreen()).then((_) {
              _loadPoints(); // Reload points after returning from RewardPointsScreen
            });
          },),
          Divider(),
          SizedBox(height: 10.0,),
          ProfileListWidget(context,Icons.exit_to_app,"Logout",() {
            openLogoutDialog(context);
          },),
          SizedBox(height: 30.0,),
          const CustomSettingsRow(
            title: 'General Settings',
            color:ColorConstant.AppGreencolor,
          ),
          SizedBox(height: 20.0,),
          ProfileListWidget(context,Icons.data_saver_off_outlined,"My Save jobs",() {
            nextScreen(context, MyJobsScreeen());
          },),
          Divider(),
          SizedBox(height: 10.0,),
          ProfileListWidget(context,Icons.email_outlined,"Contact Us",() {
            _launchEmail();
          },),
          Divider(),
          SizedBox(height: 10.0,),
          ProfileListWidget(context,Icons.share,"Share this App",() {
            _shareApp();
          },),
          Divider(),
          SizedBox(height: 10.0,),
          ProfileListWidget(context,Icons.star,"Rate this App",() {
            _launchAppOnPlayStore();
          },),
          Divider(),
          SizedBox(height: 10.0,),
          ProfileListWidget(context,Icons.policy,"Privacy Policy",() {
            launchUrlSite(url: Config().privacyPolicyUrl);
          },),
          Divider(),
          SizedBox(height: 10.0,),
          ProfileListWidget(context,Icons.info_outline,"About Us",() {
            launchUrlSite(url: Config().aboutUs);
          },),
          Divider(),
          SizedBox(height: 10.0,),
          ProfileListWidget(context,Icons.question_mark,"How Infinity works",() {
            nextScreen(context, InfinityWork());
          },),
          SizedBox(height: 40.0,)


        ],
      ),
    );
  }

  Widget ProfileListWidget(BuildContext context,IconData listIcon,String listText,VoidCallback onTap){
    return  InkWell(
      onTap: onTap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
            height: 30,
            width: 30,
            decoration: BoxDecoration(
                color:  ColorConstant.AppBluecolor,
                borderRadius: BorderRadius.circular(5)
            ),
            child: Icon(listIcon, size: 20, color: Colors.white),
          ),
         const SizedBox(width: 10.0), // Adding space between the icon and text
          Text(
            listText,
            style: KTextStyle.settingsTextStyle,
          ),
          SizedBox(width: 10.0),
          Spacer(),
          Icon(Icons.arrow_forward_ios, size: 20.0, color: Colors.black),
        ],
      ),
    );

  }

  Future<void> _launchEmail() async {
    final String email = Uri.encodeComponent(Config().supportEmail);
    final Uri mail = Uri.parse("mailto:$email");

    try {
      final bool launched = await launchUrl(mail);
      if (launched) {
        // email app opened
      } else {
        // email app is not opened
        throw Exception('Could not launch email app');
      }
    } on PlatformException catch (e) {
      throw Exception('Error launching email: $e');
    }
  }
  void _shareApp() {
    Share.share(AppConstants.sharingText);
  }

  void _launchAppOnPlayStore() async {
    final Uri uri = Uri.parse(Config().playStoreLink);

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not launch $uri';
    }

  }
  Future<void> launchUrlSite({required String url}) async {
    final Uri urlParsed = Uri.parse(url);

    if (await canLaunchUrl(urlParsed)) {
      await launchUrl(urlParsed);
    } else {
      throw 'Could not launch $url';
    }
  }

Future<void> signOut(BuildContext context) async {
  try {
    await FirebaseAuth.instance.signOut();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isLoggedIn', false);
    nextScreen(context, AuthenticationWrapper());
  } catch (e) {
    SnackBarHelper.showFailedSnackBar(
        context, "Failed to sign out.", e.toString());
  }
}
  void openLogoutDialog (context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Column(
            children: [
              Icon(
                Icons.info_outline,
                color: ColorConstant.gmailColor, // Use the desired color for the icon
                size: 40.0,
              ),
              SizedBox(height: 8.0),
              Text(
                'Hold on!',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          content: Text('Are you sure you want to logout?'),
          actions: [
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                primary: ColorConstant.AppBluecolor,
                side: BorderSide(color: ColorConstant.AppBluecolor),
              ),
              onPressed: () => Navigator.pop(context),
              child: Text('No'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: ColorConstant.AppBluecolor,
              ),
              onPressed: () async {
                signOut(context);
              },
              child: Text('Yes',style: TextStyle(color: Colors.white),),
            ),
          ],
        );
      },
    );



  }

}
