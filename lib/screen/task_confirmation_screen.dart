import 'dart:convert';
import 'package:servicehub_client/api/api_controller.dart';
import 'package:servicehub_client/utils/constant.dart';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:servicehub_client/Colors.dart';
import 'package:servicehub_client/screen/task_complete_screen.dart';
import 'package:servicehub_client/styles.dart';
import 'package:servicehub_client/widget/rounded_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TaskConfirmationScreen extends StatefulWidget {
  TaskConfirmationScreen({
    super.key,
    required this.servececategoryid,
    required this.date,
    required this.time,
    required this.addtionalinfo,
    required this.addressid,
    required this.budget,
  });

  String servececategoryid, date, time, addtionalinfo, addressid, budget;

  @override
  State<TaskConfirmationScreen> createState() => _TaskConfirmationScreenState();
}

class _TaskConfirmationScreenState extends State<TaskConfirmationScreen> {
  Apicontroller apicontroller = Apicontroller();
  String job_type = "";
  String address_type = "",
      address_1 = "",
      address_2 = "",
      city = "",
      customerid = '';

  getServiceCategoryID(String id) async {
    print("GetAddressId id is" + id);

    var url = Uri.parse(constant.APPEND_URL + "service-category?id=$id");
    final response = await http.get(url);
    var jsonResponse = jsonDecode(response.body);

    var responseData = json.decode(response.body);
    print(response.body);
    print(response.statusCode);
    setState(() {
      job_type = jsonResponse['name'].toString();
    });

    //Creating a list to store input data;
  }

  getAddressDetails(String id) async {
    print("GetAddressId id is" + id);

    var url = Uri.parse(constant.APPEND_URL + "customer-address?id=$id");
    final response = await http.get(url);
    var jsonResponse = jsonDecode(response.body);

    var responseData = json.decode(response.body);
    print(response.body);
    print(response.statusCode);
    setState(() {
      address_type = jsonResponse['address_type'].toString();
      address_1 = jsonResponse['address_1'].toString();
      address_2 = jsonResponse['address_2'].toString();
      city = jsonResponse['city'].toString();
    });

    //Creating a list to store input data;
  }

  getUserData() async {
    final ids = await SharedPreferences.getInstance();
    final idss = await SharedPreferences.getInstance();
    ids.getString("id").toString().isNotEmpty
        ? customerid = ids.getString("id").toString()
        : customerid = idss.getString("id").toString();

    //await prefs.setBool('isLogged', false);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getServiceCategoryID(widget.servececategoryid);
    getAddressDetails(widget.addressid);
    getUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      appBar: Styles.appBar(context),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text(
            'Confirm Info',
            style: screenTitle,
          ),
          const SizedBox(
            height: 20,
          ),
          const Text(
            'Your Appointment for',
            style: TextStyle(
              fontFamily: 'Segoe UI',
              fontSize: 12.0,
              color: lightGrey,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(
            height: 7,
          ),
          Text(
            job_type,
            style: const TextStyle(
              fontFamily: 'Segoe UI',
              fontSize: 20.0,
              color: darkText,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(
            height: 4,
          ),
          // Text(
          //   ,
          //   style: TextStyle(
          //     fontFamily: 'Segoe UI',
          //     fontSize: 12.0,
          //     color: lightGrey,
          //     fontWeight: FontWeight.w600,
          //   ),
          // ),
          const SizedBox(
            height: 20,
          ),
          const Text(
            'Confirmed for',
            style: TextStyle(
              fontFamily: 'Segoe UI',
              fontSize: 12.0,
              color: lightGrey,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(
            height: 2,
          ),
          Text(
            widget.date,
            style: const TextStyle(
              fontFamily: 'Segoe UI',
              fontSize: 20.0,
              color: darkText,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(
            height: 2,
          ),
          Text(
            widget.time,
            style: const TextStyle(
              fontFamily: 'Segoe UI',
              fontSize: 20.0,
              color: darkText,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          locationSection(address_type, address_1, address_2, city),
          const SizedBox(
            height: 20,
          ),
          additionalInfo(widget.addtionalinfo),
          const SizedBox(
            height: 100,
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: ElevatedButton(
              onPressed: () {
                apicontroller.CreateAppoinment(
                    widget.servececategoryid,
                    customerid.toString(),
                    widget.date,
                    widget.time.replaceAll(RegExp('[AaPp][Mm]'), ''),
                    widget.addressid.toString(),
                    widget.budget.toString(),
                    'scheduled',
                    widget.addtionalinfo,
                    context);

                //apicontroller.CreateRequest(service_provider_id, job_id, estimated_time, estimated_budget, comment)
              },
              // ignore: sort_child_properties_last
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                child: Text(
                  'Confirm',
                  style: TextStyle(
                      fontFamily: 'Segoe UI',
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: white),
                ),
              ),
              style: ElevatedButton.styleFrom(
                elevation: 0,
                backgroundColor: kPrimary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(7), // <-- Radius
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
        ]),
      ),
    );
  }

  Widget locationSection(
      String addresstype, String address1, String address2, String city) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Location at',
          style: TextStyle(
            fontFamily: 'Segoe UI',
            fontSize: 12.0,
            color: lightGrey,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(
          height: 5,
        ),
        Text(
          addresstype,
          style: const TextStyle(
            fontFamily: 'Segoe UI',
            fontSize: 15.0,
            color: darkText,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(
          height: 2,
        ),
        Text(
          address1 + '\n' + address2 + '\n' + city,
          style: const TextStyle(
            fontFamily: 'Segoe UI',
            fontSize: 12.0,
            color: lightGrey,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget additionalInfo(String additionalinformation) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Additional Information',
          style: TextStyle(
            fontFamily: 'Segoe UI',
            fontSize: 12.0,
            color: lightGrey,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(
          height: 7,
        ),
        Text(
          additionalinformation,
          style: const TextStyle(
            fontFamily: 'Segoe UI',
            fontSize: 12.0,
            color: Color(0xFF828282),
          ),
        ),
      ],
    );
  }
}
