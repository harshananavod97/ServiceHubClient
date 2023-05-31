import 'package:flutter/cupertino.dart';
import 'package:servicehub_client/Colors.dart';

class AppNameWidget extends StatelessWidget {
  const AppNameWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      child: Row(
        children: const [
          Text('Service',
              style: TextStyle(
                  fontFamily: 'Segoe UI',
                  fontSize: 30.0,
                  color: darkText,
                  fontWeight: FontWeight.w600,
                  fontStyle: FontStyle.italic)),
          Text('hub',
              style: TextStyle(
                fontFamily: 'Segoe UI',
                fontSize: 30.0,
                color: darkText,
                fontWeight: FontWeight.w700,
              ))
        ],
      ),
    );
  }
}
