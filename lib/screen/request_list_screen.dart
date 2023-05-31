import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:servicehub_client/Colors.dart';
import 'package:intl/intl.dart';
import 'package:servicehub_client/model/providerDetails.dart';
import 'package:servicehub_client/screen/request_detail_screen.dart';
import 'package:servicehub_client/styles.dart';
import 'package:servicehub_client/utils/constant.dart';
import 'package:http/http.dart' as http;
import 'package:smooth_star_rating_nsafe/smooth_star_rating.dart';

class RequestListScreen extends StatefulWidget {
  const RequestListScreen({super.key, required this.myindex});
  final int myindex;

  @override
  State<RequestListScreen> createState() => _RequestListScreenState();
}

class _RequestListScreenState extends State<RequestListScreen> {
  int providerindex = 0;
  int passindex = 0;
  List<ProviderDetails> providerlist = [];
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
    print("job id :" + widget.myindex.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      appBar: Styles.appBar(context),
      body: SingleChildScrollView(
        padding: Styles.defaultPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Requestes',
              style: screenTitle,
            ),
            FutureBuilder(
              future: getProviderDetails(widget.myindex.toString()),
              builder:
                  (context, AsyncSnapshot<List<ProviderDetails>> snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data!.isEmpty) {
                    return Center(
                      child: Text("No review requestes"),
                    );
                  }
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      //update wenne na

                      return InkWell(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  RequestDetailScreen(
                                    //update wene na
                                    indexes: widget.myindex,
                                    passindex: index,
                                  )));
                        },
                        child: requestCard(
                          snapshot.data![index].serviceProvider.fullName
                                      .toString()
                                      .length >
                                  12
                              ? snapshot.data![index].serviceProvider.fullName
                                      .toString()
                                      .substring(0, 14) +
                                  "..."
                              : snapshot.data![index].serviceProvider.fullName
                                  .toString(),
                          DateFormat('yyyy-MM-dd HH:mm')
                              .format(snapshot.data![index].job.createdAt)
                              .toString(),
                          snapshot.data![index].estimatedBudget.toString(),
                          snapshot.data![index].serviceProvider.avgRating
                              .toDouble(),
                        ),
                      );
                    },
                  );
                } else if (snapshot.hasError) {
                  return Text("${snapshot.error}");
                } else {
                  return Center(child: const CircularProgressIndicator());
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget requestCard(String full_name, String create_date,
      String Estimate_budget, double job_rating) {
    return Container(
      height: 55,
      margin: const EdgeInsets.symmetric(vertical: 7),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(9)),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                  color: kPrimary,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(8),
                      bottomLeft: Radius.circular(8))),
              child: Padding(
                padding: const EdgeInsets.only(left: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [],
                ),
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Container(
              decoration: BoxDecoration(
                  color: greyColor,
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(8),
                      bottomRight: Radius.circular(8))),
              child: Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Stack(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          full_name,
                          style: const TextStyle(
                              fontFamily: 'Segoe UI',
                              fontSize: 16.0,
                              color: darkText,
                              fontWeight: FontWeight.w700),
                        ),
                        Text(
                          create_date,
                          style: const TextStyle(
                            fontFamily: 'Segoe UI',
                            fontSize: 10.0,
                            color: darkText,
                          ),
                        ),
                        Text(
                          'LKR ' + Estimate_budget,
                          style: TextStyle(
                            fontFamily: 'Segoe UI',
                            fontSize: 10.0,
                            color: darkText,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    Positioned(
                        right: 8,
                        top: 20,
                        child: Container(
                            decoration: BoxDecoration(
                                color: white,
                                borderRadius: BorderRadius.circular(8)),
                            child: Padding(
                              padding: EdgeInsets.only(
                                  left: 15, right: 15, top: 2, bottom: 2),
                              child: Center(
                                child: SmoothStarRating(
                                    allowHalfRating: false,
                                    starCount: 5,
                                    rating: job_rating.toDouble(),
                                    size: 10.0,
                                    filledIconData: Icons.star,
                                    halfFilledIconData: Icons.star,
                                    color: Colors.red,
                                    borderColor: darkText,
                                    spacing: 0.0),
                              ),
                            )))
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
