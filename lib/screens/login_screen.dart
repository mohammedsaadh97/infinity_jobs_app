import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:infinityjobs_app/core/widgetss/SnackBarHelper.dart';
import 'package:infinityjobs_app/core/widgetss/custom_formfield.dart';
import 'package:infinityjobs_app/screens/register_screen.dart';
import 'package:infinityjobs_app/screens/forgot_password_screen.dart';
import 'package:infinityjobs_app/services/next_screen.dart';
import 'package:infinityjobs_app/utilities/color_constant.dart';
import 'package:infinityjobs_app/utilities/text_styles.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  final Function(bool) onLogin;

  const LoginScreen(this.onLogin, {super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isObscure = true;
  bool _loading = false;

  Future<void> signInWithEmailAndPassword(BuildContext context) async {
    setState(() {
      _loading = true;
    });
    try {
      UserCredential userCredential =
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
      if (userCredential.user != null) {
        widget.onLogin(true);
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('userId', userCredential.user!.uid);
      }
    } catch (e) {
      SnackBarHelper.showFailedSnackBar(
          context, "Failed to sign in.", e.toString());
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20.0, right: 20.0),
            child: SingleChildScrollView(
              child: Column(
                //mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 60.0,
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
                            color: Colors.black),
                      ),
                      TextSpan(
                        text: "Hunters",
                        style: TextStyle(
                          fontSize: 27.0,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Poppins',
                          color: Colors.green,
                        ),
                      ),
                      TextSpan(
                        text: "!",
                        style: TextStyle(
                          fontSize: 27.0,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Poppins',
                          color: ColorConstant.AppBluecolor,
                        ),
                      ),
                    ]),
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  const Text(
                    "Step into a world of opportunities....",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w900,
                      fontFamily: 'Montserrat',
                      color: ColorConstant.AppBluecolor,
                    ),
                  ),
                  const Text(
                    "Your journey starts here. Login with your registered Email ID.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Montserrat',
                      color: ColorConstant.AppBluecolor,
                    ),
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  CustomFormField(
                    headingText: "Email-ID",
                    hintText: "Enter Your Email-ID",
                    obsecureText: false,
                    suffixIcon: const SizedBox(),
                    prefixIcon: FaIcon(FontAwesomeIcons.solidEnvelope,
                        color: ColorConstant.AppGreencolor),
                    controller: _emailController,
                    maxLines: 1,
                    textInputAction: TextInputAction.done,
                    textInputType: TextInputType.emailAddress,
                    onchange: (value) {},
                  ),
                  SizedBox(height: 16.0),
                  CustomFormField(
                    headingText: "Password",
                    maxLines: 1,
                    textInputAction: TextInputAction.done,
                    textInputType: TextInputType.text,
                    hintText: "Enter Your Password",
                    obsecureText: _isObscure,
                    prefixIcon: FaIcon(FontAwesomeIcons.lock,
                        color: ColorConstant.AppGreencolor),
                    suffixIcon: IconButton(
                        icon: Icon(
                            _isObscure
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: ColorConstant.AppGreencolor),
                        onPressed: () {
                          setState(() {
                            _isObscure = !_isObscure;
                          });
                        }),
                    controller: _passwordController,
                    onchange: (String value) {},
                  ),
                  SizedBox(height: 16.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        margin: const EdgeInsets.symmetric(
                            vertical: 16, horizontal: 0),
                        child: InkWell(
                          onTap: () {
                            nextScreen(context, ForgotPasswordScreen());
                          },
                          child: const Text(
                            "Forgot Password?",
                            style: TextStyle(
                                color: ColorConstant.AppBluecolor,
                                fontSize: 16.0,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20,),
                  InkWell(
                    onTap: () {
                      if (_emailController.text.trim().length == 0) {
                        SnackBarHelper.showWarningSnackBar(
                            context, "Please Enter your Email-ID");
                        return;
                      }
                      if (_passwordController.text.trim().length == 0) {
                        SnackBarHelper.showWarningSnackBar(
                            context, "Please Enter your password");
                        return;
                      }
                      signInWithEmailAndPassword(context);
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
                            "Sign In",
                            style: KTextStyle.authButtonTextStyle,
                          )),
                    ),
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      const Text(
                        "don't have an account?",
                        style: TextStyle(
                            color: ColorConstant.AppBluecolor,
                            fontSize: 16,
                            fontWeight: FontWeight.normal),
                      ),
                     TextButton(
                        child: Text('sign up',
                            style: TextStyle(
                                color: ColorConstant.AppGreencolor,
                                fontSize: 18,
                                fontWeight: FontWeight.bold)),
                        onPressed: () {
                          nextScreen(context,  RegisterScreen(widget.onLogin));
                        }
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
          if (_loading)
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
