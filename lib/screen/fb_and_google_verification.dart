import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:servicehub_client/Colors.dart';
import 'package:servicehub_client/api/api_controller.dart';
import 'package:servicehub_client/provider/auth_provider.dart';
import 'package:servicehub_client/screen/login_screen.dart';

import 'package:servicehub_client/widget/rounded_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

class fbgooglePhoneNumberValidation extends StatefulWidget {
  const fbgooglePhoneNumberValidation({super.key});

  @override
  State<fbgooglePhoneNumberValidation> createState() =>
      _fbgooglePhoneNumberValidationState();
}

class _fbgooglePhoneNumberValidationState
    extends State<fbgooglePhoneNumberValidation> {
  String customerid = '';

  getUserData() async {
    final ids = await SharedPreferences.getInstance();
    customerid = ids.getString("id").toString();
    print("my id is" + customerid);

    //await prefs.setBool('isLogged', false);
  }

  Apicontroller apicontroller = Apicontroller();
  TextEditingController phoneNumberControlleer = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      margin: const EdgeInsets.symmetric(horizontal: 35, vertical: 15),
      child: Consumer<AuthProvider>(
        builder: (context, value, child) => Column(
            mainAxisAlignment: MainAxisAlignment.center,
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
              TextFormField(
                keyboardType: TextInputType.number,
                maxLength: 10,
                controller: phoneNumberControlleer,
                style: const TextStyle(
                    fontFamily: 'Segoe UI', fontSize: 20, color: lightText),
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
              SizedBox(
                height: 10,
              ),
              RoundedButton(
                //login button............................
                buttonText: 'Login',
                onPress: () async {
                  isValidPhoneNumber(phoneNumberControlleer.text)
                      ? await value.favalable
                          ? apicontroller.fbgoogleregister(
                              value.femail.text,
                              phoneNumberControlleer.text,
                              value.fusername.text,
                              context)
                          : await value.gavalable
                              ? apicontroller.fbgoogleregister(
                                  value.gemail.text,
                                  phoneNumberControlleer.text,
                                  value.gusername.text,
                                  context)
                              : showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: const Text(
                                          'Your Registration Failed '),
                                      actions: <Widget>[
                                        ElevatedButton(
                                          child: const Text('OK'),
                                          onPressed: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      LoginScreen(),
                                                ));
                                          },
                                        ),
                                      ],
                                    );
                                  },
                                )
                      : showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('Enter valid phonenumber'),
                              actions: <Widget>[
                                ElevatedButton(
                                  child: const Text('OK'),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            );
                          },
                        );

                  // Navigator.of(context).push(MaterialPageRoute(
                  //     builder: (BuildContext context) =>
                  //
                  //
                  //       const RegisterScreen()));
                },
              ),
              SizedBox(
                height: 20,
              ),
            ]),
      ),
    ));
  }

  //phone number validation function
  bool isValidPhoneNumber(String phoneNumber) {
    final RegExp regex = RegExp(r"^\d{10}$");
    return regex.hasMatch(phoneNumber);
  }
}
