import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:servicehub_client/Colors.dart';
import 'package:servicehub_client/api/api_controller.dart';
import 'package:servicehub_client/model/JobProvider.dart';
import 'package:servicehub_client/model/providerDetails.dart';
import 'package:servicehub_client/screen/Appoiment/appoinment_complete_screen.dart';
import 'package:servicehub_client/screen/Payment/payment_screen.dart';
import 'package:servicehub_client/styles.dart';
import 'package:servicehub_client/utils/constant.dart';
import 'package:servicehub_client/widget/rounded_button.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';







class AppoinmentInfo2Screen extends StatefulWidget {
  const AppoinmentInfo2Screen(
      {super.key,
      required this.index,
      required this.passindex,
      required this.providerid});
  final int index;
  final int passindex;
  final String providerid;

  @override
  State<AppoinmentInfo2Screen> createState() => _AppoinmentInfo2ScreenState();
}

class _AppoinmentInfo2ScreenState extends State<AppoinmentInfo2Screen> {
  String providerid = '';

 
  String fcmkey = "";
  getproviderrdata() async {
    final providerdetails = await SharedPreferences.getInstance();
    setState(() {
      fcmkey = providerdetails.getString('fcm_key').toString();
    });
  }

  Apicontroller apicontroller = Apicontroller();
  List<JobProvider> jobprovider = [];
  List<ProviderDetails> providerlist = [];


//Get Provider Details

  Future<List<ProviderDetails>> getProviderDetails(String id) async {
    providerlist.clear();
    var url = Uri.parse(
        // ignore: prefer_interpolation_to_compose_strings
        constant.APPEND_URL + "job-requests?id=$id");
    final response = await http.get(url);
    print(response.body);
    var data = json.decode(response.body);
    if (response.statusCode == 200) {
      // If the server returns a 200 OK response, parse the JSON
      print('load sucess');

      final appontment = providerDetailsFromJson(response.body);

      providerlist.addAll(appontment);
      print(response.body);

      return providerlist;
    } else {
      return providerlist;

      throw Exception('Failed to load data');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
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
              color: Colors.white,
              size: 24,
            ),
            onPressed: () {},
          ),
        ),
        title: InkWell(
          child: const Text(
            'Back',
            style: TextStyle(color: Colors.white),
          ),
          onTap: () {},
        ),
        actions: [
          InkWell(
            onTap: () async {
              //dought
              apicontroller.RemoveProviderByCustomer(
                  widget.index.toString(), context);
              await apicontroller
                  .getproviderdetails(widget.providerid.toString());

              await getproviderrdata();
              //send push notification for client reqest for job


              //-==============================================================================================
              apicontroller.SendPushNotification(
                  fcmkey.toString(), "Cancle The Job", "Cancled", context);
              //========================================================================================
            },
            child: Padding(
              padding: EdgeInsets.only(top: 10, right: 25),
              child: Text(
                'Cancel',
                style: TextStyle(
                  fontFamily: 'Segoe UI',
                  fontSize: 22.0,
                  color: Color(0xFFEA4600),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 0),
          child: FutureBuilder(
            future: getProviderDetails(widget.index.toString()),
            builder: (context, AsyncSnapshot<List<ProviderDetails>> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: Center(child: CircularProgressIndicator()),
                );
              } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                return Column(
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
                      'Confirmed on ' +
                          DateFormat('yyyy-MM-dd HH:mm')
                              .format(
                                  snapshot.data![widget.passindex].createdAt)
                              .toString(),
                      // ignore: prefer_const_constructors
                      style: TextStyle(
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
                        fontSize: 12.0,
                        color: darkText,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(
                      height: 7,
                    ),
                    Text(
                      snapshot.data![widget.passindex].job.serviceCategory.name
                          .toString()
                          .split(' ')
                          .map((word) =>
                              '${word[0].toUpperCase()}${word.substring(1)}')
                          .join(' '),
                      style: TextStyle(
                        fontFamily: 'Segoe UI',
                        fontSize: 20.0,
                        color: lightGrey,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    const Text(
                      'Date & time',
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
                              .data![widget.passindex].job.appointmentDateTime)
                          .toString(),
                      style: const TextStyle(
                        fontFamily: 'Segoe UI',
                        fontSize: 20.0,
                        color: lightGrey,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    locationSection(
                      snapshot.data![widget.passindex].job.customerAddress
                          .addressType
                          .toString(),
                      snapshot
                          .data![widget.passindex].job.customerAddress.address1
                          .toString(),
                      snapshot
                          .data![widget.passindex].job.customerAddress.address2
                          .toString(),
                      snapshot.data![widget.passindex].job.customerAddress.city
                          .toString(),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    budget(snapshot.data![widget.passindex].estimatedBudget
                        .toString()),
                    const SizedBox(
                      height: 20,
                    ),
                    additionalInfo(
                      snapshot.data![widget.passindex].job.addtionalInfo
                          .toString(),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    provider(
                      snapshot.data![widget.passindex].serviceProvider.fullName
                          .toString(),
                      snapshot.data![widget.passindex].serviceProvider.email
                          .toString(),
                      snapshot
                          .data![widget.passindex].serviceProvider.phoneNumber
                          .toString(),
                    ),
                    const SizedBox(
                      height: 43,
                    ),
                    RoundedButton(
                      buttonText: 'Finish & Pay',
                      onPress: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => PayementScreen(
                            profile_pic: snapshot.data![widget.passindex]
                                        .serviceProvider.profilePic ==
                                    null
                                ? "null"
                                : snapshot.data![widget.passindex]
                                    .serviceProvider.profilePic
                                    .toString(),
                            date: snapshot
                                .data![widget.passindex].job.requestDate
                                .toString(),
                            serive_rovider_id: snapshot
                                .data![widget.passindex].serviceProvider.id
                                .toString(),
                            job_id: snapshot.data![widget.passindex].jobId
                                .toString(),
                            payroute: snapshot.data![widget.passindex].job
                                .serviceCategory.payoutRate
                                .toString(),
                            Categoryname: snapshot.data![widget.passindex].job
                                .serviceCategory.name
                                .toString(),
                            serviceprovisername: snapshot
                                .data![widget.passindex]
                                .serviceProvider
                                .fullName
                                .toString(),
                            estimatebudget: snapshot
                                .data![widget.passindex].estimatedBudget
                                .toString(),
                          ),
                        ));
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                  ],
                );
              } else {
                return const Text('No data available');
              }
            },
          )),
    );
  }

  Widget locationSection(
      String addresstype, String address1, String address2, String city) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Locaion',
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
            color: Color(0xFF828282),
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

  Widget provider(String fullname, String provideremail, String PhoneNumber) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Provider',
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
          fullname,
          style: const TextStyle(
            fontFamily: 'Segoe UI',
            fontSize: 15.0,
            color: lightGrey,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(
          height: 7,
        ),
        //meka balanath onee
        Text(
          PhoneNumber,
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
          provideremail,
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
}
