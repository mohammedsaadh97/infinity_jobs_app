import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:infinityjobs_app/core/widgetss/popular_job.dart';
import 'package:infinityjobs_app/core/widgetss/search_bar.dart';
import 'package:infinityjobs_app/core/widgetss/top_company.dart';
import 'package:infinityjobs_app/utilities/color_constant.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String greetingTime = "";
  SharedPreferences? _prefs;

  @override
  void initState() {
    super.initState();
    loadUserData();
    greeting();
  }

  String greeting() {
    var hour = DateTime.now().hour;
    if (hour < 12) {
      return greetingTime = 'Good Morning,';
    }
    if (hour < 17) {
      return greetingTime ='Good Afternoon,';
    }
    return greetingTime ='Good Evening,';
  }
  String? _userName;
  String? _userImage;
  String? _userId;

  Future<void> loadUserData() async {

    _prefs = await SharedPreferences.getInstance();
    setState(() {
      _userId = _prefs!.getString('userId') ?? '';
    });

    DocumentSnapshot<Map<String, dynamic>> snapshot =
    await FirebaseFirestore.instance.collection('users').doc(_userId).get();

    if (snapshot.exists) {
      Map<String, dynamic> userData = snapshot.data()!;
      setState(() {
        _userName = userData['name'];
        _userImage = userData['profileImage'];
      });
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
                      ? Center(child: CircularProgressIndicator(color: ColorConstant.AppGreencolor,)) // Display CircularProgressIndicator if _profileImage is null
                      : Image.network(_userImage!, fit: BoxFit.cover),
                ),
              ),
              const SizedBox(width: 15,),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    greetingTime,
                    style: TextStyle(
                        fontSize: 17.0,
                        color: Colors.grey),
                  ),
                  SizedBox(height: 5,),
                  Text(
                    _userName?.toUpperCase() ??
                        "Job Seeker".toUpperCase(),
                    style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight. bold,
                        color: Colors.white),
                  ),
                ],
              ),
            ],
          ),
          // FaIcon(FontAwesomeIcons.bell,color: AppColors.whiteshade ),
        ],
      ),
    );
  }

  Widget HomeWidget(){
    return Padding(
      padding: const EdgeInsets.only(left: 20.0,right: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 10.0,),
          SearchBarUi(),
          SizedBox(height: 10.0,),
          TopCompanies(isBottomNavVisible: false),
          SizedBox(height: 10.0,),
          PopularJobs(),

        ],
      ),
    );
  }

}
