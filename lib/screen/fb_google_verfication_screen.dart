import 'package:flutter/material.dart';
import 'package:servicehub_client/Colors.dart';
import 'package:servicehub_client/api/api_controller.dart';
import 'package:servicehub_client/styles.dart';
import 'package:servicehub_client/widget/rounded_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FBGoogleVerfiactionScreen extends StatefulWidget {
  const FBGoogleVerfiactionScreen({super.key, required this.userId});

  final String userId;

  @override
  State<FBGoogleVerfiactionScreen> createState() =>
      _FBGoogleVerfiactionScreenState();
}

class _FBGoogleVerfiactionScreenState extends State<FBGoogleVerfiactionScreen> {
  String userid = '';

//get customer id
  getid() async {
    final id = await SharedPreferences.getInstance();

    userid = id.getString("id").toString();
  }

  @override
  void initState() {
    super.initState();
    getid();
  }

  Apicontroller apicontroller = Apicontroller();
  final otpController = TextEditingController();
  final otpFocusNode = FocusNode();

  @override
  void dispose() {
    super.dispose();
    otpController.dispose();
    otpFocusNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Styles.appBar(context),
      backgroundColor: white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Verification',
              style: screenTitle,
            ),
            const SizedBox(
              height: 40,
            ),
            const Text(
              'Enter 6 digit verfication code we\'ve sent on you given number.',
              style: TextStyle(
                  fontFamily: 'Segoe UI',
                  fontSize: 20,
                  color: darkText,
                  fontWeight: FontWeight.w600),
            ),
            const SizedBox(
              height: 28,
            ),
            const Text(
              'Enter OTP',
              style: labelText,
            ),
            const SizedBox(
              height: 8,
            ),
            TextFormField(
                controller: otpController,
                keyboardType: TextInputType.number,
                maxLength: 6,
                focusNode: otpFocusNode,
                style: const TextStyle(
                    fontFamily: 'Segoe UI', fontSize: 20, color: lightText),
                decoration: formInputStyle),
            const SizedBox(
              height: 40,
            ),
            RoundedButton(
              buttonText: 'Continue',
              onPress: () {
                setState(() {
                  apicontroller.validateotp(
                      userid.toString(), otpController.text, context);
                });
              },
            ),
            const SizedBox(
              height: 15,
            ),
            GestureDetector(
              onTap: () {
                apicontroller.resendotp(otpFocusNode.toString(), context);
              },
              child: const Align(
                alignment: Alignment.topRight,
                child: Text(
                  'Send Again',
                  style: TextStyle(
                      fontFamily: 'Segoe UI',
                      fontSize: 20,
                      color: kPrimary,
                      fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
