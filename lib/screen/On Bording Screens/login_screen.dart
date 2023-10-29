import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:servicehub_client/Colors.dart';
import 'package:servicehub_client/api/api_controller.dart';
import 'package:servicehub_client/provider/auth_provider.dart';

import 'package:servicehub_client/screen/On%20Bording%20Screens/register_screen.dart';

import 'package:servicehub_client/widget/app_name_widget.dart';
import 'package:servicehub_client/widget/rounded_button.dart';
import 'package:servicehub_client/widget/social_media_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  AutovalidateMode switched = AutovalidateMode.disabled;

  Apicontroller apicontroller = Apicontroller();
  final phoneNumberControlleer = TextEditingController();

  final _phnnoformKey = GlobalKey<FormState>();

  String email = '';

  final phoneFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: white,
      body: SafeArea(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 35, vertical: 15),
          height: height,
          child: Column(
            children: [
              const Spacer(),
              const Center(child: AppNameWidget()),
              const Spacer(),
              const Spacer(),
              Form(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Enter phone number\nto continue',
                      style: TextStyle(
                          fontFamily: 'Segoe UI',
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: darkText),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    Form(
                      key: _phnnoformKey,
                      autovalidateMode: switched,
                      child: TextFormField(
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Phone number is required';
                          }
                          if (value.length != 10) {
                            return 'Phone number must have 10 digits';
                          }
                          if (!RegExp(r'^\d{10}$').hasMatch(value)) {
                            return 'Invalid phone number';
                          }
                          return null;
                        },
                        maxLength: 10,
                        controller: phoneNumberControlleer,
                        style: const TextStyle(
                            fontFamily: 'Segoe UI',
                            fontSize: 20,
                            color: lightText),
                        decoration: const InputDecoration(
                          filled: true,
                          hintText: 'Phone Number',
                          fillColor: inputFieldBackgroundColor,
                          contentPadding: EdgeInsets.all(12.0),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(5.0),
                            ),
                            borderSide: BorderSide(
                              width: 0,
                              style: BorderStyle.none,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 18,
                    ),
                    RoundedButton(
                      buttonText: 'Login',
                      onPress: () {
                        setState(() {
                          switched = AutovalidateMode.always;
                        });
                        if (_phnnoformKey.currentState!.validate()) {
                          apicontroller.otpgenarate(
                              phoneNumberControlleer.text, context);
                        }
                      },
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    const Text(
                      'Or Continue with',
                      style: TextStyle(
                          fontFamily: 'Segoe UI',
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: darkText),
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    SocialMediaButtons(
                      buttontext: 'Facebook',
                      img: 'fb.png',
                      buttonBackground: white,
                      textColor: kPrimary,
                      onPress: () async {
                        await Provider.of<AuthProvider>(context, listen: false)
                            .signInWithFacebook(context);
                      },
                    ),
                    const SizedBox(
                      height: 17,
                    ),
                    SocialMediaButtons(
                      buttontext: 'Google',
                      img: 'google.png',
                      buttonBackground: white,
                      textColor: kPrimary,
                      onPress: () async {
                        await Provider.of<AuthProvider>(context, listen: false)
                            .googleAuth(context);
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Center(
                child: RichText(
                  text: TextSpan(children: [
                    const TextSpan(
                      text: "Don’t have account?",
                      style: TextStyle(fontSize: 14, color: Colors.black),
                    ),
                    TextSpan(
                        text: " Register",
                        style: const TextStyle(
                            fontSize: 15,
                            color: Colors.black,
                            fontWeight: FontWeight.w600),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const RegisterScreen(),
                                ));
                          })
                  ]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

//phone number validation function
  bool isValidPhoneNumber(String phoneNumber) {
    final RegExp regex = RegExp(r"^\d{10}$");
    return regex.hasMatch(phoneNumber);
  }
}
