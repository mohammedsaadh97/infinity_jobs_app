import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:infinityjobs_app/core/widgetss/custom_appbar_widget.dart';
import 'package:infinityjobs_app/core/widgetss/custom_formfield.dart';
import 'package:infinityjobs_app/core/widgetss/custom_settings_row.dart';
import 'package:infinityjobs_app/core/widgetss/formfield_autocomplte.dart';
import 'package:infinityjobs_app/core/widgetss/top_company.dart';
import 'package:infinityjobs_app/models/Skill_locationData.dart';
import 'package:infinityjobs_app/screens/search_result_screen.dart';
import 'package:infinityjobs_app/services/next_screen.dart';
import 'package:infinityjobs_app/utilities/color_constant.dart';
import 'package:infinityjobs_app/utilities/const.dart';
import 'package:infinityjobs_app/utilities/text_styles.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FindJobsScreen extends StatefulWidget {
  final bool isBottomNavVisible;
  FindJobsScreen({this.isBottomNavVisible = true , Key? key});

  @override
  State<FindJobsScreen> createState() => _FindJobsScreenState();
}

class _FindJobsScreenState extends State<FindJobsScreen> {
  TextEditingController _jobTitleQueryController = TextEditingController();
  TextEditingController _locationController = TextEditingController();
  List<String> _recentSearches = [];

  @override
  void initState() {
    super.initState();
    _loadRecentSearches();
  }

  void _loadRecentSearches() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _recentSearches = prefs.getStringList('recent_searches') ?? [];
    });
  }

  void _saveRecentSearch(String query) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      if (!_recentSearches.contains(query)) {
        _recentSearches.insert(0, query);
        if (_recentSearches.length > 5) {
          _recentSearches.removeLast();
        }
        prefs.setStringList('recent_searches', _recentSearches);
      }
    });
  }

  void _removeRecentSearch(int index) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _recentSearches.removeAt(index);
      prefs.setStringList('recent_searches', _recentSearches);
    });
  }

  String? checktext;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     body: Stack(
          children: [
            Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              color: ColorConstant.AppBluecolor,
            ),
            Column(
              children: [
                // if (widget.isBottomNavVisible)
                // Text("data"),
                BuildHeader(context),
              ],
            ),
            Positioned(
              top: MediaQuery.of(context).size.height * 0.35,
              bottom: MediaQuery.of(context).size.height * 0.0,
              left: 0, /// <-- fixed here
              right: 0,
              child: Container(
                height: MediaQuery.of(context).size.height * 0.35,
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
        ),

    );
  }

  Widget BuildHeader(BuildContext context){
    return Padding(
      padding: const EdgeInsets.only(left: 20.0,right: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 30.0,),
         /* Row(
            children: [
              FaIcon(FontAwesomeIcons.searchengin,size: 30.0,
                  color: ColorConstant.AppGreencolor),
              SizedBox(width: 10.0,),
              Text("5k Jobs Available", style : TextStyle(color: Colors.white,fontSize: 20),),
            ],
          ),*/
          SizedBox(height: 20.0,),
        const  Text("Job Title",
           style: KTextStyle.textFieldHintStyle,
            ),
        const SizedBox(height: 10.0,),
        RawAutocomplete(
            optionsBuilder: (TextEditingValue textEditingValue) {
              _jobTitleQueryController.text =textEditingValue.text;
              if (textEditingValue.text == '') {
                return const Iterable<String>.empty();
              } else {
                List<String> matches = <String>[];
                matches.addAll(LocationJobTitleData.jobTitles);

                matches.retainWhere((s) {
                  return s.toLowerCase().contains(textEditingValue.text.toLowerCase());
                });
                return matches;
              }

            },
            onSelected: (String selection) {
              print('You just selected $selection');
              _jobTitleQueryController.text = selection;
            },
            fieldViewBuilder: (BuildContext context, TextEditingController textEditingController,
                FocusNode focusNode,
                VoidCallback onFieldSubmitted) {
              return TextFormField(
                decoration: InputDecoration(
                  hintText: "Ex:Skill, Designations",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  prefixIcon: Icon(Icons.cases_rounded,color: ColorConstant.AppGreencolor,),
                  filled: true, // Set filled to true
                  fillColor: Colors.white, // Set background color to white
                  hintStyle: TextStyle(color: ColorConstant.blackshade), // Set hint text color to white
                  contentPadding: EdgeInsets.all(8.0), // Adjust content padding as needed
                ),
                controller: textEditingController,
                focusNode: focusNode,
                onFieldSubmitted: (_) {
                  textEditingController.text = _jobTitleQueryController.text;
                },
              //  onSubmitted: (String value) {},
                style: TextStyle(color: Colors.black), // Set text color to white
              );
            },
         // textEditingController: _jobTitleQueryController,
            optionsViewBuilder: (BuildContext context, void Function(String) onSelected,
                Iterable<String> options) {
              return Material(
                child: SizedBox(
                  height: 200,
                  child: SingleChildScrollView(
                    child: Column(
                      children: options.map((opt) {
                        return InkWell(
                          onTap: () {
                            onSelected(opt);
                          },
                          child: Container(
                            padding: EdgeInsets.only(right: 60),
                            child: Container(
                              width: double.infinity,
                              padding: EdgeInsets.all(10),
                              child: Text(opt),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 10.0,),
          const  Text("Location",
            style: KTextStyle.textFieldHintStyle,
          ),
          const SizedBox(height: 10.0,),
          RawAutocomplete(
            optionsBuilder: (TextEditingValue textEditingValue) {
              _locationController.text =textEditingValue.text;
              if (textEditingValue.text == '') {
                return const Iterable<String>.empty();
              } else {
                List<String> matches = <String>[];
                matches.addAll(LocationJobTitleData.locations);

                matches.retainWhere((s) {
                  return s.toLowerCase().contains(textEditingValue.text.toLowerCase());
                });
                return matches;
              }
            },
            onSelected: (String selection) {
              print('You just selected $selection');
              _locationController.text = selection;
            },
            fieldViewBuilder: (BuildContext context, _locationController,
                FocusNode focusNode,
                VoidCallback onFieldSubmitted) {
              return TextFormField(
                decoration: InputDecoration(
                  hintText: "Location",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  prefixIcon: Icon(Icons.location_on,color: ColorConstant.AppGreencolor,),
                  filled: true, // Set filled to true
                  fillColor: Colors.white, // Set background color to white
                  hintStyle: TextStyle(color: ColorConstant.blackshade), // Set hint text color to white
                  contentPadding: EdgeInsets.all(8.0), // Adjust content padding as needed
                ),
                controller: _locationController,
                focusNode: focusNode,
                //  onSubmitted: (String value) {},
                style: TextStyle(color: Colors.black), // Set text color to white
              );
            },
            optionsViewBuilder: (BuildContext context, void Function(String) onSelected,
                Iterable<String> options) {
              return Material(
                child: SizedBox(
                  height: 200,
                  child: SingleChildScrollView(
                    child: Column(
                      children: options.map((opt) {
                        return InkWell(
                          onTap: () {
                            onSelected(opt);
                          },
                          child: Container(
                            padding: EdgeInsets.only(right: 60),
                            child: Container(
                              width: double.infinity,
                              padding: EdgeInsets.all(10),
                              child: Text(opt),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 10.0,),
          Align(
            alignment: Alignment.centerRight,
            child:  MaterialButton(
              color: ColorConstant.AppGreencolor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18.0),
              ),
              onPressed: () {
                nextScreen(context,  SearchResultScreen("Job Result",_jobTitleQueryController.text,_locationController.text,3));
                String query =
                    '${_jobTitleQueryController.text}, ${_locationController.text}';
                _saveRecentSearch(query);
              },
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Text("Search",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: ConstClass.titleTextSize)),
              ),
            ),
          )
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
          SizedBox(height: 10.0),
          if (_recentSearches.isNotEmpty) ...[
            CustomSettingsRow(
              title: 'Recent Searches:',
              color:ColorConstant.AppGreencolor,
            ),
            SizedBox(height: 5.0),
            Container(
              height: 50.0, // Adjust the height as needed
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _recentSearches.length,
                itemBuilder: (BuildContext context, int index) {
                  List<String> searchItem = _recentSearches[index].split(',');
                  String jobQuery = searchItem[0].trim(); // Trim to remove any leading/trailing spaces
                  String location = searchItem.length > 1
                      ? searchItem.sublist(1).join(',').trim() // Join with ',' and trim to remove spaces
                      : '';

                  return Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Chip(
                      label: Row(
                        children: [
                          Icon(Icons.history,color: ColorConstant.AppBluecolor,),
                          SizedBox(width: 4),
                          GestureDetector(
                            onTap: (){
                              nextScreen(context,  SearchResultScreen("Results for ${_recentSearches[index]}",jobQuery,location,3));
                            },
                              child: Text(_recentSearches[index])),
                          SizedBox(width: 4),
                          // GestureDetector(
                          //   onTap: () {
                          //     print("remove recent search");
                          //     _removeRecentSearch(index);
                          //   },
                          //   child: Icon(Icons.close,color: ColorConstant.gmailColor),
                          // ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
          Divider(),
          SizedBox(height: 10.0),
          TopCompanies(),
        ],
      ),
    );
  }

}
