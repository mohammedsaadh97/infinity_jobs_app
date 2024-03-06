import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:infinityjobs_app/core/config/config.dart';
import 'package:infinityjobs_app/core/widgetss/SnackBarHelper.dart';
import 'package:infinityjobs_app/core/widgetss/custom_formfield.dart';
import 'package:infinityjobs_app/utilities/color_constant.dart';
import 'package:infinityjobs_app/utilities/text_styles.dart';
import 'package:lottie/lottie.dart';

class ForgotPasswordScreen extends StatefulWidget {
  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();
  bool _loading = false;

  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  Future<void> resetPassword(BuildContext context) async {
    setState(() {
      _loading = true;
    });
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: _emailController.text);
      showDialog(
        context: _scaffoldKey.currentContext!,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Success'),
            content: Text('Password reset email sent. Please check your email.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    } catch (e) {
      SnackBarHelper.showFailedSnackBar(
          context, "Failed to send password reset email", e.toString());
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Stack(
        children: [
          Padding(
            padding: EdgeInsets.all(20.0),
            child: Column(
              children: [
               const SizedBox(
                  height: 60,
                ),
                RichText(
                  maxLines: 2,
                  textAlign: TextAlign.center,
                  text: const TextSpan(children: <TextSpan>[
                    TextSpan(
                      text: "Welcome ",
                      style: TextStyle(
                          fontSize: 27.0,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Poppins',
                          color: Colors.black
                      ),
                    ),
                    TextSpan(
                      text: "Hunter",
                      style: TextStyle(
                        fontSize: 27.0,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Poppins',
                        color: ColorConstant.AppGreencolor,
                      ),),
                    TextSpan(
                      text: "!",
                      style: TextStyle(
                        fontSize: 27.0,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Poppins',
                        color: ColorConstant.AppBluecolor,
                      ),),
                  ]),
                ),
                SizedBox(height: 10,),
              const  Text(
                  "Your next career move is just a password reset away.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14.0,
                    fontWeight: FontWeight.w900,
                    fontFamily: 'Montserrat',
                    color: ColorConstant.AppBluecolor,
                  ),
                ),
              const  Text(
                  "Let's get you back on track!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w900,
                    fontFamily: 'Montserrat',
                    color: ColorConstant.AppBluecolor,
                  ),
                ),
                const SizedBox(
                  height: 50,
                ),
                CustomFormField(
                  headingText: "Email",
                  hintText: "Enter Your Email ID",
                  obsecureText: false,
                  prefixIcon: FaIcon(FontAwesomeIcons.solidEnvelope,color: ColorConstant.AppGreencolor ),
                  suffixIcon: const SizedBox(),
                  controller: _emailController,
                  maxLines: 1,
                  textInputAction: TextInputAction.done,
                  textInputType: TextInputType.emailAddress,
                  onchange: (String value){ },
                ),
                SizedBox(height: 50.0),
                InkWell(
                  onTap: () {
                    if (_emailController.text.trim().length == 0) {
                      SnackBarHelper.showWarningSnackBar(
                          context, "Please Enter your Email-ID");
                      return;
                    }
                    resetPassword(context);
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
                          "Reset Password",
                          style: KTextStyle.authButtonTextStyle,
                        )),
                  ),
                ),
              ],
            ),
          ),
          if (_loading)
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
