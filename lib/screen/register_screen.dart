import 'package:flutter/material.dart';
import 'package:servicehub_client/Colors.dart';
import 'package:servicehub_client/Notifications/getfcm.dart';
import 'package:servicehub_client/api/api_controller.dart';

import 'package:servicehub_client/styles.dart';
import 'package:servicehub_client/widget/rounded_button.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  AutovalidateMode switched = AutovalidateMode.disabled;
  final _emailformKey = GlobalKey<FormState>();
  final _fullnameformKey = GlobalKey<FormState>();
  final _phonenoformKey = GlobalKey<FormState>();

  final fullNameControlleer = TextEditingController();
  final phoneNumberControlleer = TextEditingController();
  final emailControlleer = TextEditingController();
  final cityControlleer = TextEditingController();
  final bioControlleer = TextEditingController();
  Apicontroller apicontroller = Apicontroller();

  final fullNameFocusNode = FocusNode();
  final phoneNumberFocusNode = FocusNode();
  final emailFocusNode = FocusNode();
  final cityFocusNode = FocusNode();
  final bioNameFocusNode = FocusNode();

  @override
  void dispose() {
    super.dispose();
    fullNameFocusNode.dispose();
    phoneNumberFocusNode.dispose();
    emailFocusNode.dispose();
    fullNameControlleer.dispose();
    phoneNumberControlleer.dispose();
    emailControlleer.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Styles.appBar(context),
      backgroundColor: white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 0),
        child: Column(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Create Account',
                  style: screenTitle,
                ),
                const SizedBox(
                  height: 22,
                ),
                inputField('Full Name', fullNameControlleer, TextInputType.text,
                    fullNameFocusNode),
                Form(
                  key: _fullnameformKey,
                  autovalidateMode: switched,
                  child: TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Full name is required';
                        }
                        if (!RegExp(r'^[a-zA-Z ]+$').hasMatch(value)) {
                          return 'Full name can only contain letters and spaces';
                        }
                        if (value.length > 255) {
                          return 'Full name cannot exceed 255 characters';
                        }
                        return null;
                      },
                      controller: fullNameControlleer,
                      keyboardType: TextInputType.text,
                      focusNode: fullNameFocusNode,
                      style: const TextStyle(
                          fontFamily: 'Segoe UI',
                          fontSize: 20,
                          color: lightText),
                      decoration: formInputStyle),
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  "Phone Number",
                  style: labelText,
                ),
                const SizedBox(
                  height: 8,
                ),
                Form(
                  autovalidateMode: switched,
                  key: _phonenoformKey,
                  child: TextFormField(
                    maxLength: 10,
                    controller: phoneNumberControlleer,
                    keyboardType: TextInputType.number,
                    focusNode: phoneNumberFocusNode,
                    style: const TextStyle(
                        fontFamily: 'Segoe UI', fontSize: 20, color: lightText),
                    decoration: formInputStyle,
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
                  ),
                ),
                const SizedBox(
                  height: 1,
                ),
                inputField('Email', emailControlleer,
                    TextInputType.emailAddress, emailFocusNode),
                Form(
                  key: _emailformKey,
                  autovalidateMode: switched,
                  child: TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Email is required';
                      }
                      final emailRegex = RegExp(
                          r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
                      if (!emailRegex.hasMatch(value)) {
                        return 'Invalid email address';
                      }
                      if (value.length > 255) {
                        return 'Email name cannot exceed 255 characters';
                      }
                      return null;
                    },
                    controller: emailControlleer,
                    keyboardType: TextInputType.text,
                    focusNode: emailFocusNode,
                    style: const TextStyle(
                        fontFamily: 'Segoe UI', fontSize: 20, color: lightText),
                    decoration: formInputStyle,
                  ),
                ),
                const SizedBox(
                  height: 80,
                ),
                RoundedButton(
                  buttonText: 'Signup Now',
                  onPress: () async {
                    String? fcmKey = await getFcmToken();
                    setState(() {
                      switched = AutovalidateMode.always;
                    });
                    if (_phonenoformKey.currentState!.validate() &&
                        _fullnameformKey.currentState!.validate() &&
                        _emailformKey.currentState!.validate()) {
                      apicontroller.register(
                          emailControlleer.text,
                          phoneNumberControlleer.text,
                          fullNameControlleer.text,
                          fcmKey.toString(),
                          context);
                    }
                  },
                ),
              ],
            ),
            const SizedBox(
              height: 26,
            ),
            const Text(
              'By Sign up you\' re agree to our Terms & Conditions',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Segoe UI',
                fontSize: 15.0,
                color: darkText,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget inputField(
    String labelName,
    TextEditingController controller,
    TextInputType inputType,
    FocusNode focusNode,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          labelName,
          style: labelText,
        ),
        const SizedBox(
          height: 8,
        ),
        // TextFormField(
        //     controller: controller,
        //     keyboardType: inputType,
        //     focusNode: focusNode,
        //     style: const TextStyle(
        //         fontFamily: 'Segoe UI', fontSize: 20, color: lightText),
        //     decoration: formInputStyle),
      ],
    );
  }

//email validation function
}
