import 'package:flutter/material.dart';
import 'package:infinityjobs_app/models/company_model.dart';
import 'package:infinityjobs_app/utilities/color_constant.dart';

class Config {


  final String appName = 'Infinity Jobs';
  final String appPackageName = 'com.infinity.infinityjobs_app';
  final String splashIcon = 'assets/images/splash.png';
  final String supportEmail = 'infinityjob.ijob@gmail.com';
  final String privacyPolicyUrl = 'https://sites.google.com/view/infinityjobprivacypolicy/home';
  final String ourWebsiteUrl = '';
  final String aboutUs = 'https://sites.google.com/view/infinityjobsaboutus/home';
  final String iOSAppId = '000000';

  //Google play store link
  final String playStoreLink = "https://play.google.com/store/apps/details?id=com.infinity.infinityjobs_app";

  // Defalut company image
  final String defaultComanyImage = "https://i.postimg.cc/ydmHtz20/building.png";

  final List<Company> companies = [
    Company(imageUrl: 'https://i.postimg.cc/J4Yp3L4q/wipro-logo.png', name: 'Wipro'),
    Company(imageUrl: 'https://i.postimg.cc/NFgdDGHN/Microsoft-logo.png', name: 'Microsoft'),
    Company(imageUrl: 'https://i.postimg.cc/J4zTBnm0/Google-G-logo.png', name: 'Google'),
    Company(imageUrl: 'https://i.postimg.cc/J7q6nXfS/HCL-Technologies-logo.png', name: 'HCL Technologies'),
    Company(imageUrl: 'https://i.postimg.cc/YC4bbsvw/Tech-Mahindra-New-Logo.png', name: 'Tech Mahindra'),
    Company(imageUrl: 'https://i.postimg.cc/zBwdTHVb/Cognizant-logo.png', name: 'Cognizant'),
    Company(imageUrl: 'https://i.postimg.cc/L5NNbdkm/zoho-logo.png', name: 'Zoho Corporation'),
    Company(imageUrl: 'https://i.postimg.cc/9Xvw5gMp/Tata-Consultancy-Services-Logo.png', name: 'Tata Consultancy Services'),

  ];




  //Intro json
  final String introJson1 = 'assets/jsons/introjson1.json';
  final String introJson2 = 'assets/jsons/introjson2.json';
  final String introJson3 = 'assets/jsons/introjson3.json';

  // no Data found
  final String noDataFound = 'assets/jsons/nodatafound.json';


}