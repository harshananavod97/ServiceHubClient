import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:servicehub_client/api/api_controller.dart';
import 'package:servicehub_client/screen/Payment/Payment_Status.dart';
import 'package:servicehub_client/screen/Main%20Screens/Drawer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../utils/Navigation_Function.dart';

class WebViewExample extends StatefulWidget {
  final String url;
  final String customerId;
  final String PayementMethod;
  final String payemetReferences;
  final String payed_amount;
  final String SeriviceProviderId;
  final String TransactionId;
  final String date;
  final String job_id;
  final String profile_pic;

  WebViewExample(
      {required this.job_id,
      required this.date,
      required this.url,
      required this.PayementMethod,
      required this.SeriviceProviderId,
      required this.customerId,
      required this.payed_amount,
      required this.payemetReferences,
      required this.TransactionId,
      required this.profile_pic});

  @override
  _WebViewExampleState createState() => _WebViewExampleState();
}

class _WebViewExampleState extends State<WebViewExample> {
  String fcmkey = "";
  getproviderrdata() async {
    final providerdetails = await SharedPreferences.getInstance();
    setState(() {
      fcmkey = providerdetails.getString('fcm_key').toString();
    });
  }

  Apicontroller apicontroller = Apicontroller();
  late WebViewController _webViewController;
  bool _isLoading = true;
  String name = '';
  getcustomerdata() async {
    final customerdetails = await SharedPreferences.getInstance();
    setState(() {
      print(customerdetails.getString('full_name').toString());
      customerdetails != null && customerdetails.getString('full_name') != null
          ? name = customerdetails.getString('full_name').toString()
          : name = "Full name";
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
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            SizedBox(
              height: 20,
            ),
            WebView(
              initialUrl: widget.url,
              javascriptMode: JavascriptMode.unrestricted,
              onWebViewCreated: (WebViewController webViewController) {
                _webViewController = webViewController;
              },
              onPageFinished: (String url) {
                handlePageNavigation(url);
                setState(() {
                  _isLoading = false;
                });
              },
            ),
            if (_isLoading)
              Center(
                child: CircularProgressIndicator(),
              ),
          ],
        ),
      ),
    );
  }

  Future<void> handlePageNavigation(String url) async {
    print(url);

    if (url.endsWith("wait=1")) {
      print("payment successful");

      await apicontroller.getproviderdetails(widget.SeriviceProviderId);
      await getproviderrdata();

      //client payment sucessfull time send to provider to push notification
//========================================================================================================================================================================================
      apicontroller.SendPushNotification(
          fcmkey.toString(),
          name + "  Send Your Payment",
          "Please find your payment\n Payment: " + widget.payed_amount,
          context);
//==========================================================================================================================================================================================

      NavigationUtillfunction.navigateTo(
          context,
          PayementStatus(
            profile_pc: widget.profile_pic,
            PayementMethod: "",
            SeriviceProviderId: widget.SeriviceProviderId,
            customerId: "",
            date: "",
            job_id: "",
            payed_amount: "",
            payemetReferences: "",
            indexofpayment: 0,
            finalprice: double.parse(widget.payed_amount),
            TransactionId: widget.TransactionId.toString(),
          ));

      apicontroller.CreatePayment(
          widget.customerId,
          widget.PayementMethod,
          widget.date,
          widget.job_id,
          widget.payemetReferences,
          widget.payed_amount,
          widget.SeriviceProviderId,
          context);
    } else if (url.endsWith("error=1")) {
      print("payment Failed");
      NavigationUtillfunction.navigateTo(
          context,
          PayementStatus(
            profile_pc: widget.profile_pic,
            PayementMethod: "",
            SeriviceProviderId: widget.SeriviceProviderId,
            customerId: "",
            date: "",
            job_id: "",
            payed_amount: "",
            payemetReferences: "",
            indexofpayment: 1,
            finalprice: double.parse(widget.payed_amount),
            TransactionId: widget.TransactionId.toString(),
          ));
    } else {
      print("unsucessfull");
    }
  }
}
