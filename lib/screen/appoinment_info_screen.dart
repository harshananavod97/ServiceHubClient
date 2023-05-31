import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:servicehub_client/Colors.dart';
import 'package:servicehub_client/api/api_controller.dart';
import 'package:servicehub_client/model/appoiments.dart';
import 'package:servicehub_client/screen/multiple_poiunts_address.dart';
import 'package:servicehub_client/screen/request_list_screen.dart';
import 'package:servicehub_client/utils/constant.dart';
import 'package:servicehub_client/widget/rounded_button.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class AppoinmentInfoScreen extends StatefulWidget {
  const AppoinmentInfoScreen({super.key, required this.index});
  final int index;

  @override
  State<AppoinmentInfoScreen> createState() => _AppoinmentInfoScreenState();
}

class _AppoinmentInfoScreenState extends State<AppoinmentInfoScreen> {
  String fcmkey = "";
  getproviderrdata() async {
    final providerdetails = await SharedPreferences.getInstance();
    setState(() {
      fcmkey = providerdetails.getString('fcm_key').toString();
    });
  }

  Apicontroller apicontroller = Apicontroller();
  String customerid = '';

  getUserData() async {
    final ids = await SharedPreferences.getInstance();
    final idss = await SharedPreferences.getInstance();

    setState(() {
      ids.getString("id").toString().isNotEmpty
          ? customerid = ids.getString("id").toString()
          : customerid = idss.getString("id").toString();
    });

    // ignore: prefer_interpolation_to_compose_strings
    print("my id is" + customerid);

    //await prefs.setBool('isLogged', false);
  }

  List<ApoinmentList> apoinmentlist = [];
  Future<List<ApoinmentList>> getUpocomingApoiment(String id) async {
    var url = Uri.parse(
        // ignore: prefer_interpolation_to_compose_strings
        constant.APPEND_URL + "customer-upcoming-appointments?id=$id");
    final response = await http.get(url);
    print(response.body);
    var data = json.decode(response.body);
    if (response.statusCode == 200) {
      // If the server returns a 200 OK response, parse the JSON
      print('load sucess');

      final appontment = apoinmentListFromJson(response.body);

      print("appointment " + appontment.length.toString());

      apoinmentlist.addAll(appontment);
      print(response.body);

      return apoinmentlist;
    } else {
      return apoinmentlist;

      throw Exception('Failed to load data');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUpocomingApoiment(customerid);
    getUserData();
  }

  @override
  Widget build(BuildContext context) {
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
          // actions: [
          //   FutureBuilder(
          //     future: getUpocomingApoiment(customerid),
          //     builder: (context, AsyncSnapshot<List<ApoinmentList>> snapshot) =>
          //         InkWell(
          //       onTap: () async {
          //         print(
          //             "this is a" + snapshot.data![widget.index].id.toString());
          //         //dought
          //         apicontroller.RemoveProviderByCustomer(
          //             snapshot.data![widget.index].id.toString(), context);
          //         await apicontroller.getproviderdetails(snapshot
          //             .data![widget.index].selectedServiceProviderId
          //             .toString());
          //         //send push notification for client reqest for job
          //         //-==============================================================================================
          //         apicontroller.SendPushNotification(
          //           fcmkey.toString(),
          //           "Cancle The Job",
          //           "Cancled",
          //           context
          //         );
          //         //========================================================================================
          //       },
          //       child: Padding(
          //         padding: EdgeInsets.only(top: 10, right: 25),
          //         child: Text(
          //           'Cancel',
          //           style: TextStyle(
          //             fontFamily: 'Segoe UI',
          //             fontSize: 22.0,
          //             color: Color(0xFFEA4600),
          //             fontWeight: FontWeight.w600,
          //           ),
          //         ),
          //       ),
          //     ),
          //   ),
          // ],
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 0),
          child: FutureBuilder(
            future: getUpocomingApoiment(customerid),
            builder: (context, AsyncSnapshot<List<ApoinmentList>> snapshot) =>
                apoinmentlist.isEmpty
                    ? Center(child: const CircularProgressIndicator())
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                            const Text(
                              'Appointment Info',
                              style: screenTitle,
                            ),
                            const SizedBox(
                              height: 7,
                            ),
                            Text(
                              // ignore: prefer_interpolation_to_compose_strings
                              'Confirmed on ' +
                                  DateFormat('yyyy-MM-dd HH:mm').format(snapshot
                                      .data![widget.index]
                                      .serviceCategory
                                      .createdAt),
                              style: const TextStyle(
                                fontFamily: 'Segoe UI',
                                fontSize: 12.0,
                                color: lightGrey,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            const Text(
                              'Your Appointment for',
                              style: TextStyle(
                                fontFamily: 'Segoe UI',
                                fontSize: 15.0,
                                color: darkText,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const SizedBox(
                              height: 7,
                            ),
                            Text(
                              snapshot.data![widget.index].serviceCategory.name
                                  .toString()
                                  .split(' ')
                                  .map((word) =>
                                      '${word[0].toUpperCase()}${word.substring(1)}')
                                  .join(' '),
                              style: const TextStyle(
                                fontFamily: 'Segoe UI',
                                fontSize: 20.0,
                                color: lightGrey,
                                fontWeight: FontWeight.w700,
                              ),
                            ),

                            const SizedBox(
                              height: 4,
                            ),
                            // Text(
                            //   'Water tap fix',
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
                              'Date & Time',
                              style: TextStyle(
                                fontFamily: 'Segoe UI',
                                fontSize: 15.0,
                                color: darkText,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const SizedBox(
                              height: 2,
                            ),
                            Text(
                              DateFormat('yyyy-MM-dd HH:mm')
                                  .format(snapshot
                                      .data![widget.index].appointmentDateTime)
                                  .toString(),
                              style: const TextStyle(
                                fontFamily: 'Segoe UI',
                                fontSize: 20.0,
                                color: lightText,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            locationSection(
                                snapshot.data![widget.index].customerAddress
                                    .addressType
                                    .toString(),
                                snapshot.data![widget.index].customerAddress
                                    .address1
                                    .toString(),
                                snapshot.data![widget.index].customerAddress
                                    .address2
                                    .toString(),
                                snapshot
                                    .data![widget.index].customerAddress.city
                                    .toString()),
                            const SizedBox(
                              height: 20,
                            ),
                            budget(snapshot.data![widget.index].estimatedBudget
                                .toString()),
                            const SizedBox(
                              height: 20,
                            ),
                            additionalInfo(snapshot
                                .data![widget.index].addtionalInfo
                                .toString()),
                            const SizedBox(
                              //meka wenas kara
                              height: 60,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(),
                              child: RoundedButton(
                                buttonText: 'Review Requests',
                                onPress: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          RequestListScreen(
                                            myindex:
                                                snapshot.data![widget.index].id,
                                          )));
                                },
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(),
                              child: RoundedButton(
                                buttonText: 'Check Providers Location',
                                onPress: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          MultiplePointsOfMap()));
                                },
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            )
                          ]),
          ),
        ));
  }

  Widget locationSection(
      String addresstype, String address1, String address2, String city) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Location',
          style: TextStyle(
            fontFamily: 'Segoe UI',
            fontSize: 15.0,
            color: darkText,
            fontWeight: FontWeight.w800,
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
            color: lightGrey,
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

  Widget budget(String budget) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Budget',
          style: TextStyle(
            fontFamily: 'Segoe UI',
            fontSize: 15.0,
            color: darkText,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(
          height: 5,
        ),
        Text(
          'LKR ' + budget,
          style: const TextStyle(
            fontFamily: 'Segoe UI',
            fontSize: 20.0,
            color: lightGrey,
            fontWeight: FontWeight.w700,
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
            fontSize: 15.0,
            color: darkText,
            fontWeight: FontWeight.w800,
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
