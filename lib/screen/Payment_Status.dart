import 'package:flutter/material.dart';

import 'package:servicehub_client/Colors.dart';
import 'package:servicehub_client/api/api_controller.dart';
import 'package:servicehub_client/screen/appontment_screen.dart';
import 'package:servicehub_client/screen/main_screen.dart';
import 'package:servicehub_client/widget/rounded_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PayementStatus extends StatefulWidget {
  PayementStatus({
    super.key,
    required this.finalprice,
    required this.TransactionId,
    required this.indexofpayment,
    required this.job_id,
    required this.date,
    required this.PayementMethod,
    required this.SeriviceProviderId,
    required this.customerId,
    required this.payed_amount,
    required this.payemetReferences,
    required this.profile_pc,
  });

  final String customerId;
  final String PayementMethod;
  final String payemetReferences;
  final String payed_amount;
  final String SeriviceProviderId;
  final String TransactionId;
  final String date;
  final String job_id;
  double finalprice;
  final String profile_pc;

  int indexofpayment;

  @override
  State<PayementStatus> createState() => _PayementStatusState();
}

class _PayementStatusState extends State<PayementStatus> {
  String fcmkey = "";
  getproviderrdata() async {
    final providerdetails = await SharedPreferences.getInstance();
    setState(() {
      fcmkey = providerdetails.getString('fcm_key').toString();
    });
  }

  Apicontroller apicontroller = Apicontroller();
  String email = '';

  getcustomerdata() async {
    final customerdetails = await SharedPreferences.getInstance();

    setState(() {
      email = customerdetails.getString('email').toString();
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getcustomerdata();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: Container(
                color: Color.fromRGBO(33, 150, 243, 1),
                child: widget.profile_pc.toString() == "null"
                    ? Center(child: const Text('No image'))
                    : Image.network(
                        'https://servicehub.clickytesting.xyz/' +
                            widget.profile_pc,
                        fit: BoxFit.cover,
                      ),
                height: 150,
                width: 150,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              'Rs ' + widget.finalprice.toStringAsFixed(2),
              style: screenTitle,
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              widget.indexofpayment == 0
                  ? 'Payment Sucessful'
                  : widget.indexofpayment == 1
                      ? 'Payment Failed'
                      : widget.indexofpayment == 2
                          ? "Cash Payment"
                          : 'Waiting Confirmation',
              style: TextStyle(
                fontFamily: 'Segoe UI',
                fontSize: 20.0,
                color: darkText,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Transcation Number',
                  style: TextStyle(
                    fontFamily: 'Segoe UI',
                    fontSize: 18.0,
                    color: lightGrey,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      widget.indexofpayment == 2
                          ? Text("")
                          : Text(
                              widget.TransactionId.toString(),
                              style: TextStyle(
                                fontFamily: 'Segoe UI',
                                fontSize: 12.0,
                                color: darkText,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
              ],
            ),
            SizedBox(
              height: 40,
            ),
            Text(
              'A Confirmation Code Will Be \nSent to Your Email',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Segoe UI',
                fontSize: 18.0,
                color: darkText,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              email,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Segoe UI',
                fontSize: 18.0,
                color: darkText,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(
              height: 70,
            ),
            widget.indexofpayment == 2
                ? Container()
                : RoundedButton(
                    buttonText: "Back To Home",
                    onPress: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MainScreen(),
                          ));
                    }),
            SizedBox(
              height: 10,
            ),
            widget.indexofpayment == 2
                ? RoundedButton(
                    buttonText: "Conirfm",
                    onPress: () async {
                      apicontroller.CreatePayment(
                          widget.customerId,
                          widget.PayementMethod,
                          widget.date,
                          widget.job_id,
                          "Not Confirm",
                          widget.payed_amount,
                          widget.SeriviceProviderId,
                          context);

                      // provider Accept Time Send To Push Notification provider

                      await apicontroller
                          .getproviderdetails(widget.SeriviceProviderId);

                      await getproviderrdata();
//==============================================================================================================================================================================================================
                      apicontroller.SendPushNotification(
                          fcmkey,
                          "Cash Payment Request",
                          widget.finalprice.toString() +
                              ".Rs Payed You have to Confirm",
                          context);
//================================================================================================================================================================================================================

                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MainScreen(),
                          ));
                    })
                : RoundedButton(
                    buttonText: "Done",
                    onPress: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                AppointmentScreen(on: true, size: 0),
                          ));
                    }),
          ],
        ),
      ),
    );
  }
}
