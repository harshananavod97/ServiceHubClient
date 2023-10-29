import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:servicehub_client/api/api_controller.dart';
import 'package:servicehub_client/model/JobProvider.dart';
import 'package:servicehub_client/model/providerDetails.dart';
import 'package:servicehub_client/utils/constant.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:servicehub_client/Colors.dart';
import 'package:servicehub_client/screen/Appoiment/appoinment_info_2_screen.dart';
import 'package:servicehub_client/styles.dart';
import 'package:servicehub_client/widget/rounded_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_star_rating_nsafe/smooth_star_rating.dart';

class RequestDetailScreen extends StatefulWidget {
  const RequestDetailScreen(
      {super.key, required this.indexes, required this.passindex});
  final int indexes;
  final int passindex;

  @override
  State<RequestDetailScreen> createState() => _RequestDetailScreenState();
}

class _RequestDetailScreenState extends State<RequestDetailScreen> {
  //Get Customer Name
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

//Get Fcm Key

  String fcmkey = "";

  getproviderrdata() async {
    final providerdetails = await SharedPreferences.getInstance();
    setState(() {
      fcmkey = providerdetails.getString('fcm_key').toString();
    });
  }

  Apicontroller apicontroller = Apicontroller();

  var rating = 0.0;
  List<JobProvider> jobprovider = [];
  List<ProviderDetails> providerlist = [];

  //Load Provider Reqest Details

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
    getProviderDetails(widget.indexes.toString());
    // print("reques job id is :" + widget.indexes.toString());
    getcustomerdata();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      appBar: Styles.appBar(context),
      body: SingleChildScrollView(
        padding: Styles.defaultPadding,
        child: FutureBuilder(
          future: getProviderDetails(widget.indexes.toString()),
          builder: (context, AsyncSnapshot<List<ProviderDetails>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              // return a loader or a placeholder widget while data is being fetched
              return Center(child: const CircularProgressIndicator());
            } else {
              // render the UI when data is available
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      height: 150,
                      width: 150,
                      decoration: BoxDecoration(
                          color: kPrimary,
                          borderRadius: BorderRadius.circular(100)),
                      child: ClipOval(
                          child: snapshot.data![widget.passindex]
                                      .serviceProvider.profilePic ==
                                  null
                              ? Center(
                                  child: Text("No Image"),
                                )
                              : Image.network(
                                  'https://servicehub.clickytesting.xyz/' +
                                      snapshot.data![widget.passindex]
                                          .serviceProvider!.profilePic
                                          .toString(),
                                  fit: BoxFit.fill,
                                )),
                    ),
                  ),
                  const SizedBox(height: 19),
                  Center(
                    child: Text(
                      snapshot.data![widget.passindex].serviceProvider.fullName
                                  .toString()
                                  .length >
                              12
                          ? snapshot.data![widget.passindex].serviceProvider
                                  .fullName
                                  .toString()
                                  .substring(0, 14) +
                              "..."
                          : snapshot
                              .data![widget.passindex].serviceProvider.fullName
                              .toString(),
                      style: const TextStyle(
                        fontFamily: 'Segoe UI',
                        fontSize: 20.0,
                        color: darkText,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const SizedBox(height: 3),
                  Center(
                    child: SmoothStarRating(
                        allowHalfRating: false,
                        starCount: 5,
                        rating: snapshot
                            .data![widget.passindex].serviceProvider.avgRating
                            .toDouble(),
                        size: 30.0,
                        filledIconData: Icons.star,
                        halfFilledIconData: Icons.star,
                        color: Colors.red,
                        borderColor: darkText,
                        spacing: 0.0),
                  ),
                  const SizedBox(height: 25),
                  requestData(
                    'From',
                    snapshot.data![widget.passindex].serviceProvider.city
                        .toString(),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "Additional Information",
                    style: TextStyle(
                      fontFamily: 'Segoe UI',
                      fontSize: 15.0,
                      color: darkText,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    snapshot.data![widget.passindex].serviceProvider.description
                        .toString(),
                    style: const TextStyle(
                      fontFamily: 'Segoe UI',
                      fontSize: 12.0,
                      color: lightGrey,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 20),
                  requestData(
                    'Budget',
                    snapshot.data![widget.passindex].estimatedBudget.toString(),
                  ),
                  const SizedBox(height: 20),
                  requestData(
                    'Date & Time',
                    DateFormat('yyyy-MM-dd HH:mm')
                        .format(snapshot.data![0].createdAt)
                        .toString(),
                  ),
                  const SizedBox(height: 20),
                  requestData(
                    'Estimated Time',
                    snapshot.data![widget.passindex].estimatedTime.toString() +
                        '  (Hours)',
                  ),
                  const SizedBox(height: 17),
                  RoundedButton(
                    buttonText: 'Accept Request',
                    onPress: () async {
                      await apicontroller.AcceptRequest(
                          snapshot.data![widget.passindex].serviceProviderId
                              .toString(),
                          snapshot.data![widget.passindex].jobId.toString(),
                          snapshot.data![widget.passindex].id.toString());

                      await apicontroller.getproviderdetails(snapshot
                          .data![widget.passindex].serviceProviderId
                          .toString());
                      await getproviderrdata();
// provider Accept Time Send To Push Notification provider
//==============================================================================================================================================================================================================
                      apicontroller.SendPushNotification(fcmkey.toString(),
                          "Aceept To Job", name + " Selected To Job", context);
//================================================================================================================================================================================================================

                      Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                              builder: (context) => AppoinmentInfo2Screen(
                                    providerid: snapshot.data![widget.passindex]
                                        .serviceProviderId
                                        .toString(),
                                    passindex: widget.passindex,
                                    index: widget.indexes,
                                  )),
                          (route) => false);
                    },
                  ),
                  const SizedBox(height: 17),
                ],
              );
            }
          },
        ),
      ),
    );
  }

  Widget requestData(String title, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
              fontFamily: 'Segoe UI',
              fontSize: 15.0,
              color: darkText,
              fontWeight: FontWeight.w800),
        ),
        const SizedBox(
          height: 10,
        ),
        Text(
          value,
          style: const TextStyle(
              fontFamily: 'Segoe UI',
              fontSize: 15.0,
              color: lightGrey,
              fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}
