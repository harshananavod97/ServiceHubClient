import 'package:flutter/material.dart';
import 'package:servicehub_client/Colors.dart';
import 'package:servicehub_client/utils/constant_image.dart';

class SocialMediaButtons extends StatelessWidget {
  const SocialMediaButtons({
    required this.img,
    required this.buttontext,
    required this.onPress,
    required this.buttonBackground,
    required this.textColor,
  });
  final String img;
  final String buttontext;
  final VoidCallback onPress;
  final Color buttonBackground;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: onPress,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 12, horizontal: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(Constant.imageasset(img)),
                SizedBox(
                  width: 20,
                ),
                Text(
                  buttontext,
                  style: TextStyle(
                      fontFamily: 'Segoe UI',
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: textColor),
                ),
              ],
            ),
          ),
          style: OutlinedButton.styleFrom(
            elevation: 0,
            backgroundColor: buttonBackground,
            shape: RoundedRectangleBorder(
              side: const BorderSide(color: kPrimary, width: 1),
              borderRadius: BorderRadius.circular(7),
            ),
          ),
        ));
  }
}
