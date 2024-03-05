import 'package:flutter/material.dart';
import 'package:infinityjobs_app/models/Skill_locationData.dart';
import 'package:infinityjobs_app/utilities/color_constant.dart';

class JobTitleWidget extends StatelessWidget {
   JobTitleWidget({super.key});

  final TextEditingController _jobTitleQueryController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return  Column(
      children: [
        Text("Job Title"),
        RawAutocomplete(
          optionsBuilder: (TextEditingValue textEditingValue) {
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
          fieldViewBuilder: (BuildContext context, _jobTitleQueryController,
              FocusNode focusNode,
              VoidCallback onFieldSubmitted) {
            return TextFormField(
              decoration: InputDecoration(
                hintText: "Skill, Designations",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                prefixIcon: Icon(Icons.cases_rounded,color: ColorConstant.AppGreencolor,),
                filled: true, // Set filled to true
                fillColor: Colors.white, // Set background color to white
                hintStyle: TextStyle(color: Colors.blueAccent), // Set hint text color to white
                contentPadding: EdgeInsets.all(8.0), // Adjust content padding as needed
              ),
              controller: _jobTitleQueryController,
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
      ],
    );
  }
}
