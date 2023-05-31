import 'package:flutter/material.dart';
import 'package:servicehub_client/Colors.dart';

class RoundedBorderButton extends StatelessWidget {
  const RoundedBorderButton({
    super.key,
    required this.buttonText,
    required this.buttonBackground,
    required this.textColor,
    required this.onPress,
  });

  final String buttonText;
  final Color buttonBackground;
  final Color textColor;
  final VoidCallback onPress;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPress,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
          child: Text(
            buttonText,
            style: TextStyle(
                fontFamily: 'Segoe UI',
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: textColor),
          ),
        ),
        style: OutlinedButton.styleFrom(
          elevation: 0,
          backgroundColor: buttonBackground,
          shape: RoundedRectangleBorder(
            side: const BorderSide(color: kPrimary, width: 1),
            borderRadius: BorderRadius.circular(7),
          ),
          // shape: RoundedRectangleBorder(
          //   borderRadius: BorderRadius.circular(7), // <-- Radius
          // ),
        ),
      ),
    );
  }
}
