import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:servicehub_client/Colors.dart';
import 'package:servicehub_client/model/appoiments.dart';
import 'package:servicehub_client/model/pastappoiments.dart';
import 'package:servicehub_client/utils/constant.dart';
import 'package:servicehub_client/widget/appoinment_card.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class AppointmentScreen extends StatefulWidget {
  AppointmentScreen({super.key, required this.on, required this.size});
  bool on;
  double size;

  @override
  State<AppointmentScreen> createState() => _AppointmentScreenState();
}

class _AppointmentScreenState extends State<AppointmentScreen> {
  String _capitalizeWords(String str) {
    List<String> words = str.split(' ');
    for (int i = 0; i < words.length; i++) {
      words[i] = words[i][0].toUpperCase() + words[i].substring(1);
    }
    return words.join(' ');
  }

  String customerid = '';
  @override
  void initState() {
    super.initState();

    getUserData();

    getUpocomingApoiment(customerid);
    getPastApoiment(customerid); //customer id
  }

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
    } else {
      return apoinmentlist;

      throw Exception('Failed to load data');
    }
  }

  List<PastApoinmentList> pastapoinmentlist = [];
  Future<List<PastApoinmentList>> getPastApoiment(String id) async {
    pastapoinmentlist.clear();
    var url = Uri.parse(
        // ignore: prefer_interpolation_to_compose_strings
        constant.APPEND_URL + "customer-past-appointments?id=$id");
    final response = await http.get(url);
    print(response.body);
    var data = json.decode(response.body);
    if (response.statusCode == 200) {
      // If the server returns a 200 OK response, parse the JSON
      print('load sucess');

      final appontment = pastApoinmentListFromJson(response.body);

      print("appointment " + appontment.length.toString());

      pastapoinmentlist.addAll(appontment);
      print(response.body);

      return pastapoinmentlist;
    } else {
      return pastapoinmentlist;

      throw Exception('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.on
          ? AppBar(
              elevation: 0,
              //leadingWidth: 30,
              titleSpacing: 0,
              backgroundColor: white,
              foregroundColor: Colors.black,
              leading: widget.on
                  ? Padding(
                      padding: const EdgeInsets.only(left: 22),
                      child: IconButton(
                        icon: const Icon(
                          Icons.arrow_back_ios,
                          color: Colors.black,
                          size: 24,
                        ),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    )
                  : const SizedBox(
                      height: 0,
                    ),
              title: widget.on ? const Text('Back') : null,
              actions: const [],
            )
          : null,
      backgroundColor: white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: widget.size,
            ),
            const Text(
              'My Appoinments',
              style: screenTitle,
            ),
            const SizedBox(
              height: 13,
            ),
            FutureBuilder(
                future: getUpocomingApoiment(customerid),
                builder:
                    (context, AsyncSnapshot<List<ApoinmentList>> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                    return ListView.builder(
                        itemCount: apoinmentlist.length,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          return AppoinmentCard(
                            serviceindex: 0.toString(), ////dought
                            index: index,
                            jobstatus:
                                snapshot.data![index].jobStatus.toString(),
                            addresstype: snapshot
                                .data![index].customerAddress.addressType
                                .toString(),
                            date: DateFormat('yyyy-MM-dd ')
                                .format(snapshot.data![index].appointmentDate)
                                .toString(),
                            time: snapshot.data![index].appointmentTime
                                .toString(),
                            budget: snapshot.data![index].estimatedBudget
                                .toString(),
                            additionalinfo:
                                snapshot.data![index].jobStatus.toString(),
                            jobtype: snapshot.data![index].serviceCategory.name
                                        .toString()
                                        .length >
                                    20
                                ? _capitalizeWords(snapshot
                                        .data![index].serviceCategory.name
                                        .toString()
                                        .substring(0, 20)) +
                                    "..."
                                : _capitalizeWords(snapshot
                                    .data![index].serviceCategory.name
                                    .toString()),

                            isPending: true,
                            isPast: false,
                          );
                        });
                  } else {
                    return const Center(
                      child: Text(
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
            const SizedBox(
              height: 10,
            ),
            const Text(
              'Past Appointments',
              style: TextStyle(
                fontFamily: 'Segoe UI',
                fontSize: 20.0,
                color: darkText,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(
              height: 13,
            ),
            FutureBuilder(
              future: getPastApoiment(customerid),
              builder:
                  (context, AsyncSnapshot<List<PastApoinmentList>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  if (snapshot.data == null || pastapoinmentlist.isEmpty) {
                    return const Center(
                      child: Text(
                        "No available data",
                        style: TextStyle(
                          fontFamily: 'Segoe UI',
                          fontSize: 15.0,
                          color: darkText,
                        ),
                      ),
                    );
                  } else {
                    return ListView.builder(
                      itemCount: pastapoinmentlist.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return AppoinmentCard(
                          serviceindex: snapshot.data![index].id.toString(),
                          jobstatus: snapshot.data![index].jobStatus.toString(),
                          index: index,
                          addresstype: snapshot
                              .data![index].customerAddress.addressType
                              .toString(),
                          date: DateFormat('yyyy-MM-dd ')
                              .format(snapshot.data![index].appointmentDate)
                              .toString(),
                          time:
                              snapshot.data![index].appointmentTime.toString(),
                          budget:
                              snapshot.data![index].estimatedBudget.toString(),
                          additionalinfo:
                              snapshot.data![index].jobStatus.toString(),
                          jobtype: snapshot.data![index].serviceCategory.name
                                      .toString()
                                      .length >
                                  20
                              ? _capitalizeWords(snapshot
                                      .data![index].serviceCategory.name
                                      .toString()
                                      .substring(0, 20)) +
                                  "..."
                              : _capitalizeWords(snapshot
                                  .data![index].serviceCategory.name
                                  .toString()),
                          isPending: true,
                          isPast: true,
                        );
                      },
                    );
                  }
                }
              },
            )
          ],
        ),
      ),
    );
  }
}
