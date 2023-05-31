import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:servicehub_client/Colors.dart';
import 'package:servicehub_client/api/api_controller.dart';
import 'package:servicehub_client/api/payment_api.dart';
import 'package:servicehub_client/screen/Payment_Status.dart';

import 'package:servicehub_client/widget/rounded_button.dart';
import 'package:servicehub_client/widget/webview.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PayementScreen extends StatefulWidget {
  PayementScreen({
    super.key,
    required this.serive_rovider_id,
    required this.serviceprovisername,
    required this.estimatebudget,
    required this.Categoryname,
    required this.payroute,
    required this.job_id,
    required this.date,
    required this.profile_pic,
  });
  String serviceprovisername;
  String estimatebudget;
  String Categoryname;
  String payroute;
  String date;
  String job_id;
  String serive_rovider_id;
  String profile_pic;

  @override
  State<PayementScreen> createState() => _PayementScreenState();
}

class _PayementScreenState extends State<PayementScreen> {
  String _capitalizeWords(String str) {
    List<String> words = str.split(' ');
    for (int i = 0; i < words.length; i++) {
      words[i] = words[i][0].toUpperCase() + words[i].substring(1);
    }
    return words.join(' ');
  }

  Apicontroller apicontroller = Apicontroller();
  String TransactionId = '';

  String urll = '';
  String Phn_no = "";
  String email = "";
  String customerid = "";

  int _activeIndex = 0;

  void _handleTap(int index) {
    setState(() {
      _activeIndex = index;
    });
  }

  getUserData() async {
    final ids = await SharedPreferences.getInstance();
    final idss = await SharedPreferences.getInstance();
    ids.getString("id").toString().isNotEmpty
        ? customerid = ids.getString("id").toString()
        : customerid = idss.getString("id").toString();

    print("my id is" + customerid);
  }

  String baseurl = "https://api.uat.geniebiz.lk/public";
  Future<void> CreateTransaction(double amount, String currency) async {
    Map data = {
      "amount": amount,
      "currency": currency,
    };

    print("post data $data");
    int index_of_no = 0;
    String body = json.encode(data);
    var url = Uri.parse(baseurl + '/v2/transactions');
    print("post url $url"); // Print the URL
    var response = await http.post(
      url,
      body: body,
      headers: {
        "accept": "application/json",
        "Authorization":
            "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJhcHBJZCI6IjM2YmFmY2U3LWEyMDEtNDI5Yi1hOWUyLWM1Yjc4NTQ2Njc3YyIsImNvbXBhbnlJZCI6IjYzOTdmMzlkZjA3ZmJhMDAwODQyYTkwYiIsImlhdCI6MTY3MDkwMjY4NSwiZXhwIjo0ODI2NTc2Mjg1fQ.fy12dgFhA3iB_RCjD7y8j5HClNRZUiBZgAg-QzFpxaE"
      },
    );
    print(response.body);
    print(response.statusCode);
    var jsonData = jsonDecode(response.body);
    print(response.body);
    if (response.statusCode == 200 || response.statusCode == 201) {
      Logger().i('Success');
      print('Response ID: ${jsonData['id']}'); // Print the response ID
      print('Response URL: ${jsonData['url']}');
      setState(() {
        TransactionId = jsonData['id'].toString();
        //URL SAVE
        urll = jsonData['url'].toString();
      });
      //ID SAVE

      index_of_no = 0;

      // Print the URL
    } else {
      Logger().e('Error');
      index_of_no = 1;
    }
    // await transaction.setInt('index_of_no', index_of_no);
  }

  getcustomerdata() async {
    final customerdetails = await SharedPreferences.getInstance();
    final transaction = await SharedPreferences.getInstance();
    setState(() {
      // emailControlleer.text = customerdetails.getString('email').toString();
      // emailControlleer.text =
      email = customerdetails.getString('email').toString();
      Phn_no = customerdetails.getString('phone_number').toString();
      print("my url is" + urll.toString());
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getcustomerdata();
    getUserData();
    print("id is  mm  " + TransactionId.toString());
  }

  @override
  Widget build(BuildContext context) {
    double finalprice = (double.parse(widget.estimatebudget) +
        (double.parse(widget.estimatebudget) -
            ((double.parse(widget.estimatebudget) *
                    double.parse(widget.payroute)) /
                100)));
    Color cardpaymentcolor = Colors.white;
    Color CashPayementColor = Colors.white;
    PaymentApi paymentApi = PaymentApi();
    return Scaffold(
      backgroundColor: white,
      appBar: AppBar(
        elevation: 0,
        //leadingWidth: 30,
        titleSpacing: 0,
        backgroundColor: white,
        foregroundColor: Colors.black,
        leading: Padding(
          padding: const EdgeInsets.only(left: 22),
          child: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
              size: 24,
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        title: const Text('Back'),
        actions: const [],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text(
            'Payment Confirmation ',
            style: screenTitle,
          ),
          const SizedBox(
            height: 20,
          ),
          //sapumal
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                  color: Colors.blue,
                  height: 80,
                  width: 80,
                  child: widget.profile_pic.toString() == "null"
                      ? Center(child: const Text('No image'))
                      : Image.network(
                          'https://servicehub.clickytesting.xyz/' +
                              widget.profile_pic,
                          fit: BoxFit.cover,
                        )),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.serviceprovisername.toString().length > 12
                        ? widget.serviceprovisername
                                .toString()
                                .substring(0, 12) +
                            '...'
                        : widget.serviceprovisername.toString(),
                    style: TextStyle(
                      fontFamily: 'Segoe UI',
                      fontSize: 15.0,
                      color: lightGrey,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    'In stock',
                    style: TextStyle(
                      fontFamily: 'Segoe UI',
                      fontSize: 12.0,
                      color: lightGrey,
                      fontWeight: FontWeight.w600,
                    ),
                  )
                ],
              ),
              Text(
                widget.estimatebudget,
                style: TextStyle(
                  fontFamily: 'Segoe UI',
                  fontSize: 18.0,
                  color: darkText,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          ////
          // UpperSection(
          //     name: widget.serviceprovisername.toString().length > 12
          //         ? widget.serviceprovisername.toString().substring(0, 12) +
          //             '...'
          //         : widget.serviceprovisername.toString(),
          //     budget: widget.estimatebudget),

          ////
          SizedBox(
            height: 40,
          ),
          const Text(
            'More Information',
            style: TextStyle(
              fontFamily: 'Segoe UI',
              fontSize: 20.0,
              color: darkText,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Text(
            'Service',
            style: TextStyle(
              fontFamily: 'Segoe UI',
              fontSize: 20.0,
              color: lightGrey,
              fontWeight: FontWeight.w600,
            ),
          ),
          PriceList(
            servicecatogoryname: widget.Categoryname.toString().length > 15
                ? _capitalizeWords(widget.Categoryname)
                        .toString()
                        .substring(0, 15) +
                    '...'
                : _capitalizeWords(widget.Categoryname).toString(),
            budjet: widget.estimatebudget,
            payroute: widget.payroute,
          ),
          const Text(
            'Payment Method',
            style: TextStyle(
              fontFamily: 'Segoe UI',
              fontSize: 20.0,
              color: darkText,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(
            height: 20,
          ),

          Column(
            children: [
              Row(
                children: [
                  CircleTickButton(
                    title: "Button 1",
                    icon: Icons.circle,
                    isActive: _activeIndex == 0,
                    onTap: () => _handleTap(0),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Text(
                    'Card Payment',
                    style: TextStyle(
                      fontFamily: 'Segoe UI',
                      fontSize: 18.0,
                      color: darkText,
                      fontWeight: FontWeight.w600,
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  CircleTickButton(
                    title: "Button 2",
                    icon: Icons.circle,
                    isActive: _activeIndex == 1,
                    onTap: () => _handleTap(1),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Text(
                    'Cash Payment',
                    style: TextStyle(
                      fontFamily: 'Segoe UI',
                      fontSize: 18.0,
                      color: darkText,
                      fontWeight: FontWeight.w600,
                    ),
                  )
                ],
              ),
            ],
          ),
          SizedBox(
            height: 40,
          ),
          RoundedButton(
            buttonText: "Proceed to Checkout",
            onPress: () async {
              if (_activeIndex == 0) {
                if (finalprice > 30.00) {
                  await CreateTransaction(finalprice * 100, 'LKR');
                  //url open *****************************************************
                  await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => WebViewExample(
                            profile_pic: widget.profile_pic,
                                job_id: widget.job_id,
                                date: widget.date,
                                TransactionId: TransactionId.toString(),
                                PayementMethod:
                                    _activeIndex == 0 ? "card" : "cash",
                                payed_amount: finalprice.toString(),
                                SeriviceProviderId:
                                    widget.serive_rovider_id.toString(),
                                customerId: customerid.toString(),
                                payemetReferences: "done",
                                url: urll,
                              )));
                  //navigate to the payment status*************************
                } else {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title:
                            Text("Your Appoiment Payment Need Grater than 30"),
                        actions: <Widget>[
                          Center(
                            child: ElevatedButton(
                              child: const Text('OK'),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                          ),
                        ],
                      );
                    },
                  );
                }
              } else {
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                        builder: (context) => PayementStatus(
                          profile_pc: widget.profile_pic,
                              job_id: widget.job_id,
                              date: widget.date,
                              TransactionId: TransactionId.toString(),
                              PayementMethod:
                                  _activeIndex == 0 ? "card" : "cash",
                              payed_amount: finalprice.toString(),
                              SeriviceProviderId:
                                  widget.serive_rovider_id.toString(),
                              customerId: customerid.toString(),
                              payemetReferences: "done",
                              indexofpayment: 2,
                              finalprice: finalprice,
                            )),
                    (route) => false);
              }
            },
          ),

          SizedBox(
            height: 30,
          ),
        ]),
      ),
    );
  }
}

class CircleTickButton extends StatelessWidget {
  final String title;
  final IconData icon;
  final bool isActive;
  final VoidCallback onTap;

  const CircleTickButton({
    Key? key,
    required this.title,
    required this.icon,
    required this.isActive,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 30,
        width: 30,
        decoration: BoxDecoration(
          color: isActive ? Colors.blue : Colors.grey,
          shape: BoxShape.circle,
        ),
        child: Center(
          child: Icon(
            size: 20,
            icon,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _activeIndex = 0;

  void _handleTap(int index) {
    setState(() {
      _activeIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Circle Tick Buttons"),
      ),
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleTickButton(
              title: "Button 1",
              icon: Icons.check,
              isActive: _activeIndex == 0,
              onTap: () => _handleTap(0),
            ),
            const SizedBox(width: 16),
            CircleTickButton(
              title: "Button 2",
              icon: Icons.check,
              isActive: _activeIndex == 1,
              onTap: () => _handleTap(1),
            ),
          ],
        ),
      ),
    );
  }
}

class PriceList extends StatelessWidget {
  PriceList(
      {super.key,
      required this.servicecatogoryname,
      required this.budjet,
      required this.payroute});
  String servicecatogoryname;
  String budjet;
  String payroute;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SubListItems(
            subPrice: budjet,
            sublistTitle: servicecatogoryname,
            textstyle: lightGrey),
        SizedBox(
          height: 10,
        ),
        SubListItems(
          subPrice: (double.parse(budjet) -
                  ((double.parse(budjet) * double.parse(payroute)) / 100))
              .toStringAsFixed(2),
          sublistTitle: "Service Charge",
          textstyle: lightGrey,
        ),
        SizedBox(
          height: 10,
        ),
        Divider(
          color: darkText,
          thickness: 2,
        ),
        SubListItems(
          subPrice: (double.parse(budjet) +
                  (double.parse(budjet) -
                      ((double.parse(budjet) * double.parse(payroute)) / 100)))
              .toStringAsFixed(2),
          sublistTitle: 'Sub Total',
          textstyle: lightGrey,
        ),
        SizedBox(
          height: 10,
        ),
        SubListItems(
            subPrice: '0.00', sublistTitle: 'Discount', textstyle: lightGrey),
        SizedBox(
          height: 10,
        ),
        SubListItems(
          subPrice: (double.parse(budjet) +
                  (double.parse(budjet) -
                      ((double.parse(budjet) * double.parse(payroute)) / 100)))
              .toStringAsFixed(2),
          sublistTitle: 'Total',
          textstyle: darkText,
        ),
        Divider(
          color: darkText,
          thickness: 2,
        ),
        SizedBox(
          height: 10,
        ),
      ],
    );
  }
}

class UpperSection extends StatelessWidget {
  UpperSection({
    required this.budget,
    required this.name,
    super.key,
  });
  String name, budget;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          color: Colors.blue,
          height: 80,
          width: 80,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              name,
              style: TextStyle(
                fontFamily: 'Segoe UI',
                fontSize: 15.0,
                color: lightGrey,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              'In stock',
              style: TextStyle(
                fontFamily: 'Segoe UI',
                fontSize: 12.0,
                color: lightGrey,
                fontWeight: FontWeight.w600,
              ),
            )
          ],
        ),
        Text(
          budget,
          style: TextStyle(
            fontFamily: 'Segoe UI',
            fontSize: 18.0,
            color: darkText,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

class SubListItems extends StatelessWidget {
  const SubListItems(
      {super.key,
      required this.subPrice,
      required this.sublistTitle,
      required this.textstyle});
  final sublistTitle;
  final subPrice;
  final textstyle;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          sublistTitle,
          style: TextStyle(
            fontFamily: 'Segoe UI',
            fontSize: 18.0,
            color: textstyle,
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(
          'Rs ' + subPrice,
          style: TextStyle(
            fontFamily: 'Segoe UI',
            fontSize: 18.0,
            color: darkText,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}
