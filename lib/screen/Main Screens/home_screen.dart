import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:servicehub_client/Colors.dart';
import 'package:servicehub_client/Notifications/getfcm.dart';
import 'package:servicehub_client/api/api_controller.dart';
import 'package:servicehub_client/model/ServiceCategory.dart';
import 'package:servicehub_client/model/appoiments.dart';
import 'package:servicehub_client/screen/Main%20Screens/all_service_category.dart';
import 'package:servicehub_client/screen/Task/appoinment_task_screen.dart';
import 'package:servicehub_client/screen/Appoiment/appontment_screen.dart';
import 'package:servicehub_client/utils/Navigation_Function.dart';
import 'package:servicehub_client/utils/constant.dart';
import 'package:servicehub_client/widget/appoinment_card.dart';
import 'package:http/http.dart' as http;
import 'package:servicehub_client/widget/rounded_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  //capitalize the first letter of each word

  String _capitalizeWords(String str) {
    List<String> words = str.split(' ');
    for (int i = 0; i < words.length; i++) {
      words[i] = words[i][0].toUpperCase() + words[i].substring(1);
    }
    return words.join(' ');
  }

  Apicontroller apicontroller = Apicontroller();
  String customerid = '';
  bool _isButtonOn = true;
  String fcmKey = "";


  //Get Fcm Key
  void GetFcmToken() async {
    fcmKey = (await getFcmToken())!;

    Logger().i('FCM Key : $fcmKey');
  }

  @override
  void initState() {
    super.initState();
    GetFcmToken();
    getServiceCategory();
    getUserData();
    getUpocomingApoiment(customerid);
  }

  
//Get User Data

  getUserData() async {
    final ids = await SharedPreferences.getInstance();
    final idss = await SharedPreferences.getInstance();

    setState(() {
      ids.getString("id").toString().isNotEmpty
          ? customerid = ids.getString("id").toString()
          : customerid = idss.getString("id").toString();
      apicontroller.getcustomerdetails(customerid, context);
    });
    print("my id is" + customerid);
  }

//showing Service Count
  int count = 6;

//Service Name List
List<Datum> servicenameslist = [];



//Add Service Catergory List

  Future<List<Datum>> getServiceCategory() async {
    // ignore: prefer_interpolation_to_compose_strings
    var url = Uri.parse(
        // ignore: prefer_interpolation_to_compose_strings
        constant.APPEND_URL + "service-categories");
    final response = await http.get(url);
    print(response.body);
    var data = json.decode(response.body);
    if (response.statusCode == 200) {
      
      print('load sucess');

      final appontment = sericeNamesFromJson(response.body);
      servicenameslist.addAll(appontment.data);
      print(response.body);

      return servicenameslist;
    } else {
      return servicenameslist;

      throw Exception('Failed to load data');
    }
  }


//Customer  Upcoming Appoinments List
 List<ApoinmentList> apoinmentlist = [];


 //Get Customer Upcoming Appoinments
 
  Future<List<ApoinmentList>> getUpocomingApoiment(String id) async {
    apoinmentlist.clear();
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

      print(servicenameslist);
    } else {
      return apoinmentlist;

      throw Exception('Failed to load data');
    }
  }

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 65),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Featured Services',
                        style: TextStyle(
                          fontFamily: 'Segoe UI',
                          fontSize: 20.0,
                          color: darkText,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          setState(() {
                            NavigationUtillfunction.navigateTo(
                                context, AllServiceCategory());
                          });
                        },
                        child: const Text(
                          'View All',
                          style: TextStyle(
                            fontFamily: 'Segoe UI',
                            fontSize: 10.0,
                            color: darkText,
                          ),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  FutureBuilder(
                    future: getServiceCategory(),
                    builder: (context, AsyncSnapshot<List<Datum>> snapshot) =>
                        GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              childAspectRatio: 8.0 / 5.0,
                              crossAxisCount: 2,
                              crossAxisSpacing: 12,
                              mainAxisSpacing: 12),
                      itemBuilder: (BuildContext context, index) => InkWell(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  AppoinmentTaskScreen(
                                    serviceindex:
                                        snapshot.data![index].id.toString(),
                                  )));
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              color: const Color(0xFFD3CECE),
                              borderRadius: BorderRadius.circular(15)),
                          child: Center(
                            child: servicenameslist.isEmpty
                                ? const CircularProgressIndicator()
                                : Text(
                                    snapshot.data![index].name
                                                .toString()
                                                .length >
                                            24
                                        ? _capitalizeWords(snapshot
                                                .data![index].name
                                                .toString()
                                                .substring(0, 24)) +
                                            "..."
                                        : _capitalizeWords(snapshot
                                            .data![index].name
                                            .toString()),
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      color: Color(0xFF4E4848),
                                      fontFamily: 'Segoe UI',
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                          ),
                        ),
                      ),
                      itemCount: count,
                    ),
                  ),
                  const SizedBox(
                    height: 22,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Upcoming Appoinments',
                        style: TextStyle(
                          fontFamily: 'Segoe UI',
                          fontSize: 20.0,
                          color: darkText,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          NavigationUtillfunction.navigateTo(
                              context,
                              AppointmentScreen(
                                on: true,
                                size: 0,
                              ));
                        },
                        child: const Text(
                          'View All',
                          style: TextStyle(
                            fontFamily: 'Segoe UI',
                            fontSize: 10.0,
                            color: darkText,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  FutureBuilder(
                      future: getUpocomingApoiment(customerid),
                      builder: (context,
                          AsyncSnapshot<List<ApoinmentList>> snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(
                              child: const CircularProgressIndicator());
                        } else if (snapshot.hasData &&
                            snapshot.data!.isNotEmpty) {
                          final itemCount = snapshot.data!.length > 5
                              ? 5
                              : snapshot.data!.length;
                          return ListView.builder(
                              itemCount: itemCount,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                return AppoinmentCard(
                                  serviceindex: 0.toString(),
                                  index: index,
                                  addresstype: snapshot
                                      .data![index].customerAddress.addressType
                                      .toString(),
                                  date: DateFormat('yyyy-MM-dd ')
                                      .format(
                                          snapshot.data![index].appointmentDate)
                                      .toString(),
                                  time: snapshot.data![index].appointmentTime
                                      .toString(),
                                  budget: snapshot.data![index].estimatedBudget
                                      .toString(),
                                  additionalinfo: snapshot
                                      .data![index].addtionalInfo
                                      .toString(),
                                  jobtype: snapshot
                                              .data![index].serviceCategory.name
                                              .toString()
                                              .length >
                                          24
                                      ? _capitalizeWords(snapshot
                                              .data![index].serviceCategory.name
                                              .toString()
                                              .substring(0, 20)) +
                                          "..."
                                      : _capitalizeWords(snapshot
                                          .data![index].serviceCategory.name
                                          .toString()),
                                  jobstatus: snapshot.data![index].jobStatus
                                      .toString(),
                                  isPending: true,
                                  isPast: false,
                                );
                              });
                        } else if (snapshot.hasError) {
                          return Text("${snapshot.error}");
                        } else {
                          return Center(
                            child: const Text(
                              "No available data",
                              style: TextStyle(
                                fontFamily: 'Segoe UI',
                                fontSize: 15.0,
                                color: darkText,
                              ),
                            ),
                          );
                        }
                      }),
                  // RoundedButton(
                  //     buttonText: "text",
                  //     onPress: () {
                  //       Navigator.push(
                  //           context,
                  //           MaterialPageRoute(
                  //             builder: (context) => MultiplePointsOfMap(),
                  //           ));
                  //     })
                ],
              ),
            ),
            Positioned(
                top: 0,
                child: Container(
                  color: navigationTop,
                  height: 23,
                  width: MediaQuery.of(context).size.width,
                )),
          ],
        ),
      ),
    );
  }
}
