import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:servicehub_client/Colors.dart';
import 'package:servicehub_client/controller/auth_conroller.dart';
import 'package:servicehub_client/screen/fb_and_google_verification.dart';

import 'package:servicehub_client/screen/login_screen.dart';
import 'package:servicehub_client/screen/main_screen.dart';

import 'package:servicehub_client/utils/Navigation_Function.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider extends ChangeNotifier {
  //store fb user profile
  Map<String, dynamic> _userdata = {};
  Map<String, dynamic> get getuserdata => _userdata;
  bool favalable = false;
  bool gavalable = false;
  TextEditingController gusername = TextEditingController();
  TextEditingController gemail = TextEditingController();
  TextEditingController gphonenumber = TextEditingController();
  TextEditingController fusername = TextEditingController();
  TextEditingController femail = TextEditingController();
  TextEditingController fphonenumber = TextEditingController();

  //facebook sign function

  Future<void> signInWithFacebook(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    // Trigger the sign-in flow
    final LoginResult loginResult = await FacebookAuth.instance.login(
        loginBehavior: LoginBehavior.dialogOnly,
        permissions: ['email', 'public_profile']);
    if (loginResult.status == LoginStatus.success) {
      final userData = await FacebookAuth.i.getUserData(
        fields: "name,email,picture.width(200)",
      );
      _userdata = userData;
      favalable = true;
      fusername.text = getuserdata['name'].toString();
      femail.text = getuserdata['email'].toString();
      notifyListeners();

      Logger().i(userData);
      final OAuthCredential facebookAuthCredential =
          FacebookAuthProvider.credential(loginResult.accessToken!.token);

      final userCredential = await FirebaseAuth.instance
          .signInWithCredential(facebookAuthCredential);

      _firebaseUser = userCredential.user;

      // Once signed in, return the UserCredential
      //FirebaseAuth.instance.signInWithCredential(facebookAuthCredential);

      if (_firebaseUser == null) {
        // ignore: prefer_interpolation_to_compose_strings
        Logger().w('User is currently signed out!' +
            prefs.getBool("isLogged").toString());

        if (prefs.getBool("isLogged") == true) {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => fbgooglePhoneNumberValidation(),
              ));
        } else {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => fbgooglePhoneNumberValidation(),
              ));
        }
      } else {
        Logger().w('User is signed in!');
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => fbgooglePhoneNumberValidation(),
            ));
      }
    }

    // Create a credential from the access token
  }

  Future<void> googleAuth(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    try {
      final usercredential = await _authcontroller.signInWithGoogle();
      if (usercredential != null) {
        Logger().w(usercredential.user);
        //setting firebase user details
        _firebaseUser = usercredential.user;
        gusername.text = FirebaseUser!.displayName.toString();
        gemail.text = FirebaseUser!.email.toString();
        gphonenumber.text = FirebaseUser!.phoneNumber.toString();

        gavalable = true;

        _firebaseUser = usercredential.user;
        notifyListeners();

        // Once signed in, return the UserCredential
        //FirebaseAuth.instance.signInWithCredential(facebookAuthCredential);

        if (_firebaseUser == null) {
          // ignore: prefer_interpolation_to_compose_strings
          Logger().w('User is currently signed out!' +
              prefs.getBool("isLogged").toString());

          if (prefs.getBool("isLogged") == true) {
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                    builder: (context) =>
                        const fbgooglePhoneNumberValidation()),
                (route) => false);
          } else {
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                    builder: (context) =>
                        const fbgooglePhoneNumberValidation()),
                (route) => false);
          }
        } else {
          Logger().w('User is signed in!');
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                  builder: (context) => const fbgooglePhoneNumberValidation()),
              (route) => false);
        }
      }
    } catch (e) {
      Logger().e(e);
    }
  }
   late LoginScreen loginScreen;
  

  //-------------INTIALIZE USER Method-----------------------------
  Future<void> initializeUser(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();

    FirebaseAuth.instance.authStateChanges().listen((User? user) async {
      if (user == null) {
        // ignore: prefer_interpolation_to_compose_strings
        Logger().w('User is currently signed out!' +
            prefs.getBool("isLogged").toString());
        if (prefs.getBool("isLogged") == true) {
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => const MainScreen()),
              (route) => false);
        } else {
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => const LoginScreen()),
              (route) => false);
              
              
              
        }
      } else {
        Logger().w('User is signed in!');
        if (prefs.getBool("isLogged") == true) {
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => const MainScreen()),
              (route) => false);
        } else {
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => const LoginScreen()),
              (route) => false);
        }
      }
    });
  }

  final AuthController _authcontroller = AuthController();
  //logout function

  Future<void> logout(BuildContext context) async {
    // ignore: unused_local_variable
    final prefs = await SharedPreferences.getInstance();
    await FacebookAuth.instance.logOut();
    await FirebaseAuth.instance.signOut();
    await _authcontroller.googlelogout();
  }

  //store firebase User
  User? _firebaseUser;
  //geter for firebaseuser
  // ignore: non_constant_identifier_names
  User? get FirebaseUser => _firebaseUser;
//Google Authuntication
}
