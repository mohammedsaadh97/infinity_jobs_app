import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:image_picker/image_picker.dart';
import 'package:infinityjobs_app/core/widgetss/SnackBarHelper.dart';
import 'package:infinityjobs_app/core/widgetss/custom_appbar_widget.dart';
import 'package:infinityjobs_app/screens/home_screen.dart';
import 'package:infinityjobs_app/utilities/color_constant.dart';
import 'package:infinityjobs_app/utilities/text_styles.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class EditProfileScreen extends StatefulWidget {
  final String? userId;
  late final String emailId;

  EditProfileScreen(this.userId,this.emailId);

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _jobTitleController = TextEditingController();
  final TextEditingController _jobLocationController = TextEditingController();

  String? _gender;
  List<String> _genders = ['Male', 'Female', 'Others'];
  File? _image;
  final picker = ImagePicker();

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  Future<void> loadUserData() async {
    DocumentSnapshot<Map<String, dynamic>> snapshot =
    await FirebaseFirestore.instance.collection('users').doc(widget.userId).get();

    if (snapshot.exists) {
      Map<String, dynamic> userData = snapshot.data()!;
      setState(() {
        _nameController.text = userData['name'];
        _gender = userData['gender'];
        _mobileController.text = userData['mobile'];
        _jobTitleController.text = userData['jobTitle'];
        _jobLocationController.text = userData['location'];
        String imageUrl = userData['profileImage'];
        print('Image URL: $imageUrl'); // Debug print for image URL
        if (imageUrl != null && imageUrl.isNotEmpty) {
          downloadAndSetImage(imageUrl);
        }
      });
    }
  }
  Future<void> downloadAndSetImage(String imageUrl) async {
    try {
      final response = await http.get(Uri.parse(imageUrl));
      final documentDirectory = await getApplicationDocumentsDirectory();
      final file = File('${documentDirectory.path}/profile_image.jpg');
      await file.writeAsBytes(response.bodyBytes);
      setState(() {
        _image = file;
      });
    } catch (e) {
      print('Error downloading image: $e');
    }
  }

  Future<void> saveProfile() async {
    setState(() {
      _isLoading = true;
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
      prefs.setBool('isLoggedIn', true);
      prefs.setString('userId', widget.userId!);
      prefs.setString('email', widget.emailId);
      prefs.setString('name', _nameController.text);
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
        _isLoading = false;
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
      return '';
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
      appBar: CustomAppBar(
        title: "Edit Profile",
        onBackPressed: () {
          Navigator.of(context).pop();
          // Add functionality for back button press
        },
        showShareButton: false,
        onSharePressed: () {
          // Add functionality for share button press
        },
      ),
      body: Stack(
        children: [
          Padding(
            padding: EdgeInsets.all(20.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: 10.0,),
                  Column(
                    children: [
                      Stack(
                        children: [
                          Container(
                            width: 120,
                            height: 120,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.grey[300],
                              border: Border.all(
                                color: ColorConstant.AppBluecolor,
                                width: 5,
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
                                          Divider(),
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
                  SizedBox(height: 16.0),
                  CustomProfileFormField(
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
                  ),

                  SizedBox(height: 30.0),
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
                child: CircularProgressIndicator(
                  color: ColorConstant.AppGreencolor,
                ),
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
                color: ColorConstant.AppBluecolor,
              ),
              children: <TextSpan>[
                TextSpan(
                  text: '',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
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
