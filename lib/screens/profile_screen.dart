import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:image_picker/image_picker.dart';
import 'package:infinityjobs_app/core/config/config.dart';
import 'package:infinityjobs_app/core/widgetss/SnackBarHelper.dart';
import 'package:infinityjobs_app/models/Skill_locationData.dart';
import 'package:infinityjobs_app/screens/home_screen.dart';
import 'package:infinityjobs_app/utilities/color_constant.dart';
import 'package:infinityjobs_app/utilities/text_styles.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  final String userId,emailId;

  ProfileScreen(this.userId,this.emailId);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _jobTitleController = TextEditingController();
  final TextEditingController _jobLocationController = TextEditingController();

  String? _gender;
  List<String> _genders = ['Male','Female','Others'];
  File? _image;
  final picker = ImagePicker();

  bool _isLoading = false; // Add a variable to track loading state

  Future<void> saveProfile() async {
    setState(() {
      _isLoading = true; // Set loading state to true when saving profile
    });
    try {
      String imageUrl = await uploadImage();
      await FirebaseFirestore.instance.collection('users').doc(widget.userId).set({
        'name': _nameController.text,
        'email': widget.emailId,
        'gender': _gender,
        'mobile': _mobileController.text,
        'jobTitle': _jobTitleController.text,
        'location': _jobLocationController.text,
        'profileImage': imageUrl,
      });
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setBool('isLoggedIn', true); // Update isLoggedIn status
      // Save profile details to SharedPreferences
      prefs.setString('userId', widget.userId);
      prefs.setString('name', _nameController.text);
      prefs.setString('email', widget.emailId);
      prefs.setString('gender', _gender!);
      prefs.setString('mobile', _mobileController.text);
      prefs.setString('jobTitle', _jobTitleController.text);
      prefs.setString('location', _jobLocationController.text);
      prefs.setString('profileImage', imageUrl);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    } catch (e) {
      SnackBarHelper.showFailedSnackBar(
          context, "Failed to save profile.", e.toString());
    } finally {
      setState(() {
        _isLoading = false; // Set loading state to false after operation completes
      });
    }
  }

  Future<String> uploadImage() async {
    try {
      if (_image != null) {
        firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance.ref().child('profile_images').child('${widget.userId}.jpg');
        await ref.putFile(_image!);
        return await ref.getDownloadURL();
      }
      return 'https://i.postimg.cc/mD1sKvZ9/no-image-profile.png';
    } catch (e) {
      throw Exception('Failed to upload image: $e');
    }
  }
  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await picker.pickImage(source: source);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(left: 20.0,right: 20),
              child: Column(
                //mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 50.0,),
                Column(
                  children: [
                    Stack(
                      children: [
                        Container(
                          width: 120, // Adjust the width and height to fit your design
                          height: 120,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.grey[300],
                            border: Border.all(
                              color: ColorConstant.AppBluecolor, // Choose your border color
                              width: 5, // Adjust the border width as needed
                            ),
                            image: _image != null ? DecorationImage(
                              image: FileImage(_image!),
                              fit: BoxFit.cover,
                            ) : null,
                          ),
                          child: _image == null ? Icon(Icons.person, size: 80, color: Colors.grey) : null,
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: GestureDetector(
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text("Pick Profile Picture"),
                                    content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        TextButton(
                                          onPressed: () {
                                            _pickImage(ImageSource.camera);
                                            Navigator.pop(context);
                                          },
                                          child: Row(
                                            children: [
                                              Icon(Icons.camera_alt, color: ColorConstant.AppGreencolor),
                                              SizedBox(width: 10),
                                              Text("Open Camera", style: TextStyle(color: ColorConstant.AppBluecolor)),
                                            ],
                                          ),
                                        ),
                                        Divider(), // Add Divider here
                                        TextButton(
                                          onPressed: () {
                                            _pickImage(ImageSource.gallery);
                                            Navigator.pop(context);
                                          },
                                          child: Row(
                                            children: [
                                              Icon(Icons.photo_library, color: ColorConstant.AppGreencolor),
                                              SizedBox(width: 10),
                                              Text("Select From Gallery", style: TextStyle(color: ColorConstant.AppBluecolor)),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              );
                            },
                            child: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.grey[200],
                              ),
                              child: Icon(Icons.camera_alt, color: ColorConstant.AppGreencolor),
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),

                  SizedBox(height: 16.0),
                  CustomProfileFormField(
                    headingText: 'Name',
                    hintText: 'Enter Your Good Name',
                    obscureText: false,
                    suffixIcon: SizedBox.shrink(),
                    prefixIcon:  Icon(Icons.person, color: ColorConstant.AppGreencolor),
                    textInputType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                    controller: _nameController,
                    maxLines: 1,
                    onChanged: (value) {},
                  ),
                  SizedBox(height: 16.0),
                  CustomProfileFormField(
                    headingText: 'Mobile No',
                    hintText: 'Enter Your Mobile Number',
                    obscureText: false,
                    suffixIcon: SizedBox.shrink(),
                    prefixIcon: Icon(Icons.phone_android_rounded, color: ColorConstant.AppGreencolor),
                    textInputType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                    controller: _mobileController,
                    maxLines: 1,
                    onChanged: (value) {},
                  ),
                  SizedBox(height: 16.0),
                  CustomProfileFormField(
                    headingText: 'Gender',
                    hintText: 'Select Your Gender',
                    obscureText: false,
                    suffixIcon: SizedBox.shrink(),
                    prefixIcon: Icon(Icons.transgender, color: ColorConstant.AppGreencolor),
                    textInputType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                    controller: TextEditingController(),
                    maxLines: 1,
                    dropdownItems: _genders,
                    dropdownValue: _gender,
                    onDropdownChanged: (value) {
                      setState(() {
                        _gender = value;
                      });
                    },
                    onChanged: (String) {},
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 16.0),
                      const  Text("Job Title",
                        style: TextStyle(  color: ColorConstant.AppBluecolor, fontSize: 14, fontWeight: FontWeight.bold)
                      ),
                      const SizedBox(height: 10.0,),
                      RawAutocomplete(
                        optionsBuilder: (TextEditingValue textEditingValue) {
                          _jobTitleController.text = textEditingValue.text;
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
                          _jobTitleController.text = selection;
                        },
                        fieldViewBuilder: (BuildContext context, _jobTitleController,
                            FocusNode focusNode,
                            VoidCallback onFieldSubmitted) {
                          return TextFormField(
                            decoration: InputDecoration(
                              hintText: "Ex:Skill, Designations",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0), // Border color
                              ),

                              prefixIcon: Icon(Icons.cases_rounded,color: ColorConstant.AppGreencolor,),
                              filled: true,
                              fillColor: Colors.grey[200], // Set background color to white
                              hintStyle: TextStyle(color: ColorConstant.blackshade), // Set hint text color to white
                              contentPadding: EdgeInsets.all(8.0), // Adjust content padding as needed
                            ),
                            controller: _jobTitleController,
                            focusNode: focusNode,
                            //  onSubmitted: (String value) {},
                            style: TextStyle(color: ColorConstant.AppBluecolor), // Set text color to white
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
                      const  Text("Location",
                          style: TextStyle(  color: ColorConstant.AppBluecolor, fontSize: 14, fontWeight: FontWeight.bold)
                      ),
                      const SizedBox(height: 10.0,),
                      RawAutocomplete(
                        optionsBuilder: (TextEditingValue textEditingValue) {
                          _jobLocationController.text = textEditingValue.text;
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
                          _jobLocationController.text = selection;
                        },
                        fieldViewBuilder: (BuildContext context, _jobLocationController,
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
                              fillColor: Colors.grey[200], // Set background color to white
                              hintStyle: TextStyle(color: ColorConstant.blackshade), // Set hint text color to white
                              contentPadding: EdgeInsets.all(8.0), // Adjust content padding as needed
                            ),
                            controller: _jobLocationController,
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
                  ),

               /*   CustomProfileFormField(
                    headingText: 'Job Title',
                    hintText: 'Enter job title',
                    obscureText: false,
                    suffixIcon: SizedBox.shrink(),
                    prefixIcon: Icon(Icons.work, color: ColorConstant.AppGreencolor),
                    textInputType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                    controller: _jobTitleController,
                    maxLines: 1,
                    onChanged: (value) {},
                  ),
                  SizedBox(height: 16.0),
                  CustomProfileFormField(
                    headingText: 'Job Location',
                    hintText: 'Enter Your job Location',
                    obscureText: false,
                    suffixIcon: SizedBox.shrink(),
                    prefixIcon: Icon(Icons.location_city, color: ColorConstant.AppGreencolor),
                    textInputType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                    controller: _jobLocationController,
                    maxLines: 1,
                    onChanged: (value) {},
                  ),*/

                  SizedBox(height: 100.0),
                  InkWell(
                    onTap: () {
                      if (_nameController.text.trim().length == 0) {
                        SnackBarHelper.showWarningSnackBar(
                            context, "Please Enter your Name");
                        return;
                      }
                      if (_mobileController.text.trim().length == 0) {
                        SnackBarHelper.showWarningSnackBar(
                            context, "Please Enter your mobile No");
                        return;
                      }
                      if (_gender!.trim().length == 0) {
                        SnackBarHelper.showWarningSnackBar(
                            context, "Select Your Gender");
                        return;
                      }
                      if (_jobTitleController.text.trim().length == 0) {
                        SnackBarHelper.showWarningSnackBar(
                            context, "Please Enter your Job Title");
                        return;
                      }
                      if (_jobLocationController.text.trim().length == 0) {
                        SnackBarHelper.showWarningSnackBar(
                            context, "Please Enter your Job Location");
                        return;
                      }
                      saveProfile();
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height * 0.05,
                      margin: const EdgeInsets.only(left: 0, right: 0),
                      decoration: BoxDecoration(
                          color: ColorConstant.AppBluecolor,
                          borderRadius:
                          BorderRadius.all(Radius.circular(10))),
                      child: Center(
                          child: Text(
                            "Save",
                            style: KTextStyle.authButtonTextStyle,
                          )),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (_isLoading)
            Container(
              color: Colors.black.withOpacity(0.5),
              child: Center(
                  child: Container(
                      height: 100,
                      width: 100,
                      child: Lottie.asset(Config().adsLoading))
              ),
            ),
        ],
      ),

    );
  }
}

class CustomProfileFormField extends StatelessWidget {
  final String headingText;
  final String hintText;
  final bool obscureText;
  final Widget suffixIcon;
  final Widget prefixIcon;
  final TextInputType textInputType;
  final TextInputAction textInputAction;
  final TextEditingController controller;
  final int maxLines;
  final List<String>? dropdownItems;
  final String? dropdownValue;
  final Function(String) onChanged;
  final Function(String?)? onDropdownChanged;

  CustomProfileFormField({
    Key? key,
    required this.headingText,
    required this.hintText,
    required this.obscureText,
    required this.suffixIcon,
    required this.prefixIcon,
    required this.textInputType,
    required this.textInputAction,
    required this.controller,
    required this.maxLines,
    required this.onChanged,
    this.dropdownItems,
    this.dropdownValue,
    this.onDropdownChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(
            left: 0,
            right: 0,
            bottom: 10,
          ),
          child: RichText(
            text: TextSpan(
              text: headingText,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: ColorConstant.AppBluecolor, // Added color here
              ),
              children: <TextSpan>[
                TextSpan(
                  text: '',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.red, // Added color here
                  ),
                ),
              ],
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.only(left: 0, right: 0),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 0.0),
            child: _buildField(),
          ),
        ),
      ],
    );
  }

  Widget _buildField() {
    if (dropdownItems != null) {
      return DropdownButtonFormField<String>(
        isExpanded: true,
        items: dropdownItems!
            .map((item) => DropdownMenuItem(
          value: item,
          child: Text(item),
        ))
            .toList(),
        value: dropdownValue,
        onChanged: onDropdownChanged,
        decoration: InputDecoration(
          hintText: hintText,
          border: InputBorder.none,
          prefixIcon: Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
            child: prefixIcon,
          ),
          suffixIcon: suffixIcon,
        ),
      );
    } else {
      return TextField(
        onChanged: onChanged,
        maxLines: maxLines,
        controller: controller,
        textInputAction: textInputAction,
        keyboardType: textInputType,
        obscureText: obscureText,
        decoration: InputDecoration(
          hintText: hintText,
          border: InputBorder.none,
          prefixIcon: Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
            child: prefixIcon,
          ),
          suffixIcon: suffixIcon,
        ),
      );
    }
  }
}
