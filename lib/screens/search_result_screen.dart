import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:infinityjobs_app/core/notifiers/search_query_notifier.dart';
import 'package:infinityjobs_app/core/widgetss/custom_appbar_widget.dart';
import 'package:infinityjobs_app/core/widgetss/job_card_widget.dart';
import 'package:infinityjobs_app/core/widgetss/search_bar.dart';
import 'package:infinityjobs_app/core/widgetss/text_animation.dart';
import 'package:infinityjobs_app/models/search_query_response.dart';
import 'package:infinityjobs_app/screens/job_details_screen.dart';
import 'package:infinityjobs_app/services/next_screen.dart';
import 'package:infinityjobs_app/utilities/color_constant.dart';
import 'package:infinityjobs_app/utilities/const.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
class SearchResultScreen extends StatefulWidget {
  final String appBarTitle;
  final String? query;
  final String? location;
  final int? sec;
   SearchResultScreen(this.appBarTitle,this.query,this.location,this.sec,{super.key});

  @override
  State<SearchResultScreen> createState() => _SearchResultScreenState();
}

class _SearchResultScreenState extends State<SearchResultScreen> {
  int _currentIndex = 0;
  List<String> _texts = [
    'First Text',
    'Second Text',
    'Third Text',
    'Fourth Text',
    'Fifth Text',
  ];
  @override
  void initState() {
    super.initState();
    Timer.periodic(Duration(seconds: 2), (Timer timer) {
      setState(() {
        _currentIndex = (_currentIndex + 1) % _texts.length;
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (BuildContext context) => SearchQueryNotifier(context,widget.query!,widget.location!,widget.sec!),
        child:  Consumer<SearchQueryNotifier>(
            builder: (context, searchQueryNotifier, _){
              return Scaffold(
                appBar:  CustomAppBar(
                  title: widget.appBarTitle,
                  onBackPressed: () {
                    Navigator.of(context).pop();
                    // Add functionality for back button press
                  },
                  showShareButton: false,
                  onSharePressed: () {
                    // Add functionality for share button press
                  },
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
                        ? TextAnimationWidget() : ListView.builder(
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
            } ));
  }

  Widget CardWidget([SearchQueryResponseData? searchqueryResponseData]){
    return JobCardWidget(searchqueryResponseData: searchqueryResponseData!);
  }

}
