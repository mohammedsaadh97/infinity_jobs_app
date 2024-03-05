import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:infinityjobs_app/core/notifiers/search_query_notifier.dart';
import 'package:infinityjobs_app/core/widgetss/job_card_widget.dart';
import 'package:infinityjobs_app/core/widgetss/search_bar.dart';
import 'package:infinityjobs_app/core/widgetss/text_animation.dart';
import 'package:infinityjobs_app/models/search_query_response.dart';
import 'package:infinityjobs_app/utilities/color_constant.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
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
    return  _userJobTitle !=null && _userLocation !=null?
      ChangeNotifierProvider(
        create: (BuildContext context) => SearchQueryNotifier(context,_userJobTitle!,_userLocation!,2),
        child:  Consumer<SearchQueryNotifier>(
            builder: (context, searchQueryNotifier, _){
              return Scaffold(
                appBar: AppBar(
                  title:Text("Actively Hiring", style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      letterSpacing: -0.6,
                      wordSpacing: 1),),
                  centerTitle: true,
                ),
                body: Padding(
                  padding: const EdgeInsets.only(left: 20.0,right: 20.0),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        SizedBox(height: 10.0,),
                        SearchBarUi(),
                        SizedBox(height: 10.0,),
                        searchQueryNotifier.searchqueryResponseData.length == 0
                        ? TextAnimationWidget()
                        : ListView.builder(
                          itemCount:searchQueryNotifier.searchqueryResponseData.length ,
                          shrinkWrap: true,
                          scrollDirection: Axis.vertical,
                          physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 10.0),
                              child: CardWidget(searchQueryNotifier.searchqueryResponseData[index]),
                            );
                          },),
                      ],
                    ),
                  ),
                ),
              );
            } ))
        :Center( child: CircularProgressIndicator(color: ColorConstant.AppBluecolor,));
  }

  Widget CardWidget([SearchQueryResponseData? searchqueryResponseData]){
    return JobCardWidget(searchqueryResponseData: searchqueryResponseData!);
  }

}
