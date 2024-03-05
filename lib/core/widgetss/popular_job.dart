import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:infinityjobs_app/core/notifiers/search_query_notifier.dart';
import 'package:infinityjobs_app/core/widgetss/custom_settings_row.dart';
import 'package:infinityjobs_app/core/widgetss/job_card_widget.dart';
import 'package:infinityjobs_app/core/widgetss/text_animation.dart';
import 'package:infinityjobs_app/models/search_query_response.dart';
import 'package:infinityjobs_app/utilities/color_constant.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PopularJobs extends StatefulWidget {
  const PopularJobs({super.key});

  @override
  State<PopularJobs> createState() => _PopularJobsState();
}

class _PopularJobsState extends State<PopularJobs> {
  String? _userJobTitle;
  String? _userLocation;
  int? _sec = 2;


  Future<void> loadUserData() async {
    SharedPreferences? _prefs;
    String? _userId;
    _prefs = await SharedPreferences.getInstance();
    setState(() {
      _userId = _prefs!.getString('userId') ?? '';
    });

    DocumentSnapshot<Map<String, dynamic>> snapshot =
    await FirebaseFirestore.instance.collection('users').doc(_userId).get();

    if (snapshot.exists) {
      Map<String, dynamic> userData = snapshot.data()!;
      setState(() {
        _userJobTitle = userData['jobTitle'];
        _userLocation = userData['location'];
      });
    }
  }


  @override
  void initState() {
    super.initState();
    loadUserData();

  }
  @override
  Widget build(BuildContext context) {
    return _userJobTitle !=null && _userLocation !=null?
    ChangeNotifierProvider(
        create: (BuildContext context) => SearchQueryNotifier(context,_userJobTitle!,_userLocation!,_sec!),
        child:  Consumer<SearchQueryNotifier>(
            builder: (context, searchQueryNotifier, _){
              return  Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CustomSettingsRow(
                    title: 'Popular Infinity Jobs',
                    color:ColorConstant.AppGreencolor,
                  ),
                  SizedBox(height: 10.0,),
                  searchQueryNotifier.searchqueryResponseData.length == 0
                  ?TextAnimationWidget()
                      : ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    itemCount:searchQueryNotifier.searchqueryResponseData.length ,
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    itemBuilder: (context, index) {
                      return CardWidget(searchQueryNotifier.searchqueryResponseData[index]);

                    },),
                ],
              );
            } ))
        :Center(
          child: Container( child: TextAnimationWidget(),
              ),
        );
  }

  Widget CardWidget([SearchQueryResponseData? searchqueryResponseData]){
    return JobCardWidget(searchqueryResponseData: searchqueryResponseData!);
  }
}

