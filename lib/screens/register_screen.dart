import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:infinityjobs_app/core/config/config.dart';
import 'package:infinityjobs_app/core/widgetss/SnackBarHelper.dart';
import 'package:infinityjobs_app/core/widgetss/custom_formfield.dart';
import 'package:infinityjobs_app/screens/login_screen.dart';
import 'package:infinityjobs_app/screens/profile_screen.dart';
import 'package:infinityjobs_app/services/next_screen.dart';
import 'package:infinityjobs_app/utilities/color_constant.dart';
import 'package:infinityjobs_app/utilities/text_styles.dart';
import 'package:lottie/lottie.dart';

class RegisterScreen extends StatefulWidget {
  final Function(bool) onLogin;

  const RegisterScreen(this.onLogin, {Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
  TextEditingController();

  bool _isObscure = true;
  bool _isLoading = false;

  Future<void> registerWithEmailAndPassword(BuildContext context) async {
    final String email = _emailController.text.trim();
    final String password = _passwordController.text.trim();
    final String confirmPassword = _confirmPasswordController.text.trim();

    if (password != confirmPassword) {
      SnackBarHelper.showWarningSnackBar(
          context, "Passwords do not match");
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      UserCredential userCredential =
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (userCredential.user != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('User registered successfully'),
          ),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => ProfileScreen(userCredential.user!.uid,_emailController.text)),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to register. ${e.toString()}'),
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Padding(
            padding: EdgeInsets.all(20.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: 60,),
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
                  const SizedBox(height: 10.0,),
                  const Text(
                    "Your next career move is just an email away.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w900,
                      fontFamily: 'Montserrat',
                      color: ColorConstant.AppBluecolor,
                    ),
                  ),
                  const Text(
                    "Register now and open doors to new opportunities.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 15.0,
                      fontWeight: FontWeight.w900,
                      fontFamily: 'Montserrat',
                      color: ColorConstant.AppBluecolor,
                    ),
                  ),
                  const SizedBox(height: 50,),
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
                    onchange: (String value){},
                  ),
                  const SizedBox(height: 10.0,),
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
                  const SizedBox(height: 10.0,),
                  CustomFormField(
                    headingText: "Confirm Password",
                    maxLines: 1,
                    textInputAction: TextInputAction.done,
                    textInputType: TextInputType.text,
                    hintText: "Confirm Your Password",
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
                    controller: _confirmPasswordController,
                    onchange: (String value) {},
                  ),
                  const SizedBox(height: 50.0,),
                  InkWell(
                    onTap: () {
                      if (_emailController.text.trim().isEmpty) {
                        SnackBarHelper.showWarningSnackBar(
                            context, "Please Enter your Email-ID");
                        return;
                      }
                      if (_passwordController.text.trim().isEmpty) {
                        SnackBarHelper.showWarningSnackBar(
                            context, "Please Enter your password");
                        return;
                      }
                      if (_confirmPasswordController.text.trim().isEmpty) {
                        SnackBarHelper.showWarningSnackBar(
                            context, "Please Confirm your password");
                        return;
                      }
                      registerWithEmailAndPassword(context);
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height * 0.05,
                      margin: const EdgeInsets.only(left: 0, right: 0),
                      decoration: BoxDecoration(
                          color: ColorConstant.AppBluecolor,
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      child: Center(
                          child: Text(
                            "Sign Up",
                            style: KTextStyle.authButtonTextStyle,
                          )),
                    ),
                  ),
                  const SizedBox(height: 20.0,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      const Text(
                        "Already have an account?",
                        style: TextStyle(
                            color: ColorConstant.AppBluecolor,
                            fontSize: 16,
                            fontWeight: FontWeight.normal),
                      ),
                      TextButton(
                          child: const Text('Sign In',
                              style: TextStyle(
                                  color: ColorConstant.AppGreencolor,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold)),
                          onPressed: () {
                            nextScreen(context,LoginScreen(widget.onLogin));
                          }
                      )
                    ],
                  )
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
