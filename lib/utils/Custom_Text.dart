import 'package:flutter/cupertino.dart';

class CustomText extends StatelessWidget {
  const CustomText({
    required this.text,
    required this.color,
    required this.fontfamily,
    required this.fontweight,
    required this.size,
    this.textalign,
  });

  final String text;
  final Color color;
  final String fontfamily;
  final FontWeight fontweight;
  final double size;
  final TextAlign? textalign;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontFamily: fontfamily,
        color: color,
        fontSize: size,
        fontWeight: fontweight,
      ),
      textAlign: textalign,
    );
  }
}
